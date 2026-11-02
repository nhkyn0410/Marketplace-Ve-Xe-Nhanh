import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Tên header, viết thường.
///
/// `RequestOptions.headers` của Dio **là** map không phân biệt hoa thường
/// (`caseInsensitiveKeyMap` trong `options.dart`), nên `containsKey` bên dưới
/// bắt được cả `Authorization` lẫn `authorization`. Vẫn giữ một hằng dùng chung
/// cho code và test để khỏi lệch nhau.
const authorizationHeader = 'authorization';

const _retriedKey = 'auth_retried';

/// Cặp token sau khi xoay phiên (`POST /auth/refresh`).
typedef SessionTokens = ({String accessToken, String refreshToken});

/// Đổi refresh token lấy cặp mới; máy chủ từ chối thì ném [DioException] kèm status.
typedef SessionRefresher = Future<SessionTokens> Function(String refreshToken);

/// Gửi lại request bằng token mới.
typedef RequestRetrier = Future<Response<dynamic>> Function(RequestOptions);

/// Đổi token qua [dio]. [dio] không được gắn [AuthInterceptor]: lời gọi đổi token
/// mà tự kích hoạt đổi token thì lặp vô hạn.
SessionRefresher bearerSessionRefresher(Dio dio) => (refreshToken) async {
  final response = await dio.post<Map<String, dynamic>>(
    '/v1/auth/refresh',
    data: {'refreshToken': refreshToken},
  );
  final data = response.data!;
  return (
    accessToken: data['accessToken'] as String,
    refreshToken: data['refreshToken'] as String,
  );
};

/// Gắn `Authorization: Bearer <token>` vào mọi request; access token hết hạn thì
/// đổi bằng refresh token rồi gửi lại, chỉ khi phiên hết hẳn mới dọn token.
///
/// Phải tự viết vì OpenAPI spec hiện **không khai security scheme** nào — mọi
/// method sinh ra đều mang `'secure': <Map<String, String>>[]`, nên
/// `BearerAuthInterceptor` của client sinh tự động không có gì để khớp và sẽ
/// không bao giờ đính header. Khi FND-008 khai `addBearerAuth()` thì xem lại
/// chỗ này để tránh gắn hai lần.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._tokens, {
    this.onUnauthorized,
    this.refreshSession,
    this.retry,
  });

  final TokenStore _tokens;

  /// Chạy sau khi phiên hết hẳn và token đã bị xoá — nơi app về màn đăng nhập.
  final Future<void> Function()? onUnauthorized;

  /// `null` thì 401 là hết phiên, không thử đổi token.
  final SessionRefresher? refreshSession;
  final RequestRetrier? retry;

  /// Lần đổi token đang chạy. Các request 401 cùng lúc phải chờ chung một lần:
  /// refresh token xoay vòng, gửi lại token cũ là máy chủ thu hồi cả phiên.
  Future<String?>? _renewal;

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
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }
    final options = err.requestOptions;
    final Object? sentHeader = options.headers[authorizationHeader];
    // Request ẩn danh (vd OTP sai) trả 401 không liên quan tới phiên nào.
    if (sentHeader == null) {
      handler.next(err);
      return;
    }
    final refresh = refreshSession;
    final send = retry;
    if (refresh == null || send == null || options.extra[_retriedKey] == true) {
      await _endSession();
      handler.next(err);
      return;
    }

    final String? accessToken;
    try {
      accessToken = await _renewAccessToken(sentHeader, refresh);
    } catch (_) {
      // Mất mạng, 429, 503: phiên có thể còn tốt, giữ token để người dùng thử lại.
      handler.next(err);
      return;
    }
    if (accessToken == null) {
      await _endSession();
      handler.next(err);
      return;
    }

    options.headers[authorizationHeader] = 'Bearer $accessToken';
    options.extra[_retriedKey] = true;
    final data = options.data;
    // FormData đã gửi một lần thì không đọc lại được.
    if (data is FormData) options.data = data.clone();
    try {
      handler.resolve(await send(options));
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  /// Token mới, hoặc `null` khi phiên đã hết hẳn. Lỗi tạm thời được ném ra.
  Future<String?> _renewAccessToken(
    Object sentHeader,
    SessionRefresher refresh,
  ) async {
    final current = await _tokens.readAccessToken();
    // Request khác đã đổi xong trong lúc request này chờ máy chủ trả lời.
    if (current != null &&
        current.isNotEmpty &&
        'Bearer $current' != sentHeader) {
      return current;
    }
    return _renewal ??= _rotate(refresh).whenComplete(() => _renewal = null);
  }

  Future<String?> _rotate(SessionRefresher refresh) async {
    final refreshToken = await _tokens.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      final fresh = await refresh(refreshToken);
      await _tokens.saveSession(
        accessToken: fresh.accessToken,
        refreshToken: fresh.refreshToken,
      );
      return fresh.accessToken;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) return null;
      rethrow;
    }
  }

  Future<void> _endSession() async {
    // Nhiều request 401 cùng lúc chỉ báo hết phiên một lần.
    final hadSession =
        await _tokens.readAccessToken() != null ||
        await _tokens.readRefreshToken() != null;
    await _tokens.clear();
    if (hadSession) await onUnauthorized?.call();
  }
}
