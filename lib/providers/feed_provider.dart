import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';

import 'package:fritter_for_reddit/helpers/functions/misc_functions.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/models/subreddit_info/subreddit_information_entity.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

part 'feed_provider.g.dart';

class FeedProvider with ChangeNotifier {
  Box<SubredditInfo> _cache;

  final SecureStorageHelper _storageHelper = SecureStorageHelper();

  BehaviorSubject<PostsFeedEntity> _postFeedStream = BehaviorSubject();

  PostsFeedEntity get postFeed => _postFeedStream.value;

  BehaviorSubject<String> currentSubredditStream =
      BehaviorSubject.seeded('frontpage');

  String get currentSubreddit => currentSubredditStream.value;

  BehaviorSubject<SubredditInformationEntity>
      currentSubredditInformationStream = BehaviorSubject.seeded(null);
  BehaviorSubject<SubredditInfo> subStream;
  bool subLoadingError = false;

  String sort = "Hot";

  String subListingFetchUrl = "";

  bool subInformationLoadingError = false;

  bool feedInformationLoadingError = false;

  ViewState _state;

  ViewState _partialState;
  ViewState _loadMorePostsState = ViewState.Idle;
  CurrentPage currentPage;

  ViewState get loadMorePostsState => _loadMorePostsState;

  ViewState get partialState => _partialState;

  ViewState get state => _state;

  SubredditInformationEntity get subredditInformationEntity =>
      currentSubredditInformationStream.value;

  FeedProvider({
    this.currentPage = CurrentPage.frontPage,
    String currentSubreddit = '',
  }) {
    _init();
  }

  void _init() {
    _cache = Hive.box<SubredditInfo>('feed');

    _fetchPostsListing(currentSubreddit: currentSubreddit);
    currentSubredditStream.listen((name) {
      debugPrint('updating currentSubredditStream to $name');
    });
    _postFeedStream.listen((feed) {
      debugPrint('updating postFeedStream');
      final posts = feed.data.children;
      assert(posts.map((post) => post.data.id).toSet().length == posts.length,
          'Duplicate posts have been detected.');
    });
    currentSubredditInformationStream.listen((subredditInformation) {
      debugPrint('updating currentSubredditStream to '
          '${subredditInformation?.data?.displayName ?? 'NO DATA for this sub'}');
    });

    subStream = ZipStream<dynamic, SubredditInfo>([
      _postFeedStream,
      currentSubredditInformationStream,
      currentSubredditStream
    ], (streams) {
      final postFeed = streams[0];
      final currentSubredditInformation = streams[1];
      var currentSubreddit = streams[2];
      return SubredditInfo(
        name: currentSubreddit,
        postsFeed: postFeed,
        subredditInformation: currentSubredditInformation,
      );
    }).asBehaviorSubject
      ..listen((subredditInfo) {
        notifyListeners();
        return _cache.put(subredditInfo.name, subredditInfo);
      });
  }

  factory FeedProvider.openFromName(String currentSubreddit) {
    return FeedProvider(
        currentPage: CurrentPage.other, currentSubreddit: currentSubreddit);
  }

  Future<Stream<Map>> accessCodeServer() async {
    final StreamController<Map> onCode = StreamController();
    HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((HttpRequest request) async {
//      // print("Server started");
      final Map<String, String> response = request.uri.queryParameters;
//      // print(request.uri.pathSegments);
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write(
            '<html><meta name="viewport" content="width=device-width, initial-scale=1.0"><body> <h2 style="text-align: center; position: absolute; top: 50%; left: 0: right: 0">Welcome to Fritter</h2><h3>You can close this window<script type="javascript">window.close()</script> </h3></body></html>');
      await request.response.close();
      await server.close(force: true);
      onCode.add(response);
      await onCode.close();
    });
    return onCode.stream;
  }

  PostsFeedEntity appendMediaType(PostsFeedEntity postFeed) {
    for (var x in postFeed.data.children) {
      x.data.postType = getMediaType(x.data)['media_type'];
    }
    return postFeed;
  }

  /// action being true results in subscribing to a subreddit
  Future<void> changeSubscriptionStatus(String subId, bool action) async {
    _partialState = ViewState.Busy;
    notifyListeners();

    String authToken = await _storageHelper.authToken;
    final url = "https://oauth.reddit.com/api/subscribe";

    http.Response subInfoResponse;
    if (action) {
      subInfoResponse = await http.post(
        url + '?action=sub&sr=$subId&skip_initial_defaults=true&X-Modhash=null',
        headers: {
          'Authorization': 'bearer ' + authToken,
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      );
    } else {
      subInfoResponse = await http.post(
        url + '?action=unsub&sr=$subId&X-Modhash=null',
        headers: {
          'Authorization': 'bearer ' + authToken,
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      );
    }
    subredditInformationEntity.data.userIsSubscriber =
        !subredditInformationEntity.data.userIsSubscriber;
    _partialState = ViewState.Idle;
    notifyListeners();
  }

  @override
  void dispose() {
    currentSubredditInformationStream.close();
    currentSubredditStream.close();
    subStream.close();
    _postFeedStream.close();
    super.dispose();
  }

  Future<void> _fetchPostsListing({
    String currentSubreddit = '',
    String currentSort = "Hot",
    bool loadingTop = false,
    int limit = 10,
  }) async {
    await _storageHelper.init();

    await _storageHelper.fetchData();

    this.sort = currentSort;

    if (_cache.containsKey(currentSubreddit)) {
      _postFeedStream.value = _cache.get(currentSubreddit).postsFeed;
      debugPrint('returning data from cache');
      notifyListeners();
    } else {
      _state = ViewState.Busy;
      notifyListeners();
    }
    http.Response response;
    try {
      if (_storageHelper.signInStatus == false) {
        // // print("fetch Posts: not signed in ");
        String url = "";
        if (currentSubreddit.isNotEmpty) {
          currentPage = CurrentPage.other;
          url = "https://www.reddit.com";
          if (loadingTop) {
            url = url +
                "/r/${currentSubreddit.toLowerCase()}" +
                currentSort.toString().toLowerCase() +
                "&limit=10";
          } else {
            url = url +
                "/r/${currentSubreddit.toLowerCase()}" +
                "/${currentSort.toString().toLowerCase()}.json" +
                "?limit=10";
          }
        } else {
          currentPage = CurrentPage.frontPage;
          url = "https://www.reddit.com";
          if (loadingTop) {
            url = url + currentSort.toString().toLowerCase() + "&limit=$limit";
          } else {
            url = url +
                "/${currentSort.toString().toLowerCase()}.json?limit=$limit";
          }
        }

        // // print(url);
        response = await http.get(url).catchError((e) {
          // // print("Feed fetch error");
          notifyListeners();
          throw new Exception("Feed fetch error");
        });
        if (response.statusCode == 200) {
          subListingFetchUrl = url;
          _postFeedStream.value = appendMediaType(
              PostsFeedEntity.fromJson(json.decode(response.body)));
        } else {
          // // print("****************");
          // // print(response.statusCode);
        }
      } else {
        if (await _storageHelper.needsTokenRefresh()) {
          await _storageHelper.performTokenRefresh();
        }

        String token = await _storageHelper.authToken;
        String url;
        if (currentSubreddit.isNotEmpty) {
          currentPage = CurrentPage.other;
          url = "https://oauth.reddit.com";
          if (loadingTop) {
            url = url +
                "/r/${currentSubreddit.toLowerCase()}" +
                currentSort.toString().toLowerCase() +
                "&limit=$limit";
          } else {
            url += "/r/${currentSubreddit.toLowerCase()}" +
                "/${currentSort.toString().toLowerCase()}.json" +
                "?limit=$limit";
          }
        } else {
          currentPage = CurrentPage.frontPage;
          url = "https://oauth.reddit.com";
          if (loadingTop) {
            url += currentSort.toString().toLowerCase() + "&limit=$limit";
          } else {
            url = url +
                "/${currentSort.toString().toLowerCase()}.json?limit=$limit";
          }
        }
        // // print("Feed fetch url is : " + url);
        response = await http.get(
          url,
          headers: {
            'Authorization': 'bearer ' + token,
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        ).catchError((e) {
          throw new Exception("Feed fetch error");
        });

        if (response.statusCode == 200) {
          _postFeedStream.value = appendMediaType(
              PostsFeedEntity.fromJson(json.decode(response.body)));
          subListingFetchUrl = url;
        } else {
          throw Exception("Failed to load data: " + response.reasonPhrase);
        }
      }
    } catch (e) {
      // // print(e.toString());
    } finally {
      _state = ViewState.Idle;
      notifyListeners();
    }
  }

  Future<SubredditInformationEntity> fetchSubredditInformationOAuth(
    String token,
    String currentSubreddit,
  ) async {
    subInformationLoadingError = false;
    final url = "https://oauth.reddit.com/r/$currentSubreddit/about";
    try {
      final subInfoResponse = await http.get(
        url,
        headers: {
          'Authorization': 'bearer ' + token,
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      ).catchError((e) {
        // // print("Error fetching Subreddit information");
        throw new Exception("Error");
      });

      if (subInfoResponse.statusCode == 200) {
        debugPrint('updating currentSubredditInformationStream');

        currentSubredditInformationStream.value =
            SubredditInformationEntity.fromJson(
                json.decode(subInfoResponse.body));

        // // print(json.decode((subInfoResponse.body).toString()));
        if (subredditInformationEntity.data.title == null) {
          subInformationLoadingError = true;
        }
      } else {
        debugPrint('updating currentSubredditInformationStream');
        currentSubredditInformationStream.value = null;
      }
    } catch (e) {
      // // print(e.toString());
    }
    return subredditInformationEntity;
  }

  Future<PostsFeedEntity> loadMorePosts() async {
    _loadMorePostsState = ViewState.Busy;
    notifyListeners();

    await _storageHelper.init();
    String url = "";
    try {
      url = subListingFetchUrl + "&after=${postFeed.data.after}";
      http.Response subredditResponse;
      if (_storageHelper.signInStatus) {
        if (await _storageHelper.needsTokenRefresh()) {
          await _storageHelper.performTokenRefresh();
        }
        // // print(url);
        String token = await _storageHelper.authToken;
        subredditResponse = await http.get(
          url,
          headers: {
            'Authorization': 'bearer ' + token,
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        // // print(subredditResponse.statusCode.toString() +
//            subredditResponse.reasonPhrase);
        // // print("previous after: " + _postFeed.data.after);
        // // print("new after : " + newData.data.after);
      } else {
        subredditResponse = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        // print(subredditResponse.statusCode.toString() +
//            subredditResponse.reasonPhrase);
      }
      final PostsFeedEntity newData =
          PostsFeedEntity.fromJson(json.decode(subredditResponse.body));
      appendMediaType(newData);
      _postFeedStream.value = postFeed.copyWith(
        data: postFeed.data.copyWith(
          children: postFeed.data.children..addAll(newData.data.children),
          after: newData.data.after,
        ),
      );
    } catch (e) {
      print("EXCEPTION : " + e.toString());
    }
    _loadMorePostsState = ViewState.Idle;
    notifyListeners();
    return postFeed;
  }

  Future<void> navigateToSubreddit(String subreddit) async {
    final String strippedSubreddit =
        subreddit.replaceFirst(RegExp(r'\/r\/| r\/'), '');

    if (strippedSubreddit != subStream.value.name) {
      debugPrint('updating currentSubredditStream');

      currentSubredditStream.value = strippedSubreddit;
      await _fetchPostsListing(currentSubreddit: strippedSubreddit);

      String token = await _storageHelper.authToken;
      await fetchSubredditInformationOAuth(token, currentSubreddit);
    } else {
      debugPrint('Requesting the same subreddit. Ignoring');
      assert(subStream.value.name == strippedSubreddit,
          "These don't actually match!");
      return;
    }
  }

  void selectProperPreviewImage() {}

  Future<void> signOutUser() async {
    _state = ViewState.Busy;
    notifyListeners();
    await _storageHelper.clearStorage();
    await _fetchPostsListing();
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<bool> votePost(
      {@required PostsFeedDataChildrenData postItem, @required int dir}) async {
    await _storageHelper.init();
    notifyListeners();
    if (postItem.likes == true) {
      postItem.score--;
    } else if (postItem.likes == false) {
      postItem.score++;
    }
    if (dir == 1) {
      postItem.score++;
      postItem.likes = true;
    } else if (dir == -1) {
      postItem.score--;
      postItem.likes = false;
    } else if (dir == 0) {
      postItem.score =
          postItem.likes == true ? postItem.score-- : postItem.score++;
      postItem.likes = null;
    }
    String url = "https://oauth.reddit.com/api/vote";
    final Uri uri = Uri.https(
      'oauth.reddit.com',
      'api/vote',
      {
        'dir': dir.toString(),
        'id': postItem.name.toString(),
        'rank': '2',
      },
    );
    // // print(uri);
    final String authToken = await _storageHelper.authToken;
    http.Response voteResponse;
    voteResponse = await http.post(
      uri,
      headers: {
        'Authorization': 'bearer ' + authToken,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );
    // // print("vote result" + voteResponse.statusCode.toString());
    notifyListeners();
    if (voteResponse.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _currentSubredditListener(dynamic value) async {
    final infoUrl = "https://api.reddit.com/r/$currentSubreddit/about";
    final subInfoResponse = await http.get(
      infoUrl,
      headers: {
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );
    if (subInfoResponse.statusCode == 200) {
      currentSubredditInformationStream.add(SubredditInformationEntity.fromJson(
          json.decode(subInfoResponse.body)));
    } else {
      // // print(response.body);
    }
  }

  /*Future _signIn() async {
    String accessToken = await _storageHelper.authToken;
    _reddit.authSetup(CLIENT_ID, '');
    Uri authUri = _reddit.authUrl('http://localhost:8080/',
        scopes: [
          'identity',
          'edit',
          'flair',
          'history',
          'modconfig',
          'modflair',
          'modlog',
          'modposts',
          'modwiki',
          'mysubreddits',
          'privatemessages',
          'read',
          'report',
          'save',
          'submit',
          'subscribe',
          'vote',
          'wikiedit',
          'wikiread'
        ],
        state: 'samplestate');
    if (true */ /*accessToken == null*/ /*) {
      launchURL(Colors.blue, authUri.toString());

      final server = await accessCodeServer();
      final Map responseParameters = await server.first;
      accessToken = responseParameters['code'];
      _storageHelper.updateAuthToken(accessToken);
    }
    _reddit = await _reddit.authFinish(
        username: CLIENT_ID, password: '', code: accessToken);
  }*/

  static FeedProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<FeedProvider>(context, listen: listen);

  Future<void> updateSorting({String sortBy, bool loadingTop}) {
    return _fetchPostsListing(
        currentSubreddit: currentSubreddit,
        currentSort: sortBy,
        loadingTop: loadingTop);
  }

  Future<void> refresh() =>
      _fetchPostsListing(currentSubreddit: currentSubreddit);
}

enum QueryType { subreddit, user, post }

@HiveType(typeId: 1)
class SubredditInfo {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final PostsFeedEntity postsFeed;
  @HiveField(2)
  final SubredditInformationEntity subredditInformation;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const SubredditInfo({
    @required this.name,
    @required this.postsFeed,
    @required this.subredditInformation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubredditInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          postsFeed == other.postsFeed &&
          subredditInformation == other.subredditInformation);

  @override
  int get hashCode =>
      name.hashCode ^ postsFeed.hashCode ^ subredditInformation.hashCode;

  @override
  String toString() => 'SubredditInfo{'
      ' name: $name, '
      ' postsFeed: $postsFeed,'
      ' subredditInformation: $subredditInformation,'
      '}';

  SubredditInfo copyWith({
    String name,
    PostsFeedEntity postsFeed,
    SubredditInformationEntity subredditInformation,
  }) =>
      SubredditInfo(
        name: name ?? this.name,
        postsFeed: postsFeed ?? this.postsFeed,
        subredditInformation: subredditInformation ?? this.subredditInformation,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'postsFeed': this.postsFeed.toJson(),
        'subredditInformation': this.subredditInformation.toJson(),
      };

  factory SubredditInfo.fromMap(Map<String, dynamic> map) {
    return SubredditInfo(
      name: map['name'],
      postsFeed: PostsFeedEntity.fromJson(map['postsFeed']),
      subredditInformation:
          SubredditInformationEntity.fromJson(map['subredditInformation']),
    );
  }

//</editor-fold>
}
