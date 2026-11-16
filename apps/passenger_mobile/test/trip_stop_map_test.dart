import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_stop_map.dart';

TripStop _stop(int sequence, double? latitude, double? longitude) => TripStop(
  sequence: sequence,
  name: 'Điểm $sequence',
  address: '',
  type: 'BUS_STATION',
  plannedAt: DateTime.utc(2026, 11, 20),
  allowPickup: true,
  allowDropoff: true,
  latitude: latitude,
  longitude: longitude,
);

// PASSENGER-PARITY A30: phần thuần của bản đồ điểm dừng (bản đồ là view gốc, không dựng được trong test).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chỉ vẽ điểm có toạ độ hợp lệ, giữ thứ tự lịch trình', () {
    final stops = [
      _stop(1, 10.8, 106.7),
      _stop(2, null, 106.0),
      _stop(3, 0, 0),
      _stop(4, 95, 106),
      _stop(5, 11.9, 108.4),
    ];
    expect(mappableStops(stops).map((stop) => stop.sequence), [1, 5]);
  });

  test('khung bao các điểm dừng', () {
    expect(stopBounds([_stop(1, 10.8, 106.7), _stop(2, 11.9, 108.4)]), (
      south: 10.8,
      west: 106.7,
      north: 11.9,
      east: 108.4,
    ));
  });

  test('bản đồ nền Goong như web, khóa được mã hoá trong URL', () {
    expect(
      goongStyleUrl('a b&c'),
      'https://tiles.goong.io/assets/goong_map_web.json?api_key=a+b%26c',
    );
  });

  test('ảnh nút số của điểm dừng là PNG', () async {
    final png = await stopMarkerPng(3, rest: true);
    expect(png.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
  });
}
