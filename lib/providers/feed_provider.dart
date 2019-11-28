import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
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

  ViewState _state;
  ViewState _partialState;
  ViewState _loadMorePostsState = ViewState.Idle;
  CurrentPage _currentPage;

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
    currentSubreddit = "",
    currentSort = "Hot",
  }) async {
    await _storageHelper.init();
    print("getting listing");
    _state = ViewState.Busy;
    notifyListeners();

    print(_storageHelper.debugPrint);
    await _storageHelper.fetchData();

    this.sub = currentSubreddit;
    this.sort = currentSort;

    if (_storageHelper.signInStatus == false) {
      print("fetch Posts: not signed in ");
      String url = "";
      if (this.sub != "") {
        _currentPage = CurrentPage.Other;
        url =
            "https://www.reddit.com/r/${sub.toLowerCase()}/${currentSort.toString().toLowerCase()}.json";
      } else {
        _currentPage = CurrentPage.FrontPage;
        url =
            "https://www.reddit.com/${currentSort.toString().toLowerCase()}.json";
      }

      http.Response response;
      try {
        response = await http.get(url);
        if (response.statusCode == 200) {
          _postFeed = PostsFeedEntity.fromJson(json.decode(response.body));
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
          } else {}
        } else {
          print("****************");
          print(response.statusCode);
        }
      } catch (e) {
        print(e.toString());
      }
      _state = ViewState.Idle;
      notifyListeners();
      return;
    }

    if (await _storageHelper.needsTokenRefresh()) {
      await _storageHelper.performTokenRefresh();
    }

    http.Response subredditResponse;

    String token = await _storageHelper.authToken;
    String url;
    if (currentSubreddit == "") {
      _currentPage = CurrentPage.FrontPage;
      url =
          "https://oauth.reddit.com/${currentSort.toString().toLowerCase()}/?limit=10";
    } else {
      _currentPage = CurrentPage.Other;
      url =
          "https://oauth.reddit.com/r/$currentSubreddit/${currentSort.toString().toLowerCase()}/?limit=10";
    }

    print("Feed fetch url is : " + url);
    subredditResponse = await http.get(
      url,
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );

    if (subredditResponse.statusCode == 200)
      _postFeed =
          new PostsFeedEntity.fromJson(json.decode(subredditResponse.body));
    else
      throw new Exception(
          "Failed to load data: " + subredditResponse.reasonPhrase);

    if (_currentPage != CurrentPage.FrontPage)
      await fetchSubredditInformation(token, currentSubreddit);
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> fetchSubredditInformation(
    String token,
    String currentSubreddit,
  ) async {
    final url = "https://oauth.reddit.com/r/$currentSubreddit/about";
    final subInfoResponse = await http.get(
      url,
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );

    if (subInfoResponse.statusCode == 200) {
      _subredditInformationEntity = new SubredditInformationEntity.fromJson(
          json.decode(subInfoResponse.body));
      this.sub = _subredditInformationEntity.data.displayName;
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

  Future<bool> votePost({@required String id, @required int dir}) async {
    await _storageHelper.init();
    PostsFeedDatachild item = _postFeed.data.children.firstWhere((v) {
      return v.data.id.compareTo(id) == 0 ? true : false;
    });
    notifyListeners();
    if (item.data.likes == true) {
      item.data.score--;
    } else if (item.data.likes == false) {
      item.data.score++;
    }
    if (dir == 1) {
      item.data.score++;
      item.data.likes = true;
    } else if (dir == -1) {
      item.data.score--;
      item.data.likes = false;
    } else if (dir == 0) {
      item.data.score =
          item.data.likes == true ? item.data.score-- : item.data.score++;
      item.data.likes = null;
    }
    String url = "https://oauth.reddit.com/api/vote";
    final String authToken = await _storageHelper.authToken;
    http.Response voteResponse;
    voteResponse = await http.post(
      url + '?dir=$dir&id=$id&rank=2',
      headers: {
        'Authorization': 'bearer ' + authToken,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );

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
        if (sub != "") {
          url =
              "https://oauth.reddit.com/r/$sub/${sort.toString().toLowerCase()}/?limit=10&after=${postFeed.data.after}";
        } else {
          url = url =
              "https://oauth.reddit.com/${sort.toString().toLowerCase()}/?limit=10&after=${postFeed.data.after}";
        }
        print(url);
        String token = await _storageHelper.authToken;
        http.Response subredditResponse = await http.get(
          url,
          headers: {
            'Authorization': 'bearer ' + token,
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        print(subredditResponse.statusCode.toString() +
            subredditResponse.reasonPhrase);
        final PostsFeedEntity newData =
            new PostsFeedEntity.fromJson(json.decode(subredditResponse.body));
        _postFeed.data.children.addAll(newData.data.children);
        print("previous after: " + _postFeed.data.after);
        print("new after : " + newData.data.after);
        _postFeed.data.after = newData.data.after;
      } else {
        url = "http://www.reddit.com";
        if (sub != "") {
          url =
              "https://www.reddit.com/r/$sub/${sort.toString().toLowerCase()}.json?limit=10&after=${postFeed.data.after}";
        } else {
          url = url =
              "https://www.reddit.com/${sort.toString().toLowerCase()}.json?limit=10&after=${postFeed.data.after}";
        }
        print(url);
        http.Response subredditResponse = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        print(subredditResponse.statusCode.toString() +
            subredditResponse.reasonPhrase);
        final PostsFeedEntity newData =
            new PostsFeedEntity.fromJson(json.decode(subredditResponse.body));
        _postFeed.data.children.addAll(newData.data.children);
        print("previous after: " + _postFeed.data.after);
        print("new after : " + newData.data.after);
        _postFeed.data.after = newData.data.after;
      }
    } catch (e) {
      print("EXCEPTION : " + e.toString());
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
}
