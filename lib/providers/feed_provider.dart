import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/misc_functions.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/models/subreddit_info/subreddit_information_entity.dart';
import 'package:http/http.dart' as http;

class FeedProvider with ChangeNotifier {
  final SecureStorageHelper _storageHelper = new SecureStorageHelper();

  PostsFeedEntity _postFeed;
  SubredditInformationEntity _subredditInformationEntity;

  bool _subLoadingError = false;

  String sub = "";
  String sort = "Hot";
  String subListingFetchUrl = "";

  bool _subInformationLoadingError = false;
  bool _feedInformationLoadingError = false;
  ViewState _state;
  ViewState _partialState;
  ViewState _loadMorePostsState = ViewState.Idle;
  CurrentPage _currentPage;

  bool get subredditInformationError => _subInformationLoadingError;
  bool get feedInformationError => _feedInformationLoadingError;

  ViewState get partialState => _partialState;
  ViewState get state => _state;
  ViewState get loadMorePostsState => _loadMorePostsState;

  PostsFeedEntity get postFeed => _postFeed;
  SubredditInformationEntity get subredditInformationEntity =>
      _subredditInformationEntity;
  CurrentPage get currentPage => _currentPage;

  bool get subLoadingError => _subLoadingError;

  FeedProvider() {
    _currentPage = CurrentPage.FrontPage;
    fetchPostsListing();
  }

  FeedProvider.openFromName(String currentSubreddit) {
    _currentPage = CurrentPage.Other;
    _subLoadingError = false;

    fetchPostsListing(currentSubreddit: currentSubreddit);
  }

  Future<void> fetchPostsListing({
    String currentSubreddit = "",
    String currentSort = "Hot",
    loadingTop = false,
  }) async {
    await _storageHelper.init();
    _state = ViewState.Busy;
    notifyListeners();

    await _storageHelper.fetchData();

    this.sub = currentSubreddit;
    this.sort = currentSort;

    http.Response response;
    try {
      if (_storageHelper.signInStatus == false) {
        // // print("fetch Posts: not signed in ");
        String url = "";
        if (this.sub != "") {
          _currentPage = CurrentPage.Other;
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
          _currentPage = CurrentPage.FrontPage;
          url = "https://www.reddit.com";
          if (loadingTop) {
            url = url + currentSort.toString().toLowerCase() + "&limit=10";
          } else {
            url =
                url + "/${currentSort.toString().toLowerCase()}.json?limit=10";
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
          _postFeed = PostsFeedEntity.fromJson(json.decode(response.body));
          appendMediaType(_postFeed);
          final infoUrl = "https://api.reddit.com/r/$currentSubreddit/about";
          final subInfoResponse = await http.get(
            infoUrl,
            headers: {
              'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
            },
          );
          if (subInfoResponse.statusCode == 200) {
            _subredditInformationEntity =
                new SubredditInformationEntity.fromJson(
                    json.decode(subInfoResponse.body));
            this.sub = _subredditInformationEntity.data.displayName;
          } else {
            // // print(response.body);
          }
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
        if (this.sub != "") {
          _currentPage = CurrentPage.Other;
          url = "https://oauth.reddit.com";
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
          _currentPage = CurrentPage.FrontPage;
          url = "https://oauth.reddit.com";
          if (loadingTop) {
            url = url + currentSort.toString().toLowerCase() + "&limit=10";
          } else {
            url =
                url + "/${currentSort.toString().toLowerCase()}.json?limit=10";
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
          _postFeed = new PostsFeedEntity.fromJson(json.decode(response.body));
          appendMediaType(_postFeed);
          subListingFetchUrl = url;
        } else
          throw new Exception("Failed to load data: " + response.reasonPhrase);

        if (_currentPage != CurrentPage.FrontPage)
          await fetchSubredditInformationOAuth(token, currentSubreddit);
      }
    } catch (e) {
      // // print(e.toString());
    } finally {
      _state = ViewState.Idle;
      notifyListeners();
    }
  }

  Future<void> fetchSubredditInformationOAuth(
    String token,
    String currentSubreddit,
  ) async {
    _subInformationLoadingError = false;
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
        _subredditInformationEntity = new SubredditInformationEntity.fromJson(
            json.decode(subInfoResponse.body));
        this.sub = _subredditInformationEntity.data.displayName;

        // // print(json.decode((subInfoResponse.body).toString()));
        if (_subredditInformationEntity.data.title == null) {
          _subInformationLoadingError = true;
        }
      } else {
        throw new Exception("Failed to get sub Information");
      }
    } catch (e) {
      // // print(e.toString());
    }
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
    _subredditInformationEntity.data.userIsSubscriber =
        !_subredditInformationEntity.data.userIsSubscriber;
    _partialState = ViewState.Idle;
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

  Future<void> loadMorePosts() async {
    _loadMorePostsState = ViewState.Busy;
    notifyListeners();

    await _storageHelper.init();
    String url = "";
    try {
      if (_storageHelper.signInStatus) {
        if (await _storageHelper.needsTokenRefresh()) {
          await _storageHelper.performTokenRefresh();
        }
        url = subListingFetchUrl + "&after=${postFeed.data.after}";
        // // print(url);
        String token = await _storageHelper.authToken;
        http.Response subredditResponse = await http.get(
          url,
          headers: {
            'Authorization': 'bearer ' + token,
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        // // print(subredditResponse.statusCode.toString() +
//            subredditResponse.reasonPhrase);
        final PostsFeedEntity newData =
            new PostsFeedEntity.fromJson(json.decode(subredditResponse.body));
        _postFeed.data.children.addAll(newData.data.children);
        appendMediaType(newData);
        // // print("previous after: " + _postFeed.data.after);
        // // print("new after : " + newData.data.after);
        _postFeed.data.after = newData.data.after;
      } else {
        url = subListingFetchUrl + "&after=${postFeed.data.after}";
        // // print(url);
        http.Response subredditResponse = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        // // print(subredditResponse.statusCode.toString() +
//            subredditResponse.reasonPhrase);
        final PostsFeedEntity newData =
            new PostsFeedEntity.fromJson(json.decode(subredditResponse.body));
        appendMediaType(newData);
        _postFeed.data.children.addAll(newData.data.children);
        // // print("previous after: " + _postFeed.data.after);
        // // print("new after : " + newData.data.after);
        _postFeed.data.after = newData.data.after;
      }
    } catch (e) {
      // // print("EXCEPTION : " + e.toString());
    }
    _loadMorePostsState = ViewState.Idle;
    notifyListeners();
  }

  Future<void> signOutUser() async {
    _state = ViewState.Busy;
    notifyListeners();
    await _storageHelper.clearStorage();
    await fetchPostsListing();
    _state = ViewState.Idle;
    notifyListeners();
  }

  void appendMediaType(PostsFeedEntity postFeed) {
    for (var x in _postFeed.data.children) {
      x.data.postType = getMediaType(x.data)['media_type'];
    }
  }

  void selectProperPreviewImage() {}
}
