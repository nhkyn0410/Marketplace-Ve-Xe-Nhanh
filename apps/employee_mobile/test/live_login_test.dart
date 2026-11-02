import 'dart:async';

import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/employee_api.dart';
import 'package:employee_mobile/login_screen.dart';
import 'package:employee_mobile/trip_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _submit(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).first, 'nhaxe/taixe');
  await tester.enterText(find.byType(TextFormField).last, 'secret');
  final handle = find.byKey(const ValueKey('swipe-Đăng nhập'));
  await tester.ensureVisible(handle);
  await tester.drag(handle, const Offset(1000, 0));
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });

  testWidgets('Real login waits for server success without opening demo', (
    tester,
  ) async {
    final response = Completer<void>();
    String? submitted;
    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: employeeTheme(Brightness.light),
        home: LoginScreen(
          onPreview: (_, username) => completed = true,
          onLogin: (username, password) {
            submitted = username;
            expect(password, 'secret');
            return response.future;
          },
        ),
      ),
    );
    await _submit(tester);
    expect(submitted, 'nhaxe/taixe');
    expect(completed, isFalse);
    expect(find.text('Xem thử giao diện'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    response.complete();
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });

  testWidgets('Rejected server login stays on form and never opens demo', (
    tester,
  ) async {
    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: employeeTheme(Brightness.light),
        home: LoginScreen(
          onPreview: (_, username) => completed = true,
          onLogin: (_, password) async {
            throw EmployeeApiException('AUTH_INVALID_CREDENTIALS', 'Rejected');
          },
        ),
      ),
    );
    await _submit(tester);
    await tester.pumpAndSettle();
    expect(completed, isFalse);
    expect(
      find.text('Tên đăng nhập hoặc mật khẩu không đúng.'),
      findsOneWidget,
    );
    expect(find.text('Mở bản xem thử'), findsNothing);
  });

  testWidgets(
    'Live assignments request selected day and never show sample trips',
    (tester) async {
      final requested = <DateTime>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: employeeTheme(Brightness.light),
          home: DriverPage(
            child: TripsScreen(
              trips: createDemoTrips(),
              onTabSelected: (_) {},
              loadTrips: (day) async {
                requested.add(day);
                return [];
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(requested, hasLength(1));
      expect(find.text('MX102'), findsNothing);
      expect(find.text('Về ngày có chuyến mẫu'), findsNothing);
      await tester.tap(find.byTooltip('Ngày sau'));
      await tester.pumpAndSettle();
      expect(requested, hasLength(2));
      expect(requested.last.difference(requested.first).inDays, 1);
    },
  );
}
