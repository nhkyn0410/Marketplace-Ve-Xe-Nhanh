import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Nơi **duy nhất** chạm access token (ADR-017: mobile lưu token bằng
/// `flutter_secure_storage`, không dùng SharedPreferences).
class TokenStorage {
  const TokenStorage([this._storage = const FlutterSecureStorage()]);

  static const _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> clear() => _storage.delete(key: _accessTokenKey);
}
