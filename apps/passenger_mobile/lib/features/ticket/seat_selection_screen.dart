import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/booking_flow_chrome.dart';
import 'package:passenger_mobile/features/ticket/passenger_information_screen.dart';
import 'package:passenger_mobile/features/ticket/stop_picker_sheet.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);

/// Số chỗ tối đa mỗi lần giữ / đặt (API `MAX_PASSENGERS`).
const _maxSeats = 10;

enum _SeatStatus { available, selected, unavailable }

/// Chọn chỗ trên sơ đồ của chuyến + điểm đón / trả, rồi giữ chỗ (`POST /seat-holds`).
class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({
    required this.api,
    required this.trip,
    required this.pickupSequence,
    required this.dropoffSequence,
    super.key,
  });

  final TripBookingApi api;
  final TripDetail trip;
  final int pickupSequence;
  final int dropoffSequence;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late TripDetail _trip = widget.trip;
  late int _pickup = widget.pickupSequence;
  late int _dropoff = widget.dropoffSequence;
  final Set<String> _selected = {};
  int _deck = 1;
  bool _holding = false;

  List<int> get _decks =>
      ({for (final seat in _trip.seats) seat.deck}.toList()..sort());

  int get _total {
    var sum = 0;
    for (final seat in _trip.seats) {
      if (_selected.contains(seat.code)) sum += seat.price ?? 0;
    }
    return sum;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleSeat(TripSeat seat) {
    if (!seat.bookable || _holding) return;
    setState(() {
      if (_selected.remove(seat.code)) return;
      if (_selected.length >= _maxSeats) {
        _showMessage('Mỗi lần đặt tối đa $_maxSeats chỗ.');
        return;
      }
      _selected.add(seat.code);
    });
  }

  Future<void> _chooseStop({required bool pickup}) async {
    final stops = pickup ? _trip.pickupStops : _trip.dropoffStopsAfter(_pickup);
    final selected = await showTripStopPicker(
      context,
      pickup: pickup,
      stops: stops,
      selectedSequence: pickup ? _pickup : _dropoff,
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (pickup) {
        _pickup = selected.sequence;
        final dropoffs = _trip.dropoffStopsAfter(_pickup);
        if (!dropoffs.any((stop) => stop.sequence == _dropoff) &&
            dropoffs.isNotEmpty) {
          _dropoff = dropoffs.last.sequence;
        }
      } else {
        _dropoff = selected.sequence;
      }
    });
  }

  /// Tải lại sơ đồ; bỏ những chỗ đã chọn nay không còn đặt được.
  Future<void> _reloadSeats() async {
    try {
      final trip = await widget.api.loadTrip(_trip.tripId);
      if (!mounted) return;
      final bookable = {
        for (final seat in trip.seats)
          if (seat.bookable) seat.code,
      };
      setState(() {
        _trip = trip;
        _selected.removeWhere((code) => !bookable.contains(code));
      });
    } catch (_) {
      // Giữ sơ đồ cũ; lần giữ chỗ sau server vẫn kiểm lại.
    }
  }

  Future<void> _continue() async {
    final codes = _selected.toList()..sort();
    setState(() => _holding = true);
    SeatHold hold;
    try {
      hold = await widget.api.holdSeats(
        tripId: _trip.tripId,
        seatCodes: codes,
        pickupSequence: _pickup,
        dropoffSequence: _dropoff,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _holding = false);
      _showMessage(describeBookingFailure(error));
      if (error is ApiFailure &&
          const {
            'SEAT_NOT_AVAILABLE',
            'SEAT_HOLD_CONFLICT',
            'TRIP_SEAT_UNKNOWN',
          }.contains(error.code)) {
        await _reloadSeats();
      }
      return;
    }
    if (!mounted) return;
    setState(() => _holding = false);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PassengerInformationScreen(
          selectedSeats: hold.seatCodes,
          holdExpiresAt: hold.expiresAt,
        ),
      ),
    );
    // Khách quay lại chọn chỗ khác: trả chỗ đang giữ cho người khác.
    try {
      await widget.api.releaseHold(hold.holdId);
    } catch (_) {
      // Giữ chỗ tự hết hạn sau 10 phút nếu bỏ không được.
    }
    await _reloadSeats();
  }

  @override
  Widget build(BuildContext context) {
    final pickup = _trip.stopAt(_pickup);
    final dropoff = _trip.stopAt(_dropoff);
    final decks = _decks;
    final deck = decks.contains(_deck) ? _deck : decks.first;
    final codes = _selected.toList()..sort();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('seat-selection-screen'),
        backgroundColor: _page,
        bottomNavigationBar: _SeatBookingBar(
          seats: codes,
          total: _total,
          busy: _holding,
          onContinue: codes.isEmpty || _holding ? null : _continue,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BookingFlowHeader(
                key: const Key('seat-selection-header'),
                title: 'Chọn chỗ',
                subtitle: _trip.routeName,
                timerLabel: null,
                expired: false,
                onBack: () => Navigator.maybePop(context),
                backKey: const Key('seat-selection-back'),
                timerKey: const Key('seat-hold-countdown'),
              ),
              const BookingStepProgress(
                key: Key('seat-selection-progress'),
                activeStep: 0,
              ),
              Expanded(
                child: CustomScrollView(
                  key: const Key('seat-selection-scroll'),
                  slivers: [
                    if (pickup != null && dropoff != null) ...[
                      SliverToBoxAdapter(
                        child: _TripSummary(
                          trip: _trip,
                          pickup: pickup,
                          dropoff: dropoff,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _StopSummary(
                          pickup: pickup,
                          dropoff: dropoff,
                          onPickup: () => _chooseStop(pickup: true),
                          onDropoff: () => _chooseStop(pickup: false),
                        ),
                      ),
                    ],
                    if (decks.length > 1)
                      SliverToBoxAdapter(
                        child: _DeckSwitch(
                          decks: decks,
                          selected: deck,
                          onChanged: (value) => setState(() => _deck = value),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                        child: _SeatMap(
                          seats: [
                            for (final seat in _trip.seats)
                              if (seat.deck == deck) seat,
                          ],
                          selected: _selected,
                          onSeatSelected: _toggleSeat,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: _SeatLegend()),
                    const SliverToBoxAdapter(child: SizedBox(height: 14)),
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

class _TripSummary extends StatelessWidget {
  const _TripSummary({
    required this.trip,
    required this.pickup,
    required this.dropoff,
  });

  final TripDetail trip;
  final TripStop pickup;
  final TripStop dropoff;

  @override
  Widget build(BuildContext context) {
    final minutes = dropoff.plannedAt.difference(pickup.plannedAt).inMinutes;
    final rating = trip.averageRating;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0A2637),
            blurRadius: 9,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              OperatorInitialAvatar(name: trip.operatorName, size: 31),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.operatorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        if (rating != null && trip.reviewCount > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: _orange,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Flexible(
                          child: Text(
                            rating != null && trip.reviewCount > 0
                                ? '${rating.toStringAsFixed(1)} (${trip.reviewCount} đánh giá)'
                                : 'Chưa có đánh giá',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: _muted, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${trip.vehicleTypeName} · ${formatVnDate(pickup.plannedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _TripTime(
                time: formatVnClock(pickup.plannedAt),
                place: pickup.name,
              ),
              Expanded(child: _TripLine(duration: formatTripDuration(minutes))),
              _TripTime(
                time: formatVnClock(dropoff.plannedAt),
                place: dropoff.name,
                alignEnd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripTime extends StatelessWidget {
  const _TripTime({
    required this.time,
    required this.place,
    this.alignEnd = false,
  });

  final String time;
  final String place;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            place,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _TripLine extends StatelessWidget {
  const _TripLine({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
              ),
              const Expanded(
                child: Divider(color: Color(0xFFABC5D3), height: 2),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(duration, style: const TextStyle(color: _muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _StopSummary extends StatelessWidget {
  const _StopSummary({
    required this.pickup,
    required this.dropoff,
    required this.onPickup,
    required this.onDropoff,
  });

  final TripStop pickup;
  final TripStop dropoff;
  final VoidCallback onPickup;
  final VoidCallback onDropoff;

  @override
  Widget build(BuildContext context) {
    final stackCards =
        MediaQuery.sizeOf(context).width < 390 ||
        MediaQuery.textScalerOf(context).scale(13) > 16;
    final pickupCard = _StopCard(
      key: const Key('pickup-card'),
      title: 'Điểm đón',
      stop: pickup,
      color: _blue,
      onTap: onPickup,
    );
    final dropoffCard = _StopCard(
      key: const Key('dropoff-card'),
      title: 'Điểm trả',
      stop: dropoff,
      color: _orange,
      onTap: onDropoff,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 0),
      child: stackCards
          ? Column(
              children: [
                SizedBox(width: double.infinity, child: pickupCard),
                const SizedBox(height: 7),
                SizedBox(width: double.infinity, child: dropoffCard),
              ],
            )
          : Row(
              children: [
                Expanded(child: pickupCard),
                const SizedBox(width: 7),
                Expanded(child: dropoffCard),
              ],
            ),
    );
  }
}

class _StopCard extends StatelessWidget {
  const _StopCard({
    super.key,
    required this.title,
    required this.stop,
    required this.color,
    required this.onTap,
  });

  final String title;
  final TripStop stop;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, size: 17, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title · ${formatVnClock(stop.plannedAt)}',
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                    Text(
                      stop.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 16, color: _muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeckSwitch extends StatelessWidget {
  const _DeckSwitch({
    required this.decks,
    required this.selected,
    required this.onChanged,
  });

  final List<int> decks;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Row(
        children: [
          for (final deck in decks) ...[
            Expanded(
              child: ChoiceChip(
                key: Key('seat-deck-$deck'),
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    deck == 1 ? 'Tầng dưới' : 'Tầng trên',
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: deck == selected,
                showCheckmark: false,
                selectedColor: const Color(0xFFDDF0FA),
                labelStyle: TextStyle(
                  color: deck == selected ? _blue : _muted,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (_) => onChanged(deck),
              ),
            ),
            if (deck != decks.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _SeatMap extends StatelessWidget {
  const _SeatMap({
    required this.seats,
    required this.selected,
    required this.onSeatSelected,
  });

  final List<TripSeat> seats;
  final Set<String> selected;
  final ValueChanged<TripSeat> onSeatSelected;

  _SeatStatus statusOf(TripSeat seat) {
    if (selected.contains(seat.code)) return _SeatStatus.selected;
    return seat.bookable ? _SeatStatus.available : _SeatStatus.unavailable;
  }

  @override
  Widget build(BuildContext context) {
    final rows = seats.fold<int>(0, (max, seat) => math.max(max, seat.row));
    final columns = seats.fold<int>(
      0,
      (max, seat) => math.max(max, seat.column),
    );
    final byPosition = {
      for (final seat in seats) (seat.row, seat.column): seat,
    };
    final seatWidth = columns <= 2 ? 52.0 : (columns == 3 ? 42.0 : 34.0);
    const seatHeight = 30.0;
    final gapX = columns <= 2 ? 19.0 : 8.0;
    const gapY = 8.0;
    final frameWidth = 62 + columns * seatWidth + (columns - 1) * gapX;
    final frameHeight = 75 + rows * seatHeight + (rows - 1) * gapY + 12;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Center(
        child: SizedBox(
          key: const Key('seat-bus-frame'),
          width: frameWidth,
          height: frameHeight,
          child: CustomPaint(
            painter: _BusOutlinePainter(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(31, 75, 31, 12),
              child: Column(
                children: [
                  for (var row = 1; row <= rows; row++) ...[
                    Row(
                      children: [
                        for (var column = 1; column <= columns; column++) ...[
                          SizedBox(
                            width: seatWidth,
                            height: seatHeight,
                            child: switch (byPosition[(row, column)]) {
                              final TripSeat seat => _SeatButton(
                                seat: seat.code,
                                status: statusOf(seat),
                                onTap: () => onSeatSelected(seat),
                              ),
                              null => const SizedBox.shrink(),
                            },
                          ),
                          if (column < columns) SizedBox(width: gapX),
                        ],
                      ],
                    ),
                    if (row < rows) const SizedBox(height: gapY),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SeatButton extends StatelessWidget {
  const _SeatButton({
    required this.seat,
    required this.status,
    required this.onTap,
  });

  final String seat;
  final _SeatStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = status == _SeatStatus.selected;
    final enabled = status != _SeatStatus.unavailable;
    final background = switch (status) {
      _SeatStatus.available => Colors.white,
      _SeatStatus.selected => _blue,
      _SeatStatus.unavailable => const Color(0xFFE5EDF2),
    };
    final border = switch (status) {
      _SeatStatus.available => const Color(0xFF1687E8),
      _SeatStatus.selected => _blue,
      _SeatStatus.unavailable => const Color(0xFFCCDBE5),
    };
    return InkWell(
      key: Key('seat-$seat'),
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: border),
          boxShadow: selected
              ? const [BoxShadow(color: Color(0x331E8ABE), blurRadius: 6)]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (status == _SeatStatus.unavailable)
              const CustomPaint(painter: _SeatHatchPainter()),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  seat,
                  style: TextStyle(
                    color: switch (status) {
                      _SeatStatus.selected => Colors.white,
                      _SeatStatus.unavailable => const Color(0xFF86A5BB),
                      _SeatStatus.available => const Color(0xFF20538C),
                    },
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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

class _BusOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 185;
    final scaleY = size.height / 352;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    const outlineColor = Color(0xFF2362AE);
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = outlineColor;
    final softOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .9
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFBED4E4);
    final windshieldFill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFEEF3F7);
    final dashboardFill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD8E2E9);

    final body = Path()
      ..moveTo(24, 48)
      ..lineTo(29, 29)
      ..cubicTo(32, 13, 53, 8, 92.5, 8)
      ..cubicTo(132, 8, 153, 13, 156, 29)
      ..lineTo(161, 48)
      ..lineTo(161, 331)
      ..cubicTo(161, 344, 152, 349, 137, 349)
      ..lineTo(48, 349)
      ..cubicTo(33, 349, 24, 344, 24, 331)
      ..close();
    canvas.drawPath(body, Paint()..color = Colors.white);
    canvas.drawPath(body, outline);

    final windshield = Path()
      ..moveTo(29, 64)
      ..lineTo(29, 45)
      ..cubicTo(30, 33, 39, 27, 51, 27)
      ..lineTo(134, 27)
      ..cubicTo(146, 27, 155, 33, 156, 45)
      ..lineTo(156, 64)
      ..cubicTo(156, 70, 151, 73, 143, 73)
      ..lineTo(42, 73)
      ..cubicTo(34, 73, 29, 70, 29, 64)
      ..close();
    canvas.drawPath(windshield, windshieldFill);
    canvas.drawPath(windshield, softOutline);
    canvas.drawLine(const Offset(25, 74), const Offset(160, 74), outline);

    final leftRoofLight = Path()
      ..moveTo(31, 25)
      ..quadraticBezierTo(32, 20, 37, 18)
      ..lineTo(54, 14)
      ..quadraticBezierTo(55, 23, 48, 26)
      ..lineTo(31, 30)
      ..close();
    final rightRoofLight = Path()
      ..moveTo(154, 25)
      ..quadraticBezierTo(153, 20, 148, 18)
      ..lineTo(131, 14)
      ..quadraticBezierTo(130, 23, 137, 26)
      ..lineTo(154, 30)
      ..close();
    canvas.drawPath(leftRoofLight, Paint()..color = Colors.white);
    canvas.drawPath(rightRoofLight, Paint()..color = Colors.white);
    canvas.drawPath(leftRoofLight, outline);
    canvas.drawPath(rightRoofLight, outline);

    final driverPanel = RRect.fromRectAndCorners(
      const Rect.fromLTWH(37, 37, 51, 34),
      topLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );
    canvas.drawRRect(driverPanel, dashboardFill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(108, 43, 38, 17),
        const Radius.circular(7),
      ),
      dashboardFill,
    );
    _drawSteeringWheel(canvas, const Offset(61, 56));

    for (final rect in const [
      Rect.fromLTWH(11, 47, 13, 31),
      Rect.fromLTWH(161, 47, 13, 31),
      Rect.fromLTWH(17, 106, 6, 43),
      Rect.fromLTWH(162, 106, 6, 43),
      Rect.fromLTWH(17, 176, 6, 43),
      Rect.fromLTWH(162, 176, 6, 43),
      Rect.fromLTWH(17, 271, 6, 43),
      Rect.fromLTWH(162, 271, 6, 43),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        outline,
      );
    }

    final aisle = Paint()
      ..color = const Color(0xFFC7DCE9)
      ..strokeWidth = .9;
    for (double y = 77; y < 342; y += 8) {
      canvas.drawLine(
        Offset(92.5, y),
        Offset(92.5, math.min(y + 4, 342)),
        aisle,
      );
    }

    canvas.restore();
  }

  void _drawSteeringWheel(Canvas canvas, Offset center) {
    final wheelPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF8CA7BC);
    canvas.drawCircle(center, 10, wheelPaint);
    canvas.drawCircle(center, 2.4, wheelPaint);
    canvas.drawLine(center, center.translate(0, 9), wheelPaint);
    canvas.drawLine(center, center.translate(-8.5, -3), wheelPaint);
    canvas.drawLine(center, center.translate(8.5, -3), wheelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeatHatchPainter extends CustomPainter {
  const _SeatHatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCADAE5)
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 8) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeatLegend extends StatelessWidget {
  const _SeatLegend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        runSpacing: 7,
        children: const [
          _LegendItem(
            label: 'Trống',
            color: Colors.white,
            border: Color(0xFF9CB2C0),
          ),
          _LegendItem(label: 'Đang chọn', color: _blue, border: _blue),
          // API gộp đã bán / đang giữ / khóa thành một trạng thái.
          _LegendItem(
            label: 'Không đặt được',
            color: Color(0xFFE5EDF2),
            border: Color(0xFFCCDBE5),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    required this.border,
  });

  final String label;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: _muted, fontSize: 13)),
      ],
    );
  }
}

class _SeatBookingBar extends StatelessWidget {
  const _SeatBookingBar({
    required this.seats,
    required this.total,
    required this.busy,
    required this.onContinue,
  });

  final List<String> seats;
  final int total;
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
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seats.isEmpty
                          ? 'Chưa chọn chỗ'
                          : '${seats.length} chỗ — ${seats.join(', ')}',
                      key: const Key('seat-selection-count'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      formatVnd(total),
                      key: const Key('seat-selection-total'),
                      style: const TextStyle(
                        color: _orange,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 132,
                  maxWidth: 170,
                  minHeight: 50,
                ),
                child: FilledButton(
                  key: const Key('seat-selection-continue'),
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    disabledBackgroundColor: const Color(0xFFB9CED9),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                'Tiếp tục',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            Icon(Icons.arrow_forward_rounded, size: 16),
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
