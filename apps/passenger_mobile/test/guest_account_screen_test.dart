import 'dart:math' as math;

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

  testWidgets('máy thấp, chữ lớn: không cuộn, nội dung gọn trên thanh tab', (
    tester,
  ) async {
    for (final size in const [Size(360, 640), Size(360, 780), Size(384, 823)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: const TextScaler.linear(1.6),
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
      final scroll = find.byKey(const Key('guest-account-scroll'));
      await tester.drag(scroll, const Offset(0, -800));
      await tester.pump();

      expect(
        tester
            .state<ScrollableState>(
              find
                  .descendant(of: scroll, matching: find.byType(Scrollable))
                  .first,
            )
            .position
            .pixels,
        0,
        reason: '$size',
      );
      final hotline = tester.getRect(
        find.byKey(const Key('guest-account-hotline')),
      );
      expect(hotline.bottom, lessThanOrEqualTo(size.height - 120));
      // Thu nhỏ chữ nhưng thẻ vẫn phủ hết bề ngang.
      expect(hotline.width, closeTo(math.min(376, size.width - 36), 1));
      expect(tester.takeException(), isNull, reason: '$size');
    }
  });
}
