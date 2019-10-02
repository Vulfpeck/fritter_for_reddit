import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final _storage = new FlutterSecureStorage();
  Map<String, dynamic> map = new Map<String, dynamic>();

  SecureStorageHelper() {
    fetchData();
  }

  String get authToken => map['authToken'];
  String get debugPrint => map.toString();
  String get refreshToken => map['refreshToken'];
  String get lastTokenRefresh => map['lastTokenRefresh'];

  bool get signInStatus =>
      (map.containsKey('signedIn') && map['signedIn'] == "true");

  bool needsTokenRefresh() {
    Duration time =
        (DateTime.now()).difference(DateTime.parse(lastTokenRefresh));
    print(time.toString());
    if (time.inMinutes > 50) {
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
  }

  Future<void> fetchData() async {
    map = await _storage.readAll();
    print(map);
  }

  bool getSignInStatus() {
    return map.containsKey('signedIn') && map['signedIn'] == "true";
  }

  Future<void> clearStorage() async {
    map = new Map<String, dynamic>();
    await _storage.deleteAll();
  }
}
