import 'dart:async';

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
import 'package:passenger_mobile/features/journey/journey_ticket_filters.dart';
import 'package:passenger_mobile/features/journey/trip_review_panel.dart';

enum _GuestJourneyStep { lookup, otp, results, detail }

/// Lựa chọn khi mở đơn đặt bằng tài khoản trong phiên tra cứu (UC-35 A1b).
enum _AccountBookingChoice { login, viewOnly }

/// Bước con của tab Hành trình không phải route: nút Back của Android phải lùi
/// đúng bước thay vì rời tab.
abstract interface class JourneyBackHandler {
  /// `true` nếu đã lùi một bước; `false` nếu đang ở bước đầu.
  bool handleBack();
}

abstract interface class JourneyBookingOpener {
  Future<void> openBooking(String bookingId);
}

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

class _GuestJourneyFlowState extends State<GuestJourneyFlow>
    implements JourneyBackHandler {
  _GuestJourneyStep _step = _GuestJourneyStep.lookup;
  String _email = '';

  /// Mã đặt vé khách nhập (đã chuẩn hóa); `null` = tra theo email.
  String? _bookingCode;
  JourneyLookupOtp? _otp;

  /// Bí mật phiên tra cứu — chỉ giữ trong bộ nhớ, mất khi đóng app.
  String? _lookupToken;
  JourneyLookupResult? _result;
  JourneyBooking? _booking;
  String? _accessToken;
  bool _opening = false;

  /// Đơn đang xem là đơn đặt bằng tài khoản mở chỉ đọc: không hủy vé, không khiếu nại.
  bool _readOnly = false;

  /// Khách đã chọn "Chỉ xem vé" một lần: không hỏi đăng nhập lại trong phiên tra cứu.
  bool _viewOnlyAccepted = false;

  void _show(_GuestJourneyStep step) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _step = step);
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), action: action));
  }

  Future<void> _requestOtp(String email, String? bookingCode) async {
    try {
      final otp = await widget.api.requestLookupOtp(
        email,
        bookingCode: bookingCode,
      );
      if (!mounted) return;
      _email = email;
      _bookingCode = bookingCode;
      _otp = otp;
      _show(_GuestJourneyStep.otp);
    } catch (error) {
      if (mounted) _showMessage(describeJourneyFailure(error));
    }
  }

  Future<String?> _verify(String code) async {
    try {
      final token = await widget.api.verifyLookupOtp(
        _email,
        code,
        bookingCode: _bookingCode,
      );
      final result = await widget.api.listLookupBookings(token);
      if (!mounted) return null;
      _lookupToken = token;
      _result = result;
      _viewOnlyAccepted = false;
      _show(_GuestJourneyStep.results);
      // Có mã đặt vé: mở thẳng đơn đó (UC-35 bước 1); Back vẫn về danh sách một đơn.
      if (result.bookingScoped && result.bookings.length == 1) {
        unawaited(_open(result.bookings.single));
      }
      return null;
    } catch (error) {
      return describeJourneyFailure(error);
    }
  }

  Future<String?> _resend() async {
    try {
      _otp = await widget.api.requestLookupOtp(
        _email,
        bookingCode: _bookingCode,
      );
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

  /// Đơn đặt bằng tài khoản: hỏi đăng nhập một lần; không đăng nhập thì vẫn xem chỉ đọc
  /// (UC-35 A1b, bước 6 — hủy vé và khiếu nại phải đăng nhập tài khoản đó).
  Future<void> _open(JourneyBookingSummary summary) async {
    final token = _lookupToken;
    if (token == null || _opening) return;
    final readOnly = summary.bookedWithAccount;
    if (readOnly && !_viewOnlyAccepted) {
      final choice = await _askLogin(summary);
      if (!mounted || choice == null) return;
      if (choice == _AccountBookingChoice.login) {
        widget.onLoginRequested();
        return;
      }
      _viewOnlyAccepted = true;
    }
    setState(() => _opening = true);
    try {
      String? access;
      final JourneyBooking booking;
      if (readOnly) {
        booking = await widget.api.lookupBooking(token, summary.bookingId);
      } else {
        access = await widget.api.grantLookupAccess(token, summary.bookingId);
        booking = await widget.api.loadBooking(
          summary.bookingId,
          accessToken: access,
        );
      }
      if (!mounted) return;
      _accessToken = access;
      _booking = booking;
      _readOnly = readOnly;
      _opening = false;
      _show(_GuestJourneyStep.detail);
    } catch (error) {
      if (!mounted) return;
      setState(() => _opening = false);
      _showMessage(describeJourneyFailure(error));
    }
  }

  Future<_AccountBookingChoice?> _askLogin(JourneyBookingSummary summary) {
    return showDialog<_AccountBookingChoice>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('journey-account-booking-dialog'),
        title: const Text('Đơn đặt bằng tài khoản'),
        content: Text(
          'Đơn ${summary.bookingCode} được đặt bằng tài khoản. Bạn có muốn đăng nhập không? '
          'Không đăng nhập vẫn xem được vé, nhưng không hủy vé hay gửi khiếu nại.',
        ),
        actions: [
          TextButton(
            key: const Key('journey-account-booking-view'),
            onPressed: () =>
                Navigator.pop(context, _AccountBookingChoice.viewOnly),
            child: const Text('Chỉ xem vé'),
          ),
          FilledButton(
            key: const Key('journey-account-booking-login'),
            onPressed: () =>
                Navigator.pop(context, _AccountBookingChoice.login),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  void _restart() {
    _lookupToken = null;
    _result = null;
    _booking = null;
    _accessToken = null;
    _readOnly = false;
    _viewOnlyAccepted = false;
    _show(_GuestJourneyStep.lookup);
  }

  void _closeDetail() {
    _show(_GuestJourneyStep.results);
    _refreshResults();
  }

  @override
  bool handleBack() {
    switch (_step) {
      case _GuestJourneyStep.lookup:
        return false;
      case _GuestJourneyStep.otp:
        _show(_GuestJourneyStep.lookup);
      case _GuestJourneyStep.results:
        _restart();
      case _GuestJourneyStep.detail:
        _closeDetail();
    }
    return true;
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
        maxAttempts: _otp?.maxAttempts ?? 5,
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
        hasAccount: _result?.hasAccount ?? false,
        onLoginRequested: widget.onLoginRequested,
      ),
      _GuestJourneyStep.detail => GuestTicketDetailScreen(
        booking: _booking!,
        onBack: _closeDetail,
        onTabSelected: widget.onTabSelected,
        onSupportRequested: widget.onSupportRequested,
        readOnly: _readOnly,
        onLoginRequested: widget.onLoginRequested,
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
    this.demoPanelBuilder,
    super.key,
  });

  final JourneyApi api;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onSupportRequested;
  final Widget? Function(JourneyBooking booking)? demoPanelBuilder;

  @override
  State<MyJourneyFlow> createState() => _MyJourneyFlowState();
}

class _MyJourneyFlowState extends State<MyJourneyFlow>
    implements JourneyBackHandler, JourneyBookingOpener {
  late Future<List<JourneyBookingSummary>> _bookings = widget.api
      .listMyBookings();
  JourneyBooking? _booking;
  bool _opening = false;

  /// Tab + từ khóa đang lọc (SCR-PSG-24); mặc định "Sắp tới" như web.
  JourneyTicketTab _tab = JourneyTicketTab.upcoming;
  String _query = '';

  Future<void> _reload() async {
    final next = widget.api.listMyBookings();
    setState(() {
      _bookings = next;
    });
    await next.catchError((_) => const <JourneyBookingSummary>[]);
  }

  void _closeDetail() {
    setState(() => _booking = null);
    _reload();
  }

  @override
  bool handleBack() {
    if (_booking == null) return false;
    _closeDetail();
    return true;
  }

  Future<void> _open(JourneyBookingSummary summary) async {
    await openBooking(summary.bookingId);
  }

  @override
  Future<void> openBooking(String bookingId) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      final booking = await widget.api.loadBooking(bookingId);
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
          // Mở đơn khác từ thông báo khi đang xem chi tiết: vé và khối đánh giá phải theo đơn mới.
          key: ValueKey(booking.bookingId),
          booking: booking,
          onBack: _closeDetail,
          onTabSelected: widget.onTabSelected,
          onSupportRequested: widget.onSupportRequested,
          journeyDemoPanel: widget.demoPanelBuilder?.call(booking),
          reviewPanel: TripReviewPanel(api: widget.api, booking: booking),
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
          final visible = filterJourneyBookings(items, _tab, _query);
          return _OpeningOverlay(
            busy: _opening,
            child: GuestTicketResultsScreen(
              title: 'Vé của tôi',
              subtitle: 'Các đơn đặt bằng tài khoản của bạn',
              bookings: visible,
              onOpenBooking: _open,
              onRefresh: _reload,
              onTabSelected: widget.onTabSelected,
              filterBar: items.isEmpty
                  ? null
                  : JourneyTicketFilterBar(
                      tab: _tab,
                      counts: journeyTicketCounts(items),
                      initialQuery: _query,
                      onTabChanged: (tab) => setState(() => _tab = tab),
                      onQueryChanged: (query) =>
                          setState(() => _query = query),
                    ),
              emptyMessage: items.isEmpty
                  ? null
                  : _query.trim().isNotEmpty
                  ? 'Không tìm thấy đơn khớp "${_query.trim()}".'
                  : 'Chưa có đơn nào trong mục ${_tab.label}.',
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
