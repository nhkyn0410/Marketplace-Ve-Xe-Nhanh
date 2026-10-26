import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:employee_mobile/trip_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _openManifest(WidgetTester tester, DemoTrip trip) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: employeeTheme(Brightness.light),
      home: PassengerScreen(trip: trip, onTabSelected: (_) {}),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });

  testWidgets(
    'Search trims input and respects boarding filter after check-in',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final trip = createDemoTrips().first;
      await _openManifest(tester, trip);
      await tester.enterText(find.byType(TextField), '  vx102002  ');
      await tester.pumpAndSettle();
      expect(find.text('Trần Thị Mai'), findsOneWidget);
      expect(find.text('Nguyễn Văn An'), findsNothing);
      await tester.tap(find.text('Chưa lên · 32'));
      await tester.pumpAndSettle();
      await tester.fling(find.text('Trần Thị Mai'), const Offset(200, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.byType(TicketScreen), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(const ValueKey('swipe-Xác nhận lên xe')),
      );
      await tester.drag(
        find.byKey(const ValueKey('swipe-Xác nhận lên xe')),
        const Offset(1000, 0),
      );
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 1);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy hành khách'), findsOneWidget);
      await tester.tap(find.byTooltip('Xóa tìm kiếm'));
      await tester.pumpAndSettle();
      expect(find.text('Chưa lên · 31'), findsOneWidget);
      expect(find.text('Đã lên · 1'), findsOneWidget);
      expect(find.text('Nguyễn Văn An'), findsOneWidget);
      expect(find.text('Trần Thị Mai'), findsNothing);
      await tester.tap(find.text('Đã lên · 1'));
      await tester.pumpAndSettle();
      expect(find.text('Trần Thị Mai'), findsOneWidget);
      expect(find.text('Nguyễn Văn An'), findsNothing);
    },
  );

  testWidgets(
    'Manifest scrolls all passengers and refreshes without losing search',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _openManifest(tester, createDemoTrips().first);
      final list = find.byKey(const ValueKey('manifest-passengers'));
      await tester.scrollUntilVisible(
        find.text('Khách mẫu 32'),
        250,
        scrollable: find.descendant(
          of: list,
          matching: find.byType(Scrollable),
        ),
      );
      expect(find.text('Khách mẫu 32'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'VX102001');
      await tester.pumpAndSettle();
      await tester.fling(list, const Offset(0, 300), 1200);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Bản mẫu · ↓ Kéo để cập nhật'),
        findsOneWidget,
      );
      expect(find.text('Nguyễn Văn An'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'VX102001',
      );
    },
  );

  testWidgets(
    'Narrow manifest handles keyboard and opens trip stops and scanner',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await _openManifest(tester, createDemoTrips().last);
      await tester.tap(find.text('Xem →'));
      await tester.pumpAndSettle();
      expect(find.text('Điểm đón / trả · MX103'), findsOneWidget);
      expect(find.text('Đón · Bến xe Đà Lạt'), findsWidgets);
      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Mai');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      tester.view.resetViewInsets();
      await tester.tap(find.byTooltip('Xóa tìm kiếm'));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(const ValueKey('swipe-Quét vé')),
        const Offset(1000, 0),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ScannerScreen), findsOneWidget);
      expect(find.text('Bản xem thử · Camera chưa bật'), findsOneWidget);
    },
  );
}
