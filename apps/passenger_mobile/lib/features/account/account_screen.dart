import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/account/passenger_avatar.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';

const _primary = Color(0xFF2B7EAD);
const _ink = Color(0xFF091739);
const _muted = Color(0xFF607A8E);
const _pageBackground = Color(0xFFECFAFF);
const _headerFloralAsset = 'assets/account/header_floral.png';

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
    required this.onEditProfile,
    required this.onSavedPassengers,
    required this.onVoucherWallet,
    required this.onPointHistory,
    required this.onMyReviews,
    required this.onNotificationSettings,
    required this.onLoginSessions,
    this.logoutErrorMessage,
    super.key,
  });

  final AccountOverviewLoader loadOverview;
  final AccountLogout onLogout;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onEditProfile;
  final VoidCallback onSavedPassengers;
  final VoidCallback onVoucherWallet;
  final VoidCallback onPointHistory;
  final VoidCallback onMyReviews;
  final VoidCallback onNotificationSettings;
  final VoidCallback onLoginSessions;
  final String? logoutErrorMessage;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<AccountOverview> _overview = widget.loadOverview();
  bool _loggingOut = false;
  bool _dockVisible = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('account-screen'),
      backgroundColor: _pageBackground,
      extendBody: true,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 4,
        onTap: widget.onTabSelected,
        visible: _dockVisible,
        slideKey: const Key('account-bottom-dock-animation'),
      ),
      body: TabEntrance(
        statusBarColor: _pageBackground,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: _pageBackground,
          ),
          child: NotificationListener<UserScrollNotification>(
            onNotification: _handleUserScroll,
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
                  onEditProfile: widget.onEditProfile,
                  onSavedPassengers: widget.onSavedPassengers,
                  onVoucherWallet: widget.onVoucherWallet,
                  onPointHistory: widget.onPointHistory,
                  onMyReviews: widget.onMyReviews,
                  onNotificationSettings: widget.onNotificationSettings,
                  onLoginSessions: widget.onLoginSessions,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _handleUserScroll(UserScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final shouldShow = switch (notification.direction) {
      ScrollDirection.forward => true,
      ScrollDirection.reverse => false,
      ScrollDirection.idle =>
        notification.metrics.pixels <= 0 ? true : _dockVisible,
    };
    if (shouldShow != _dockVisible && mounted) {
      setState(() => _dockVisible = shouldShow);
    }
    return false;
  }
}

class _AccountContent extends StatelessWidget {
  const _AccountContent({
    required this.overview,
    required this.loggingOut,
    required this.logoutErrorMessage,
    required this.onRefresh,
    required this.onLogout,
    required this.onEditProfile,
    required this.onSavedPassengers,
    required this.onVoucherWallet,
    required this.onPointHistory,
    required this.onMyReviews,
    required this.onNotificationSettings,
    required this.onLoginSessions,
  });

  final AccountOverview overview;
  final bool loggingOut;
  final String? logoutErrorMessage;
  final Future<void> Function() onRefresh;
  final VoidCallback onLogout;
  final VoidCallback onEditProfile;
  final VoidCallback onSavedPassengers;
  final VoidCallback onVoucherWallet;
  final VoidCallback onPointHistory;
  final VoidCallback onMyReviews;
  final VoidCallback onNotificationSettings;
  final VoidCallback onLoginSessions;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: _primary,
      child: ListView(
        key: const Key('account-content-scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 150),
        children: [
          _AccountHeader(overview: overview, onEditProfile: onEditProfile),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LoyaltyCard(overview: overview, onTap: onPointHistory),
                const SizedBox(height: 12),
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
                      onTap: onSavedPassengers,
                    ),
                    _AccountMenuItem(
                      icon: Icons.confirmation_number_rounded,
                      color: const Color(0xFFFFA726),
                      background: const Color(0xFFFFF3DE),
                      title: 'Ví voucher',
                      subtitle: 'Voucher ưu đãi của bạn',
                      onTap: onVoucherWallet,
                    ),
                    _AccountMenuItem(
                      icon: Icons.stacked_bar_chart_rounded,
                      color: const Color(0xFF169BD5),
                      background: const Color(0xFFE4F6FE),
                      title: 'Lịch sử điểm',
                      subtitle: 'Xem chi tiết điểm tích lũy',
                      onTap: onPointHistory,
                    ),
                    _AccountMenuItem(
                      icon: Icons.star_rounded,
                      color: const Color(0xFFFFB31A),
                      background: const Color(0xFFFFF3DE),
                      title: 'Đánh giá của tôi',
                      subtitle: 'Các chuyến đi đã đánh giá',
                      onTap: onMyReviews,
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
                      onTap: onNotificationSettings,
                    ),
                    _AccountMenuItem(
                      icon: Icons.verified_user_rounded,
                      color: const Color(0xFF1985C4),
                      background: const Color(0xFFE2F3FC),
                      title: 'Phiên đăng nhập & thiết bị',
                      subtitle: 'Quản lý thiết bị đang đăng nhập',
                      onTap: onLoginSessions,
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
          ),
        ],
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.overview, required this.onEditProfile});

  final AccountOverview overview;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final safeTop = MediaQuery.paddingOf(context).top;
    final statusExtent = safeTop < 30 ? 30.0 : safeTop;
    final floralHeight = statusExtent + 177;
    final profileTop = statusExtent + 135;
    final headerLeft = (viewportWidth * 34 / 412).clamp(24.0, 34.0);

    return SizedBox(
      key: const Key('account-header'),
      height: profileTop + 82,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: floralHeight,
            child: ClipRect(
              child: ColoredBox(
                color: const Color(0xFFFCFAF4),
                child: Stack(
                  children: [
                    Positioned(
                      key: const Key('account-header-floral'),
                      left: 0,
                      top: -floralHeight * 2.2632,
                      width: viewportWidth * 1.8519,
                      height: floralHeight * 5.2632,
                      child: Image.asset(
                        _headerFloralAsset,
                        key: const Key('account-header-floral-image'),
                        fit: BoxFit.fill,
                        excludeFromSemantics: true,
                      ),
                    ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        key: Key('account-header-overlay'),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xA6FFFCF7),
                              Color(0xF5FFFCF7),
                              Color(0xF5FFFCF7),
                              Color(0x99FFFCF7),
                            ],
                            stops: [0, .18, .75, 1],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: headerLeft,
            top: statusExtent + 13,
            width: 99,
            height: 31,
            child: const _AccountBrandCapsule(),
          ),
          Positioned(
            left: headerLeft,
            right: 18,
            top: statusExtent + 47,
            child: const Text(
              'Tài khoản của tôi',
              style: TextStyle(
                color: _ink,
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: headerLeft + 1,
            right: 16,
            top: statusExtent + 84,
            child: const Text(
              'Quản lý thông tin cá nhân và tiện ích của bạn',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: profileTop,
            height: 82,
            child: _ProfileCard(overview: overview, onEdit: onEditProfile),
          ),
        ],
      ),
    );
  }
}

class _AccountBrandCapsule extends StatelessWidget {
  const _AccountBrandCapsule();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/auth/logo/light_mark.svg',
              width: 20,
              height: 16,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: SvgPicture.asset(
                'assets/auth/logo/light_wordmark.svg',
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ),
          ],
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 350;
        return Container(
          key: const Key('account-profile-card'),
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          decoration: _cardDecoration(radius: 18),
          child: Row(
            children: [
              PassengerAvatar(
                size: compact ? 52 : 62,
                imageUrl: overview.imageUrl,
              ),
              SizedBox(width: compact ? 10 : 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overview.name,
                      key: const Key('account-name'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
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
                            style: const TextStyle(
                              color: Color(0xFF647F9A),
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                        if (overview.emailVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF1AA7D8),
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: 1,
                height: 48,
                child: ColoredBox(color: Color(0xFFD7E7EF)),
              ),
              SizedBox(width: compact ? 7 : 9),
              SizedBox(
                width: compact ? 92 : 110,
                height: 38,
                child: TextButton.icon(
                  key: const Key('account-edit-button'),
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF087EB4),
                    backgroundColor: const Color(0xFFE4F7FF),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color(0xFFB2E3FF),
                        width: .5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 15),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Chỉnh sửa',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
