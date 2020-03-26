import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../secrets.dart';

class SecureStorageHelper {
  SecureStorage _storage;
  Map<String, dynamic> map = Map();

  SecureStorageHelper() {
    if (Platform.isAndroid || Platform.isIOS) {
      _storage = MobileSecureStorage();
    } else if (Platform.isMacOS) {
      _storage = MacOSSecureStorage();
    } else {
      throw UnsupportedError(
          '${Platform.operatingSystem} is not currently supported');
    }
  }

  Future<void> init() async {
    await fetchData();
  }

  Future<String> get authToken => _storage.read('authToken');

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
    // print("storage helper: signin status: map key check" +
//        map.containsKey('signedIn').toString());
    if (map.containsKey('signedIn') && map['signedIn'] == "true") {
      return true;
    } else {
      print('not signed in');

      return false;
    }
  }

  Future<bool> needsTokenRefresh() async {
    Duration time =
        (DateTime.now()).difference(DateTime.parse(await lastTokenRefresh));
    // print("Time since last token refresh: " + time.inMinutes.toString());
    // print(await authToken);
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
    // print("Storage helper: Update Credentials : " + map.toString());
    await fetchData();
    // print("Storage helper: Update Credentials : " + map.toString());
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
    if (Platform.operatingSystem != null) {
      print('before');
      map = await _storage.readAll();
      print('after');
    } else {
      print("skip init");
      map = new Map();
    }
  }

  Future<void> clearStorage() async {
    map = new Map<String, dynamic>();
    await _storage.deleteAll();
    await fetchData();
  }

  Future<void> performTokenRefresh() async {
    // print("******* PERFORMING A TOKEN REFRESH *****");
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

    // print("Token refresh status code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      // print("Refreshed token: " + map.toString());
      await updateAuthToken(map['access_token']);
    } else {
      // print("Failed to refresh token");
      // print(json.decode(response.body));
    }
  }
}

abstract class SecureStorage {
  Future<void> write({
    @required String key,
    @required String value,
  });

  Future<Map<String, String>> readAll();

  Future<void> deleteAll();

  Future<String> read(String s);
}

class MobileSecureStorage extends SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();

  @override
  Future<void> write({String key, String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String> read(String key) {
    return _storage.read(key: key);
  }
}

/// This is actually not secure at all. It's just sharedPreferences. This will
/// change once Keychain support is added for macOS.
class MacOSSecureStorage extends SecureStorage {
  @override
  Future<void> deleteAll() async {
    final prefs = await sharedPreferences;
    return prefs.clear();
  }

  @override
  Future<Map<String, String>> readAll() async {
    final prefs = await sharedPreferences;
    return {
      "authToken": prefs.getString("authToken"),
      "refreshToken": prefs.getString("refreshToken"),
      "signedIn": prefs.getString("signedIn"),
      "lastTokenRefresh": prefs.getString("lastTokenRefresh"),
    };
  }

  @override
  Future<void> write({String key, String value}) async {
    final prefs = await sharedPreferences;
    prefs.setString(key, value);
  }

  Future<SharedPreferences> get sharedPreferences async =>
      await SharedPreferences.getInstance();

  @override
  Future<String> read(String key) async {
    final prefs = await sharedPreferences;
    return prefs.getString(key);
  }
}
