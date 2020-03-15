import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/states.dart';
import 'package:flutter_provider_app/models/subreddits/child.dart';
import 'package:flutter_provider_app/models/subreddits/subreddits_subscribed.dart';
import 'package:flutter_provider_app/models/user_profile/user_information_entity.dart';
import 'package:flutter_provider_app/secrets.dart';
import 'package:http/http.dart' as http;

class UserInformationProvider with ChangeNotifier {
  HttpServer server;
  final _storageHelper = new SecureStorageHelper();

  bool get signedIn => _storageHelper.signInStatus;

  UserInformationEntity userInformation;
  SubredditsSubscribed userSubreddits;

  ViewState _state;
  ViewState _authenticationStatus;

  ViewState get authenticationStatus => _authenticationStatus;

  UserInformationProvider() {
    print("UserInformationProvider-> Constructor()");
    validateAuthentication();
  }

  ViewState get state => _state;

  Future<void> performTokenRefresh() async {
    print("UserInformationProvider-> PerformTokenRefresh()");
    await _storageHelper.performTokenRefresh();
  }

  Future<void> validateAuthentication() async {
    print("UserInformationProvider-> ValidateAuthentication()");
    await _storageHelper.init();
    _state = ViewState.Busy;
    notifyListeners();
    print("UserInformationProvider-> ValidateAuth() -> Update state -> busy");

    if (_storageHelper.signInStatus) {
      print("UserInformationProvider-> ValidateAuth() <- User is Signed in");
      await _storageHelper.performTokenRefresh();
      await loadUserInformation();
    } else {
      print(
          "UserInformationProvider-> ValidateAuth() <- user is not signed in");
    }

    _state = ViewState.Idle;
    print("UserInformationProvider-> ValidateAuth() -> Update State -> idle");
    notifyListeners();
  }

  Future<bool> performAuthentication() async {
    print("UserInformationProvider-> performAuth()");
    _authenticationStatus = ViewState.Busy;
    notifyListeners();
    bool authResult = true;
    if (server != null) {
      await server.close(force: true);
    }
    await _storageHelper.clearStorage();
    Stream<String> onCode = await _server();

    final String accessCode = await onCode.first;

    _authenticationStatus = ViewState.Busy;
    notifyListeners();
    if (accessCode == null) {
      print("UserInformationProvider-> performAuth() ->auth failed");
      authResult = false;
    }

    http.Response authenticationResponse;
    if (authResult) {
      String user = CLIENT_ID;
      String password = ""; // blank for unknown clients like apps

      String basicAuth =
          "Basic " + base64Encode(utf8.encode('$user:$password'));
      authenticationResponse = await http.post(
        "https://www.reddit.com/api/v1/access_token",
        headers: {
          "Authorization": basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            "grant_type=authorization_code&code=$accessCode&redirect_uri=http://localhost:8080/",
      );
    }
    if (authenticationResponse != null &&
        authenticationResponse.statusCode == 200) {
      print("UserInformationProvider-> performAuth() -> auth success");
      Map<String, dynamic> map = json.decode(authenticationResponse.body);
      await _storageHelper.updateCredentials(map['access_token'],
          map['refresh_token'], DateTime.now().toIso8601String(), true);
      await loadUserInformation();
    } else {
      print("UserInformationProvider-> performAuth() ->auth failed");
      print(authenticationResponse);
      authResult = false;
    }

    _authenticationStatus = ViewState.Idle;
    _state = ViewState.Idle;
    notifyListeners();
    return authResult;
  }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write(
            '<html><meta name="viewport" content="width=device-width, initial-scale=1.0"><body> <h2 style="text-align: center; position: absolute; top: 50%; left: 0: right: 0">Welcome to Fritter</h2><h3>You can close this window<script type="javascript">window.close()</script> </h3></body></html>');
      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });
    return onCode.stream;
  }

  Future<void> signOutUser() async {
    print("UserInformationProvider-> signoutUser()");
    _state = ViewState.Busy;
    notifyListeners();
    await _storageHelper.clearStorage();
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> loadUserInformation() async {
    String token = await _storageHelper.authToken;

    if (token == null) {
      return;
    }
    final response = await http.get(
      "https://oauth.reddit.com/api/v1/me",
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus'
      },
    );

    if (response.statusCode == 200)
      userInformation =
          new UserInformationEntity.fromJson(json.decode(response.body));

    final subredditResponse = await http.get(
      "https://oauth.reddit.com/subreddits/mine/?limit=100",
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );

//    // print("Subreddit list request Response code: " +
//        subredditResponse.statusCode.toString());

    if (subredditResponse.statusCode == 200) {
      userSubreddits = new SubredditsSubscribed.fromJsonMap(
          json.decode(subredditResponse.body));

      userSubreddits.data.children.sort((Child a, Child b) {
        return a.display_name
            .toLowerCase()
            .compareTo(b.display_name.toLowerCase());
      });
    }
  }

  Future<void> authenticateUser(BuildContext context) async {
    launchURL(
        context,
        "https://www.reddit.com/api/v1/authorize.compact?client_id=" +
            CLIENT_ID +
            "&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread");
    bool res = await this.performAuthentication();
    // print("final res: " + res.toString());
    if (res) {
      await Provider.of<FeedProvider>(context).fetchPostsListing();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Sign '),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Retry'),
                onPressed: () {
                  authenticateUser(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
