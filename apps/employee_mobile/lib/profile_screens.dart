import 'package:flutter/material.dart';

import 'design_system.dart';

/// Màn cá nhân của nhân viên với thông tin và thao tác minh họa.
class ProfileScreen extends StatelessWidget {
  /// Tạo nội dung cá nhân để hiển thị trong hai mục chính của ứng dụng.
  const ProfileScreen({
    super.key,
    required this.username,
    required this.dark,
    required this.onThemeChanged,
    required this.onLogout,
  });

  final String username;
  final bool dark;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final text = dark ? const Color(0xfff4f5f6) : DriverColors.navy;
    final secondary = dark ? const Color(0xffaeafb3) : DriverColors.secondary;
    final surface = dark ? const Color(0xff1c1e22) : Colors.white;
    final inset = dark ? const Color(0xff26282c) : DriverColors.canvas;
    final outline = dark ? const Color(0xff47494e) : DriverColors.border;
    final prefix = dark ? 'darkprofile' : 'profile';
    Widget sectionTitle(String label) =>
        Text(label, style: driverText(16, FontWeight.w600, text));
    Widget menu(String label, String asset, VoidCallback onOpen) => Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0).abs() > 120) onOpen();
        },
        child: Material(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onOpen,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                border: Border.all(color: outline),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: inset,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: FigmaAsset(
                      '$prefix-$asset',
                      width: asset == 'imgGroup' ? 11.8 : 19.8,
                      height: asset == 'imgGroup' ? 21.8 : 19.8,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: driverText(16, FontWeight.w600, text),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FigmaAsset('$prefix-imgGroup1', width: 13.2, height: 9.8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Widget appearanceOption(bool value, String label, String asset) => Expanded(
      child: Semantics(
        selected: dark == value,
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onThemeChanged(value),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: dark == value
                    ? (dark ? const Color(0xff3c3e43) : Colors.white)
                    : null,
                border: dark == value ? Border.all(color: outline) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FigmaAsset('$prefix-$asset', width: 20, height: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: driverText(
                      14,
                      FontWeight.w500,
                      dark == value ? text : secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return ColoredBox(
      color: dark ? const Color(0xff111317) : Colors.white,
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Text(
                  'Cá nhân',
                  style: driverText(28, FontWeight.w700, text),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (box.maxHeight - 72).clamp(0.0, double.infinity),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DriverCard(
                            color: DriverColors.teal,
                            padding: 20,
                            radius: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FigmaAsset(
                                      dark
                                          ? 'darkprofile-imgEmployeeEmployeeAvatar'
                                          : 'profile-imgNhanVienDngPhc',
                                      width: 72,
                                      height: 72,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nguyễn Minh',
                                            style: driverText(
                                              22,
                                              FontWeight.w600,
                                              Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 13,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: DriverColors.cream,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Tài xế',
                                                  style: driverText(
                                                    12,
                                                    FontWeight.w400,
                                                    DriverColors.teal,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  'Mây Express',
                                                  style: driverText(
                                                    12,
                                                    FontWeight.w400,
                                                    Colors.white.withValues(
                                                      alpha: .85,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tên đăng nhập',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    Colors.white.withValues(alpha: .7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  username,
                                  style: driverText(
                                    14,
                                    FontWeight.w500,
                                    Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          sectionTitle('Tài khoản'),
                          const SizedBox(height: 10),
                          menu(
                            'Thiết bị đăng nhập',
                            'imgGroup',
                            () =>
                                openDriverPage(context, const DevicesScreen()),
                          ),
                          const SizedBox(height: 16),
                          sectionTitle('Giao diện'),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onHorizontalDragEnd: (details) {
                              final velocity = details.primaryVelocity ?? 0;
                              if (velocity.abs() > 120) {
                                onThemeChanged(velocity > 0);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: inset,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  appearanceOption(
                                    false,
                                    'Sáng',
                                    'imgEmployeeAppearanceIconSun',
                                  ),
                                  const SizedBox(width: 4),
                                  appearanceOption(
                                    true,
                                    'Tối',
                                    'imgEmployeeAppearanceIconMoon',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          sectionTitle('Hỗ trợ'),
                          const SizedBox(height: 12),
                          menu(
                            'Liên hệ nhà xe',
                            'imgGroup2',
                            () => openDriverPage(
                              context,
                              ContactScreen(username: username),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      SwipeAction(
                        label: 'Đăng xuất',
                        onComplete: onLogout,
                        foreground: dark
                            ? const Color(0xff62acdc)
                            : DriverColors.teal,
                        background: surface,
                        border: false,
                        arrowAsset: '$prefix-imgFrame',
                        chevronAsset: '$prefix-imgFrame1',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Màn liên hệ nhà xe với địa chỉ email minh họa của thiết kế.
class ContactScreen extends StatelessWidget {
  /// Tạo màn hỗ trợ cho tài khoản nhập ở màn đăng nhập hoặc màn cá nhân.
  const ContactScreen({super.key, this.username = 'mayexpress/nv.minh'});

  final String username;

  @override
  Widget build(BuildContext context) => DriverPage(
    background: Colors.white,
    statusAsset: 'contact-imgTinHiuWiFiPin',
    bottom: const _BackToProfile(prefix: 'contact'),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DriverHeading(
            'Liên hệ nhà xe',
            subtitle: 'Hỗ trợ tài khoản nhân viên',
            foreground: DriverColors.navy,
            backAsset: 'contact-imgGroup',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DriverCard(
                  color: DriverColors.cream,
                  padding: 20,
                  radius: 24,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 88),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const FigmaAsset(
                            'contact-imgTaiNgheHTr',
                            width: 44,
                            height: 44,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mây Express',
                                style: driverText(
                                  28,
                                  FontWeight.w700,
                                  DriverColors.navy,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Quản lý nhân viên',
                                style: driverText(
                                  14,
                                  FontWeight.w500,
                                  DriverColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tài khoản của bạn',
                  style: driverText(
                    12,
                    FontWeight.w400,
                    DriverColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  username,
                  style: driverText(16, FontWeight.w600, DriverColors.navy),
                ),
                const SizedBox(height: 8),
                const Divider(color: DriverColors.border, height: 1),
                const SizedBox(height: 43),
                DriverCard(
                  color: DriverColors.canvas,
                  padding: 20,
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const FigmaAsset(
                            'contact-imgEmail',
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email hỗ trợ',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'hotro@mayexpress.example',
                                  style: driverText(
                                    14,
                                    FontWeight.w500,
                                    DriverColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SwipeAction(
                        label: 'Mở email hỗ trợ',
                        background: Colors.white,
                        arrowAsset: 'contact-imgFrame',
                        chevronAsset: 'contact-imgFrame1',
                        onComplete: () => showDemoNotice(
                          context,
                          'Email .example là dữ liệu minh họa, chưa thể gửi email hỗ trợ.',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bạn cần hỗ trợ?',
                  style: driverText(16, FontWeight.w600, DriverColors.navy),
                ),
                const SizedBox(height: 12),
                Text(
                  'Cấp lại mật khẩu · Quyền truy cập\nThông tin chuyến được phân công',
                  style: driverText(
                    14,
                    FontWeight.w500,
                    DriverColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Màn các phiên đăng nhập với dữ liệu mẫu và thao tác thu hồi minh họa.
class DevicesScreen extends StatelessWidget {
  /// Tạo màn thiết bị, không thực hiện thay đổi phiên đăng nhập thật.
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) => DriverPage(
    background: Colors.white,
    statusAsset: 'devices-imgTinHiuWiFiPin',
    bottom: const _BackToProfile(prefix: 'devices'),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DriverHeading(
            'Thiết bị đăng nhập',
            subtitle: '2 phiên đang hoạt động',
            foreground: DriverColors.navy,
            backAsset: 'devices-imgGroup',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DriverCard(
                  color: DriverColors.canvas,
                  padding: 20,
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const FigmaAsset(
                            'devices-imgDinThoi',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'iPhone 13',
                                  style: driverText(
                                    16,
                                    FontWeight.w600,
                                    DriverColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Text(
                                    'Thiết bị này',
                                    style: driverText(
                                      12,
                                      FontWeight.w400,
                                      DriverColors.teal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'iOS · Ứng dụng nhân viên',
                        style: driverText(
                          14,
                          FontWeight.w500,
                          DriverColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Đang hoạt động',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'IP 171.***.***.23',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SwipeAction(
                        label: 'Đăng xuất thiết bị này',
                        background: Colors.white,
                        arrowAsset: 'devices-imgFrame',
                        chevronAsset: 'devices-imgFrame1',
                        onComplete: () => showDemoNotice(
                          context,
                          'Đây là thiết bị minh họa. Chưa thực hiện đăng xuất phiên thật.',
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Phiên khác',
                  style: driverText(16, FontWeight.w600, DriverColors.navy),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const FigmaAsset(
                      'devices-imgDinThoiAndroid',
                      width: 36,
                      height: 36,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Samsung Galaxy A54',
                            style: driverText(
                              16,
                              FontWeight.w600,
                              DriverColors.navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Android · Ứng dụng nhân viên',
                            style: driverText(
                              12,
                              FontWeight.w400,
                              DriverColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Hoạt động gần nhất · 13/10, 19:42',
                  style: driverText(
                    12,
                    FontWeight.w400,
                    DriverColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'IP 113.***.***.84',
                  style: driverText(
                    12,
                    FontWeight.w400,
                    DriverColors.secondary,
                  ),
                ),
                const SizedBox(height: 22),
                SwipeAction(
                  label: 'Thu hồi phiên này',
                  background: Colors.white,
                  arrowAsset: 'devices-imgFrame',
                  chevronAsset: 'devices-imgFrame1',
                  onComplete: () => showDemoNotice(
                    context,
                    'Đây là phiên minh họa. Chưa thực hiện thu hồi phiên thật.',
                  ),
                ),
                const SizedBox(height: 70),
                const Divider(color: DriverColors.border, height: 1),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FigmaAsset(
                      'devices-imgBoMtPhien',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Không nhận ra thiết bị? Thu hồi phiên để chặn truy cập.',
                        style: driverText(
                          14,
                          FontWeight.w500,
                          DriverColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _BackToProfile extends StatelessWidget {
  const _BackToProfile({required this.prefix});

  final String prefix;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(40, 14, 40, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwipeAction(
            label: 'Về cá nhân',
            background: Colors.white,
            arrowAsset: '$prefix-imgFrame',
            chevronAsset: '$prefix-imgFrame1',
            onComplete: () => Navigator.maybePop(context),
          ),
        ],
      ),
    ),
  );
}
