import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/models/states.dart';
import 'package:fritter_for_reddit/models/subreddits/child.dart';
import 'package:fritter_for_reddit/models/subreddits/subreddits_subscribed.dart';
import 'package:fritter_for_reddit/models/user_profile/user_information_entity.dart';
import 'package:fritter_for_reddit/secrets.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';
import 'package:http/http.dart' as http;

class UserInformationProvider with ChangeNotifier {
  static UserInformationProvider of(BuildContext context,
          {bool listen = false}) =>
      Provider.of<UserInformationProvider>(context, listen: listen);

  HttpServer server;
  final _storageHelper = new SecureStorageHelper();

  bool get signedIn => _storageHelper.signInStatus;

  UserInformationEntity userInformation;
  SubredditsSubscribed userSubreddits;

  ViewState _state;
  ViewState _authenticationStatus;

  ViewState get authenticationStatus => _authenticationStatus;

  UserInformationProvider() {
//    // print("*** Initializing user information provider ****");
    validateAuthentication();
  }

  ViewState get state => _state;

  Future<void> performTokenRefresh() async {
    await _storageHelper.performTokenRefresh();
  }

  Future<void> validateAuthentication() async {
//    // print("*** Validating authentication ****");
    await _storageHelper.init();
    _state = ViewState.Busy;
    notifyListeners();

    if (_storageHelper.signInStatus) {
      await _storageHelper.performTokenRefresh();
      await loadUserInformation();
    } else {
//      // print("** user is not authenticated");
    }

    _state = ViewState.Idle;
    // // print("validate authentication debug // // print" + _storageHelper.debug// // print);
    notifyListeners();
  }

  Future<bool> performAuthentication() async {
    _authenticationStatus = ViewState.Busy;
    notifyListeners();
    bool authResult = true;
    if (server != null) {
      await server.close(force: true);
    }
    await _storageHelper.clearStorage();
//    // print("*** Performing authentication ****");
    // start a new instance of the server that listens to localhost requests
    Stream<String> onCode = await accessCodeServer();

    // server returns the first access_code it receives

    final String accessCode = await onCode.first;
//    // print("local host response");

    notifyListeners();
    _authenticationStatus = ViewState.Busy;
    if (accessCode == null) {
//      // print("isNull");
      authResult = false;
    }

    // now we use this code to obtain authentication token and other data

    String user = CLIENT_ID;
    String password = ""; // blank for unknown clients like apps

    String basicAuth = "Basic " + base64Encode(utf8.encode('$user:$password'));
    final response = await http.post(
      "https://www.reddit.com/api/v1/access_token",
      headers: {
        "Authorization": basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body:
          "grant_type=authorization_code&code=$accessCode&redirect_uri=http://localhost:8080/",
    );

//    // print(
//        "New authentication response code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      await _storageHelper.updateCredentials(map['access_token'],
          map['refresh_token'], DateTime.now().toIso8601String(), true);
//      // print('authentication: token stored to secure storage');
      await loadUserInformation();
    } else {
//      // print("Authentication failed");
      authResult = false;
    }

    _authenticationStatus = ViewState.Idle;
    _state = ViewState.Idle;
    notifyListeners();
    return authResult;
  }

  Future<Stream<String>> accessCodeServer() async {
    final StreamController<String> onCode = new StreamController();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((HttpRequest request) async {
//      // print("Server started");
      final String code = request.uri.queryParameters["code"];
//      // print(request.uri.pathSegments);
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
    _state = ViewState.Busy;
    notifyListeners();
    await _storageHelper.clearStorage();
    userInformation = null;
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> loadUserInformation() async {
//    // print("*** Loading user information ****");

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
//    // print("Loading user information response code: " +
//        response.statusCode.toString());
//    // print(json.decode(response.body));

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

      userSubreddits.data.children
          .sort((SubredditListChild a, SubredditListChild b) {
        return a.display_name
            .toLowerCase()
            .compareTo(b.display_name.toLowerCase());
      });
    }
  }

  @override
  void notifyListeners() {
    runAssertions();
    super.notifyListeners();
  }

  void runAssertions() {
    // if signed in, make sure that userInformation isn't null
    if (state == ViewState.Idle) {
      assert(!(signedIn && userInformation == null));
    }
    // and vice versa
    if (state == ViewState.Idle) {
      assert(!(!signedIn && userInformation != null));
    }
  }

  Future<void> authenticateUser(BuildContext context) async {
    const url = "https://www.reddit.com/api/v1/authorize.compact?client_id=" +
        CLIENT_ID +
        "&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread";
    // TODO: Embed a WebView for macOS when this is supported.
    launchURL(Theme.of(context).primaryColor, url);
    bool res = await this.performAuthentication();
    // print("final res: " + res.toString());
    if (res) {
      await Provider.of<FeedProvider>(context, listen: false)
          .navigateToSubreddit('');
      if (!PlatformX.isDesktop && Navigator.canPop(context)) {
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
