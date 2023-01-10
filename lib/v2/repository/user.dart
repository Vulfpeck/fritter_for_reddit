import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _AUTH_TOKEN_KEY = 'auth_token';
const _REFRESH_TOKEN_KEY = 'refresh_token';
const _EXPIRES_AT = 'refresh_token';
final storage = new FlutterSecureStorage();

class SignedInUserTokenData {
  final String? authToken;
  final String? refreshToken;
  final DateTime expiresAt;

  SignedInUserTokenData(this.authToken, this.refreshToken, this.expiresAt);
}

class UserRepository {
  SignedInUserTokenData? _signedInUserTokenData;

  SignedInUserTokenData? get tokenData => _signedInUserTokenData;

  UserRepository._init(SignedInUserTokenData? tokenData)
      : _signedInUserTokenData = tokenData;

  static Future<UserRepository> create() async {
    String? currentAuthToken = await storage.read(key: _AUTH_TOKEN_KEY);
    String? currentRefreshToken = await storage.read(key: _REFRESH_TOKEN_KEY);
    String? expiresAtString = await storage.read(key: _REFRESH_TOKEN_KEY);

    SignedInUserTokenData? tokenData = null;
    if (currentRefreshToken != null) {
      tokenData = SignedInUserTokenData(
        currentAuthToken,
        currentRefreshToken,
        DateTime.parse(expiresAtString!),
      );
    }

    return UserRepository._init(tokenData);
  }

  Future updateTokenData(SignedInUserTokenData tokenData) async {
    await storage.write(key: _AUTH_TOKEN_KEY, value: tokenData.authToken);
    await storage.write(key: _REFRESH_TOKEN_KEY, value: tokenData.refreshToken);
    await storage.write(
      key: _EXPIRES_AT,
      value: tokenData.expiresAt != null
          ? tokenData.expiresAt.toIso8601String()
          : null,
    );

    _signedInUserTokenData = tokenData;
  }

  Future clearTokenData() async {
    await storage.delete(key: _AUTH_TOKEN_KEY);
    await storage.delete(key: _REFRESH_TOKEN_KEY);
    await storage.delete(key: _EXPIRES_AT);
  }
}
