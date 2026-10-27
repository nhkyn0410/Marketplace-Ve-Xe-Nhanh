import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';

import 'booking_flow_chrome.dart';
import 'booking_models.dart';
import 'payment_screen.dart';
import 'trip_booking_api.dart';
import 'trip_detail_models.dart';
import 'trip_search_models.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);
const _green = Color(0xFF2FAE70);
const _field = Color(0xFFF7FAFC);

/// Bước xác nhận: xem lại chuyến, hành khách, điểm đón / trả, ưu đãi, tổng tiền rồi tạo đơn (`POST /bookings`).
class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({
    super.key,
    required this.api,
    required this.trip,
    required this.hold,
    required this.draft,
    this.now,
  });

  final TripBookingApi api;
  final TripDetail trip;
  final SeatHold hold;
  final BookingDraft draft;
  final DateTime Function()? now;

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  late SeatHold _hold = widget.hold;
  late PromotionQuote? _promotion = widget.draft.promotion;
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _termsAccepted = false;
  bool _submitting = false;

  int get _discount => _promotion?.discount ?? 0;
  int get _total => _promotion?.total ?? _hold.subtotal;
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
    final remaining = _hold.expiresAt.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _createBooking() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final booking = await widget.api.createBooking(
        holdId: _hold.holdId,
        draft: BookingDraft(
          contact: widget.draft.contact,
          passengers: widget.draft.passengers,
          promotion: _promotion,
        ),
        expectedTotal: _total,
      );
      if (!mounted) return;
      // Đơn đã tạo thì không quay lại sửa được (chỗ đã chuyển sang đơn): xóa các bước trước khỏi lịch sử.
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => PaymentScreen(booking: booking, now: widget.now),
        ),
        (route) => route.isFirst,
      );
    } catch (error) {
      if (!mounted) return;
      await _handleBookingError(error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _handleBookingError(Object error) async {
    if (error is ApiFailure && error.code == 'BOOKING_SNAPSHOT_CHANGED') {
      await _refreshPrices();
      return;
    }
    if (error is ApiFailure && error.code.startsWith('PROMOTION_')) {
      setState(() => _promotion = null);
      _showMessage(
        '${error.detail} Mã đã được bỏ, vui lòng xem lại tổng tiền.',
      );
      return;
    }
    _showMessage(describeBookingFailure(error));
  }

  /// Giá vừa đổi: đọc lại phiên giữ chỗ, tính lại mã khuyến mãi, cho khách xem tổng mới.
  Future<void> _refreshPrices() async {
    try {
      final hold = await widget.api.reloadHold(_hold.holdId);
      PromotionQuote? promotion;
      final code = _promotion?.code;
      if (code != null) {
        try {
          promotion = await widget.api.checkPromotion(
            tripId: widget.trip.tripId,
            code: code,
            subtotal: hold.subtotal,
          );
        } catch (_) {
          promotion = null;
        }
      }
      if (!mounted) return;
      setState(() {
        _hold = hold;
        _promotion = promotion;
      });
      _showMessage(
        'Giá vé vừa thay đổi. Tổng mới: ${formatVnd(_total)}. Bấm thanh toán lần nữa nếu đồng ý.',
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(describeBookingFailure(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    final pickup = widget.trip.stopAt(_hold.pickup.sequence);
    final dropoff = widget.trip.stopAt(_hold.dropoff.sequence);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _page,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('booking-confirmation-screen'),
        backgroundColor: _page,
        bottomNavigationBar: _ConfirmationBottomBar(
          totalAmount: _total,
          busy: _submitting,
          onContinue: expired || !_termsAccepted || _submitting
              ? null
              : _createBooking,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BookingFlowHeader(
                key: const Key('booking-confirmation-header'),
                title: 'Xác nhận booking',
                subtitle: widget.trip.routeName,
                timerLabel: _timerLabel,
                expired: expired,
                urgent: _remaining <= const Duration(minutes: 1),
                onBack: () => Navigator.maybePop(context),
                backKey: const Key('booking-confirmation-back'),
                timerKey: const Key('booking-hold-timer'),
                backgroundColor: _page,
              ),
              const BookingStepProgress(
                key: Key('booking-confirmation-progress'),
                activeStep: 1,
                backgroundColor: _page,
              ),
              Expanded(
                child: CustomScrollView(
                  key: const Key('booking-confirmation-scroll'),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _TripCard(trip: widget.trip, hold: _hold),
                    ),
                    SliverToBoxAdapter(
                      child: _PassengersCard(
                        passengers: widget.draft.passengers,
                        contact: widget.draft.contact,
                        onEdit: () => Navigator.maybePop(context),
                      ),
                    ),
                    if (pickup != null && dropoff != null)
                      SliverToBoxAdapter(
                        child: _StopsCard(pickup: pickup, dropoff: dropoff),
                      ),
                    if (_promotion != null)
                      SliverToBoxAdapter(
                        child: _VoucherCard(promotion: _promotion!),
                      ),
                    SliverToBoxAdapter(
                      child: _PaymentDetailsCard(
                        hold: _hold,
                        promotion: _promotion,
                        discount: _discount,
                        totalAmount: _total,
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

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip, required this.hold});

  final TripDetail trip;
  final SeatHold hold;

  @override
  Widget build(BuildContext context) {
    final rating = trip.averageRating;
    final minutes = hold.dropoff.plannedAt
        .difference(hold.pickup.plannedAt)
        .inMinutes;
    return _WhiteCard(
      child: Column(
        children: [
          Row(
            children: [
              OperatorInitialAvatar(name: trip.operatorName, size: 34),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.operatorName,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (rating != null && trip.reviewCount > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: _orange,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Expanded(
                          child: Text(
                            rating != null && trip.reviewCount > 0
                                ? '${rating.toStringAsFixed(1)} (${trip.reviewCount} đánh giá)'
                                : 'Chưa có đánh giá',
                            style: const TextStyle(color: _muted, fontSize: 13),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoutePoint(
                time: formatVnClock(hold.pickup.plannedAt),
                station: hold.pickup.name,
              ),
              Expanded(
                child: _DurationRoute(duration: formatTripDuration(minutes)),
              ),
              _RoutePoint(
                time: formatVnClock(hold.dropoff.plannedAt),
                station: hold.dropoff.name,
                end: true,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 9),
            child: Divider(height: 1, color: Color(0xFFE7EEF2)),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _TripMeta(
                  icon: Icons.calendar_month_rounded,
                  label: formatVnDate(hold.pickup.plannedAt),
                ),
              ),
              const SizedBox(height: 21, child: VerticalDivider(width: 20)),
              Expanded(
                child: _TripMeta(
                  icon: Icons.airline_seat_recline_extra_rounded,
                  label: trip.vehicleTypeName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.time,
    required this.station,
    this.end = false,
  });

  final String time;
  final String station;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
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
          Text(
            station,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: end ? TextAlign.end : TextAlign.start,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DurationRoute extends StatelessWidget {
  const _DurationRoute({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
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
          Text(duration, style: const TextStyle(color: _muted, fontSize: 13)),
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
    required this.passengers,
    required this.contact,
    required this.onEdit,
  });

  final List<BookingPassenger> passengers;
  final BookingContact contact;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.group_rounded,
            title: 'Ghế & hành khách',
            onEdit: onEdit,
          ),
          const SizedBox(height: 9),
          for (var index = 0; index < passengers.length; index++) ...[
            _PassengerRow(
              seat: passengers[index].seatCode,
              name: passengers[index].fullName,
            ),
            if (index != passengers.length - 1) const SizedBox(height: 7),
          ],
          const SizedBox(height: 9),
          Text(
            'Liên hệ: ${contact.fullName} · ${contact.phone} · ${contact.email}',
            key: const Key('booking-contact-line'),
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
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
  const _StopsCard({required this.pickup, required this.dropoff});

  final TripStop pickup;
  final TripStop dropoff;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          const _CardHeader(
            icon: Icons.location_on_rounded,
            title: 'Điểm đón / Điểm trả',
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_rounded, color: _green, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: _StopDetails(
                  label: 'Điểm đón',
                  title: pickup.name,
                  address: pickup.address,
                  time: formatVnClock(pickup.plannedAt),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFF04F56),
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StopDetails(
                  label: 'Điểm trả',
                  title: dropoff.name,
                  address: dropoff.address,
                  time: formatVnClock(dropoff.plannedAt),
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
  const _VoucherCard({required this.promotion});

  final PromotionQuote promotion;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          const _CardHeader(icon: Icons.card_giftcard_rounded, title: 'Ưu đãi'),
          const SizedBox(height: 9),
          Container(
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
                  child: const Icon(
                    Icons.percent_rounded,
                    color: _orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promotion.code,
                        style: const TextStyle(
                          color: Color(0xFF258A54),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        promotion.name,
                        style: const TextStyle(color: _muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  '-${formatVnd(promotion.discount)}',
                  style: const TextStyle(
                    color: Color(0xFF258A54),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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

class _PaymentDetailsCard extends StatelessWidget {
  const _PaymentDetailsCard({
    required this.hold,
    required this.promotion,
    required this.discount,
    required this.totalAmount,
  });

  final SeatHold hold;
  final PromotionQuote? promotion;
  final int discount;
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
          for (final seat in hold.seats) ...[
            _PaymentRow(
              label: 'Chỗ ${seat.code}',
              amount: formatVnd(seat.price),
            ),
            const SizedBox(height: 7),
          ],
          // v1 chưa thu phí dịch vụ nhưng vẫn tách dòng (CO-12).
          _PaymentRow(label: 'Phí dịch vụ', amount: formatVnd(0)),
          if (promotion != null) ...[
            const SizedBox(height: 7),
            _PaymentRow(
              label: 'Giảm giá (${promotion!.code})',
              amount: '-${formatVnd(discount)}',
              discount: true,
            ),
          ],
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
                formatVnd(totalAmount),
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
    required this.busy,
    required this.onContinue,
  });

  final int totalAmount;
  final bool busy;
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
                      formatVnd(totalAmount),
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
                  child: busy
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
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
