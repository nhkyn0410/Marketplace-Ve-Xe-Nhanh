import 'dart:async';

import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _open(
  WidgetTester tester,
  Widget screen, {
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: employeeTheme(Brightness.light),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: screen,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _swipe(WidgetTester tester, String label) async {
  await tester.drag(
    find.byKey(ValueKey('swipe-$label')),
    const Offset(1000, 0),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });

  testWidgets(
    'Seat map separates booked, boarded and empty seats at narrow width',
    (tester) async {
      final trip = createDemoTrips().last;
      final passenger = trip.passengers.first..boarded = true;
      await _open(
        tester,
        SeatMapScreen(
          trip: trip,
          lastPassenger: passenger,
          scanResults: const Stream.empty(),
        ),
        textScale: 1.4,
      );
      expect(find.text('1 / 28 đã lên xe'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('seat-A01')),
          matching: find.text('Đã lên'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('seat-A02')),
          matching: find.text('Chưa lên'),
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byKey(const ValueKey('seat-H01')));
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('seat-H01')),
          matching: find.text('Trống'),
        ),
        findsOneWidget,
      );
      expect(
        trip.seats
            .where((code) => !trip.passengers.any((p) => p.seat == code))
            .length,
        8,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Offline scanner ignores QR until retry and then updates the selected trip',
    (tester) async {
      final trip = createDemoTrips().last;
      final scans = StreamController<String>.broadcast();
      addTearDown(scans.close);
      await _open(
        tester,
        ScannerScreen(
          trip: trip,
          initiallyOffline: true,
          scanResults: scans.stream,
        ),
      );
      scans.add('VX103001');
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 0);
      expect(find.text('Mất kết nối'), findsOneWidget);
      await _swipe(tester, 'Thử lại');
      scans.add('VX103001');
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 1);
      expect(find.text('VX103001'), findsOneWidget);
      await _swipe(tester, 'Xem sơ đồ ghế');
      expect(find.text('1 / 28 đã lên xe'), findsOneWidget);
      await _swipe(tester, 'Quét vé tiếp');
      scans.add('VX103002');
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 2);
      await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      expect(find.text('2 / 28 đã lên xe'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Scanner and seat map reject a trip outside assignment', (
    tester,
  ) async {
    final trip = createDemoTrips().first..assigned = false;
    final scans = StreamController<String>.broadcast();
    addTearDown(scans.close);
    await _open(tester, ScannerScreen(trip: trip, scanResults: scans.stream));
    scans.add('VX102001');
    await tester.pumpAndSettle();
    expect(trip.boardedCount, 0);
    expect(find.text('Chưa được phân công'), findsOneWidget);
    await _open(tester, SeatMapScreen(trip: trip, scanResults: scans.stream));
    expect(find.text('Sơ đồ ghế'), findsNothing);
    expect(find.byKey(const ValueKey('seat-A01')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Empty manifest leaves all physical seats empty and progress finite',
    (tester) async {
      final trip = createDemoTrips().first..passengers.clear();
      await _open(
        tester,
        SeatMapScreen(trip: trip, scanResults: const Stream.empty()),
      );
      expect(find.text('0 / 0 đã lên xe'), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('seat-A01')),
          matching: find.text('Trống'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
