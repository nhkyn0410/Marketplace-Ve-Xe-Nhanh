import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';

const _primary = Color(0xFF2B7EAD);
const _ink = Color(0xFF17324D);
const _muted = Color(0xFF71869A);
const _pageBackground = Color(0xFFF3FAFE);

typedef AccountOverviewLoader = Future<AccountOverview> Function();
typedef AccountLogout = Future<bool> Function();

class AccountOverview {
  const AccountOverview({
    required this.name,
    required this.email,
    required this.emailVerified,
    this.imageUrl,
    this.availablePoints,
    this.loyaltyTier,
    this.savedPassengerCount,
  });

  final String name;
  final String email;
  final bool emailVerified;
  final String? imageUrl;
  final int? availablePoints;
  final String? loyaltyTier;
  final int? savedPassengerCount;
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    required this.loadOverview,
    required this.onLogout,
    required this.onTabSelected,
    this.logoutErrorMessage,
    super.key,
  });

  final AccountOverviewLoader loadOverview;
  final AccountLogout onLogout;
  final ValueChanged<int> onTabSelected;
  final String? logoutErrorMessage;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<AccountOverview> _overview = widget.loadOverview();
  bool _loggingOut = false;

  Future<void> _reload() async {
    final next = widget.loadOverview();
    setState(() {
      _overview = next;
    });
    await next;
  }

  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    final succeeded = await widget.onLogout();
    if (!mounted || succeeded) return;
    setState(() => _loggingOut = false);
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$label sẽ được triển khai ở bước tiếp theo.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('account-screen'),
      backgroundColor: _pageBackground,
      extendBody: true,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 4,
        onTap: widget.onTabSelected,
      ),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<AccountOverview>(
          future: _overview,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const _AccountLoading();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return _AccountError(onRetry: _reload);
            }
            return _AccountContent(
              overview: snapshot.requireData,
              loggingOut: _loggingOut,
              logoutErrorMessage: widget.logoutErrorMessage,
              onRefresh: _reload,
              onLogout: _logout,
              onComingSoon: _showComingSoon,
            );
          },
        ),
      ),
    );
  }
}

class _AccountContent extends StatelessWidget {
  const _AccountContent({
    required this.overview,
    required this.loggingOut,
    required this.logoutErrorMessage,
    required this.onRefresh,
    required this.onLogout,
    required this.onComingSoon,
  });

  final AccountOverview overview;
  final bool loggingOut;
  final String? logoutErrorMessage;
  final Future<void> Function() onRefresh;
  final VoidCallback onLogout;
  final ValueChanged<String> onComingSoon;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: _primary,
      child: ListView(
        key: const Key('account-content-scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 150),
        children: [
          const Text(
            'Tài khoản của tôi',
            style: TextStyle(
              color: _ink,
              fontSize: 24,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Quản lý thông tin cá nhân và tiện ích của bạn',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 18),
          _ProfileCard(
            overview: overview,
            onEdit: () => onComingSoon('Chỉnh sửa hồ sơ'),
          ),
          const SizedBox(height: 14),
          _LoyaltyCard(
            overview: overview,
            onTap: () => onComingSoon('VXN Plus'),
          ),
          const SizedBox(height: 18),
          const _SectionTitle('Tiện ích tài khoản'),
          const SizedBox(height: 8),
          _MenuCard(
            children: [
              _AccountMenuItem(
                icon: Icons.groups_rounded,
                color: const Color(0xFF159DCE),
                background: const Color(0xFFE2F7FF),
                title: 'Hành khách đã lưu',
                subtitle: overview.savedPassengerCount == null
                    ? 'Quản lý hành khách thường dùng'
                    : '${overview.savedPassengerCount}/5 hành khách',
                onTap: () => onComingSoon('Hành khách đã lưu'),
              ),
              _AccountMenuItem(
                icon: Icons.confirmation_number_rounded,
                color: const Color(0xFFFFA726),
                background: const Color(0xFFFFF3DE),
                title: 'Ví voucher',
                subtitle: 'Voucher ưu đãi của bạn',
                onTap: () => onComingSoon('Ví voucher'),
              ),
              _AccountMenuItem(
                icon: Icons.stacked_bar_chart_rounded,
                color: const Color(0xFF169BD5),
                background: const Color(0xFFE4F6FE),
                title: 'Lịch sử điểm',
                subtitle: 'Xem chi tiết điểm tích lũy',
                onTap: () => onComingSoon('Lịch sử điểm'),
              ),
              _AccountMenuItem(
                icon: Icons.star_rounded,
                color: const Color(0xFFFFB31A),
                background: const Color(0xFFFFF3DE),
                title: 'Đánh giá của tôi',
                subtitle: 'Các chuyến đi đã đánh giá',
                onTap: () => onComingSoon('Đánh giá của tôi'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _SectionTitle('Cài đặt & bảo mật'),
          const SizedBox(height: 8),
          _MenuCard(
            children: [
              _AccountMenuItem(
                icon: Icons.notifications_rounded,
                color: const Color(0xFF1AA7D8),
                background: const Color(0xFFE1F7FF),
                title: 'Cài đặt thông báo',
                subtitle: 'Quản lý thông báo hệ thống',
                onTap: () => onComingSoon('Cài đặt thông báo'),
              ),
              _AccountMenuItem(
                icon: Icons.verified_user_rounded,
                color: const Color(0xFF1985C4),
                background: const Color(0xFFE2F3FC),
                title: 'Phiên đăng nhập & thiết bị',
                subtitle: 'Quản lý thiết bị đang đăng nhập',
                onTap: () => onComingSoon('Phiên đăng nhập & thiết bị'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Material(
            color: const Color(0xFFFFEEEE),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              key: const Key('account-logout-button'),
              onTap: loggingOut ? null : onLogout,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    if (loggingOut)
                      const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE5484D),
                        ),
                      )
                    else
                      const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFE5484D),
                        size: 21,
                      ),
                    const SizedBox(width: 12),
                    Text(
                      loggingOut ? 'Đang đăng xuất...' : 'Đăng xuất',
                      style: const TextStyle(
                        color: Color(0xFFE5484D),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFE5484D),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (logoutErrorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              logoutErrorMessage!,
              key: const Key('account-logout-error'),
              style: const TextStyle(
                color: Color(0xFFB42318),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.overview, required this.onEdit});

  final AccountOverview overview;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _AccountAvatar(imageUrl: overview.imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overview.name,
                  key: const Key('account-name'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        overview.email,
                        key: const Key('account-email'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 11.5),
                      ),
                    ),
                    if (overview.emailVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF1AA7D8),
                        size: 15,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            key: const Key('account-edit-button'),
            onPressed: onEdit,
            style: TextButton.styleFrom(
              foregroundColor: _primary,
              backgroundColor: const Color(0xFFE1F5FC),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text(
              'Chỉnh sửa',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      'assets/home/hero/user_avatar.png',
      width: 52,
      height: 52,
      fit: BoxFit.cover,
    );
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Color(0xFFEAF7FC),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageUrl == null || imageUrl!.trim().isEmpty
            ? fallback
            : Image.network(
                imageUrl!,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard({required this.overview, required this.onTap});

  final AccountOverview overview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tier = _tierLabel(overview.loyaltyTier);
    final points = overview.availablePoints == null
        ? '—'
        : _formatPoints(overview.availablePoints!);
    return Container(
      key: const Key('account-loyalty-card'),
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF248DB8), Color(0xFF126993)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x242B7EAD),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: .45)),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFFE596),
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VXN Plus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tier,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_rounded,
                        color: Color(0xFFFFC83D),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        points,
                        key: const Key('account-points'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'điểm khả dụng',
                        style: TextStyle(
                          color: Color(0xFFDCEFFC),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFC53D),
              foregroundColor: const Color(0xFF714D00),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'Xem quyền lợi',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static String _tierLabel(String? value) => switch (value) {
    'SILVER' => 'Hạng Bạc',
    'GOLD' => 'Hạng Vàng',
    'PLATINUM' => 'Hạng Bạch Kim',
    _ => 'Hạng Đồng',
  };

  static String _formatPoints(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) buffer.write('.');
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(radius: 20),
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1)
              const Divider(
                height: 1,
                indent: 74,
                endIndent: 16,
                color: Color(0xFFEAF1F5),
              ),
          ],
        ],
      ),
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF8EA1AF),
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountLoading extends StatelessWidget {
  const _AccountLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        key: Key('account-loading'),
        color: _primary,
      ),
    );
  }
}

class _AccountError extends StatelessWidget {
  const _AccountError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: _primary, size: 48),
            const SizedBox(height: 14),
            const Text(
              'Chưa thể tải thông tin tài khoản',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Vui lòng kiểm tra kết nối và thử lại.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const Key('account-retry-button'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration({double radius = 16}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: const Color(0xFFE3F0F7)),
  boxShadow: const [
    BoxShadow(color: Color(0x102B7EAD), blurRadius: 14, offset: Offset(0, 5)),
  ],
);
