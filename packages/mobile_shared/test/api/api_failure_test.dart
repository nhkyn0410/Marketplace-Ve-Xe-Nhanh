import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

final _options = RequestOptions(path: '/v1/auth/otp/verify');

DioException _errorWith(Object? body, int status) => DioException.badResponse(
      statusCode: status,
      requestOptions: _options,
      response: Response<dynamic>(
        requestOptions: _options,
        data: body,
        statusCode: status,
      ),
    );

void main() {
  ApiFailure convert(DioException error) =>
      toApiFailure(error, standardSerializers);

  test('problem+json đầy đủ → lấy đúng code, detail, requestId', () {
    // Chép nguyên response thật của API khi nhập sai OTP.
    final failure = convert(_errorWith({
      'type': 'about:blank',
      'title': 'Authentication error',
      'status': 401,
      'detail': 'Thông tin đăng nhập không hợp lệ.',
      'instance': '/v1/auth/otp/verify',
      'code': 'AUTH_INVALID_CREDENTIALS',
      'requestId': '4bf7937d-5ba3-4f88-b5c8-383ce20bbdbf',
    }, 401));

    expect(failure.status, 401);
    expect(failure.code, 'AUTH_INVALID_CREDENTIALS');
    expect(failure.detail, 'Thông tin đăng nhập không hợp lệ.');
    expect(failure.requestId, '4bf7937d-5ba3-4f88-b5c8-383ce20bbdbf');
    expect(failure.isNetworkError, isFalse);
  });

  test('body thiếu field non-nullable vẫn giữ được code và detail của server', () {
    // `ProblemDetailsDto` có 6 field non-nullable. Thiếu `type` + `instance` là
    // built_value ném — nếu bỏ cả body thì mất luôn thông tin server ĐÃ gửi.
    final failure = convert(_errorWith({
      'title': 'Validation error',
      'status': 400,
      'detail': 'Email không hợp lệ.',
      'code': 'VALIDATION_FAILED',
    }, 400));

    expect(failure.code, 'VALIDATION_FAILED');
    expect(failure.detail, 'Email không hợp lệ.');
    expect(failure.status, 400);
  });

  test('body không phải problem+json → không đẩy chuỗi nội bộ của Dio ra UI', () {
    // Trang lỗi HTML 502 của hạ tầng là đường chạm được ngay hôm nay.
    final failure = convert(_errorWith('<html><body>Bad gateway</body></html>', 502));

    expect(failure.status, 502);
    expect(failure.code, 'UNEXPECTED_RESPONSE');
    expect(failure.detail, 'Máy chủ trả lỗi 502.');
    // Thông báo của Dio là tiếng Anh, nói về `validateStatus` — vô nghĩa với
    // người dùng cuối. Ghim lại để không ai đưa nó trở lại.
    expect(failure.detail, isNot(contains('validateStatus')));
  });

  test('không chạm được tới server → isNetworkError', () {
    final failure = convert(DioException.connectionTimeout(
      timeout: const Duration(seconds: 10),
      requestOptions: _options,
    ));

    expect(failure.isNetworkError, isTrue);
    expect(failure.status, 0);
    expect(failure.code, 'NETWORK_ERROR');
  });
}
