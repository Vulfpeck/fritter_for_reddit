import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/search_results/subreddits/search_subreddits_repo_entity.dart';
import 'package:flutter_provider_app/models/states.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  final SecureStorageHelper _secureStorageHelper = new SecureStorageHelper();

  ViewState _subredditQueryLoadingState = ViewState.Idle;
  SearchSubredditsRepoEntity _subQueryResult = SearchSubredditsRepoEntity();

  ViewState get subredditQueryLoadingState => _subredditQueryLoadingState;
  SearchSubredditsRepoEntity get subQueryResult => _subQueryResult;

  SearchProvider() {
    initProvider();
  }

  Future<void> initProvider() async {
    await _secureStorageHelper.init();
  }

  Future<void> queryReddit({@required String query}) async {
    _subredditQueryLoadingState = ViewState.Busy;
    notifyListeners();
    if (_secureStorageHelper.signInStatus) {
      String authToken = await _secureStorageHelper.authToken;
      Uri uri = Uri.https(
        'oauth.reddit.com',
        'api/search_subreddits.json',
        {
          'query': query,
        },
      );
      print(uri);
      http.Response response = await http.post(
        uri,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          'Authorization': 'bearer $authToken',
        },
      );
      print("Subreddit search query status: " + response.statusCode.toString());

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
      print(uri);
      http.Response response = await http.post(
        uri,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        },
      );
      print("Subreddit search query status: " + response.statusCode.toString());

      if (response.statusCode == 200) {
        _subQueryResult = _subQueryResult.fromJson(json.decode(response.body));
      }
    }

    _subredditQueryLoadingState = ViewState.Idle;
    notifyListeners();
  }
}
