/// Code Dart dùng chung giữa `passenger_mobile` và `employee_mobile` (ADR-028).
///
/// Quy tắc: KHÔNG đưa vào đây thứ gì kéo theo permission — đặc biệt background
/// geolocation. Lý do tách 2 app là để app hành khách không phải khai nó.
library;

export 'src/api/api_client_factory.dart';
export 'src/api/api_failure.dart';
export 'src/storage/token_storage.dart';
