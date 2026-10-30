import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_otp_screen.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_detail_screen.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_lookup_screen.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_results_screen.dart';
import 'package:passenger_mobile/features/journey/journey_api.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';

enum _GuestJourneyStep { lookup, otp, results, detail }

/// Tab Hành trình khi chưa đăng nhập: tra cứu bằng email + OTP → danh sách đơn → chi tiết / hủy vé.
class GuestJourneyFlow extends StatefulWidget {
  const GuestJourneyFlow({
    required this.api,
    required this.onLoginRequested,
    required this.onTabSelected,
    this.onFaqRequested,
    this.onSupportRequested,
    super.key,
  });

  final JourneyApi api;
  final VoidCallback onLoginRequested;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onFaqRequested;
  final VoidCallback? onSupportRequested;

  @override
  State<GuestJourneyFlow> createState() => _GuestJourneyFlowState();
}

class _GuestJourneyFlowState extends State<GuestJourneyFlow> {
  _GuestJourneyStep _step = _GuestJourneyStep.lookup;
  String _email = '';
  JourneyLookupOtp? _otp;

  /// Bí mật phiên tra cứu — chỉ giữ trong bộ nhớ, mất khi đóng app.
  String? _lookupToken;
  JourneyLookupResult? _result;
  JourneyBooking? _booking;
  String? _accessToken;
  bool _opening = false;

  void _show(_GuestJourneyStep step) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _step = step);
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), action: action));
  }

  Future<void> _requestOtp(String email) async {
    try {
      final otp = await widget.api.requestLookupOtp(email);
      if (!mounted) return;
      _email = email;
      _otp = otp;
      _show(_GuestJourneyStep.otp);
    } catch (error) {
      if (mounted) _showMessage(describeJourneyFailure(error));
    }
  }

  Future<String?> _verify(String code) async {
    try {
      final token = await widget.api.verifyLookupOtp(_email, code);
      final result = await widget.api.listLookupBookings(token);
      if (!mounted) return null;
      _lookupToken = token;
      _result = result;
      _show(_GuestJourneyStep.results);
      return null;
    } catch (error) {
      return describeJourneyFailure(error);
    }
  }

  Future<String?> _resend() async {
    try {
      _otp = await widget.api.requestLookupOtp(_email);
      return null;
    } catch (error) {
      return describeJourneyFailure(error);
    }
  }

  Future<void> _refreshResults() async {
    final token = _lookupToken;
    if (token == null) return;
    try {
      final result = await widget.api.listLookupBookings(token);
      if (mounted) setState(() => _result = result);
    } catch (error) {
      if (mounted) _showMessage(describeJourneyFailure(error));
    }
  }

  Future<void> _open(JourneyBookingSummary summary) async {
    final token = _lookupToken;
    if (token == null || _opening) return;
    if (summary.bookedWithAccount) {
      _showMessage(
        'Đơn ${summary.bookingCode} đặt bằng tài khoản. Đăng nhập để xem và hủy vé.',
        action: SnackBarAction(
          label: 'Đăng nhập',
          onPressed: widget.onLoginRequested,
        ),
      );
      return;
    }
    setState(() => _opening = true);
    try {
      final access = await widget.api.grantLookupAccess(
        token,
        summary.bookingId,
      );
      final booking = await widget.api.loadBooking(
        summary.bookingId,
        accessToken: access,
      );
      if (!mounted) return;
      _accessToken = access;
      _booking = booking;
      _opening = false;
      _show(_GuestJourneyStep.detail);
    } catch (error) {
      if (!mounted) return;
      setState(() => _opening = false);
      _showMessage(describeJourneyFailure(error));
    }
  }

  void _restart() {
    _lookupToken = null;
    _result = null;
    _booking = null;
    _accessToken = null;
    _show(_GuestJourneyStep.lookup);
  }

  @override
  Widget build(BuildContext context) {
    // Đổi bước tức thì, không trượt (như màn Tài khoản khi chưa đăng nhập).
    final child = switch (_step) {
      _GuestJourneyStep.lookup => GuestTicketLookupScreen(
        onLoginRequested: widget.onLoginRequested,
        onTabSelected: widget.onTabSelected,
        onFaqRequested: widget.onFaqRequested,
        onSupportRequested: widget.onSupportRequested,
        onRequestOtp: _requestOtp,
      ),
      _GuestJourneyStep.otp => GuestJourneyOtpScreen(
        maskedEmail: _otp?.maskedEmail ?? _email,
        expiresInSeconds: _otp?.expiresInSeconds ?? 300,
        resendAfterSeconds: _otp?.resendAfterSeconds ?? 60,
        onVerify: _verify,
        onResend: _resend,
        onChangeLookup: () => _show(_GuestJourneyStep.lookup),
        onTabSelected: widget.onTabSelected,
      ),
      _GuestJourneyStep.results => GuestTicketResultsScreen(
        title: 'Kết quả tra cứu vé',
        subtitle: 'Đã xác minh email ${_result?.maskedEmail ?? ''}',
        lookupEmail: _result?.maskedEmail ?? '',
        bookings: _result?.bookings ?? const [],
        onOpenBooking: _open,
        onChangeLookup: _restart,
        onRefresh: _refreshResults,
        onTabSelected: widget.onTabSelected,
      ),
      _GuestJourneyStep.detail => GuestTicketDetailScreen(
        booking: _booking!,
        onBack: () {
          _show(_GuestJourneyStep.results);
          _refreshResults();
        },
        onTabSelected: widget.onTabSelected,
        onSupportRequested: widget.onSupportRequested,
        quoteCancellation: (ticketIds) => widget.api.quoteCancellation(
          _booking!.bookingId,
          ticketIds,
          accessToken: _accessToken,
        ),
        cancelTickets: (ticketIds, expectedRefund, reason) async {
          final bookingId = _booking!.bookingId;
          final result = await widget.api.cancel(
            bookingId,
            ticketIds,
            expectedRefund: expectedRefund,
            reason: reason,
            accessToken: _accessToken,
          );
          final updated = await widget.api.loadBooking(
            bookingId,
            accessToken: _accessToken,
          );
          _booking = updated;
          return (result, updated);
        },
      ),
    };
    return KeyedSubtree(
      key: ValueKey(_step),
      child: _OpeningOverlay(busy: _opening, child: child),
    );
  }
}

/// Tab Hành trình khi đã đăng nhập: "Vé của tôi" → chi tiết / hủy vé.
class MyJourneyFlow extends StatefulWidget {
  const MyJourneyFlow({
    required this.api,
    required this.onTabSelected,
    this.onSupportRequested,
    super.key,
  });

  final JourneyApi api;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onSupportRequested;

  @override
  State<MyJourneyFlow> createState() => _MyJourneyFlowState();
}

class _MyJourneyFlowState extends State<MyJourneyFlow> {
  late Future<List<JourneyBookingSummary>> _bookings = widget.api
      .listMyBookings();
  JourneyBooking? _booking;
  bool _opening = false;

  Future<void> _reload() async {
    final next = widget.api.listMyBookings();
    setState(() => _bookings = next);
    await next.catchError((_) => const <JourneyBookingSummary>[]);
  }

  Future<void> _open(JourneyBookingSummary summary) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      final booking = await widget.api.loadBooking(summary.bookingId);
      if (!mounted) return;
      setState(() {
        _booking = booking;
        _opening = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _opening = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(describeJourneyFailure(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = _booking;
    if (booking != null) {
      return KeyedSubtree(
        key: const ValueKey('my-journey-detail'),
        child: GuestTicketDetailScreen(
          booking: booking,
          onBack: () {
            setState(() => _booking = null);
            _reload();
          },
          onTabSelected: widget.onTabSelected,
          onSupportRequested: widget.onSupportRequested,
          quoteCancellation: (ticketIds) =>
              widget.api.quoteCancellation(booking.bookingId, ticketIds),
          cancelTickets: (ticketIds, expectedRefund, reason) async {
            final result = await widget.api.cancel(
              booking.bookingId,
              ticketIds,
              expectedRefund: expectedRefund,
              reason: reason,
            );
            final updated = await widget.api.loadBooking(booking.bookingId);
            _booking = updated;
            return (result, updated);
          },
        ),
      );
    }
    return FutureBuilder<List<JourneyBookingSummary>>(
      key: const ValueKey('my-journey-list'),
      future: _bookings,
      builder: (context, snapshot) {
        final items = snapshot.data;
        if (items != null) {
          return _OpeningOverlay(
            busy: _opening,
            child: GuestTicketResultsScreen(
              title: 'Vé của tôi',
              subtitle: 'Các đơn đặt bằng tài khoản của bạn',
              bookings: items,
              onOpenBooking: _open,
              onRefresh: _reload,
              onTabSelected: widget.onTabSelected,
            ),
          );
        }
        return _JourneyStatusScreen(
          onTabSelected: widget.onTabSelected,
          error: snapshot.hasError
              ? describeJourneyFailure(snapshot.error!)
              : null,
          onRetry: _reload,
        );
      },
    );
  }
}

/// Đang tải / lỗi tải "Vé của tôi".
class _JourneyStatusScreen extends StatelessWidget {
  const _JourneyStatusScreen({
    required this.onTabSelected,
    required this.onRetry,
    this.error,
  });

  final ValueChanged<int> onTabSelected;
  final VoidCallback onRetry;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final message = error;
    return Scaffold(
      key: const Key('my-journey-status'),
      extendBody: true,
      backgroundColor: journeyPage,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 3,
        onTap: onTabSelected,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: journeyOverlayStyle,
        child: Column(
          children: [
            const JourneyHeroHeader(
              title: 'Vé của tôi',
              subtitle: 'Các đơn đặt bằng tài khoản của bạn',
            ),
            Expanded(
              child: Center(
                child: message == null
                    ? const CircularProgressIndicator(color: journeyButton)
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: journeyBody,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            JourneyOutlineButton(
                              key: const Key('my-journey-retry'),
                              label: 'Thử lại',
                              onPressed: onRetry,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chặn thao tác và hiện vòng xoay khi đang mở chi tiết đơn.
class _OpeningOverlay extends StatelessWidget {
  const _OpeningOverlay({required this.busy, required this.child});

  final bool busy;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (busy)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33FFFFFF),
              child: Center(
                child: CircularProgressIndicator(color: journeyButton),
              ),
            ),
          ),
      ],
    );
  }
}
