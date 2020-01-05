import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../secrets.dart';

class SecureStorageHelper {
  final _storage = new FlutterSecureStorage();
  Map<String, dynamic> map = new Map();

  SecureStorageHelper();
  Future<void> init() async {
    await fetchData();
  }

  Future<String> get authToken async {
    return map['authToken'];
  }

  String get debugPrint => map.toString();

  Future<String> get refreshToken async {
    await fetchData();
    return map['refreshToken'];
  }

  Future<String> get lastTokenRefresh async {
    await fetchData();
    return map['lastTokenRefresh'];
  }

  bool get signInStatus {
    print("storage helper: signin status: map key check" +
        map.containsKey('signedIn').toString());
    if (map.containsKey('signedIn') && map['signedIn'] == "true") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> needsTokenRefresh() async {
    Duration time =
        (DateTime.now()).difference(DateTime.parse(await lastTokenRefresh));
    print("Time since last token refresh: " + time.inMinutes.toString());
    print(await authToken);
    if (time.inMinutes > 30) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateCredentials(
    String authToken,
    String refreshToken,
    String lastTokenRefresh,
    bool signedIn,
  ) async {
    await _storage.write(key: "authToken", value: authToken);
    await _storage.write(key: "refreshToken", value: refreshToken);
    await _storage.write(key: "signedIn", value: signedIn.toString());
    await _storage.write(
      key: "lastTokenRefresh",
      value: DateTime.now().toIso8601String(),
    );
    print("Storage helper: Update Credentials : " + map.toString());
    await fetchData();
    print("Storage helper: Update Credentials : " + map.toString());
  }

  Future<void> updateAuthToken(String accessToken) async {
    map['authToken'] = accessToken;
    await _storage.write(key: 'authToken', value: accessToken);
    await _storage.write(
      key: 'lastTokenRefresh',
      value: DateTime.now().toIso8601String(),
    );
    await _storage.write(
      key: 'signedIn',
      value: true.toString(),
    );
  }

  Future<void> fetchData() async {
    map = await _storage.readAll();
  }

  Future<void> clearStorage() async {
    map = new Map<String, dynamic>();
    await _storage.deleteAll();
    await fetchData();
  }

  Future<void> performTokenRefresh() async {
    print("******* PERFORMING A TOKEN REFRESH *****");
    String user = CLIENT_ID;
    String password = "";
    String basicAuth = "Basic " + base64Encode(utf8.encode('$user:$password'));
    final response = await http
        .post(
      "https://www.reddit.com/api/v1/access_token",
      headers: {
        "Authorization": basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: "grant_type=refresh_token&refresh_token=${await refreshToken}",
    )
        .catchError((e) {
      this.clearStorage();
    });

    print("Token refresh status code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print("Refreshed token: " + map.toString());
      await updateAuthToken(map['access_token']);
    } else {
      print("Failed to refresh token");
      print(json.decode(response.body));
    }
  }
}
