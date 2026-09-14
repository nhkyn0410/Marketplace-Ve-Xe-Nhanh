import 'package:api_client_dart/api_client_dart.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

/// Lỗi API đã có kiểu, dịch từ RFC 7807 (`application/problem+json`) của API.
///
/// Có lớp này thì tầng UI không phải đụng `DioException`: nó chỉ đọc [code]
/// (mã trong GLOSSARY, vd `AUTH_INVALID_CREDENTIALS`) và [detail].
class ApiFailure implements Exception {
  const ApiFailure({
    required this.status,
    required this.code,
    required this.detail,
    this.requestId,
  });

  final int status;
  final String code;
  final String detail;

  /// Dán vào log server để tra đúng request (FND-006 gắn `x-request-id`).
  final String? requestId;

  /// `true` khi chưa chạm được tới API: mất mạng, sai địa chỉ, timeout.
  bool get isNetworkError => status == 0;

  @override
  String toString() => '[$code] $detail';
}

/// Dịch [DioException] sang [ApiFailure].
///
/// `serializers` lấy từ `ApiClientDart.serializers` — phải đúng bộ đó, vì
/// `ProblemDetailsDto` là built_value chứ không parse tay được.
ApiFailure toApiFailure(DioException error, Serializers serializers) {
  final response = error.response;
  final data = response?.data;

  // Dio 5 tự decode `application/problem+json` (nó nhận hậu tố `+json`),
  // nên tới đây `data` đã là Map chứ không còn là chuỗi.
  if (data is Map) {
    try {
      final problem = serializers.deserializeWith(
        ProblemDetailsDto.serializer,
        Map<String, dynamic>.from(data),
      )!;
      return ApiFailure(
        status: problem.status,
        code: problem.code,
        detail: problem.detail,
        requestId: problem.requestId,
      );
    } catch (_) {
      // Body không đúng dạng problem+json — rơi xuống nhánh chung bên dưới.
    }
  }

  return ApiFailure(
    status: response?.statusCode ?? 0,
    code: response == null ? 'NETWORK_ERROR' : 'UNEXPECTED_RESPONSE',
    detail: error.message ?? 'Không gọi được API.',
  );
}
