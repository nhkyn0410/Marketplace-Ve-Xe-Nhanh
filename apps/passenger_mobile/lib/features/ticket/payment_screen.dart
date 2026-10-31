import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';

import 'booking_flow_chrome.dart';
import 'booking_models.dart';
import 'payment_completion_screen.dart';
import 'trip_search_models.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);

/// Bước 3: đơn vừa tạo đang chờ thanh toán tới hạn của đơn.
///
/// Cổng thanh toán (payOS + cổng thử) chưa nối — nút thanh toán khóa kèm ghi chú.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.booking, this.now});

  final CreatedBooking booking;
  final DateTime Function()? now;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _refreshRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_refreshRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openPaymentCompletion() {
    final passengers = widget.booking.passengers;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentCompletionScreen(
          selectedSeats: passengers.map((p) => p.seatCode).toList(),
          passengerNames: passengers.map((p) => p.displayName).toList(),
        ),
      ),
    );
  }

  void _refreshRemaining() {
    final remaining = widget.booking.expiresAt.difference(_now());
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
    final expired = _remaining == Duration.zero;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('payment-screen'),
        backgroundColor: _page,
                bottomNavigationBar: _PaymentBottomBar(
          total: booking.total,
          disabled: expired,
          onPay: _openPaymentCompletion,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BookingFlowHeader(
                key: const Key('payment-header'),
                title: 'Thanh toán',
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
                    _OrderCard(booking: booking),
                    const SizedBox(height: 9),
                    _PendingNotice(
                      bookingCode: booking.bookingCode,
                      expiresAt: booking.expiresAt,
                      email: booking.contact.email,
                      expired: expired,
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

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.booking});

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

class _PendingNotice extends StatelessWidget {
  const _PendingNotice({
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
                        'Thanh toán trong ứng dụng sẽ mở ở bản sau; quá hạn chưa thanh toán thì đơn tự hủy. '
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _PaymentBottomBar extends StatelessWidget {
  const _PaymentBottomBar({
    this.total,
    this.onPay,
    this.disabled = false,
  });

  final int? total;
  final VoidCallback? onPay;
  final bool disabled;

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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Thanh toán',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 17),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
