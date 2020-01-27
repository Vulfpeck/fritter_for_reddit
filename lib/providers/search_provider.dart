import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/models/search_results/subreddits/search_subreddits_repo_entity.dart';
import 'package:flutter_provider_app/models/states.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  final SecureStorageHelper _secureStorageHelper = new SecureStorageHelper();

  ViewState _subredditQueryLoadingState = ViewState.Idle;
  ViewState _postsQueryLoadingState = ViewState.Idle;

  SearchSubredditsRepoEntity _subQueryResult = SearchSubredditsRepoEntity();
  PostsFeedEntity _postsQueryResult = PostsFeedEntity();

  ViewState get subredditQueryLoadingState => _subredditQueryLoadingState;
  ViewState get postsQueryLoadingState => _postsQueryLoadingState;

  SearchSubredditsRepoEntity get subQueryResult => _subQueryResult;
  PostsFeedEntity get postsQueryResult => _postsQueryResult;

  SearchProvider() {
    initProvider();
  }

  Future<void> initProvider() async {
    await _secureStorageHelper.init();
  }

  Future<void> searchSubreddits({@required String query}) async {
    _subredditQueryLoadingState = ViewState.Busy;
    notifyListeners();
    await _secureStorageHelper.init();
    if (_secureStorageHelper.signInStatus) {
      String authToken = await _secureStorageHelper.authToken;
      Uri uri = Uri.https(
        'oauth.reddit.com',
        'api/search_subreddits.json',
        {
          'query': query,
        },
      );
      // print(uri);
      http.Response response = await http.post(
        uri,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          'Authorization': 'bearer $authToken',
        },
      );
      // print("Subreddit search query status: " + response.statusCode.toString());

      if (response.statusCode == 200) {
        _subQueryResult = _subQueryResult.fromJson(json.decode(response.body));
      }
    } else {
      Uri uri = Uri.https(
        'www.reddit.com',
        'api/search_subreddits.json',
        {
          'query': query,
        },
      );
      // print(uri);
      http.Response response = await http.post(
        uri,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      );
      // print("Subreddit search query status: " + response.statusCode.toString());

      if (response.statusCode == 200) {
        _subQueryResult = _subQueryResult.fromJson(json.decode(response.body));
      }
    }

    _subredditQueryLoadingState = ViewState.Idle;
    notifyListeners();
  }

  Future<void> searchPosts({
    @required String query,
    String subreddit = "",
  }) async {
    await _secureStorageHelper.init();
    _postsQueryLoadingState = ViewState.Busy;
    notifyListeners();

    if (_secureStorageHelper.signInStatus) {
      String authToken = await _secureStorageHelper.authToken;
      Uri uri = Uri.https(
        'oauth.reddit.com',
        'search.json',
        {
          'q': query,
        },
      );
      // print(uri);
      http.Response response = await http.get(
        uri,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          'Authorization': 'bearer $authToken',
        },
      );
      // print("Signed in posts query status code: " +
//          response.statusCode.toString());

      if (response.statusCode == 200) {
        // print(json.decode(response.body));
        _postsQueryResult =
            PostsFeedEntity.fromJson(json.decode(response.body));
      }
    } else {
      Uri uri = Uri.https(
        'www.reddit.com',
        'search.json',
        {
          'q': query,
        },
      );
      // print(uri);
      http.Response response = await http.get(
        uri,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      );
      // print("Signed out posts query status code" +
//          response.statusCode.toString());

      if (response.statusCode == 200) {
        _postsQueryResult =
            PostsFeedEntity.fromJson(json.decode(response.body));
      }

      // print(_postsQueryResult.data.children.length);
      for (var x in _postsQueryResult.data.children) {
        // print(x.data.title);
      }
    }

    // print(_postsQueryResult.toJson().toString());
    _postsQueryLoadingState = ViewState.Idle;
    notifyListeners();
  }

  void clearResults() {
    _postsQueryResult = PostsFeedEntity();
    _subQueryResult = SearchSubredditsRepoEntity();
    notifyListeners();
  }
}
