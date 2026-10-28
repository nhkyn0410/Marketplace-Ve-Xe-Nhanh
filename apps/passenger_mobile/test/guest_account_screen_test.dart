import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/guest_account_screen.dart';

void main() {
  Future<({List<int> tabs, List<String> calls})> pump(
    WidgetTester tester, {
    bool hotlineOpens = true,
    VoidCallback? onLogin,
  }) async {
    final tabs = <int>[];
    final calls = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: GuestAccountScreen(
          onLoginRequested: onLogin ?? () {},
          onTabSelected: tabs.add,
          onCallHotline: (hotline) async {
            calls.add(hotline);
            return hotlineOpens;
          },
        ),
      ),
    );
    await tester.pump();
    // Cuộn hết danh sách: mục cuối nằm trên thanh tab nổi (giống người dùng thật).
    await tester.drag(
      find.byKey(const Key('guest-account-scroll')),
      const Offset(0, -800),
    );
    await tester.pump();
    return (tabs: tabs, calls: calls);
  }

  testWidgets('nút đăng nhập mới mở màn đăng nhập', (tester) async {
    var loginRequested = false;
    await pump(tester, onLogin: () => loginRequested = true);
    expect(find.text('Bạn chưa đăng nhập'), findsOneWidget);
    expect(loginRequested, isFalse);

    await tester.tap(find.byKey(const Key('guest-account-login')));
    expect(loginRequested, isTrue);
  });

  testWidgets('tra cứu vé sang tab Hành trình, gọi tổng đài lỗi thì báo', (
    tester,
  ) async {
    final result = await pump(tester, hotlineOpens: false);

    await tester.tap(find.byKey(const Key('guest-account-lookup')));
    expect(result.tabs, [3]);

    await tester.tap(find.byKey(const Key('guest-account-hotline')));
    await tester.pump();
    expect(result.calls, ['1900 636 707']);
    expect(
      find.text('Không thể mở ứng dụng gọi điện trên thiết bị này.'),
      findsOneWidget,
    );
  });

  testWidgets('chữ lớn không tràn', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 780),
          textScaler: TextScaler.linear(1.6),
        ),
        child: MaterialApp(
          home: GuestAccountScreen(
            onLoginRequested: () {},
            onTabSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
