import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:employee_mobile/trip_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dữ liệu thật đặt tên tuyến vào `DemoTrip.id` (vd tuyến Buôn Ma Thuột), dài
/// hơn nhiều so với mã chuyến ngắn của bản minh họa. Màn hẹp (~384 dp như điện
/// thoại thật) không được tràn hàng, nhãn bên trái không bị ép thành chữ dọc.
const _longRoute =
    'TP. Hồ Chí Minh (BX Miền Đông cũ) – Gia Nghĩa – Buôn Ma Thuột';

const _origin = 'Bến xe Miền Đông cũ';
const _destination = 'Văn phòng Kumho Samco Buôn Ma Thuột';

// Như API ghép chuyến thật: điểm đón / trả trùng tên bến đầu / cuối.
DemoTrip _trip() => DemoTrip(
  id: _longRoute,
  origin: _origin,
  destination: _destination,
  pickupName: _origin,
  dropoffName: _destination,
  departure: '22:00',
  operatingNote: '',
  vehiclePlate: '51B19876',
  passengers: [
    DemoPassenger('Phạm Văn Tuấn', 'A01', 'VXNFFSBHX-01', '0*** *** 789'),
    DemoPassenger('Phạm Thị Ngọc', 'A02', 'VXNFFSBHX-02', '0*** *** 790'),
  ],
);

Future<void> _pumpNarrow(WidgetTester tester, Widget home) async {
  tester.view.physicalSize = const Size(384, 854);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(theme: employeeTheme(Brightness.light), home: home),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });

  testWidgets('Thẻ chuyến với tên tuyến dài không tràn, biển số đọc được', (
    tester,
  ) async {
    await _pumpNarrow(
      tester,
      DriverPage(
        child: TripsScreen(trips: [_trip()], onTabSelected: (_) {}),
      ),
    );
    expect(tester.takeException(), isNull);
    final plate = find.text('51B19876 · 2 khách');
    expect(plate, findsOneWidget);
    // Bị ép thì hộp chữ chỉ còn vài pixel và chữ xếp dọc.
    expect(tester.getSize(plate).width, greaterThan(100));
    expect(find.text(_longRoute), findsWidgets);
  });

  testWidgets('Vé hành khách ở màn Đã lên xe không tràn với tên tuyến dài', (
    tester,
  ) async {
    final trip = _trip();
    await _pumpNarrow(
      tester,
      BoardingSuccessScreen(trip: trip, passenger: trip.passengers.first),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.text('VÉ HÀNH KHÁCH')).width, greaterThan(60));
    // Tấm vé cao cố định: tên bến dài không được đè xuống nửa dưới (ô Ghế, mã
    // vé). `.last` = dòng điểm đón / trả nằm dưới tên bến cùng chữ.
    final lowerTop = tester.getRect(find.text('Ghế')).top;
    expect(tester.getRect(find.text(_origin).last).bottom, lessThan(lowerTop));
    expect(
      tester.getRect(find.text(_destination).last).bottom,
      lessThan(lowerTop),
    );
  });

  testWidgets('Màn Kiểm tra vé không tràn với tên tuyến dài', (tester) async {
    await _pumpNarrow(
      tester,
      TicketResultScreen(
        trip: _trip(),
        code: 'VXNFFSBHX-01',
        kind: TicketResultKind.alreadyBoarded,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.text('KIỂM TRA VÉ')).width, greaterThan(60));
  });
}
