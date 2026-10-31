import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Màu nền xanh nhạt của vùng điều hướng hệ thống, cùng màu với nền thanh tab.
const passengerNavigationBarColor = Color(0xFFEBF5FB);

/// Giữ vùng điều hướng Android nền xanh nhạt, nút màu tối trên mọi màn hình.
class PassengerSystemNavigation extends StatelessWidget {
  const PassengerSystemNavigation({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        // Flutter lấy kiểu thanh điều hướng tại chính giữa vùng hệ thống dưới cùng.
        // Nền và kiểu nút nằm trên cả route và modal; không nhận chạm.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: bottom > 0 ? bottom : 1,
          child: IgnorePointer(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: passengerNavigationBarColor,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarContrastEnforced: false,
              ),
              child: bottom > 0
                  ? const ColoredBox(
                      key: Key('passenger-system-navigation-background'),
                      color: passengerNavigationBarColor,
                      child: SizedBox.expand(),
                    )
                  : const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}
