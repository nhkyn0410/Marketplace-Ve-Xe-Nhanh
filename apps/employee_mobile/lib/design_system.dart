import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Bảng màu dùng chung của giao diện nhân viên trong Figma.
abstract final class DriverColors {
  static const navy = Color(0xff0a2840);
  static const header = Color(0xff123d5c);
  static const teal = Color(0xff006078);
  static const orange = Color(0xfff5a21a);
  static const canvas = Color(0xffebf5fb);
  static const cream = Color(0xfffef8ec);
  static const text = Color(0xff172b35);
  static const secondary = Color(0xff60727c);
  static const border = Color(0xffe4e5e7);
  static const warning = Color(0xff9e6410);
}

/// Hiển thị nguyên bản SVG đã tải từ màn Figma tương ứng.
class FigmaAsset extends StatelessWidget {
  const FigmaAsset(this.name, {super.key, this.width, this.height});
  final String name;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/figma/$name.svg',
    width: width,
    height: height,
    excludeFromSemantics: true,
  );
}

/// Định dạng chữ theo cỡ, độ đậm và màu của bộ thiết kế nhân viên.
TextStyle driverText([
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color? color,
]) => TextStyle(
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: size <= 14 ? 1.4 : 1.3,
);

/// Khung màn hình dùng vùng an toàn trên điện thoại và thanh hệ thống mẫu trên web.
class DriverPage extends StatelessWidget {
  const DriverPage({
    super.key,
    required this.child,
    this.bottom,
    this.background,
    this.statusBackground,
    this.lightStatus = false,
    this.statusAsset,
    this.keepTheme = false,
    this.indicatorBackground,
    this.indicatorColor,
  });
  final Widget child;
  final Widget? bottom;
  final Color? background;
  final Color? statusBackground;
  final bool lightStatus;
  final String? statusAsset;
  final bool keepTheme;
  final Color? indicatorBackground;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) => Theme(
    data: keepTheme ? Theme.of(context) : employeeTheme(Brightness.light),
    child: Builder(
      builder: (context) {
        final color = lightStatus
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface;
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: Column(
              children: [
                if (kIsWeb)
                  Container(
                    height: 44,
                    color: statusBackground ?? background,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '9:41',
                          style: driverText(14, FontWeight.w600, color),
                        ),
                        FigmaAsset(
                          statusAsset ??
                              (lightStatus
                                  ? 'login-imgTinHiuWiFiPin'
                                  : 'trips-imgTinHiuWiFiPin'),
                          width: 66,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                Expanded(child: child),
                ?bottom,
                if (kIsWeb)
                  Container(
                    height: 18,
                    color: indicatorBackground,
                    alignment: Alignment.center,
                    child: Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color:
                            indicatorColor ??
                            Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Tiêu đề có điều hướng quay lại và mô tả ngắn của màn hình.
class DriverHeading extends StatelessWidget {
  const DriverHeading(
    this.title, {
    super.key,
    this.subtitle,
    this.trailing,
    this.background,
    this.foreground,
    this.back = true,
    this.large = false,
    this.backAsset,
    this.padding,
    this.subtitleSpacing = 10,
    this.backAssetSize = const Size(8, 14),
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? background;
  final Color? foreground;
  final bool back;
  final bool large;
  final String? backAsset;
  final EdgeInsets? padding;
  final double subtitleSpacing;
  final Size backAssetSize;

  @override
  Widget build(BuildContext context) => Container(
    color: background,
    padding:
        padding ?? EdgeInsets.fromLTRB(24, 8, 24, subtitle == null ? 20 : 24),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (back)
          IconButton(
            tooltip: 'Quay lại',
            onPressed: () => Navigator.maybePop(context),
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            padding: EdgeInsets.zero,
            icon: backAsset == null
                ? Icon(Icons.chevron_left, color: foreground)
                : FigmaAsset(
                    backAsset!,
                    width: backAssetSize.width,
                    height: backAssetSize.height,
                  ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: driverText(large ? 32 : 22, FontWeight.w700, foreground),
              ),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.only(top: subtitleSpacing),
                  child: Text(
                    subtitle!,
                    style: driverText(
                      12,
                      FontWeight.w400,
                      DriverColors.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Thanh xác nhận chỉ kích hoạt khi vuốt tay kéo sang phải đủ quãng đường.
class SwipeAction extends StatefulWidget {
  const SwipeAction({
    super.key,
    required this.label,
    required this.onComplete,
    this.filled = false,
    this.enabled = true,
    this.foreground,
    this.background,
    this.arrowAsset = 'login-imgFrame',
    this.chevronAsset = 'login-imgFrame1',
    this.border = true,
    this.borderColor,
    this.handleAsset,
  });
  final String label;
  final VoidCallback onComplete;
  final bool filled;
  final bool enabled;
  final Color? foreground;
  final Color? background;
  final String arrowAsset;
  final String chevronAsset;
  final bool border;
  final Color? borderColor;
  final String? handleAsset;

  @override
  State<SwipeAction> createState() => _SwipeActionState();
}

class _SwipeActionState extends State<SwipeAction> {
  double _offset = 0;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final maxOffset = (box.maxWidth - (widget.handleAsset == null ? 48 : 54))
          .clamp(0.0, double.infinity);
      return Semantics(
        label: '${widget.label}. Vuốt sang phải để xác nhận.',
        enabled: widget.enabled,
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color:
                widget.background ??
                (widget.filled
                    ? DriverColors.teal
                    : Theme.of(context).colorScheme.surface),
            borderRadius: BorderRadius.circular(16),
            border: widget.border
                ? Border.all(
                    color:
                        widget.borderColor ??
                        (widget.filled
                            ? DriverColors.teal
                            : DriverColors.border),
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 52),
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: driverText(
                    14,
                    FontWeight.w600,
                    widget.foreground ??
                        (widget.filled ? Colors.white : DriverColors.teal),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: FigmaAsset(widget.chevronAsset, width: 20, height: 20),
              ),
              Positioned(
                left: 5 + _offset,
                top: widget.handleAsset == null ? 5 : 8,
                child: GestureDetector(
                  key: ValueKey('swipe-${widget.label}'),
                  onHorizontalDragUpdate: widget.enabled
                      ? (details) => setState(() {
                          _offset = (_offset + details.delta.dx).clamp(
                            0.0,
                            maxOffset,
                          );
                        })
                      : null,
                  onHorizontalDragCancel: () => setState(() => _offset = 0),
                  onHorizontalDragEnd: widget.enabled
                      ? (_) {
                          final complete =
                              maxOffset > 0 && _offset >= maxOffset * .8;
                          setState(() => _offset = 0);
                          if (complete) widget.onComplete();
                        }
                      : null,
                  child: widget.handleAsset != null
                      ? FigmaAsset(widget.handleAsset!, width: 44, height: 32)
                      : Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: widget.enabled
                                ? DriverColors.orange
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: FigmaAsset(
                            widget.arrowAsset,
                            width: 20,
                            height: 20,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Thẻ nền bo góc theo hệ khoảng cách dùng chung trong app nhân viên.
class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.child,
    this.color,
    this.padding = 16,
    this.radius = 16,
    this.border = false,
  });
  final Widget child;
  final Color? color;
  final double padding;
  final double radius;
  final bool border;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(radius),
      border: border ? Border.all(color: DriverColors.border) : null,
    ),
    child: child,
  );
}

/// Nhãn trạng thái chuyến hoặc hành khách.
class StatusPill extends StatelessWidget {
  const StatusPill(
    this.label, {
    super.key,
    this.success = false,
    this.neutral = false,
  });
  final String label;
  final bool success;
  final bool neutral;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: success
          ? const Color(0xffecfbf3)
          : neutral
          ? const Color(0xfff4f5f6)
          : DriverColors.cream,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: driverText(
        12,
        FontWeight.w400,
        success
            ? const Color(0xff078449)
            : neutral
            ? DriverColors.secondary
            : DriverColors.warning,
      ),
    ),
  );
}

/// Mở màn hình con và giữ thao tác quay lại theo Navigator của Flutter.
Future<T?> openDriverPage<T>(BuildContext context, Widget page) {
  ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      settings: RouteSettings(name: page.runtimeType.toString()),
      builder: (_) => page,
    ),
  );
}

/// Thông báo rõ ràng cho thao tác đang dùng dữ liệu minh họa.
void showDemoNotice(BuildContext context, [String? message]) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? 'Bản giao diện minh họa — chưa kết nối máy chủ.',
        ),
      ),
    );

/// Theme Inter và màu nền dùng cho từng màn giao diện nhân viên.
ThemeData employeeTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: brightness,
    scaffoldBackgroundColor: dark ? const Color(0xff111317) : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DriverColors.teal,
      brightness: brightness,
      primary: dark ? const Color(0xff62acdc) : DriverColors.teal,
      surface: dark ? const Color(0xff1c1e22) : Colors.white,
      onSurface: dark ? const Color(0xfff4f5f6) : DriverColors.text,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xff26282c) : const Color(0xfff7f9fa),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      hintStyle: driverText(16, FontWeight.w400, DriverColors.secondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffcacdcf)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffcacdcf)),
      ),
    ),
    dividerColor: DriverColors.canvas,
  );
}
