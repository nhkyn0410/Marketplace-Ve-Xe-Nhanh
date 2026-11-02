import 'package:flutter/material.dart';

/// Phân loại trạng thái thông báo toast toàn ứng dụng.
enum AppToastType {
  /// Thao tác thành công (sao chép mã, hoàn tất đặt chỗ, lưu thông tin...).
  success,

  /// Thông tin chung, hướng dẫn.
  info,

  /// Cảnh báo nhẹ (chưa chọn ghế, số lượng vé tối đa...).
  warning,

  /// Lỗi hệ thống, mạng hoặc xác thực.
  error,
}

/// Tiện ích hiển thị thông báo Toast / SnackBar nổi hiện đại cho Vé Xe Nhanh.
class AppToast {
  const AppToast._();

  /// Hiển thị thông báo nổi (`floating`) dạng card trắng bo tròn thanh lịch,
  /// đồng điệu với ngôn ngữ thiết kế sáng và nhận diện thương hiệu của Vé Xe Nhanh.
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    SnackBarAction? action,
    Duration duration = const Duration(milliseconds: 2800),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 8,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFD6E8F6), width: 1.2),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          duration: duration,
          action: action,
          content: _ToastContent(message: message, type: type),
        ),
      );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({
    required this.message,
    required this.type,
  });

  final String message;
  final AppToastType type;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, bgIconColor) = switch (type) {
      AppToastType.success => (
        Icons.check_circle_rounded,
        const Color(0xFF059669), // Xanh lục ngọc đậm
        const Color(0xFFD1FAE5), // Nền ngọc nhạt tươi
      ),
      AppToastType.info => (
        Icons.info_rounded,
        const Color(0xFF2B7EAD), // Xanh thương hiệu Vé Xe Nhanh
        const Color(0xFFE0F2FE), // Nền xanh dương dịu
      ),
      AppToastType.warning => (
        Icons.warning_amber_rounded,
        const Color(0xFFD97706), // Vàng hổ phách
        const Color(0xFFFEF3C7), // Nền vàng nhạt
      ),
      AppToastType.error => (
        Icons.error_outline_rounded,
        const Color(0xFFDC2626), // Đỏ tươi
        const Color(0xFFFEE2E2), // Nền đỏ nhạt
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bgIconColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 19,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Be Vietnam Pro',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: Color(0xFF102E58), // Màu chữ xanh sẫm thương hiệu
            ),
          ),
        ),
      ],
    );
  }
}
