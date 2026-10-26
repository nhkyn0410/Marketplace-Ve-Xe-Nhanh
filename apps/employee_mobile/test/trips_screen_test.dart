import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/driver_app.dart';
import 'package:employee_mobile/operation_screens.dart';
import 'package:employee_mobile/trip_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _swipe(
  WidgetTester tester,
  String label, {
  bool last = false,
}) async {
  final handles = find.byKey(ValueKey('swipe-$label'));
  final handle = last ? handles.last : handles.first;
  await tester.ensureVisible(handle);
  await tester.drag(handle, const Offset(1000, 0));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });

  testWidgets(
    'No assignments on sample day shows empty state without a misleading reset',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: employeeTheme(Brightness.light),
          home: DriverPage(
            child: TripsScreen(trips: const [], onTabSelected: (_) {}),
          ),
        ),
      );
      expect(find.text('Chưa có chuyến'), findsOneWidget);
      expect(
        find.text('Chuyến được phân công sẽ hiện tại đây.'),
        findsOneWidget,
      );
      expect(find.text('Về ngày có chuyến mẫu'), findsNothing);
      expect(find.text('Xem chuyến'), findsNothing);
    },
  );

  testWidgets(
    'Selected day survives tab navigation and second trip opens its own details',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const EmployeeApp());
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'mayexpress/nv.minh',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'demo-only');
      await _swipe(tester, 'Đăng nhập');
      await tester.tap(find.text('Mở bản xem thử'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Ngày sau'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cá nhân').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chuyến').last);
      await tester.pumpAndSettle();
      expect(find.text('15/10/2026'), findsOneWidget);
      expect(find.text('Chưa có chuyến'), findsOneWidget);
      await tester.tap(find.text('Về ngày có chuyến mẫu'));
      await tester.pumpAndSettle();
      await _swipe(tester, 'Xem chuyến', last: true);
      expect(find.text('MX103'), findsOneWidget);
      expect(find.text('28 hành khách'), findsOneWidget);
      expect(find.text('14/10/2026 · 17:30'), findsOneWidget);
      expect(find.text('Có mặt tại bến trước 17:00.'), findsOneWidget);
    },
  );

  testWidgets('Assigned trips remain readable on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: employeeTheme(Brightness.light),
        home: DriverPage(
          child: TripsScreen(trips: createDemoTrips(), onTabSelected: (_) {}),
        ),
      ),
    );
    await _swipe(tester, 'Xem chuyến');
    expect(find.text('MX102'), findsOneWidget);
    expect(find.text('32 hành khách'), findsOneWidget);
  });

  testWidgets(
    'Boarding requires a full swipe and keeps status after returning',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final trip = createDemoTrips().first;
      await tester.pumpWidget(
        MaterialApp(
          theme: employeeTheme(Brightness.light),
          home: TripDetailScreen(trip: trip, onTabSelected: (_) {}),
        ),
      );
      await tester.tap(find.text('Bắt đầu đón khách'));
      await tester.drag(
        find.byKey(const ValueKey('swipe-Bắt đầu đón khách')),
        const Offset(35, 0),
      );
      await tester.pumpAndSettle();
      expect(trip.status, 'Sắp khởi hành');
      expect(find.byType(OperationsScreen), findsNothing);
      await _swipe(tester, 'Bắt đầu đón khách');
      expect(trip.status, 'Đón khách');
      expect(trip.operationHistory.single.title, 'Đón khách');
      expect(find.byType(OperationsScreen), findsOneWidget);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.text('Đón khách'), findsOneWidget);
      expect(find.text('Mở Vận hành'), findsOneWidget);
      await _swipe(tester, 'Mở Vận hành');
      expect(trip.status, 'Đón khách');
      expect(trip.operationHistory.length, 1);
    },
  );

  testWidgets('Returning from passenger list refreshes the unboarded count', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final trip = createDemoTrips().first;
    await tester.pumpWidget(
      MaterialApp(
        theme: employeeTheme(Brightness.light),
        home: TripDetailScreen(trip: trip, onTabSelected: (_) {}),
      ),
    );
    expect(find.text('Chưa lên: 32'), findsOneWidget);
    await _swipe(tester, 'Danh sách khách');
    expect(find.byType(PassengerScreen), findsOneWidget);
    trip.passengers.first.boarded = true;
    await tester.tap(find.byTooltip('Quay lại'));
    await tester.pumpAndSettle();
    expect(find.text('32 hành khách'), findsOneWidget);
    expect(find.text('Chưa lên: 31'), findsOneWidget);
  });
}
