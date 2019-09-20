import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_provider_app/secrets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthProvider with ChangeNotifier {
  bool _signedIn = false;
  bool _isLoading = false;
  String _authToken;
  String _refreshToken;

  AuthProvider() {
    validateAuthentication();
  }

  bool get signedIn => _signedIn;
  String get authToken => _authToken;
  String get refreshToken => _refreshToken;
  bool get isLoading => _isLoading;

  Future<bool> validateAuthentication() async {
    _isLoading = true;
    notifyListeners();
    final storage = new FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();
    print(allValues);
    if (allValues.containsKey('signedIn') && allValues['signedIn'] == "true") {
      _signedIn = true;
    } else {
      _signedIn = false;
    }

    _isLoading = false;
    notifyListeners();
    print("validateAuthentication: " + signedIn.toString());
    return signedIn;
  }

  Future<bool> authenticateUser() async {
    notifyListeners();
    _isLoading = true;
    // start a new instance of the server that listens to localhost requests
    Stream<String> onCode = await _server();
    final String url =
        "https://www.reddit.com/api/v1/authorize.compact?client_id=vFywxbdXsQbSOg&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity";
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
      await storeUserCredentials(_authToken, _refreshToken);
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

  Future<void> storeUserCredentials(
      String authToken, String refreshToken) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "authToken", value: authToken);
    await storage.write(key: "refreshToken", value: refreshToken);
    await storage.write(key: "signedIn", value: signedIn.toString());
  }

  Future<void> signOutUser() async {
    _isLoading = true;
    notifyListeners();
    final storage = new FlutterSecureStorage();
    await storage.delete(key: "authToken");
    await storage.delete(key: "refreshToken");
    await storage.delete(key: "signedIn");
    _isLoading = false;
    _signedIn = false;
    notifyListeners();
  }
}
