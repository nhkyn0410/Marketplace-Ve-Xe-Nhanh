import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

/// Adapter giả: không mở socket, chỉ ghi lại request rồi trả 200 rỗng.
class _CaptureAdapter implements HttpClientAdapter {
  final List<RequestOptions> captured = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured.add(options);
    return ResponseBody.fromString(
      '{"status":"ok"}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('baseUrl là origin trần — KHÔNG được sinh ra `/v1/v1/...`', () async {
    // Đây là bẫy trung tâm của FND-009: tiền tố `/v1` đã nằm sẵn trong code sinh
    // từ OpenAPI (`_path = '/v1/auth/otp/request'`). Ai đó thêm `/v1` vào baseUrl
    // là mọi endpoint ăn 404, và triệu chứng trông y hệt "API chưa chạy".
    final adapter = _CaptureAdapter();
    final client = createApiClient(baseUrl: 'http://test.local:3000');
    client.dio.httpClientAdapter = adapter;

    await client.getAuthApi().authControllerRequestOtp(
          otpRequestDto: OtpRequestDto((b) => b..email = 'rider@example.com'),
        );

    expect(adapter.captured.single.uri.path, '/v1/auth/otp/request');
    expect(adapter.captured.single.uri.toString(),
        'http://test.local:3000/v1/auth/otp/request');
  });

  test('nới timeout đủ cho endpoint gửi OTP', () {
    // Mặc định của generator là receiveTimeout 3s, trong khi
    // `POST /v1/auth/otp/request` chờ nhà cung cấp email trả lời rồi mới đáp 200.
    final client = createApiClient(baseUrl: 'http://test.local:3000');

    expect(client.dio.options.connectTimeout, const Duration(seconds: 10));
    expect(client.dio.options.receiveTimeout, const Duration(seconds: 15));
  });

  test('không truyền tokens thì không gắn AuthInterceptor', () {
    final client = createApiClient(baseUrl: 'http://test.local:3000');

    expect(client.dio.interceptors.whereType<AuthInterceptor>(), isEmpty);
  });
}
