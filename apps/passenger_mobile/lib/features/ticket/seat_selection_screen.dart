import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_flow_chrome.dart';
import 'passenger_information_screen.dart';

const _detailAssets = 'assets/ticket/detail';
const _ticketAssets = 'assets/ticket';
const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _lightBlue = Color(0xFFEAF6FC);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);
const _green = Color(0xFF26A56F);

enum _SeatStatus { available, selected, booked, unavailable }

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({
    super.key,
    this.holdDuration = const Duration(minutes: 10),
    this.now,
  });

  /// SDLC v1: a successful seat hold expires after exactly 10 minutes.
  final Duration holdDuration;
  final DateTime Function()? now;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  static const _unavailableSeats = {'A13', 'A16'};
  static const _bookedSeats = {'A07', 'A10'};

  Timer? _timer;
  late DateTime _holdExpiresAt;
  Duration _remaining = Duration.zero;
  final Set<String> _selectedSeats = {'A01'};
  _Stop _pickup = _pickupStops.first;
  _Stop _dropoff = _dropoffStops.first;

  @override
  void initState() {
    super.initState();
    // Fixture UI represents the Figma state after SeatHold succeeds. Replace
    // this timestamp with expiresAt from POST /v1/seat-holds when API is ready.
    _holdExpiresAt = _now().add(widget.holdDuration);
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
    final next = _holdExpiresAt.difference(_now());
    _remaining = next.isNegative ? Duration.zero : next;
  }

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutesPart = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsPart = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesPart:$secondsPart';
  }

  Future<void> _chooseStop({required bool pickup}) async {
    final stops = pickup ? _pickupStops : _dropoffStops;
    final current = pickup ? _pickup : _dropoff;
    final selected = await showModalBottomSheet<_Stop>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990A2336),
      builder: (context) =>
          _StopPickerSheet(pickup: pickup, stops: stops, selected: current),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (pickup) {
        _pickup = selected;
      } else {
        _dropoff = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    final selectedSeats = _selectedSeats.toList()..sort();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('seat-selection-screen'),
        backgroundColor: _page,
        bottomNavigationBar: _SeatBookingBar(
          seats: expired ? const [] : selectedSeats,
          onContinue: expired || selectedSeats.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PassengerInformationScreen(
                        selectedSeats: selectedSeats,
                        holdExpiresAt: _holdExpiresAt,
                        now: widget.now,
                      ),
                    ),
                  );
                },
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _Header(
                timerLabel: _timerLabel,
                expired: expired,
                urgent: _remaining <= const Duration(minutes: 1),
                onBack: () => Navigator.maybePop(context),
              ),
              const _StepProgress(),
              Expanded(
                child: CustomScrollView(
                  key: const Key('seat-selection-scroll'),
                  slivers: [
                    const SliverToBoxAdapter(child: _TripSummary()),
                    SliverToBoxAdapter(
                      child: _StopSummary(
                        pickup: _pickup,
                        dropoff: _dropoff,
                        onPickup: () => _chooseStop(pickup: true),
                        onDropoff: () => _chooseStop(pickup: false),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                        child: _SeatMap(
                          selectedSeats: expired ? const {} : _selectedSeats,
                          unavailableSeats: _unavailableSeats,
                          bookedSeats: _bookedSeats,
                          onSeatSelected: (seat) {
                            if (expired) return;
                            setState(() {
                              if (!_selectedSeats.remove(seat)) {
                                _selectedSeats.add(seat);
                              }
                            });
                          },
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

class _Header extends StatelessWidget {
  const _Header({
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
      key: const Key('seat-selection-header'),
      title: 'Chọn chỗ',
      timerLabel: timerLabel,
      expired: expired,
      urgent: urgent,
      onBack: onBack,
      backKey: const Key('seat-selection-back'),
      timerKey: const Key('seat-hold-countdown'),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress();

  @override
  Widget build(BuildContext context) {
    return const BookingStepProgress(
      key: Key('seat-selection-progress'),
      activeStep: 0,
    );
  }
}

class _TripSummary extends StatelessWidget {
  const _TripSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.fromLTRB(11, 10, 8, 9),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.asset(
                  '$_detailAssets/phuong_trang_logo.png',
                  width: 31,
                  height: 31,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phương Trang',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: _orange, size: 12),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '4.8 (12.5K đánh giá)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: _muted, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Limousine 34 phòng',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Image.asset(
                '$_ticketAssets/phuong_trang_bus.png',
                width: 55,
                height: 34,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted, size: 19),
            ],
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              _TripTime(time: '07:00', place: 'TP.HCM'),
              Expanded(child: _TripLine()),
              _TripTime(time: '13:30', place: 'Đà Lạt', alignEnd: true),
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
    return Column(
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
        Text(place, style: const TextStyle(color: _muted, fontSize: 13)),
      ],
    );
  }
}

class _TripLine extends StatelessWidget {
  const _TripLine();

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
          const Text('6h30', style: TextStyle(color: _muted, fontSize: 13)),
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

  final _Stop pickup;
  final _Stop dropoff;
  final VoidCallback onPickup;
  final VoidCallback onDropoff;

  @override
  Widget build(BuildContext context) {
    final stackCards =
        MediaQuery.sizeOf(context).width < 390 ||
        MediaQuery.textScalerOf(context).scale(13) > 16;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 0),
      child: stackCards
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: _StopCard(
                    key: const Key('pickup-card'),
                    title: 'Điểm đón',
                    stop: pickup,
                    color: _blue,
                    onTap: onPickup,
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  child: _StopCard(
                    key: const Key('dropoff-card'),
                    title: 'Điểm trả',
                    stop: dropoff,
                    color: _orange,
                    onTap: onDropoff,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _StopCard(
                    key: const Key('pickup-card'),
                    title: 'Điểm đón',
                    stop: pickup,
                    color: _blue,
                    onTap: onPickup,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _StopCard(
                    key: const Key('dropoff-card'),
                    title: 'Điểm trả',
                    stop: dropoff,
                    color: _orange,
                    onTap: onDropoff,
                  ),
                ),
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
  final _Stop stop;
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
                      title,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                    Text(
                      stop.name,
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

class _SeatMap extends StatelessWidget {
  const _SeatMap({
    required this.selectedSeats,
    required this.unavailableSeats,
    required this.bookedSeats,
    required this.onSeatSelected,
  });

  final Set<String> selectedSeats;
  final Set<String> unavailableSeats;
  final Set<String> bookedSeats;
  final ValueChanged<String> onSeatSelected;

  _SeatStatus statusOf(String seat) {
    if (selectedSeats.contains(seat)) return _SeatStatus.selected;
    if (bookedSeats.contains(seat)) return _SeatStatus.booked;
    if (unavailableSeats.contains(seat)) return _SeatStatus.unavailable;
    return _SeatStatus.available;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Center(
        child: SizedBox(
          key: const Key('seat-bus-frame'),
          width: 185,
          height: 352,
          child: CustomPaint(
            painter: _BusOutlinePainter(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(31, 75, 31, 9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(9, (row) {
                  final leftSeat =
                      'A${(row * 2 + 1).toString().padLeft(2, '0')}';
                  final rightSeat =
                      'A${(row * 2 + 2).toString().padLeft(2, '0')}';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SeatButton(
                        seat: leftSeat,
                        status: statusOf(leftSeat),
                        onTap: () => onSeatSelected(leftSeat),
                      ),
                      _SeatButton(
                        seat: rightSeat,
                        status: statusOf(rightSeat),
                        onTap: () => onSeatSelected(rightSeat),
                      ),
                    ],
                  );
                }),
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
    final enabled = status == _SeatStatus.available || selected;
    final background = switch (status) {
      _SeatStatus.available => Colors.white,
      _SeatStatus.selected => _blue,
      _SeatStatus.booked => const Color(0xFFDCE5EA),
      _SeatStatus.unavailable => const Color(0xFFE5EDF2),
    };
    final border = switch (status) {
      _SeatStatus.available => const Color(0xFF1687E8),
      _SeatStatus.selected => _blue,
      _SeatStatus.booked => const Color(0xFFDCE5EA),
      _SeatStatus.unavailable => const Color(0xFFCCDBE5),
    };
    return InkWell(
      key: Key('seat-$seat'),
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: 52,
        height: 27,
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
              child: Text(
                seat,
                style: TextStyle(
                  color: switch (status) {
                    _SeatStatus.selected => Colors.white,
                    _SeatStatus.booked => const Color(0xFF8AA8BE),
                    _SeatStatus.unavailable => const Color(0xFF86A5BB),
                    _SeatStatus.available => const Color(0xFF20538C),
                  },
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
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
          _LegendItem(
            label: 'Đã đặt',
            color: Color(0xFFD1DBE1),
            border: Color(0xFFBCCAD2),
          ),
          _LegendItem(
            label: 'Không khả dụng',
            color: Color(0xFFEEF2F4),
            border: Color(0xFFDDE5E9),
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
  const _SeatBookingBar({required this.seats, required this.onContinue});

  final List<String> seats;
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
                      '${seats.length} ghế',
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
                      seats.isEmpty
                          ? '0 đ'
                          : '${_formatAmount(seats.length * 280000)} đ',
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
                  child: const Row(
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

String _formatAmount(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) buffer.write('.');
    buffer.write(digits[index]);
  }
  return buffer.toString();
}

class _StopPickerSheet extends StatefulWidget {
  const _StopPickerSheet({
    required this.pickup,
    required this.stops,
    required this.selected,
  });

  final bool pickup;
  final List<_Stop> stops;
  final _Stop selected;

  @override
  State<_StopPickerSheet> createState() => _StopPickerSheetState();
}

class _StopPickerSheetState extends State<_StopPickerSheet> {
  late _Stop _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final maxHeight = math.min(520.0, media.height * .72);
    final accent = widget.pickup ? _green : const Color(0xFFFF5252);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          key: Key(widget.pickup ? 'pickup-sheet' : 'dropoff-sheet'),
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 8, 10),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: accent, size: 22),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        widget.pickup ? 'Chọn điểm đón' : 'Chọn điểm trả',
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('stop-sheet-close'),
                      onPressed: () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: _ink,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  key: const Key('stop-options'),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(11, 0, 11, 8),
                  itemCount: widget.stops.length,
                  itemBuilder: (context, index) {
                    final stop = widget.stops[index];
                    final selected = stop == _selected;
                    return _StopOption(
                      stop: stop,
                      selected: selected,
                      first: index == 0,
                      last: index == widget.stops.length - 1,
                      onTap: () => setState(() => _selected = stop),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 4, 11, 11),
                child: SizedBox(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: FilledButton(
                      key: const Key('confirm-stop'),
                      onPressed: () => Navigator.pop(context, _selected),
                      style: FilledButton.styleFrom(
                        backgroundColor: _blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class _StopOption extends StatelessWidget {
  const _StopOption({
    required this.stop,
    required this.selected,
    required this.first,
    required this.last,
    required this.onTap,
  });

  final _Stop stop;
  final bool selected;
  final bool first;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('stop-${stop.time}-${stop.name}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _lightBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  if (!first)
                    Container(
                      width: 1,
                      height: 8,
                      color: const Color(0xFFD7E2E8),
                    )
                  else
                    const SizedBox(height: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? _blue : const Color(0xFFB9CBD5),
                    ),
                  ),
                  if (!last)
                    Container(
                      width: 1,
                      height: 35,
                      color: const Color(0xFFD7E2E8),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.time,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      stop.name,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      stop.address,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Container(
                width: 16,
                height: 16,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? _blue : const Color(0xFFB9CBD5),
                  ),
                ),
                child: selected
                    ? const DecoratedBox(
                        decoration: BoxDecoration(
                          color: _blue,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stop {
  const _Stop({required this.time, required this.name, required this.address});

  final String time;
  final String name;
  final String address;
}

const _pickupStops = [
  _Stop(
    time: '07:00',
    name: 'Bến xe Miền Tây',
    address: '395 Kinh Dương Vương, Bình Tân, TP.HCM',
  ),
  _Stop(
    time: '07:20',
    name: 'Ngã tư Bình Phước',
    address: 'Quốc lộ 13, Thủ Đức',
  ),
  _Stop(time: '07:40', name: 'Bến xe An Sương', address: 'Quốc lộ 22, Hóc Môn'),
  _Stop(
    time: '08:00',
    name: 'Trạm thu phí Tây Ninh',
    address: 'Quốc lộ 22, Củ Chi',
  ),
];

const _dropoffStops = [
  _Stop(
    time: '13:30',
    name: 'Bến xe Đà Lạt',
    address: '01 Tô Hiến Thành, Phường 3, Đà Lạt',
  ),
  _Stop(
    time: '13:50',
    name: 'Ngã ba Liên Khương',
    address: 'Quốc lộ 27, Đức Trọng',
  ),
  _Stop(time: '14:10', name: 'Chợ Liên Nghĩa', address: 'Đức Trọng, Lâm Đồng'),
  _Stop(time: '14:30', name: 'Trung tâm Đà Lạt', address: 'Đường 3/2, Đà Lạt'),
];
