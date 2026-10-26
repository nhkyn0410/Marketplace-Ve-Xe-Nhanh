import 'dart:async';

import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/driver_app.dart';
import 'package:employee_mobile/operation_screens.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> swipe(WidgetTester tester, String label) async {
  final handle = find.byKey(ValueKey('swipe-$label')).first;
  await tester.ensureVisible(handle);
  await tester.drag(handle, const Offset(1000, 0));
  await tester.pumpAndSettle();
}

Future<void> enterPreview(WidgetTester tester) async {
  await tester.pumpWidget(const EmployeeApp());
  await tester.enterText(
    find.byType(TextFormField).at(0),
    'mayexpress/nv.minh',
  );
  await tester.enterText(find.byType(TextFormField).at(1), 'demo-only');
  await swipe(tester, 'Đăng nhập');
  await tester.tap(find.text('Mở bản xem thử'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await fonts.load();
  });

  testWidgets('Login requires complete swipe and explains the demo session', (
    tester,
  ) async {
    await tester.pumpWidget(const EmployeeApp());
    expect(tester.getSize(find.byType(SwipeAction)).width, 720);
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();
    expect(find.text('Xem thử giao diện'), findsNothing);
    await swipe(tester, 'Đăng nhập');
    expect(find.text('Nhập tên đăng nhập'), findsOneWidget);
    expect(find.text('Nhập mật khẩu'), findsWidgets);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'mayexpress/nv.minh',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'demo-only');
    await tester.drag(
      find.byKey(const ValueKey('swipe-Đăng nhập')),
      const Offset(40, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xem thử giao diện'), findsNothing);
    await swipe(tester, 'Đăng nhập');
    expect(find.text('Xem thử giao diện'), findsOneWidget);
    await tester.tap(find.text('Mở bản xem thử'));
    await tester.pumpAndSettle();
    expect(find.text('Chuyến của tôi'), findsOneWidget);
  });

  testWidgets(
    'Assignment day changes, search and boarded filter stay consistent',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await enterPreview(tester);
      await tester.tap(find.byTooltip('Ngày sau'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có chuyến'), findsOneWidget);
      await tester.tap(find.text('Về ngày có chuyến mẫu'));
      await tester.pumpAndSettle();
      await swipe(tester, 'Xem chuyến');
      expect(find.text('32 hành khách'), findsOneWidget);
      await swipe(tester, 'Danh sách khách');
      await tester.enterText(find.byType(TextField), 'VX102002');
      await tester.pumpAndSettle();
      expect(find.text('Trần Thị Mai'), findsOneWidget);
      expect(find.text('Nguyễn Văn An'), findsNothing);
      await tester.enterText(find.byType(TextField), 'missing');
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy hành khách'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đã lên · 0'));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có hành khách ở trạng thái này.'), findsOneWidget);
    },
  );

  testWidgets(
    'QR scan confirms once, shows seats and resumes without manual entry',
    (tester) async {
      final trip = createDemoTrips().first;
      final scans = StreamController<String>.broadcast();
      addTearDown(scans.close);
      await tester.pumpWidget(
        MaterialApp(
          theme: employeeTheme(Brightness.light),
          home: ScannerScreen(trip: trip, scanResults: scans.stream),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Nhập mã vé'), findsNothing);
      scans.add('VX103001');
      await tester.pumpAndSettle();
      expect(find.text('Vé thuộc chuyến khác'), findsOneWidget);
      expect(trip.boardedCount, 0);
      await swipe(tester, 'Quét vé khác');
      scans.add(' vx102001 ');
      scans.add('VX102001');
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 1);
      final checkedInAt = trip.passengers.first.checkedInAt;
      expect(find.text('Đã lên xe'), findsOneWidget);
      await swipe(tester, 'Xem sơ đồ ghế');
      expect(find.byType(SeatMapScreen), findsOneWidget);
      expect(find.text('1 / 32 đã lên xe'), findsOneWidget);
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
      await tester.ensureVisible(find.byKey(const ValueKey('seat-I04')));
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('seat-I04')),
          matching: find.text('Trống'),
        ),
        findsOneWidget,
      );
      await swipe(tester, 'Quét vé tiếp');
      scans.add('VX102001');
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 1);
      expect(trip.passengers.first.checkedInAt, checkedInAt);
      expect(find.byType(BoardingSuccessScreen), findsOneWidget);
    },
  );

  testWidgets('Profile theme and support screens work on narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await enterPreview(tester);
    await tester.tap(find.text('Cá nhân').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tối'));
    await tester.tap(find.text('Tối'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Tối'))).brightness,
      Brightness.dark,
    );
    await tester.ensureVisible(find.text('Liên hệ nhà xe'));
    await tester.tap(find.text('Liên hệ nhà xe'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Hỗ trợ tài khoản nhân viên')))
          .brightness,
      Brightness.light,
    );
    expect(find.text('Hỗ trợ tài khoản nhân viên'), findsOneWidget);
    await tester.tap(find.byTooltip('Quay lại'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Thiết bị đăng nhập'));
    await tester.tap(find.text('Thiết bị đăng nhập'));
    await tester.pumpAndSettle();
  });

  testWidgets('Operation swipe progresses only local trip state', (
    tester,
  ) async {
    final trip = createDemoTrips().first;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Inter'),
        home: OperationsScreen(trip: trip),
      ),
    );
    final action = tester
        .widgetList<SwipeAction>(find.byType(SwipeAction))
        .first;
    await swipe(tester, action.label);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(trip.status, 'Đón khách');
    expect(find.textContaining('chưa gửi máy chủ.'), findsOneWidget);
  });
}
