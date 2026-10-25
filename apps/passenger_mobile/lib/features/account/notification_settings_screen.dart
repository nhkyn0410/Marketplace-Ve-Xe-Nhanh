import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/account/account_settings_header.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final _enabled = <String, bool>{
    'security': true,
    'ticket': true,
    'trip': true,
    'dispute': true,
    'promotion': true,
    'loyalty': true,
    'news': false,
  };

  void _toggle(String id) {
    setState(() => _enabled[id] = !(_enabled[id] ?? false));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: accountSettingsOverlayStyle,
      child: Scaffold(
        key: const Key('notification-settings-screen'),
        backgroundColor: accountSettingsBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AccountSettingsHeader(
                title: 'Cài đặt thông báo',
                onBack: widget.onBack,
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('notification-settings-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 6, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _SectionTitle('Thông báo quan trọng'),
                      const SizedBox(height: 14),
                      _NotificationGroup(
                        items: [
                          _item(
                            id: 'security',
                            icon: 'shield.svg',
                            iconBackground: const Color(0xFFEDF7FF),
                            title: 'Bảo mật tài khoản',
                            subtitle:
                                'Đăng nhập, thay đổi thông tin, xác minh...',
                          ),
                          _item(
                            id: 'ticket',
                            icon: 'ticket.svg',
                            iconBackground: const Color(0xFFFFF0F1),
                            title: 'Vé và thanh toán',
                            subtitle:
                                'Xác nhận đặt vé, thanh toán, hoàn tiền...',
                          ),
                          _item(
                            id: 'trip',
                            icon: 'bus.svg',
                            iconBackground: const Color(0xFFE5F8F1),
                            title: 'Thay đổi hoặc hủy chuyến',
                            subtitle:
                                'Cập nhật lịch trình, đổi/hủy chuyến...',
                          ),
                          _item(
                            id: 'dispute',
                            icon: 'chat.svg',
                            iconBackground: const Color(0xFFFFF3E0),
                            title: 'Khiếu nại và tranh chấp',
                            subtitle: 'Cập nhật trạng thái khiếu nại...',
                          ),
                        ],
                        enabled: _enabled,
                        onToggle: _toggle,
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle('Thông báo tùy chọn'),
                      const SizedBox(height: 14),
                      _NotificationGroup(
                        items: [
                          _item(
                            id: 'promotion',
                            icon: 'gift.svg',
                            iconBackground: const Color(0xFFFFF0F1),
                            title: 'Ưu đãi và khuyến mãi',
                            subtitle: 'Chương trình giảm giá, voucher...',
                          ),
                          _item(
                            id: 'loyalty',
                            icon: 'star.svg',
                            iconBackground: const Color(0xFFFFF4DF),
                            title: 'VXN Plus',
                            subtitle: 'Cập nhật điểm, hạng thành viên...',
                          ),
                          _item(
                            id: 'news',
                            icon: 'megaphone.svg',
                            iconBackground: const Color(0xFFFFF3DF),
                            title: 'Tin tức và sản phẩm mới',
                            subtitle: 'Giới thiệu tuyến mới, nhà xe mới...',
                          ),
                        ],
                        enabled: _enabled,
                        onToggle: _toggle,
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

  _NotificationItemData _item({
    required String id,
    required String icon,
    required Color iconBackground,
    required String title,
    required String subtitle,
  }) {
    return _NotificationItemData(
      id: id,
      icon: icon,
      iconBackground: iconBackground,
      title: title,
      subtitle: subtitle,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF0B1548),
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _NotificationItemData {
  const _NotificationItemData({
    required this.id,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
}

class _NotificationGroup extends StatelessWidget {
  const _NotificationGroup({
    required this.items,
    required this.enabled,
    required this.onToggle,
  });

  final List<_NotificationItemData> items;
  final Map<String, bool> enabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFECF1F8)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++)
            _NotificationRow(
              item: items[index],
              enabled: enabled[items[index].id] ?? false,
              showDivider: index != items.length - 1,
              onTap: () => onToggle(items[index].id),
            ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.item,
    required this.enabled,
    required this.showDivider,
    required this.onTap,
  });

  final _NotificationItemData item;
  final bool enabled;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.iconBackground,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              '$accountSettingsAssetRoot/${item.icon}',
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 61,
              alignment: Alignment.centerLeft,
              decoration: showDivider
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE8EEF6),
                          width: .5,
                        ),
                      ),
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF0B1548),
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: accountSettingsMuted,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _FigmaSwitch(
            key: Key('notification-switch-${item.id}'),
            value: enabled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _FigmaSwitch extends StatelessWidget {
  const _FigmaSwitch({required this.value, required this.onTap, super.key});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      button: true,
      label: value ? 'Đang bật' : 'Đang tắt',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 26,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value
                ? const Color(0xFF1389DD)
                : const Color(0xFFDCE1E7),
            borderRadius: BorderRadius.circular(13),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 22),
            ),
          ),
        ),
      ),
    );
  }
}
