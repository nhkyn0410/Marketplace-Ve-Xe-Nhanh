import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Tên header, viết thường: HTTP không phân biệt hoa thường nhưng `Map` của Dio
/// thì có, nên phải dùng đúng một hằng ở cả code lẫn test.
const authorizationHeader = 'authorization';

/// Gắn `Authorization: Bearer <token>` vào mọi request và dọn token khi API trả 401.
///
/// Phải tự viết vì OpenAPI spec hiện **không khai security scheme** nào — mọi
/// method sinh ra đều mang `'secure': <Map<String, String>>[]`, nên
/// `BearerAuthInterceptor` của client sinh tự động không có gì để khớp và sẽ
/// không bao giờ đính header. Khi FND-008 khai `addBearerAuth()` thì xem lại
/// chỗ này để tránh gắn hai lần.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens, {this.onUnauthorized});

  final TokenStore _tokens;

  /// Chạy sau khi token bị xoá vì 401 — nơi app điều hướng về màn đăng nhập.

  final Future<void> Function()? onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    //Không ghi đè nếu lời gọi đã tự đặt header (vd luồng refresh).
    if (!options.headers.containsKey(authorizationHeader)) {
      final token = await _tokens.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[authorizationHeader] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // CHỈ 401. Lỗi hạ tầng (500/503) mà cũng xoá token thì người dùng bị đá ra
    // màn đăng nhập mỗi lần API sập — cùng loại sai lầm mà `isClientAuthError`
    // ở backend đã tránh.
    if (err.response?.statusCode == 401) {
      await _tokens.clear();
      await onUnauthorized?.call();
    }
    handler.next(err);
  }
}
