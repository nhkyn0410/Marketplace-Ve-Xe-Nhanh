import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_flow_chrome.dart';
import 'payment_screen.dart';

const _detailAssets = 'assets/ticket/detail';
const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);
const _green = Color(0xFF2FAE70);
const _field = Color(0xFFF7FAFC);
const _seatPrice = 280000;
const _serviceFee = 20000;
const _discount = 50000;

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({
    super.key,
    required this.selectedSeats,
    required this.passengerNames,
    required this.holdExpiresAt,
    this.now,
  }) : assert(selectedSeats.length > 0),
       assert(selectedSeats.length == passengerNames.length);

  final List<String> selectedSeats;
  final List<String> passengerNames;
  final DateTime holdExpiresAt;
  final DateTime Function()? now;

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _termsAccepted = true;

  int get _ticketAmount => widget.selectedSeats.length * _seatPrice;
  int get _totalAmount => _ticketAmount + _serviceFee - _discount;
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

  void _refreshRemaining() {
    final remaining = widget.holdExpiresAt.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  void _continueToPayment() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentScreen(
          selectedSeats: widget.selectedSeats,
          passengerNames: widget.passengerNames,
          holdExpiresAt: widget.holdExpiresAt,
          now: widget.now,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _page,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('booking-confirmation-screen'),
        backgroundColor: _page,
        bottomNavigationBar: _ConfirmationBottomBar(
          totalAmount: _totalAmount,
          onContinue: expired || !_termsAccepted ? null : _continueToPayment,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _ConfirmationHeader(
                timerLabel: _timerLabel,
                expired: expired,
                urgent: _remaining <= const Duration(minutes: 1),
                onBack: () => Navigator.maybePop(context),
              ),
              const _ConfirmationProgress(),
              Expanded(
                child: CustomScrollView(
                  key: const Key('booking-confirmation-scroll'),
                  slivers: [
                    const SliverToBoxAdapter(child: _TripCard()),
                    SliverToBoxAdapter(
                      child: _PassengersCard(
                        seats: widget.selectedSeats,
                        passengerNames: widget.passengerNames,
                        onEdit: () => Navigator.maybePop(context),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _StopsCard(
                        onEdit: () => Navigator.maybePop(context),
                      ),
                    ),
                    const SliverToBoxAdapter(child: _VoucherCard()),
                    SliverToBoxAdapter(
                      child: _PaymentDetailsCard(
                        seatCount: widget.selectedSeats.length,
                        ticketAmount: _ticketAmount,
                        totalAmount: _totalAmount,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _TermsRow(
                        accepted: _termsAccepted,
                        onChanged: (value) {
                          setState(() => _termsAccepted = value ?? false);
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
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

class _ConfirmationHeader extends StatelessWidget {
  const _ConfirmationHeader({
    required this.timerLabel,
    required this.expired,
    required this.urgent,
    required this.onBack,
  });

  final String timerLabel;
  final bool expired;
  final bool urgent;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BookingFlowHeader(
      key: const Key('booking-confirmation-header'),
      title: 'Xác nhận booking',
      subtitle: 'TP.HCM → Đà Lạt',
      timerLabel: timerLabel,
      expired: expired,
      urgent: urgent,
      onBack: onBack,
      backKey: const Key('booking-confirmation-back'),
      timerKey: const Key('booking-hold-timer'),
      backgroundColor: _page,
    );
  }
}

class _ConfirmationProgress extends StatelessWidget {
  const _ConfirmationProgress();

  @override
  Widget build(BuildContext context) {
    return const BookingStepProgress(
      key: Key('booking-confirmation-progress'),
      activeStep: 1,
      backgroundColor: _page,
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                '$_detailAssets/phuong_trang_logo.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 7,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Phương Trang',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _PopularBadge(),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: _orange, size: 14),
                        SizedBox(width: 2),
                        Text(
                          '4.8',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '(1.2K đánh giá)',
                            style: TextStyle(color: _muted, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              _RoutePoint(
                time: '07:00',
                city: 'TP.HCM',
                station: 'Bến xe Miền Đông',
              ),
              Expanded(child: _DurationRoute()),
              _RoutePoint(
                time: '13:30',
                city: 'Đà Lạt',
                station: 'Bến xe Đà Lạt',
                end: true,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 9),
            child: Divider(height: 1, color: Color(0xFFE7EEF2)),
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              Expanded(
                child: _TripMeta(
                  icon: Icons.calendar_month_rounded,
                  label: 'Thứ 6, 10/10/2026',
                ),
              ),
              SizedBox(height: 21, child: VerticalDivider(width: 20)),
              Expanded(
                child: _TripMeta(
                  icon: Icons.airline_seat_recline_extra_rounded,
                  label: 'Limousine 34 phòng',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9D1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Phổ biến',
        style: TextStyle(
          color: Color(0xFFE98A24),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.time,
    required this.city,
    required this.station,
    this.end = false,
  });

  final String time;
  final String city;
  final String station;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: end
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(city, style: const TextStyle(color: _muted, fontSize: 13)),
          Text(
            station,
            textAlign: end ? TextAlign.end : TextAlign.start,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DurationRoute extends StatelessWidget {
  const _DurationRoute();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _DashedLine()),
              Container(
                width: 27,
                height: 22,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F3FA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.directions_bus_filled_rounded,
                  color: _blue,
                  size: 16,
                ),
              ),
              const Expanded(child: _DashedLine()),
            ],
          ),
          const SizedBox(height: 2),
          const Text('6h30', style: TextStyle(color: _muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _TripMeta extends StatelessWidget {
  const _TripMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _blue, size: 18),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PassengersCard extends StatelessWidget {
  const _PassengersCard({
    required this.seats,
    required this.passengerNames,
    required this.onEdit,
  });

  final List<String> seats;
  final List<String> passengerNames;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _CardHeader(
            icon: Icons.group_rounded,
            title: 'Ghế & hành khách',
            onEdit: onEdit,
          ),
          const SizedBox(height: 9),
          for (var index = 0; index < seats.length; index++) ...[
            _PassengerRow(seat: seats[index], name: passengerNames[index]),
            if (index != seats.length - 1) const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}

class _PassengerRow extends StatelessWidget {
  const _PassengerRow({required this.seat, required this.name});

  final String seat;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 42),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            seat,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _field,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE1EBF0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2F2FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: _blue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StopsCard extends StatelessWidget {
  const _StopsCard({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _CardHeader(
            icon: Icons.location_on_rounded,
            title: 'Điểm đón / Điểm trả',
            onEdit: onEdit,
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_rounded, color: _green, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: _StopDetails(
                  label: 'Điểm đón',
                  title: 'Bến xe Miền Đông',
                  address: '292 Đinh Bộ Lĩnh, Bình Thạnh, TP.HCM',
                  time: '07:00',
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 11),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 2,
                height: 20,
                child: CustomPaint(painter: _DashedLinePainter(vertical: true)),
              ),
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Color(0xFFF04F56),
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StopDetails(
                  label: 'Điểm trả',
                  title: 'Bến xe Đà Lạt',
                  address: '01 Tô Hiến Thành, Phường 3, Đà Lạt',
                  time: '13:30',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StopDetails extends StatelessWidget {
  const _StopDetails({
    required this.label,
    required this.title,
    required this.address,
    required this.time,
  });

  final String label;
  final String title;
  final String address;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 13)),
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(address, style: const TextStyle(color: _muted, fontSize: 13)),
        const SizedBox(height: 3),
        Row(
          children: [
            const Icon(Icons.access_time_rounded, color: _muted, size: 14),
            const SizedBox(width: 4),
            Text(
              time,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard();

  @override
  Widget build(BuildContext context) {
    return const _WhiteCard(
      child: Column(
        children: [
          _CardHeader(icon: Icons.card_giftcard_rounded, title: 'Ưu đãi'),
          SizedBox(height: 9),
          _AppliedVoucher(),
        ],
      ),
    );
  }
}

class _AppliedVoucher extends StatelessWidget {
  const _AppliedVoucher();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECF8F0),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE7C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.percent_rounded, color: _orange, size: 20),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VXN50K',
                  style: TextStyle(
                    color: Color(0xFF258A54),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Giảm 50.000 đ cho đơn hàng',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: _green, size: 15),
                  SizedBox(width: 3),
                  Text(
                    'Đã áp dụng',
                    style: TextStyle(
                      color: Color(0xFF258A54),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '-50.000 đ',
                style: TextStyle(
                  color: Color(0xFF258A54),
                  fontSize: 16,
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

class _PaymentDetailsCard extends StatelessWidget {
  const _PaymentDetailsCard({
    required this.seatCount,
    required this.ticketAmount,
    required this.totalAmount,
  });

  final int seatCount;
  final int ticketAmount;
  final int totalAmount;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          const _CardHeader(
            icon: Icons.receipt_long_rounded,
            title: 'Chi tiết thanh toán',
          ),
          const SizedBox(height: 8),
          _PaymentRow(
            label: 'Tiền vé ($seatCount ghế x 280.000 đ)',
            amount: '${_formatAmount(ticketAmount)} đ',
          ),
          const SizedBox(height: 7),
          const _PaymentRow(label: 'Phí dịch vụ', amount: '20.000 đ'),
          const SizedBox(height: 7),
          const _PaymentRow(
            label: 'Giảm giá (VXN50K)',
            amount: '-50.000 đ',
            discount: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFE2EBF0)),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tổng thanh toán',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_formatAmount(totalAmount)} đ',
                key: const Key('booking-total-amount'),
                style: const TextStyle(
                  color: _blue,
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

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.label,
    required this.amount,
    this.discount = false,
  });

  final String label;
  final String amount;
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
          amount,
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

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.accepted, required this.onChanged});

  final bool accepted;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              key: const Key('booking-terms-checkbox'),
              value: accepted,
              onChanged: onChanged,
              activeColor: _blue,
              checkColor: Colors.white,
              side: const BorderSide(color: _blue, width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(
              spacing: 3,
              runSpacing: 1,
              children: const [
                Text(
                  'Tôi đồng ý với',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
                Text(
                  'Điều khoản đặt vé',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text('và', style: TextStyle(color: _muted, fontSize: 13)),
                Text(
                  'Chính sách hủy',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
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

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.icon, required this.title, this.onEdit});

  final IconData icon;
  final String title;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _blue, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onEdit != null)
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: _blue, size: 15),
                  SizedBox(width: 4),
                  Text(
                    'Sửa',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _ConfirmationBottomBar extends StatelessWidget {
  const _ConfirmationBottomBar({
    required this.totalAmount,
    required this.onContinue,
  });

  final int totalAmount;
  final VoidCallback? onContinue;

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
          padding: const EdgeInsets.fromLTRB(12, 9, 10, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng thanh toán',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                    Text(
                      '${_formatAmount(totalAmount)} đ',
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 168,
                  maxWidth: 210,
                  minHeight: 50,
                ),
                child: FilledButton(
                  key: const Key('booking-continue-payment'),
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    disabledBackgroundColor: const Color(0xFFB9CED9),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Tiếp tục thanh toán',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
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
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 2,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({this.vertical = false});

  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBDD0DB)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    const dashLength = 4.0;
    const gap = 3.0;
    final length = vertical ? size.height : size.width;

    for (var offset = 0.0; offset < length; offset += dashLength + gap) {
      final end = (offset + dashLength).clamp(0.0, length);
      if (vertical) {
        canvas.drawLine(
          Offset(size.width / 2, offset),
          Offset(size.width / 2, end),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(offset, size.height / 2),
          Offset(end, size.height / 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => false;
}

String _formatAmount(int amount) {
  final digits = amount.toString();
  final result = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) result.write('.');
    result.write(digits[index]);
  }
  return result.toString();
}
