import 'package:flutter/foundation.dart';

/// Liên hệ hỗ trợ của sàn — một nguồn duy nhất cho mọi màn của app (web dùng
/// `apps/marketplace/lib/support-contact.ts`).
///
/// Số tổng đài lấy từ `--dart-define=SUPPORT_HOTLINE=...` lúc build (vd
/// "1900 1234"). Để trống thì các màn không hiện số để gọi mà hướng khách sang
/// email hỗ trợ (AS-16 cho phép email / ticket thay hotline).
@immutable
class SupportContact {
  const SupportContact({this.hotline = ''});

  /// Cấu hình của bản build đang chạy.
  static const configured = SupportContact(
    hotline: String.fromEnvironment('SUPPORT_HOTLINE'),
  );

  static const email = 'support@vexenhanh.vn';

  /// Giá trị thô từ cấu hình; hiển thị thì dùng [label].
  final String hotline;

  String get _digits => hotline.replaceAll(RegExp(r'[^\d+]'), '');

  /// Đã cấu hình số tổng đài hay chưa.
  bool get hasHotline => _digits.length >= 3;

  /// Chữ hiển thị của kênh liên hệ: số tổng đài, hoặc địa chỉ email khi chưa có số.
  String get label => hasHotline ? hotline.trim() : email;

  /// Kênh liên hệ để mở: gọi tổng đài, hoặc soạn email khi chưa có số.
  Uri get uri => hasHotline
      ? Uri(scheme: 'tel', path: _digits)
      : Uri(scheme: 'mailto', path: email);

  /// Vế câu hướng dẫn: "gọi tổng đài 1900 1234" / "gửi email tới support@…".
  String get instruction =>
      hasHotline ? 'gọi tổng đài $label' : 'gửi email tới $label';

  /// Báo khi máy không mở được ứng dụng gọi điện / email.
  String get launchFailureMessage => hasHotline
      ? 'Không thể mở ứng dụng gọi điện trên thiết bị này.'
      : 'Không mở được ứng dụng email. Vui lòng gửi thư tới $email.';
}

/// Mở kênh liên hệ (ứng dụng gọi điện hoặc email); `false` = máy không mở được.
typedef SupportLauncher = Future<bool> Function(Uri uri);
