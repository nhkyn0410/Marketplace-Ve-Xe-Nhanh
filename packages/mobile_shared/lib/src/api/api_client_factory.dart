import 'package:api_client_dart/api_client_dart.dart';

/// Tạo client API dùng chung cho cả hai app.
///
/// [baseUrl] chỉ là **origin** (vd `http://10.0.2.2:3000`) — KHÔNG kèm `/v1`.
/// Tiền tố phiên bản đã nằm sẵn trong code sinh từ OpenAPI
/// (`_path = '/v1/auth/otp/request'`), nối thêm ở đây sẽ ra `/v1/v1/...`.
ApiClientDart createApiClient({required String baseUrl}) {
  final client = ApiClientDart(basePathOverride: baseUrl);

  // Generator đặt mặc định receiveTimeout = 3s. `POST /v1/auth/otp/request`
  // chờ nhà cung cấp email trả lời rồi mới đáp 200, nên 3s là hụt và lỗi hiện
  // ra dưới dạng timeout chứ không phải lỗi thật. Nới cho đủ thở.
  client.dio.options
    ..connectTimeout = const Duration(seconds: 10)
    ..receiveTimeout = const Duration(seconds: 15);

  return client;
}
