import 'package:flutter/material.dart';

import 'booking_models.dart' show isDoubleSeat;
import 'trip_detail_models.dart';

const _blue = Color(0xFF1E8ABE);

/// Trạng thái hiển thị của một chỗ theo dữ liệu còn bán và lựa chọn hiện tại.
enum SeatMapStatus { available, selected, unavailable }

/// Kích thước hình chỗ; chỗ đôi rộng hơn nhưng vẫn chỉ chiếm một ô dữ liệu.
Size seatMapTileSize(String type) => switch (type) {
  'BED' => const Size(56, 80),
  'BED_DOUBLE' => const Size(72, 80),
  'CABIN' => const Size(64, 88),
  'CABIN_DOUBLE' => const Size(80, 88),
  _ => const Size(48, 54),
};

/// Tên dễ hiểu của loại chỗ dùng trong chú giải và trình đọc màn hình.
String seatMapTypeLabel(String type) => switch (type) {
  'BED' => 'Giường nằm',
  'BED_DOUBLE' => 'Giường đôi',
  'CABIN' => 'Cabin',
  'CABIN_DOUBLE' => 'Cabin đôi',
  _ => 'Ghế ngồi',
};

/// Ô chọn chỗ có hình ghế, giường hoặc khoang cabin riêng và mã chỗ luôn rõ.
class SeatMapTile extends StatelessWidget {
  const SeatMapTile({
    required this.seat,
    required this.status,
    required this.onTap,
    super.key,
  });

  final TripSeat seat;
  final SeatMapStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = status == SeatMapStatus.selected;
    final enabled = status != SeatMapStatus.unavailable;
    final doubleSeat = isDoubleSeat(seat.type);
    final cabin = seat.type.startsWith('CABIN');
    final color = selected
        ? Colors.white
        : enabled
        ? const Color(0xFF20538C)
        : const Color(0xFF7894A5);
    final stateLabel = switch (status) {
      SeatMapStatus.available => 'còn trống',
      SeatMapStatus.selected => 'đang chọn',
      SeatMapStatus.unavailable => 'không đặt được',
    };
    final label =
        '${seatMapTypeLabel(seat.type)} ${seat.code}'
        '${doubleSeat ? ', 2 người' : ''}, $stateLabel';
    return Semantics(
      key: Key('seat-${seat.code}'),
      label: label,
      button: true,
      enabled: enabled,
      selected: selected,
      onTap: enabled ? onTap : null,
      child: ExcludeSemantics(
        child: Tooltip(
          message: label,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(cabin ? 12 : 7),
              child: CustomPaint(
                painter: _SeatShapePainter(type: seat.type, status: status),
                child: Align(
                  alignment: const Alignment(0, .35),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: .48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              seat.code,
                              style: TextStyle(
                                color: color,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (doubleSeat) ...[
                              const SizedBox(height: 3),
                              Text(
                                '2 người',
                                style: TextStyle(color: color, fontSize: 9),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SeatShapePainter extends CustomPainter {
  const _SeatShapePainter({required this.type, required this.status});

  final String type;
  final SeatMapStatus status;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final seated = type == 'SEAT';
    final cabin = type.startsWith('CABIN');
    final selected = status == SeatMapStatus.selected;
    final unavailable = status == SeatMapStatus.unavailable;
    final border = unavailable ? const Color(0xFFB7CAD7) : _blue;
    final line = selected ? Colors.white.withValues(alpha: .7) : border;
    final fill = selected
        ? _blue
        : unavailable
        ? const Color(0xFFE5EDF2)
        : Colors.white;
    final accent = selected
        ? Colors.white.withValues(alpha: .24)
        : const Color(0xFFDCEBF5);
    final stroke = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = cabin ? 1.6 : 1.25;
    final detail = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    Rect rect(double x, double y, double width, double height) =>
        Rect.fromLTWH(x * w, y * h, width * w, height * h);
    RRect rounded(Rect rect, double radius) =>
        RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final body = Path();
    if (seated) {
      body
        ..addRRect(rounded(rect(.14, .06, .72, .78), 7))
        ..addRRect(rounded(rect(.02, .35, .13, .53), 3))
        ..addRRect(rounded(rect(.85, .35, .13, .53), 3))
        ..addRRect(rounded(rect(.18, .88, .64, .06), 2));
    } else {
      body.addRRect(
        rounded(
          cabin ? rect(.04, .02, .92, .96) : rect(.10, .03, .80, .94),
          cabin ? 12 : 7,
        ),
      );
    }
    if (selected) {
      canvas.drawShadow(body, _blue.withValues(alpha: .3), 3, false);
    }
    canvas.drawPath(body, Paint()..color = fill);
    if (unavailable) {
      canvas.save();
      canvas.clipPath(body);
      final hatch = Paint()
        ..color = const Color(0xFFCCDBE5)
        ..strokeWidth = .75;
      for (double x = -h; x < w; x += 7) {
        canvas.drawLine(Offset(x, h), Offset(x + h, 0), hatch);
      }
      canvas.restore();
    }
    canvas.drawPath(body, stroke);

    if (seated) {
      canvas.drawRRect(
        rounded(rect(.23, .13, .54, .16), 3),
        Paint()..color = accent,
      );
      canvas.drawLine(
        Offset(w * .21, h * .33),
        Offset(w * .79, h * .33),
        detail,
      );
      return;
    }
    final pillows = cabin ? rect(.24, .15, .52, .15) : rect(.21, .11, .58, .16);
    final count = isDoubleSeat(type) ? 2 : 1;
    final pillowWidth = (pillows.width - (count - 1) * 3) / count;
    for (var index = 0; index < count; index++) {
      final pillow = rounded(
        Rect.fromLTWH(
          pillows.left + index * (pillowWidth + 3),
          pillows.top,
          pillowWidth,
          pillows.height,
        ),
        3,
      );
      canvas.drawRRect(pillow, Paint()..color = accent);
      canvas.drawRRect(pillow, detail);
    }
    if (cabin) {
      canvas.drawRRect(rounded(rect(.16, .09, .68, .80), 7), detail);
      final curtains = Paint()..color = accent;
      canvas.drawRRect(rounded(rect(.07, .24, .06, .52), 2), curtains);
      canvas.drawRRect(rounded(rect(.87, .24, .06, .52), 2), curtains);
      canvas.drawLine(
        Offset(w * .24, h * .87),
        Offset(w * .76, h * .87),
        detail,
      );
    } else {
      canvas.drawLine(
        Offset(w * .16, h * .33),
        Offset(w * .84, h * .33),
        detail,
      );
      canvas.drawLine(
        Offset(w * .16, h * .88),
        Offset(w * .84, h * .88),
        detail,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SeatShapePainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.status != status;
}
