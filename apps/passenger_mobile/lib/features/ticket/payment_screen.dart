import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_flow_chrome.dart';
import 'booking_models.dart';
import 'payment_checkout_screen.dart';
import 'payment_completion_screen.dart';
import 'payment_models.dart';
import 'trip_booking_api.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);

/// Chọn phương thức thanh toán trước khi mở màn QR hoặc cổng thanh toán tương ứng.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.api,
    required this.booking,
    this.now,
    this.isSignedIn = false,
    this.onBookingFinished,
    this.launchPaymentUrl,
  });

  final TripBookingApi api;
  final CreatedBooking booking;
  final DateTime Function()? now;
  final bool isSignedIn;
  final VoidCallback? onBookingFinished;
  final Future<bool> Function(Uri)? launchPaymentUrl;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {
  PassengerPaymentMethod _method = PassengerPaymentMethod.payos;
  BookingPaymentState? _state;
  Timer? _timer;
  Duration _remaining = Duration.zero;
  String? _error;
  bool _navigating = false;
  bool _checking = false;
  bool _completed = false;
  bool _foreground = true;

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
      if (mounted &&
          _foreground &&
          ModalRoute.of(context)?.isCurrent != false) {
        setState(_refreshRemaining);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_checkState());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void _refreshRemaining() {
    final remaining = widget.booking.expiresAt.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _checkState() async {
    if (_checking ||
        _completed ||
        !mounted ||
        !_foreground ||
        ModalRoute.of(context)?.isCurrent == false) {
      return;
    }
    _checking = true;
    try {
      final state = await widget.api.loadPaymentState(widget.booking);
      if (!mounted ||
          !_foreground ||
          ModalRoute.of(context)?.isCurrent == false) {
        return;
      }
      setState(() {
        _state = state;
        _error = null;
        _refreshRemaining();
      });
      if (state.isConfirmed) {
        _completed = true;
        _timer?.cancel();
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PaymentCompletionScreen(
              booking: widget.booking,
              issuedTickets: state.tickets,
              selectedSeats: state.tickets
                  .map((ticket) => ticket.seatCode)
                  .toList(),
              passengerNames: state.tickets
                  .map(
                    (ticket) => passengerDisplayName(
                      ticket.passengerName,
                      ticket.companionName,
                    ),
                  )
                  .toList(),
              isSignedIn: widget.isSignedIn,
              onBookingFinished: widget.onBookingFinished,
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = describeBookingFailure(error));
    } finally {
      _checking = false;
    }
  }

  Future<void> _openCheckout() async {
    if (_navigating || _completed || _closed || _remaining == Duration.zero) {
      return;
    }
    setState(() => _navigating = true);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentCheckoutScreen(
          api: widget.api,
          booking: widget.booking,
          method: _method,
          now: widget.now,
          isSignedIn: widget.isSignedIn,
          onBookingFinished: widget.onBookingFinished,
          launchPaymentUrl: widget.launchPaymentUrl,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _navigating = false;
      _refreshRemaining();
    });
    await _checkState();
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero || _state?.isClosed == true;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('payment-screen'),
        backgroundColor: _page,
        bottomNavigationBar: PaymentBottomBar(
          disabled: expired || _closed || _completed || _navigating,
          label: 'Tiếp tục',
          onPay: _openCheckout,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BookingFlowHeader(
                key: const Key('payment-header'),
                title: 'Phương thức thanh toán',
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
                    PaymentOrderCard(booking: widget.booking),
                    const SizedBox(height: 10),
                    PaymentPendingNotice(
                      bookingCode: widget.booking.bookingCode,
                      expiresAt: widget.booking.expiresAt,
                      email: widget.booking.contact.email,
                      expired: expired,
                    ),
                    const SizedBox(height: 14),
                    if (_state?.needsReconciliation == true)
                      const Text(
                        'Giao dịch đang được đối soát. Vui lòng không chuyển tiền thêm; liên hệ hỗ trợ và cung cấp mã đơn nếu cần.',
                        key: Key('payment-reconciling'),
                      )
                    else if (!expired) ...[
                      const Text(
                        'Chọn phương thức thanh toán',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (final method in PassengerPaymentMethod.values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _MethodCard(
                            method: method,
                            selected: _method == method,
                            onTap: _navigating
                                ? null
                                : () => setState(() => _method = method),
                          ),
                        ),
                    ],
                    if (_error != null)
                      Text(
                        _error!,
                        key: const Key('payment-error'),
                        style: const TextStyle(color: Color(0xFFB42318)),
                      ),
                    TextButton.icon(
                      key: const Key('payment-refresh'),
                      onPressed: _completed ? null : _checkState,
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

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PassengerPaymentMethod method;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final logoAsset = method.logoAsset;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? const Color(0xFFEAF6FC) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? _blue : const Color(0xFFE0EBF0),
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: Key('payment-method-${method.apiValue}'),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                if (logoAsset != null)
                  Image.asset(
                    logoAsset,
                    key: Key('payment-logo-${method.apiValue}'),
                    width: 48,
                    height: 48,
                    cacheWidth: 160,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: method == PassengerPaymentMethod.payos
                          ? const Color(0xFFE3F5E9)
                          : const Color(0xFFFFF1D8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      method == PassengerPaymentMethod.payos
                          ? Icons.qr_code_2_rounded
                          : Icons.science_outlined,
                      color: method == PassengerPaymentMethod.payos
                          ? const Color(0xFF23864D)
                          : const Color(0xFFA66B16),
                      size: 30,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method.description,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? _blue : _muted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
