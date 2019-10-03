import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/states.dart';
import 'package:flutter_provider_app/models/subreddits/child.dart';
import 'package:flutter_provider_app/models/subreddits/subreddits_subscribed.dart';
import 'package:flutter_provider_app/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserInformationProvider with ChangeNotifier {
  HttpServer server;
  final _storageHelper = new SecureStorageHelper();

  bool get signedIn => _storageHelper.signInStatus;

  UserInformation userInformation;
  SubredditsSubscribed userSubreddits;

  ViewState _state;

  UserInformationProvider() {
    print("*** Initializeding user information provider ****");
    validateAuthentication();
  }

  ViewState get state => _state;

  Future<void> validateAuthentication() async {
    print("*** Validating authentication ****");

    _state = ViewState.Busy;
    notifyListeners();
    await _storageHelper.fetchData();

    if (_storageHelper.signInStatus) {
      await performTokenRefresh();
      await loadUserInformation();
    } else {
      print("** user is not authenticated");
    }

    _state = ViewState.Idle;
    print("validate authentication debug print" + _storageHelper.debugPrint);
    notifyListeners();
  }

  Future<void> performAuthentication() async {
    if (server != null) {
      await server.close(force: true);
    }
    print("*** Performing authentication ****");

    notifyListeners();
    _state = ViewState.Busy;
    // start a new instance of the server that listens to localhost requests
    Stream<String> onCode = await _server();
    final String url =
        "https://www.reddit.com/api/v1/authorize.compact?client_id=" +
            CLIENT_ID +
            "&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread";
    launch(url);

    // server returns the first access_code it receives
    final String accessCode = await onCode.first;
    print("Local host response: " + accessCode);

    // now we use this code to obtain authentication token and other shit

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

    print(
        "New authentication response code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      await _storageHelper.updateCredentials(map['access_token'],
          map['refresh_token'], DateTime.now().toIso8601String(), true);
      await loadUserInformation();
    } else {
      print("Authentication failed");
    }
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((HttpRequest request) async {
      print("Server started");
      final String code = request.uri.queryParameters["code"];
      print(request.uri.pathSegments);
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write(
            "<html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><h1 style='margin: 0 auto; height:100%; text-align:center;'>Close this window and go frit yourself.</h1></html>");
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
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> performTokenRefresh() async {
    print("******* PERFORMING A TOKEN REFRESH *****");
    String user = CLIENT_ID;
    String password = "";
    String basicAuth = "Basic " + base64Encode(utf8.encode('$user:$password'));
    _state = ViewState.Busy;
    notifyListeners();
    final response = await http.post(
      "https://www.reddit.com/api/v1/access_token",
      headers: {
        "Authorization": basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body:
          "grant_type=refresh_token&refresh_token=${await _storageHelper.refreshToken}",
    );

    print("Token refresh status code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print(map);
      await _storageHelper.updateAuthToken(map['access_token']);
    } else {
      print("Failed to refresh token");
      print(json.decode(response.body));
    }
    _state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> loadUserInformation() async {
    print("*** Loading user information ****");

    String token = await _storageHelper.authToken;

    final response = await http.get(
      "https://oauth.reddit.com/api/v1/me",
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus'
      },
    );
    print("Loading user information response code: " +
        response.statusCode.toString());

    if (response.statusCode == 200)
      userInformation =
          new UserInformation.fromJsonMap(json.decode(response.body));

    final subredditResponse = await http.get(
      "https://oauth.reddit.com/subreddits/mine/?limit=100",
      headers: {
        'Authorization': 'bearer ' + token,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );

    print("Subreddit list request Response code: " +
        subredditResponse.statusCode.toString());

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
}
