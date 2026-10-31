import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/booking_flow_chrome.dart';
import 'package:passenger_mobile/features/ticket/passenger_information_screen.dart';
import 'package:passenger_mobile/features/ticket/seat_map_tile.dart';
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

/// Chọn chỗ trên sơ đồ của chuyến + điểm đón / trả, rồi giữ chỗ (`POST /seat-holds`).
class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({
    required this.api,
    required this.trip,
    required this.pickupSequence,
    required this.dropoffSequence,
    this.isSignedIn = false,
    this.onBookingFinished,
    super.key,
  });

  final TripBookingApi api;
  final TripDetail trip;
  final int pickupSequence;
  final int dropoffSequence;
  final bool isSignedIn;
  final VoidCallback? onBookingFinished;

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
    // Giá chỗ theo chặng (3.3): đổi điểm đón / trả thì tải lại giá.
    _reloadSeats();
  }

  /// Tải lại sơ đồ (giá theo chặng đang chọn); bỏ những chỗ đã chọn nay không còn đặt được.
  Future<void> _reloadSeats() async {
    try {
      final trip = await widget.api.loadTrip(
        _trip.tripId,
        pickupSequence: _pickup,
        dropoffSequence: _dropoff,
      );
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
          api: widget.api,
          trip: _trip,
          hold: hold,
          isSignedIn: widget.isSignedIn,
          onBookingFinished: widget.onBookingFinished,
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
                subtitle: null,
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
              OperatorInitialAvatar(
                name: trip.operatorName,
                logoUrl: trip.operatorLogoUrl,
                size: 31,
              ),
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
          Column(
            children: [
              Row(
                children: [
                  _TripTime(time: formatVnClock(pickup.plannedAt)),
                  const SizedBox(width: 8),
                  const Expanded(child: _TimelineBar()),
                  const SizedBox(width: 8),
                  _TripTime(time: formatVnClock(dropoff.plannedAt)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                formatTripDuration(minutes),
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripTime extends StatelessWidget {
  const _TripTime({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: const TextStyle(
        color: _ink,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  const _TimelineBar();

  @override
  Widget build(BuildContext context) {
    return Row(
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

  SeatMapStatus statusOf(TripSeat seat) {
    if (selected.contains(seat.code)) return SeatMapStatus.selected;
    return seat.bookable ? SeatMapStatus.available : SeatMapStatus.unavailable;
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
    // Empty cells keep their coordinates; a double widens its column only.
    final widths = [
      for (var column = 1; column <= columns; column++)
        seats
            .where((seat) => seat.column == column)
            .fold<double>(
              24,
              (width, seat) =>
                  math.max(width, seatMapTileSize(seat.type).width),
            ),
    ];
    final heights = [
      for (var row = 1; row <= rows; row++)
        seats
            .where((seat) => seat.row == row)
            .fold<double>(
              24,
              (height, seat) =>
                  math.max(height, seatMapTileSize(seat.type).height),
            ),
    ];
    const gapX = 6.0;
    const gapY = 10.0;
    final gridWidth =
        widths.fold<double>(0, (sum, width) => sum + width) +
        math.max(0, columns - 1) * gapX;
    final types = seats.map((seat) => seat.type).toSet();

    return Container(
      key: const Key('seat-map-grid'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 6,
            children: [
              for (final type in types)
                Text(
                  seatMapTypeLabel(type),
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward_rounded, color: _muted, size: 15),
              SizedBox(width: 4),
              Text('Đầu xe', style: TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (gridWidth > constraints.maxWidth) ...[
                  const Text(
                    'Vuốt ngang để xem toàn bộ chỗ',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                ],
                SingleChildScrollView(
                  key: const Key('seat-map-horizontal-scroll'),
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: math.max(gridWidth, constraints.maxWidth),
                    child: Center(
                      child: SizedBox(
                        width: gridWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var row = 1; row <= rows; row++) ...[
                              Row(
                                children: [
                                  for (var col = 1; col <= columns; col++) ...[
                                    SizedBox(
                                      width: widths[col - 1],
                                      height: heights[row - 1],
                                      child: switch (byPosition[(row, col)]) {
                                        final TripSeat seat => Center(
                                          child: SizedBox.fromSize(
                                            size: seatMapTileSize(seat.type),
                                            child: SeatMapTile(
                                              seat: seat,
                                              status: statusOf(seat),
                                              onTap: () => onSeatSelected(seat),
                                            ),
                                          ),
                                        ),
                                        null => const SizedBox.shrink(),
                                      },
                                    ),
                                    if (col < columns)
                                      const SizedBox(width: gapX),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
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
