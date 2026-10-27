import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _lightBlue = Color(0xFFEAF6FC);
const _muted = Color(0xFF71899B);
const _green = Color(0xFF26A56F);

/// Mở sheet chọn điểm đón (hoặc điểm trả) trong các điểm của chuyến; trả điểm đã chọn hoặc `null` khi đóng.
Future<TripStop?> showTripStopPicker(
  BuildContext context, {
  required bool pickup,
  required List<TripStop> stops,
  required int selectedSequence,
}) {
  return showModalBottomSheet<TripStop>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x990A2336),
    builder: (context) => _StopPickerSheet(
      pickup: pickup,
      stops: stops,
      selectedSequence: selectedSequence,
    ),
  );
}

class _StopPickerSheet extends StatefulWidget {
  const _StopPickerSheet({
    required this.pickup,
    required this.stops,
    required this.selectedSequence,
  });

  final bool pickup;
  final List<TripStop> stops;
  final int selectedSequence;

  @override
  State<_StopPickerSheet> createState() => _StopPickerSheetState();
}

class _StopPickerSheetState extends State<_StopPickerSheet> {
  late int _selected = widget.selectedSequence;

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
                    return _StopOption(
                      stop: stop,
                      selected: stop.sequence == _selected,
                      first: index == 0,
                      last: index == widget.stops.length - 1,
                      onTap: () => setState(() => _selected = stop.sequence),
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
                      onPressed: () => Navigator.pop(
                        context,
                        widget.stops.firstWhere(
                          (stop) => stop.sequence == _selected,
                          orElse: () => widget.stops.first,
                        ),
                      ),
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

  final TripStop stop;
  final bool selected;
  final bool first;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('stop-${stop.sequence}'),
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
                      formatVnClock(stop.plannedAt),
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
