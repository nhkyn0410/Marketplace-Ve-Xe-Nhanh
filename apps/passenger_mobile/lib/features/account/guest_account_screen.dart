import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';

const _supportHotline = '1900 636 707';

/// Tab Tài khoản khi chưa đăng nhập: nêu lợi ích của tài khoản rồi mới mở màn đăng nhập.
class GuestAccountScreen extends StatelessWidget {
  const GuestAccountScreen({
    required this.onLoginRequested,
    required this.onTabSelected,
    this.onCallHotline,
    super.key,
  });

  final VoidCallback onLoginRequested;
  final ValueChanged<int> onTabSelected;

  /// Mở ứng dụng gọi điện; `false` = máy không gọi được.
  final Future<bool> Function(String hotline)? onCallHotline;

  Future<void> _callHotline(BuildContext context) async {
    final launched =
        onCallHotline != null && await onCallHotline!(_supportHotline);
    if (launched || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Không thể mở ứng dụng gọi điện trên thiết bị này.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('guest-account-screen'),
      extendBody: true,
      backgroundColor: journeyPage,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 4,
        onTap: onTabSelected,
      ),
      body: TabEntrance(
        child: AnnotatedRegion(
          value: journeyOverlayStyle,
          child: JourneyFixedPage(
            scrollKey: const Key('guest-account-scroll'),
            header: const JourneyHeroHeader(title: 'Tài khoản'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                JourneySurface(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Bạn chưa đăng nhập',
                        style: TextStyle(
                          color: journeyInk,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Đăng nhập hoặc tạo tài khoản bằng email để dùng:',
                        style: TextStyle(
                          color: journeyBody,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _Benefit(
                        icon: Icons.people_alt_outlined,
                        title: 'Hành khách đã lưu',
                        body: 'Điền thông tin hành khách chỉ với một chạm.',
                      ),
                      const _Benefit(
                        icon: Icons.local_activity_outlined,
                        title: 'Ví voucher',
                        body: 'Lưu mã giảm giá và dùng khi đặt vé.',
                      ),
                      const _Benefit(
                        icon: Icons.workspace_premium_outlined,
                        title: 'Điểm VXN Plus',
                        body: 'Tích điểm sau mỗi chuyến đi để đổi ưu đãi.',
                      ),
                      const _Benefit(
                        icon: Icons.rate_review_outlined,
                        title: 'Đánh giá chuyến đi',
                        body: 'Chia sẻ trải nghiệm với nhà xe sau chuyến.',
                      ),
                      const SizedBox(height: 6),
                      JourneyPrimaryButton(
                        key: const Key('guest-account-login'),
                        label: 'Đăng nhập / Đăng ký',
                        onPressed: onLoginRequested,
                        height: 46,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                JourneySurface(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _Action(
                        key: const Key('guest-account-lookup'),
                        icon: Icons.confirmation_number_outlined,
                        title: 'Tra cứu vé đã đặt',
                        body: 'Không cần đăng nhập: dùng mã đặt vé và email.',
                        onTap: () => onTabSelected(3),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: journeyBorder,
                      ),
                      _Action(
                        key: const Key('guest-account-hotline'),
                        icon: Icons.support_agent_outlined,
                        title: 'Tổng đài hỗ trợ',
                        body: _supportHotline,
                        onTap: () => _callHotline(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: journeyButton, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  body,
                  style: const TextStyle(
                    color: journeyBody,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Material trong suốt: hiệu ứng chạm vẽ trên thẻ trắng thay vì bị nền thẻ che.
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: journeyButton),
        title: Text(
          title,
          style: const TextStyle(
            color: journeyInk,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          body,
          style: const TextStyle(color: journeyBody, fontSize: 12.5),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: journeyBody),
      ),
    );
  }
}
