import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'booking_flow_chrome.dart';
import 'booking_models.dart';
import 'payment_completion_screen.dart';
import 'payment_checkout_card.dart';
import 'payment_models.dart';
import 'trip_booking_api.dart';
import 'trip_search_models.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);

/// Thực hiện phương thức đã chọn và chờ máy chủ xác nhận thanh toán, phát hành vé.
class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({
    super.key,
    required this.api,
    required this.booking,
    required this.method,
    this.now,
    this.isSignedIn = false,
    this.onBookingFinished,
    this.launchPaymentUrl,
  });

  final TripBookingApi api;
  final CreatedBooking booking;
  final PassengerPaymentMethod method;
  final DateTime Function()? now;
  final bool isSignedIn;
  final VoidCallback? onBookingFinished;
  final Future<bool> Function(Uri)? launchPaymentUrl;

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  Timer? _pollTimer;
  Duration _remaining = Duration.zero;
  BookingPaymentSession? _checkout;
  BookingPaymentState? _state;
  String? _error;
  bool _submitting = false;
  bool _checking = false;
  bool _completed = false;
  bool _foreground = true;
  bool _initializing = false;
  int _paymentGeneration = 0;

  bool get _closed =>
      _state?.isClosed == true || _state?.needsReconciliation == true;

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _refreshRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final wasOpen = _remaining > Duration.zero;
      if (_foreground) setState(_refreshRemaining);
      if (wasOpen && _remaining == Duration.zero) unawaited(_checkState());
    });
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_remaining > Duration.zero) unawaited(_checkState());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_beginCheckout());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground && mounted) {
      setState(_refreshRemaining);
      unawaited(_checkState());
    }
  }

  Future<void> _beginCheckout() async {
    if (_initializing ||
        _submitting ||
        _completed ||
        _closed ||
        _remaining == Duration.zero) {
      return;
    }
    setState(() => _initializing = true);
    try {
      final checked = await _checkState();
      if (checked &&
          mounted &&
          !_completed &&
          !_closed &&
          _foreground &&
          ModalRoute.of(context)?.isCurrent != false &&
          _remaining > Duration.zero) {
        await _startPayment();
      }
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _startPayment() async {
    if (_submitting || _closed || _remaining == Duration.zero) return;
    _paymentGeneration++;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final checkout = await widget.api.startPayment(
        widget.booking,
        widget.method,
      );
      if (!mounted) return;
      setState(() {
        _checkout = checkout;
        _refreshRemaining();
      });
      await _checkState();
      if (mounted &&
          !_completed &&
          !_closed &&
          (widget.method != PassengerPaymentMethod.payos ||
              checkout.transfer == null)) {
        await _openUrl(checkout.paymentUrl);
      }
    } catch (error) {
      if (mounted) setState(() => _error = _describeFailure(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _openUrl(Uri uri) async {
    if (_remaining == Duration.zero ||
        _closed ||
        !_foreground ||
        ModalRoute.of(context)?.isCurrent == false) {
      return;
    }
    try {
      if (!const {'http', 'https'}.contains(uri.scheme) || uri.host.isEmpty) {
        throw const FormatException('Invalid payment URL');
      }
      final opened =
          await (widget.launchPaymentUrl?.call(uri) ??
              launchUrl(uri, mode: LaunchMode.externalApplication));
      if (!opened && mounted) {
        setState(
          () => _error = 'Không mở được trang thanh toán. Vui lòng thử lại hoặc quay lại chọn phương thức khác.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Không mở được trang thanh toán. Vui lòng thử lại hoặc quay lại chọn phương thức khác.',
        );
      }
    }
  }

  Future<bool> _checkState({bool manual = false}) async {
    if (!mounted ||
        _checking ||
        _completed ||
        !_foreground ||
        (!manual && ModalRoute.of(context)?.isCurrent == false)) {
      return false;
    }
    _checking = true;
    final generation = _paymentGeneration;
    try {
      final state = await widget.api.loadPaymentState(widget.booking);
      if (!mounted || generation != _paymentGeneration) return false;
      setState(() {
        _state = state;
        _error = null;
        if (state.paymentStatus == 'FAILED' ||
            state.paymentStatus == 'CANCELLED') {
          _checkout = null;
          _error =
              'Thanh toán chưa thành công. Bạn có thể thử lại khi đơn còn hạn.';
        }
      });
      if (state.isConfirmed &&
          _foreground &&
          ModalRoute.of(context)?.isCurrent != false) {
        _openPaymentCompletion(state.tickets);
      }
      if (state.isClosed || state.needsReconciliation) _pollTimer?.cancel();
      return true;
    } catch (error) {
      if (mounted) setState(() => _error = _describeFailure(error));
      return false;
    } finally {
      _checking = false;
    }
  }

  void _openPaymentCompletion(List<IssuedBookingTicket> tickets) {
    if (_completed) return;
    _completed = true;
    _timer?.cancel();
    _pollTimer?.cancel();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentCompletionScreen(
          booking: widget.booking,
          issuedTickets: tickets,
          selectedSeats: tickets.map((p) => p.seatCode).toList(),
          passengerNames: tickets
              .map(
                (p) => passengerDisplayName(p.passengerName, p.companionName),
              )
              .toList(),
          isSignedIn: widget.isSignedIn,
          onBookingFinished: widget.onBookingFinished,
        ),
      ),
    );
  }

  void _refreshRemaining() {
    final checkoutExpiry = _checkout?.expiresAt;
    final deadline =
        checkoutExpiry != null &&
            checkoutExpiry.isBefore(widget.booking.expiresAt)
        ? checkoutExpiry
        : widget.booking.expiresAt;
    final remaining = deadline.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final rest = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$rest';
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final expired = _remaining == Duration.zero || _state?.isClosed == true;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('payment-checkout-screen'),
        backgroundColor: _page,
        bottomNavigationBar: PaymentBottomBar(
          total: booking.total,
          disabled:
              expired || _closed || _submitting || _initializing || _completed,
          label: _submitting || _initializing
              ? 'Đang tạo thanh toán…'
              : _checkout == null
              ? 'Thanh toán'
              : widget.method.openLabel,
          onPay: _checkout == null
              ? _beginCheckout
              : () => _openUrl(_checkout!.paymentUrl),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BookingFlowHeader(
                key: const Key('payment-header'),
                title: widget.method.label,
                timerLabel: _timerLabel,
                expired: expired,
                urgent: _remaining <= const Duration(minutes: 1),
                onBack: () => Navigator.maybePop(context),
                backKey: const Key('payment-back'),
                timerKey: const Key('payment-hold-timer'),
              ),
              const BookingStepProgress(
                key: Key('payment-progress'),
                activeStep: 2,
              ),
              Expanded(
                child: ListView(
                  key: const Key('payment-scroll'),
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                  children: [
                    PaymentOrderCard(booking: booking),
                    const SizedBox(height: 9),
                    PaymentPendingNotice(
                      bookingCode: booking.bookingCode,
                      expiresAt: booking.expiresAt,
                      email: booking.contact.email,
                      expired: expired,
                    ),
                    const SizedBox(height: 9),
                    if (_state?.needsReconciliation == true)
                      const _Card(
                        child: Text(
                          'Giao dịch đang được đối soát. Vui lòng không chuyển tiền thêm; '
                          'liên hệ hỗ trợ và cung cấp mã đơn nếu cần.',
                          key: Key('payment-reconciling'),
                        ),
                      )
                    else if (!expired && _checkout == null)
                      _Card(child: Text(widget.method.description)),
                    if (_checkout != null && !expired && !_closed)
                      PaymentCheckoutCard(
                        method: widget.method,
                        session: _checkout!,
                        onOpenUrl: _openUrl,
                      ),
                    if (_error != null) ...[
                      const SizedBox(height: 9),
                      Text(
                        _error!,
                        key: const Key('payment-error'),
                        style: const TextStyle(color: Color(0xFFB42318)),
                      ),
                    ],
                    TextButton.icon(
                      key: const Key('payment-refresh'),
                      onPressed: _completed
                          ? null
                          : () => _checkState(manual: true),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Kiểm tra trạng thái thanh toán'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _describeFailure(Object error) {
  if (error is ApiFailure) {
    return switch (error.code) {
      'PAYMENT_PROVIDER_UNAVAILABLE' =>
        'Phương thức này chưa được bật. Vui lòng chọn phương thức khác.',
      'BOOKING_EXPIRED' => 'Đơn đã quá hạn thanh toán. Vui lòng đặt lại.',
      'PAYMENT_IN_PROGRESS' =>
        'Yêu cầu trước đang được xử lý. Vui lòng chờ rồi kiểm tra trạng thái.',
      'PAYMENT_PROVIDER_ERROR' =>
        'Chưa kết nối được cổng thanh toán. Vui lòng thử lại.',
      _ => describeBookingFailure(error),
    };
  }
  return describeBookingFailure(error);
}

/// Tóm tắt đơn và số tiền giữ nguyên khi chọn hoặc thực hiện thanh toán.
class PaymentOrderCard extends StatelessWidget {
  const PaymentOrderCard({super.key, required this.booking});

  final CreatedBooking booking;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: _blue, size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Đơn của bạn',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                booking.bookingCode,
                key: const Key('payment-booking-code'),
                style: const TextStyle(
                  color: _blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            booking.operatorName,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${booking.vehicleTypeName} · ${formatVnDate(booking.pickupAt)}',
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
          const SizedBox(height: 9),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Đón ${formatVnClock(booking.pickupAt)}',
            value: booking.pickupName,
          ),
          _InfoRow(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFFE0A82E),
            label: 'Trả ${formatVnClock(booking.dropoffAt)}',
            value: '${booking.dropoffName} (dự kiến)',
          ),
          for (final passenger in booking.passengers)
            _InfoRow(
              icon: Icons.event_seat_rounded,
              label: 'Chỗ ${passenger.seatCode}',
              value: passenger.displayName,
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(height: 1, color: Color(0xFFE2EBF0)),
          ),
          _PriceRow(label: 'Tiền vé', value: formatVnd(booking.subtotal)),
          const SizedBox(height: 6),
          _PriceRow(label: 'Phí dịch vụ', value: formatVnd(booking.serviceFee)),
          if (booking.discount > 0) ...[
            const SizedBox(height: 6),
            _PriceRow(
              label: 'Giảm giá',
              value: '-${formatVnd(booking.discount)}',
              discount: true,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(height: 1, color: Color(0xFFE2EBF0)),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tổng cộng',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                formatVnd(booking.total),
                key: const Key('payment-order-total'),
                style: const TextStyle(
                  color: _orange,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Nhắc hạn giữ chỗ và email nhận thông tin của đơn đang chờ thanh toán.
class PaymentPendingNotice extends StatelessWidget {
  const PaymentPendingNotice({
    super.key,
    required this.bookingCode,
    required this.expiresAt,
    required this.email,
    required this.expired,
  });

  final String bookingCode;
  final DateTime expiresAt;
  final String email;
  final bool expired;

  @override
  Widget build(BuildContext context) {
    final deadline = formatVnClock(expiresAt);
    return Container(
      key: const Key('payment-pending-notice'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: expired ? const Color(0xFFFFEEEE) : const Color(0xFFEAF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            expired ? Icons.error_outline_rounded : Icons.info_outline_rounded,
            color: expired ? const Color(0xFFD84A4A) : _blue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              expired
                  ? 'Đơn $bookingCode đã quá hạn thanh toán, chỗ đã được trả lại. Vui lòng đặt lại.'
                  : 'Đơn $bookingCode đã được tạo và giữ chỗ tới $deadline. '
                        'Hoàn tất thanh toán trước thời hạn để nhận vé. '
                        'Thông tin đơn gửi tới $email.',
              style: const TextStyle(color: _ink, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = _blue,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 15),
          const SizedBox(width: 7),
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.discount = false,
  });

  final String label;
  final String value;
  final bool discount;

  @override
  Widget build(BuildContext context) {
    final color = discount ? const Color(0xFF258A54) : _muted;
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: color, fontSize: 13)),
        ),
        Text(
          value,
          style: TextStyle(
            color: discount ? const Color(0xFF258A54) : _ink,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

/// Nút hành động cố định ở cuối các màn thanh toán.
class PaymentBottomBar extends StatelessWidget {
  const PaymentBottomBar({
    super.key,
    this.total,
    this.onPay,
    this.disabled = false,
    this.label = 'Thanh toán',
  });

  final int? total;
  final VoidCallback? onPay;
  final bool disabled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x16092137),
            blurRadius: 13,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              key: const Key('payment-submit'),
              onPressed: disabled ? null : onPay,
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                disabledBackgroundColor: const Color(0xFFB9CED9),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 17),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
