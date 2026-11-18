import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';

/// Khóa Goong Maptiles của app — khóa hiển thị bản đồ, công khai (khác `GOONG_API_KEY` của API). Trống thì ẩn
/// bản đồ, không thay bằng nguồn bản đồ khác (ADR-027: bản đồ phải đúng chủ quyền Hoàng Sa / Trường Sa).
const goongMaptilesKey = String.fromEnvironment('GOONG_MAPTILES_KEY');

/// Bản đồ nền Goong, cùng địa chỉ với web (`packages/ui` `goongStyleUrl`).
String goongStyleUrl(String key) =>
    'https://tiles.goong.io/assets/goong_map_web.json?api_key=${Uri.encodeQueryComponent(key)}';

/// Điểm dừng có toạ độ hợp lệ để vẽ, giữ thứ tự lịch trình.
List<TripStop> mappableStops(List<TripStop> stops) => [
  for (final stop in stops)
    if (_validPoint(stop.latitude, stop.longitude)) stop,
];

bool _validPoint(double? latitude, double? longitude) =>
    latitude != null &&
    longitude != null &&
    latitude.isFinite &&
    longitude.isFinite &&
    latitude.abs() <= 90 &&
    longitude.abs() <= 180 &&
    !(latitude == 0 && longitude == 0);

/// Khung bao các điểm (nam, tây, bắc, đông).
({double south, double west, double north, double east}) stopBounds(
  List<TripStop> stops,
) {
  var south = 90.0, west = 180.0, north = -90.0, east = -180.0;
  for (final stop in stops) {
    final latitude = stop.latitude!, longitude = stop.longitude!;
    if (latitude < south) south = latitude;
    if (latitude > north) north = latitude;
    if (longitude < west) west = longitude;
    if (longitude > east) east = longitude;
  }
  return (south: south, west: west, north: north, east: east);
}

/// Bản đồ Goong các điểm dừng, đánh số theo lịch trình (trạm nghỉ màu cam như web). Nằm trong trang cuộn nên
/// chỉ để xem: tắt kéo / phóng / xoay để không giành cử chỉ cuộn trang.
class GoongStopMap extends StatefulWidget {
  const GoongStopMap({required this.stops, required this.mapKey, super.key});

  /// Đã lọc bằng [mappableStops].
  final List<TripStop> stops;
  final String mapKey;

  @override
  State<GoongStopMap> createState() => _GoongStopMapState();
}

class _GoongStopMapState extends State<GoongStopMap> {
  MapLibreMapController? _controller;

  LatLng _point(TripStop stop) => LatLng(stop.latitude!, stop.longitude!);

  Future<void> _drawStops() async {
    final controller = _controller;
    final stops = widget.stops;
    if (controller == null || stops.isEmpty) return;
    try {
      await controller.setSymbolIconAllowOverlap(true);
      for (var index = 0; index < stops.length; index++) {
        final rest = stops[index].type == 'REST_STOP';
        final image = 'trip-stop-${index + 1}${rest ? '-rest' : ''}';
        await controller.addImage(
          image,
          await stopMarkerPng(index + 1, rest: rest),
        );
        await controller.addSymbol(
          SymbolOptions(
            geometry: _point(stops[index]),
            iconImage: image,
            iconSize: 0.5,
          ),
        );
      }
      await controller.moveCamera(_camera(stops));
    } catch (_) {
      // Bản đồ chỉ minh hoạ; lỗi vẽ không chặn trang chi tiết chuyến.
    }
  }

  CameraUpdate _camera(List<TripStop> stops) {
    if (stops.length == 1) {
      return CameraUpdate.newLatLngZoom(_point(stops.single), 13);
    }
    final bounds = stopBounds(stops);
    return CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(bounds.south, bounds.west),
        northeast: LatLng(bounds.north, bounds.east),
      ),
      left: 36,
      top: 36,
      right: 36,
      bottom: 36,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bounds = stopBounds(widget.stops);
    return MapLibreMap(
      styleString: goongStyleUrl(widget.mapKey),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          (bounds.south + bounds.north) / 2,
          (bounds.west + bounds.east) / 2,
        ),
        zoom: 6,
      ),
      onMapCreated: (controller) => _controller = controller,
      onStyleLoadedCallback: () => unawaited(_drawStops()),
      scrollGesturesEnabled: false,
      dragEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      doubleClickZoomEnabled: false,
      compassEnabled: false,
    );
  }
}

/// Ảnh PNG nút số của điểm dừng (vẽ bằng Flutter, không phụ thuộc phông chữ của bản đồ nền).
Future<Uint8List> stopMarkerPng(int number, {bool rest = false}) async {
  const size = 56.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const center = Offset(size / 2, size / 2);
  canvas
    ..drawCircle(center, size / 2, Paint()..color = Colors.white)
    ..drawCircle(
      center,
      size / 2 - 5,
      Paint()..color = rest ? const Color(0xFFB54708) : const Color(0xFF0E7490),
    );
  final label = TextPainter(
    text: TextSpan(
      text: '$number',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  label.paint(canvas, center - Offset(label.width / 2, label.height / 2));
  final image = await recorder.endRecording().toImage(
    size.toInt(),
    size.toInt(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}
