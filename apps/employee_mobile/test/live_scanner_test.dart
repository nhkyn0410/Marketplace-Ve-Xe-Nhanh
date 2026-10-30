import 'dart:async';

import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/employee_api.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

DemoTrip liveTrip() => DemoTrip(
  id: 'REAL-01',
  serverId: 'server-trip-id',
  origin: 'Hà Nội',
  destination: 'Huế',
  departure: '10:00',
  operatingNote: '',
  serviceDate: DateTime(2026, 10, 31),
  passengers: [DemoPassenger('Khách thật', 'B1', 'VXNTEST-01', '0***')],
  seats: ['B1'],
);

Future<StreamController<String>> open(
  WidgetTester tester,
  DemoTrip trip,
) async {
  final source = StreamController<String>.broadcast();
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await source.close();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      theme: employeeTheme(Brightness.light),
      home: ScannerScreen(trip: trip, scanResults: source.stream),
    ),
  );
  await tester.pumpAndSettle();
  return source;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });

  testWidgets(
    'Live scan preserves token case, locks repeated frames and waits for server',
    (tester) async {
      final trip = liveTrip();
      final pending = Completer<DemoPassenger>();
      var calls = 0;
      String? received;
      trip.checkInTicket = (code) {
        calls++;
        received = code;
        return pending.future;
      };
      final source = await open(tester, trip);
      source.add('AbCd_token');
      source.add('AbCd_token');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(calls, 1);
      expect(received, 'AbCd_token');
      expect(trip.boardedCount, 0);
      expect(find.byType(BoardingSuccessScreen), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final passenger = trip.passengers.first..boarded = true;
      pending.complete(passenger);
      await tester.pumpAndSettle();
      expect(find.byType(BoardingSuccessScreen), findsOneWidget);
      expect(find.text('Chuyến REAL-01 · 31/10/2026'), findsOneWidget);
    },
  );

  for (final entry in {
    'TICKET_NOT_FOUND': 'Không tìm thấy vé',
    'WRONG_TRIP': 'Vé thuộc chuyến khác',
    'CANCELLED': 'Vé đã hủy',
    'REFUNDED': 'Vé đã hoàn tiền',
    'ALREADY_CHECKED_IN': 'Vé đã lên xe trước đó',
    'USED': 'Không thể xác nhận lên xe',
  }.entries) {
    testWidgets('Live ${entry.key} never boards passenger or exposes raw QR', (
      tester,
    ) async {
      final trip = liveTrip();
      trip.checkInTicket = (_) async =>
          throw EmployeeTicketException(entry.key);
      final source = await open(tester, trip);
      source.add('PrivateRawQrToken');
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
      expect(find.text('PrivateRawQrToken'), findsNothing);
      expect(trip.boardedCount, 0);
      expect(find.byType(BoardingSuccessScreen), findsNothing);
    });
  }

  testWidgets('Network failure never displays boarding success', (
    tester,
  ) async {
    final trip = liveTrip();
    trip.checkInTicket = (_) async => throw const EmployeeApiException(
      'NETWORK_ERROR',
      'Không kết nối được máy chủ.',
    );
    final source = await open(tester, trip);
    source.add('Token');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Chưa xác nhận lên xe'), findsOneWidget);
    expect(trip.boardedCount, 0);
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();
    expect(find.byType(ScannerScreen), findsOneWidget);
  });
}
