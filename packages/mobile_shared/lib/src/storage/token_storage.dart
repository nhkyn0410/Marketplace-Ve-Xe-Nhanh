import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Hợp đồng đọc/ghi access token.
///
/// Tách khỏi [TokenStorage] để những thứ *dùng* token (vd `AuthInterceptor`)
/// test được mà không phải kéo theo platform channel của
/// `flutter_secure_storage`. Bản thân [TokenStorage] vẫn được test riêng ở
/// `test/storage/token_storage_test.dart` bằng cách giả lập chính channel đó.
abstract interface class TokenStore {
  Future<String?> readAccessToken();
  Future<void> saveAccessToken(String token);
  Future<void> clear();
}

/// Nơi **duy nhất** chạm access token thật (ADR-017: mobile lưu token bằng
/// `flutter_secure_storage`, không dùng SharedPreferences).
class TokenStorage implements TokenStore {
  const TokenStorage([this._storage = const FlutterSecureStorage()]);

  static const _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<void> clear() => _storage.delete(key: _accessTokenKey);
}
