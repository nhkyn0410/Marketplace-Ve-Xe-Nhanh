import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

const _connectTimeout = Duration(seconds: 10);
const _receiveTimeout = Duration(seconds: 15);

/// Tạo client API dùng chung cho cả hai app.
///
/// [baseUrl] chỉ là **origin** (vd `http://10.0.2.2:3000`) — KHÔNG kèm `/v1`.
/// Tiền tố phiên bản đã nằm sẵn trong code sinh từ OpenAPI
/// (`_path = '/v1/auth/otp/request'`), nối thêm ở đây sẽ ra `/v1/v1/...`.
ApiClientDart createApiClient({
  required String baseUrl,
  TokenStore? tokens,
  Future<void> Function()? onUnauthorized,
}) {
  final client = ApiClientDart(basePathOverride: baseUrl);
  client.dio.options
    ..connectTimeout = _connectTimeout
    ..receiveTimeout = _receiveTimeout;

  if (tokens != null) {
    client.dio.interceptors.add(
      AuthInterceptor(
        tokens,
        onUnauthorized: onUnauthorized,
        refreshSession: bearerSessionRefresher(
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: _connectTimeout,
              receiveTimeout: _receiveTimeout,
            ),
          ),
        ),
        retry: client.dio.fetch,
      ),
    );
  }

  return client;
}
