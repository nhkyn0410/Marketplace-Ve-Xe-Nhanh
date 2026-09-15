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
      // `ProblemDetailsDto` có 6 field non-nullable; thiếu ĐÚNG MỘT field là
      // built_value ném và ta mất luôn `code`/`detail` mà server ĐÃ gửi. Đọc lại
      // từng field một để giữ được phần dùng được của body.
      final code = data['code'];
      final detail = data['detail'];
      if (code is String || detail is String) {
        return ApiFailure(
          status: (data['status'] as int?) ?? response?.statusCode ?? 0,
          code: code is String ? code : 'UNEXPECTED_RESPONSE',
          detail: detail is String ? detail : _genericMessage(response),
          requestId: data['requestId'] as String?,
        );
      }
    }
  }

  return ApiFailure(
    status: response?.statusCode ?? 0,
    code: response == null ? 'NETWORK_ERROR' : 'UNEXPECTED_RESPONSE',
    detail: _genericMessage(response),
  );
}

/// Câu hiển thị cho người dùng khi body không nói được gì có ích.
///
/// KHÔNG dùng `DioException.message`: đó là văn bản tiếng Anh nội bộ của thư viện
/// ("...RequestOptions.validateStatus was configured to throw...") — đúng cho log,
/// sai hoàn toàn khi đập thẳng vào mặt người dùng. Trang lỗi HTML 502/503 của
/// hạ tầng là đường chạm được ngay hôm nay.
String _genericMessage(Response<dynamic>? response) {
  if (response == null) return 'Không kết nối được máy chủ.';
  return 'Máy chủ trả lỗi ${response.statusCode}.';
}
