import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final _storage = new FlutterSecureStorage();
  Map<String, dynamic> map = new Map<String, dynamic>();

  SecureStorageHelper() {
    fetchData();
  }

  Future<String> get authToken async {
    await fetchData();
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
    if (map != null)
      return (map.containsKey('signedIn') && map['signedIn'] == "true");
    else {
      return false;
    }
  }

  Future<bool> needsTokenRefresh() async {
    Duration time =
        (DateTime.now()).difference(DateTime.parse(await lastTokenRefresh));
    print("Time since last token refresh: " + time.inMinutes.toString());
    if (time.inMinutes > 30) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateCredentials(String authToken, String refreshToken,
      String lastTokenRefresh, bool signedIn) async {
    await _storage.write(key: "authToken", value: authToken);
    await _storage.write(key: "refreshToken", value: refreshToken);
    await _storage.write(key: "signedIn", value: signedIn.toString());
    await _storage.write(
      key: "lastTokenRefresh",
      value: DateTime.now().toIso8601String(),
    );

    await fetchData();
  }

  Future<void> updateAuthToken(String accessToken) async {
    map['authToken'] = accessToken;
    await _storage.write(key: 'authToken', value: accessToken);
    await _storage.write(
        key: 'lastTokenRefresh', value: DateTime.now().toIso8601String());
  }

  Future<void> fetchData() async {
    map = await _storage.readAll();
  }

  bool getSignInStatus() {
    return map.containsKey('signedIn') && map['signedIn'] == "true";
  }

  Future<void> clearStorage() async {
    map = new Map<String, dynamic>();
    await _storage.deleteAll();
    await fetchData();
  }
}
