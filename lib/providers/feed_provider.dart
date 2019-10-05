import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/models/subreddit_info/subreddit_information_entity.dart';
import 'package:http/http.dart' as http;

class FeedProvider with ChangeNotifier {
  final SecureStorageHelper _storageHelper = new SecureStorageHelper();
  String subName = "FrontPage";
  String sub = "";
  String sort = "Hot";

  ViewState _state;

  ViewState _partialState;

  ViewState get partialState => _partialState;
  CurrentPage _currentPage;

  ViewState get state => _state;

  CurrentPage get currentPage => _currentPage;
  PostsFeedEntity _postFeed;

  PostsFeedEntity get postFeed => _postFeed;
  SubredditInformationEntity _subredditInformationEntity;

  SubredditInformationEntity get subredditInformationEntity =>
      _subredditInformationEntity;

  FeedProvider() {
    _currentPage = CurrentPage.FrontPage;
    fetchPostsListing();
  }

  Future<void> fetchPostsListing({
    currentSubreddit = "",
    currentSort = "Hot",
  }) async {
    print("** fetching posts");

    _state = ViewState.Busy;
    notifyListeners();
    _storageHelper.fetchData();

    print(_storageHelper.signInStatus);
    if (_storageHelper.signInStatus == false) {
      print("fetch Posts: not signed in ");
      sort = currentSort;
      print("Is at frontpage");
      _currentPage = CurrentPage.FrontPage;
      final url =
          "https://www.reddit.com/${currentSort.toString().toLowerCase()}.json";
      final response = await http.get(url);
      _postFeed = PostsFeedEntity.fromJson(json.decode(response.body));
      _state = ViewState.Idle;
      notifyListeners();
      return;
    }

    if (await _storageHelper.needsTokenRefresh()) {
      await _storageHelper.performTokenRefresh();
    }

    http.Response subredditResponse;
    print("** Fetch posts user is authenticated");

    String token = await _storageHelper.authToken;
    String url;
    print("fetch Posts: got token");
    sort = currentSort;
    if (currentSubreddit == "") {
      print("Is at frontpage");
      _currentPage = CurrentPage.FrontPage;
      url =
          "https://oauth.reddit.com/${currentSort.toString().toLowerCase()}/?limit=100";
    } else {
      _currentPage = CurrentPage.Other;
      url =
          "https://oauth.reddit.com/r/$currentSubreddit/${currentSort.toString().toLowerCase()}/?limit=100";
    }
    print(url);
    subredditResponse = await http.get(
      url,
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );
    print("fetch posts list response code: " +
        subredditResponse.statusCode.toString());

    if (subredditResponse.statusCode == 200)
      _postFeed =
          new PostsFeedEntity.fromJson(json.decode(subredditResponse.body));

    if (_currentPage != CurrentPage.FrontPage)
      await fetchSubRedditInformation(token, currentSubreddit);
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> fetchSubRedditInformation(
      String token, String currentSubreddit) async {
    final url = "https://oauth.reddit.com/r/$currentSubreddit/about";
    final subInfoResponse = await http.get(
      url,
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );
    print("sub infor response code: " + subInfoResponse.statusCode.toString());

    if (subInfoResponse.statusCode == 200) {
      _subredditInformationEntity = new SubredditInformationEntity.fromJson(
          json.decode(subInfoResponse.body));
      this.sub = _subredditInformationEntity.data.displayName;
      print(_subredditInformationEntity.toJson());
    }
    print("** subreddit information fetching complete");
  }

  /// action being true results in subscribing to a subreddit
  Future<void> unsubscribeFromSubreddit(String subId, bool action) async {
    print(action);
    print(subId);
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
      print("url" + url);
    } else {
      subInfoResponse = subInfoResponse = await http.post(
        url + '?action=unsub&sr=$subId&X-Modhash=null',
        headers: {
          'Authorization': 'bearer ' + authToken,
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      );

      print("url" + url);
    }

    print(json.decode(subInfoResponse.body));

    _subredditInformationEntity.data.userIsSubscriber =
        !_subredditInformationEntity.data.userIsSubscriber;
    _partialState = ViewState.Idle;
    notifyListeners();
  }

  Future<bool> vote(String id, int dir) async {
    notifyListeners();
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
      print("Vote success : " + json.decode(voteResponse.body).toString());
      return true;
    } else {
      print("Vote failed : " + json.decode(voteResponse.body).toString());
      return false;
    }
  }
}
