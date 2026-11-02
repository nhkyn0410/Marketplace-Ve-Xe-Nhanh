import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';
import 'package:passenger_mobile/main.dart';

/// Máy thật nhỏ hơn thì dock vẫn nằm trong màn hình; dùng cùng cỡ với các test khác.
Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 915);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PassengerApp());
  // Đọc token + chuyển màn; không dùng pumpAndSettle vì màn đăng nhập có splash lặp.
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _pumpFor(WidgetTester tester, Duration duration) async {
  final frames = duration.inMilliseconds ~/ 100;
  for (var frame = 0; frame < frames; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

const _homeSearch = Key('origin-input');

void main() {
  testWidgets('còn refresh token: mở lại app vào thẳng Trang chủ', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({
      'access_token': 'access',
      'refresh_token': 'refresh',
    });

    await _pumpApp(tester);

    expect(find.byKey(_homeSearch), findsOneWidget);
    expect(find.byType(AuthEntryScreen), findsNothing);
  });

  testWidgets('không có token: vẫn ở màn đăng nhập', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});

    await _pumpApp(tester);

    expect(find.byType(AuthEntryScreen), findsOneWidget);
    expect(find.byKey(_homeSearch), findsNothing);
  });

  testWidgets('Back ở tab khác về Trang chủ thay vì thoát app', (tester) async {
    FlutterSecureStorage.setMockInitialValues({
      'access_token': 'access',
      'refresh_token': 'refresh',
    });
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('route-dock-tab-1')));
    await _pumpFor(tester, const Duration(seconds: 1));
    expect(find.byKey(_homeSearch), findsNothing);

    final handled = await tester.binding.handlePopRoute();
    await _pumpFor(tester, const Duration(seconds: 1));

    expect(handled, isTrue);
    expect(find.byKey(_homeSearch), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Back ở tab Hành trình cũng về Trang chủ', (tester) async {
    FlutterSecureStorage.setMockInitialValues({
      'access_token': 'access',
      'refresh_token': 'refresh',
    });
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('route-dock-tab-3')));
    await _pumpFor(tester, const Duration(seconds: 1));
    expect(find.byKey(_homeSearch), findsNothing);

    await tester.binding.handlePopRoute();
    await _pumpFor(tester, const Duration(seconds: 1));
    expect(find.byKey(_homeSearch), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
