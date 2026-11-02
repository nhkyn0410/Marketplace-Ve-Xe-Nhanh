import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/account/account_settings_header.dart';

/// Một phiên đăng nhập của tài khoản (`GET /auth/sessions`).
class LoginSessionInfo {
  const LoginSessionInfo({
    required this.id,
    required this.current,
    required this.deviceLabel,
    required this.createdAt,
    required this.lastUsedAt,
    this.ipAddress,
  });

  final String id;
  final bool current;

  /// Nhãn thô từ API, vd `Mobile app on Android`.
  final String deviceLabel;

  /// Đã che, vd `198.51.100.*`.
  final String? ipAddress;
  final DateTime createdAt;
  final DateTime lastUsedAt;

  String get deviceName => deviceLabel
      .replaceAll('Mobile app', 'Ứng dụng di động')
      .replaceAll('Unknown device', 'Thiết bị không xác định')
      .replaceAll('Device', 'Thiết bị')
      .replaceAll(' on ', ' trên ');

  String get addressLabel => ipAddress == null
      ? 'Không rõ địa chỉ IP'
      : 'IP ${ipAddress!}';

  String get signedInLabel => 'Đăng nhập lúc ${_formatMoment(createdAt)}';

  String get lastUsedLabel => 'Hoạt động lúc ${_formatMoment(lastUsedAt)}';
}

String _formatMoment(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.hour)}:${two(local.minute)} • '
      '${two(local.day)}/${two(local.month)}/${local.year}';
}

typedef LoginSessionLoader = Future<List<LoginSessionInfo>> Function();
typedef LoginSessionRevoker = Future<void> Function(String sessionId);

class LoginSessionsScreen extends StatefulWidget {
  const LoginSessionsScreen({
    required this.loadSessions,
    required this.revokeSession,
    required this.onBack,
    super.key,
  });

  final LoginSessionLoader loadSessions;
  final LoginSessionRevoker revokeSession;
  final VoidCallback onBack;

  @override
  State<LoginSessionsScreen> createState() => _LoginSessionsScreenState();
}

class _LoginSessionsScreenState extends State<LoginSessionsScreen> {
  late Future<List<LoginSessionInfo>> _sessions = widget.loadSessions();

  bool _showingConfirmation = false;

  void _reload() {
    setState(() {
      _sessions = widget.loadSessions();
    });
  }

  /// [sessionIds] có một phần tử khi đăng xuất một thiết bị, đủ danh sách khi đăng xuất tất cả.
  Future<void> _confirmLogout(List<String> sessionIds) async {
    setState(() => _showingConfirmation = true);
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA3707F8D),
      builder: (context) => const _LogoutConfirmationSheet(),
    );
    if (!mounted) return;
    setState(() => _showingConfirmation = false);
    if (confirmed != true) return;
    try {
      for (final sessionId in sessionIds) {
        await widget.revokeSession(sessionId);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Chưa đăng xuất được thiết bị. Vui lòng thử lại.'),
            ),
          );
      }
    }
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: accountSettingsOverlayStyle,
      child: Scaffold(
        key: const Key('login-sessions-screen'),
        backgroundColor: accountSettingsBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AccountSettingsHeader(
                title: 'Phiên đăng nhập & thiết bị',
                onBack: widget.onBack,
              ),
              Expanded(
                child: FutureBuilder<List<LoginSessionInfo>>(
                  future: _sessions,
                  builder: (context, snapshot) {
                    final sessions = snapshot.data;
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        key: Key('login-sessions-loading'),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (sessions == null) {
                      return _SessionsLoadError(onRetry: _reload);
                    }
                    final current = sessions
                        .where((session) => session.current)
                        .firstOrNull;
                    final others = sessions
                        .where((session) => !session.current)
                        .toList(growable: false);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: _showingConfirmation
                          ? _DetailedSessionsContent(
                              key: const Key('login-sessions-detailed-content'),
                              current: current,
                              sessions: others,
                              onLogout: _confirmLogout,
                            )
                          : _CompactSessionsContent(
                              key: const Key('login-sessions-compact-content'),
                              current: current,
                              sessions: others,
                              onLogout: _confirmLogout,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionsLoadError extends StatelessWidget {
  const _SessionsLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chưa thể tải danh sách phiên đăng nhập.',
            style: TextStyle(color: accountSettingsMuted, fontSize: 13),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            key: const Key('login-sessions-retry'),
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _CompactSessionsContent extends StatelessWidget {
  const _CompactSessionsContent({
    required this.current,
    required this.sessions,
    required this.onLogout,
    super.key,
  });

  final LoginSessionInfo? current;
  final List<LoginSessionInfo> sessions;
  final Future<void> Function(List<String> sessionIds) onLogout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 18, 10),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 30),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SessionSectionTitle('Thiết bị hiện tại', size: 18),
                const SizedBox(height: 10),
                if (current case final session?)
                  _CurrentSessionCard(session: session),
                const SizedBox(height: 19),
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: _SessionSectionTitle('Các phiên đăng nhập khác'),
                ),
                const SizedBox(height: 7),
                for (var index = 0; index < sessions.length; index++) ...[
                  _OtherSessionCard(
                    session: sessions[index],
                    onLogout: () => onLogout([sessions[index].id]),
                  ),
                  if (index != sessions.length - 1) const SizedBox(height: 19),
                ],
                if (sessions.isEmpty)
                  const _NoOtherSessions()
                else ...[
                  const Spacer(),
                  const SizedBox(height: 24),
                  _LogoutAllButton(
                    onTap: () => onLogout([
                      for (final session in sessions) session.id,
                    ]),
                  ),
                ],
                const SizedBox(height: 78),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailedSessionsContent extends StatelessWidget {
  const _DetailedSessionsContent({
    required this.current,
    required this.sessions,
    required this.onLogout,
    super.key,
  });

  final LoginSessionInfo? current;
  final List<LoginSessionInfo> sessions;
  final Future<void> Function(List<String> sessionIds) onLogout;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SecurityInformation(),
          const SizedBox(height: 18),
          const _SessionSectionTitle('Thiết bị hiện tại', size: 18),
          const Text(
            'Thiết bị bạn đang sử dụng để đăng nhập.',
            style: TextStyle(
              color: accountSettingsMuted,
              fontSize: 12,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 8),
          if (current case final session?)
            _CurrentSessionCard(session: session),
          const SizedBox(height: 14),
          const _SessionSectionTitle('Các phiên đăng nhập khác'),
          const SizedBox(height: 2),
          const Text(
            'Danh sách các phiên đã đăng nhập vào tài khoản của bạn.',
            style: TextStyle(
              color: accountSettingsMuted,
              fontSize: 11,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < sessions.length; index++) ...[
            _OtherSessionCard(
              session: sessions[index],
              onLogout: () => onLogout([sessions[index].id]),
            ),
            if (index != sessions.length - 1) const SizedBox(height: 7),
          ],
          if (sessions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _LogoutAllButton(
              onTap: () => onLogout([
                for (final session in sessions) session.id,
              ]),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tất cả các thiết bị khác sẽ bị đăng xuất. Thiết bị hiện tại của bạn vẫn được giữ nguyên.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accountSettingsMuted,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SecurityInformation extends StatelessWidget {
  const _SecurityInformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FE),
        border: Border.all(color: const Color(0xFFE4EFFB)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE5F4FF),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              '$accountSettingsAssetRoot/shield.svg',
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Quản lý các phiên đăng nhập trên thiết bị của bạn.\nVì lý do bảo mật, hãy đăng xuất khi không sử dụng\nứng dụng trên thiết bị đó.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accountSettingsMuted,
                fontSize: 10,
                height: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionSectionTitle extends StatelessWidget {
  const _SessionSectionTitle(this.label, {this.size = 16});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF0B1548),
        fontSize: size,
        height: 1.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CurrentSessionCard extends StatelessWidget {
  const _CurrentSessionCard({required this.session});

  final LoginSessionInfo session;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('current-session-card'),
      height: 116,
      padding: const EdgeInsets.only(left: 16, right: 10),
      decoration: _sessionCardDecoration(),
      child: Row(
        children: [
          _SessionIconCircle(
            size: 64,
            asset: '$accountSettingsAssetRoot/phone.svg',
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _SessionDetails(
              title: 'Phiên hiện tại',
              subtitle: session.deviceName,
              location: session.addressLabel,
              signedInAt: session.signedInLabel,
              active: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherSessionCard extends StatelessWidget {
  const _OtherSessionCard({required this.session, required this.onLogout});

  final LoginSessionInfo session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('login-session-${session.id}'),
      height: 106,
      padding: const EdgeInsets.only(left: 10, right: 7),
      decoration: _sessionCardDecoration(),
      child: Row(
        children: [
          _SessionIconCircle(
            size: 56,
            asset: '$accountSettingsAssetRoot/lock.svg',
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _SessionDetails(
              title: session.deviceName,
              subtitle: session.lastUsedLabel,
              location: session.addressLabel,
              signedInAt: session.signedInLabel,
            ),
          ),
          TextButton.icon(
            key: Key('logout-session-${session.id}'),
            onPressed: onLogout,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF241F),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              minimumSize: const Size(82, 44),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: SvgPicture.asset(
              '$accountSettingsAssetRoot/logout.svg',
              excludeFromSemantics: true,
            ),
            label: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDetails extends StatelessWidget {
  const _SessionDetails({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.signedInAt,
    this.active = false,
  });

  final String title;
  final String subtitle;
  final String location;
  final String signedInAt;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF0B1548),
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (active) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F8EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Đang hoạt động',
                  style: TextStyle(
                    color: Color(0xFF00834F),
                    fontSize: 9,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: accountSettingsMuted,
            fontSize: 11,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 1),
        _SessionMeta(icon: 'pin.svg', label: location),
        const SizedBox(height: 1),
        _SessionMeta(icon: 'clock.svg', label: signedInAt),
      ],
    );
  }
}

class _SessionMeta extends StatelessWidget {
  const _SessionMeta({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 14,
          child: Center(
            child: SvgPicture.asset(
              '$accountSettingsAssetRoot/$icon',
              excludeFromSemantics: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: accountSettingsMuted,
              fontSize: 10,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionIconCircle extends StatelessWidget {
  const _SessionIconCircle({required this.size, required this.asset});

  final double size;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFEAF6FF),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(asset, excludeFromSemantics: true),
    );
  }
}

class _LogoutAllButton extends StatelessWidget {
  const _LogoutAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: OutlinedButton.icon(
        key: const Key('logout-all-other-sessions'),
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFF241F),
          backgroundColor: const Color(0xFFFFF0F1),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          side: const BorderSide(color: Color(0xFFFFDFDF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: SvgPicture.asset(
          '$accountSettingsAssetRoot/logout_all.svg',
          excludeFromSemantics: true,
        ),
        label: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Đăng xuất tất cả thiết bị khác',
            maxLines: 1,
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ),
    );
  }
}

class _NoOtherSessions extends StatelessWidget {
  const _NoOtherSessions();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text(
        'Không còn phiên đăng nhập nào khác.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: accountSettingsMuted,
          fontSize: 12,
          height: 1.5,
        ),
      ),
    );
  }
}

class _LogoutConfirmationSheet extends StatelessWidget {
  const _LogoutConfirmationSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('logout-confirmation-sheet'),
      height: 432 + MediaQuery.paddingOf(context).bottom,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 179,
            top: 15,
            child: Container(
              width: 54,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF8595A9),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            left: 158,
            top: 53,
            child: Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8E8),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                '$accountSettingsAssetRoot/logout_large.svg',
                excludeFromSemantics: true,
              ),
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            top: 160,
            child: Text(
              'Đăng xuất thiết bị khác?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accountSettingsInk,
                fontSize: 21,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            top: 209,
            child: Text(
              'Thiết bị đó sẽ cần đăng nhập lại để tiếp tục\nsử dụng các tiện ích tài khoản.\nThiết bị bạn đang dùng vẫn giữ nguyên đăng nhập.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF60799E),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            top: 304,
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: OutlinedButton(
                      key: const Key('cancel-session-logout'),
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accountSettingsInk,
                        backgroundColor: const Color(0xFFF4F8FC),
                        side: const BorderSide(color: Color(0xFFE0EBF7)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Hủy bỏ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: FilledButton(
                      key: const Key('confirm-session-logout'),
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF342C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

BoxDecoration _sessionCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(color: const Color(0xFFE9F0F8)),
    borderRadius: BorderRadius.circular(15),
  );
}
