import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_provider_app/models/Subreddit.dart';
import 'package:flutter_provider_app/models/UserInformation.dart';
import 'package:flutter_provider_app/secrets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserInformationProvider with ChangeNotifier {
  AppUserInformation userInformation;

  bool _signedIn = false;
  bool _isLoading = false;
  String _authToken;
  String _refreshToken;

  UserInformationProvider() {
    validateAuthentication();
  }

  bool get signedIn => _signedIn;
  String get authToken => _authToken;
  String get refreshToken => _refreshToken;
  bool get isLoading => _isLoading;
  final storage = new FlutterSecureStorage();

  Future<bool> validateAuthentication() async {
    _isLoading = true;
    notifyListeners();
    Map<String, String> allValues = await storage.readAll();
    print(allValues);
    if (allValues.containsKey('signedIn') && allValues['signedIn'] == "true") {
      _authToken = allValues['authToken'];
      _refreshToken = allValues['refreshToken'];
      if (await needsTokenRefresh()) {
        performTokenRefresh();
      }
      await loadUserInformation();
      _signedIn = true;
    } else {
      _signedIn = false;
    }

    _isLoading = false;
    notifyListeners();
    print("validateAuthentication: " + signedIn.toString());
    return signedIn;
  }

  Future<bool> performAuthentication() async {
    notifyListeners();
    _isLoading = true;
    // start a new instance of the server that listens to localhost requests
    Stream<String> onCode = await _server();
    final String url =
        "https://www.reddit.com/api/v1/authorize.compact?client_id=" +
            CLIENT_ID +
            "&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread";
    launch(url);

    // server returns the first acess_code it receives
    final String accessCode = await onCode.first;

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

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      _authToken = map['access_token'];
      _refreshToken = map["refresh_token"];
      _signedIn = true;
      await updateStorageUserCredentials();
      await loadUserInformation();
      print(signedIn);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _signedIn = false;
      print("Authentication failed");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    HttpServer server;
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

  Future<void> updateStorageUserCredentials() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "authToken", value: _authToken);
    await storage.write(key: "refreshToken", value: _refreshToken);
    await storage.write(key: "signedIn", value: _signedIn.toString());
    await storage.write(
      key: "lastTokenRefresh",
      value: DateTime.now().toIso8601String(),
    );

    _authToken = await storage.read(key: 'authToken');
    _refreshToken = await storage.read(key: 'refreshToken');
  }

  Future<void> signOutUser() async {
    _isLoading = true;
    notifyListeners();
    await storage.delete(key: "authToken");
    await storage.delete(key: "refreshToken");
    await storage.delete(key: "signedIn");
    await storage.delete(key: "lastTokenRefresh");
    _isLoading = false;
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> needsTokenRefresh() async {
    Duration time = (DateTime.now()).difference(
        DateTime.parse(await storage.read(key: 'lastTokenRefresh')));
    print(time.toString());
    if (time.inMinutes > 50) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> performTokenRefresh() async {
    String user = CLIENT_ID;
    String password = "";
    String basicAuth = "Basic " + base64Encode(utf8.encode('$user:$password'));
    _isLoading = true;
    notifyListeners();
    final response = await http.post(
      "https://www.reddit.com/api/v1/access_token",
      headers: {
        "Authorization": basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: "grant_type=refresh_token&refresh_token=$_refreshToken",
    );

    Map<String, dynamic> map = json.decode(response.body);
    print(map);
    _authToken = map['access_token'];
    await updateStorageUserCredentials();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserInformation() async {
    final response = await http.get(
      "https://oauth.reddit.com/api/v1/me",
      headers: {
        'Authorization': 'bearer ' + _authToken,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus'
      },
    );
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> subsList;
    final subredditResponse = await http.get(
      "https://oauth.reddit.com/subreddits/mine/subscriber",
      headers: {
        'Authorization': 'bearer ' + _authToken,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus'
      },
    );
    Map<String, dynamic> subRedditMap = json.decode(subredditResponse.body);
    List<dynamic> myList = subRedditMap['data']['children'];
//    print(myList);
    subsList = myList.map((e) {
      String icon_url = "";
      if (e['data']['icon_img'] == "") {
        if (e['data']['community_icon'] == "") {
          icon_url =
              e['data']['header_img'] != null ? e['data']['header_img'] : "";
        } else {
          icon_url = e['data']['community_icon'];
        }
      } else {
        icon_url = e['data']['icon_img'];
      }
      return (new Subreddit(
          display_name: e['data']['display_name'],
          header_img: e['data']['header_img'],
          display_name_prefixed: e['data']['display_name_prefixed'],
          subscribers: e['data']['subscribers'].toString(),
          community_icon: icon_url,
          user_is_subscriber: e['data']['user_is_subscriber'].toString(),
          url: e['data']['url']));
    }).toList();
    for (Subreddit x in subsList) print(x.community_icon);
    userInformation = new AppUserInformation(
      icon_color: map['subreddit']['icon_color'],
      icon_img: map['subreddit']['icon_img'],
      display_name_prefixed: map['subreddit']['display_name_prefixed'],
      comment_karma: map['comment_karma'].toString(),
      link_karma: map['link_karma'].toString(),
      subredditsList: subsList,
    );
  }
}
