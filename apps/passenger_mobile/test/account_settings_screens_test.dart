import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/login_sessions_screen.dart';
import 'package:passenger_mobile/features/account/notification_settings_screen.dart';

Future<void> _pumpScreen(WidgetTester tester, Widget screen) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: screen,
    ),
  );
}

void main() {
  testWidgets('cài đặt thông báo hiển thị đúng nhóm và đổi state cục bộ', (
    tester,
  ) async {
    var wentBack = false;
    await _pumpScreen(
      tester,
      NotificationSettingsScreen(onBack: () => wentBack = true),
    );

    expect(find.text('Thông báo quan trọng'), findsOneWidget);
    expect(find.text('Thông báo tùy chọn'), findsOneWidget);
    expect(find.text('Bảo mật tài khoản'), findsOneWidget);
    expect(find.text('Tin tức và sản phẩm mới'), findsOneWidget);

    final newsSwitch = find.byKey(const Key('notification-switch-news'));
    expect(
      tester.getSemantics(newsSwitch),
      matchesSemantics(
        label: 'Đang tắt',
        isButton: true,
        hasToggledState: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(newsSwitch);
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(newsSwitch),
      matchesSemantics(
        label: 'Đang bật',
        isButton: true,
        hasToggledState: true,
        isToggled: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.byKey(const Key('account-settings-back')));
    expect(wentBack, isTrue);
  });

  testWidgets('phiên đăng nhập mở và hủy floating xác nhận', (tester) async {
    await _pumpScreen(tester, LoginSessionsScreen(onBack: () {}));

    expect(find.byKey(const Key('current-session-card')), findsOneWidget);
    expect(find.text('Hà Nội, Việt Nam'), findsOneWidget);
    expect(find.text('Đà Nẵng, Việt Nam'), findsOneWidget);

    await tester.tap(find.byKey(const Key('logout-session-hanoi')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('logout-confirmation-sheet')), findsOneWidget);
    expect(find.text('Đăng xuất tài khoản?'), findsOneWidget);
    expect(
      find.byKey(const Key('login-sessions-detailed-content')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('cancel-session-logout')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('logout-confirmation-sheet')), findsNothing);
    expect(find.text('Hà Nội, Việt Nam'), findsOneWidget);
    expect(
      find.byKey(const Key('login-sessions-compact-content')),
      findsOneWidget,
    );
  });

  testWidgets('xác nhận đăng xuất cập nhật danh sách phiên cục bộ', (
    tester,
  ) async {
    await _pumpScreen(tester, LoginSessionsScreen(onBack: () {}));

    await tester.tap(find.byKey(const Key('logout-session-hanoi')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-session-logout')));
    await tester.pumpAndSettle();

    expect(find.text('Hà Nội, Việt Nam'), findsNothing);
    expect(find.text('Đà Nẵng, Việt Nam'), findsOneWidget);
  });
}
