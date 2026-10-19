import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late DateTime issuedAt;

  setUp(() {
    now = DateTime.utc(2026, 10, 16, 8);
    issuedAt = now;
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(412, 915);
    view.devicePixelRatio = 1;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  Widget screen({
    Future<bool> Function(String)? onVerify,
    Future<bool> Function()? onResend,
    VoidCallback? onEditEmail,
    VoidCallback? onOtpChanged,
    String? errorMessage,
    bool busy = false,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(padding: padding),
        child: child!,
      ),
      home: EmailVerificationScreen(
        email: 'khach@example.com',
        issuedAt: issuedAt,
        now: () => now,
        busy: busy,
        errorMessage: errorMessage,
        onOtpChanged: onOtpChanged,
        onVerify: onVerify ?? (_) async => false,
        onResend: onResend ?? () async => false,
        onEditEmail: onEditEmail ?? () {},
      ),
    );
  }

  testWidgets('hiển thị đúng cấu trúc Figma và tự focus OTP', (tester) async {
    await tester.pumpWidget(screen());
    await tester.pump();

    expect(find.text('Xác nhận email'), findsOneWidget);
    expect(find.text('MÃ OTP (6 CHỮ SỐ)'), findsOneWidget);
    expect(find.text('Xác minh'), findsOneWidget);
    expect(find.byKey(const Key('otp-expiry')), findsOneWidget);
    expect(_text(tester, const Key('otp-expiry')), '05:00');
    expect(
      _richText(tester, const Key('otp-resend-cooldown')),
      'Gửi lại sau 01:00',
    );
    for (var index = 0; index < 6; index++) {
      expect(find.byKey(Key('otp-box-$index')), findsOneWidget);
    }

    final field = tester.widget<TextField>(find.byKey(const Key('otp-field')));
    expect(field.focusNode?.hasFocus, isTrue);
    expect(field.autofillHints, contains(AutofillHints.oneTimeCode));

    final heading = tester.widget<Text>(find.text('Xác nhận email'));
    expect(heading.style?.fontFamily, 'Be Vietnam Pro');
    expect(heading.style?.fontWeight, FontWeight.w600);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dán 6 số, tự phân ô và Backspace không làm lệch mã', (
    tester,
  ) async {
    var changes = 0;
    await tester.pumpWidget(screen(onOtpChanged: () => changes++));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('otp-field')), '841236');
    await tester.pump();
    expect(_otpDigits(tester), ['8', '4', '1', '2', '3', '6']);

    await tester.enterText(find.byKey(const Key('otp-field')), '84123');
    await tester.pump();
    expect(_otpDigits(tester), ['8', '4', '1', '2', '3', '']);
    expect(changes, 2);
  });

  testWidgets('chỉ verify đủ 6 số và chặn nhấn liên tục', (tester) async {
    final result = Completer<bool>();
    var calls = 0;
    await tester.pumpWidget(
      screen(
        onVerify: (otp) {
          calls++;
          expect(otp, '123456');
          return result.future;
        },
      ),
    );
    await tester.pump();

    await tester.enterText(find.byKey(const Key('otp-field')), '12345');
    await tester.tap(find.byKey(const Key('otp-verify-button')));
    expect(calls, 0);

    await tester.enterText(find.byKey(const Key('otp-field')), '123456');
    await tester.pump();
    await tester.tap(find.byKey(const Key('otp-verify-button')));
    await tester.tap(find.byKey(const Key('otp-verify-button')));
    await tester.pump();

    expect(calls, 1);
    expect(find.byKey(const Key('otp-verify-loading')), findsOneWidget);

    result.complete(false);
    await tester.pump();
    expect(find.byKey(const Key('otp-verify-loading')), findsNothing);
  });

  testWidgets('deadline cập nhật đúng sau khi app background rồi resume', (
    tester,
  ) async {
    await tester.pumpWidget(screen());
    await tester.pump();
    expect(_text(tester, const Key('otp-expiry')), '05:00');

    now = issuedAt.add(const Duration(minutes: 5, seconds: 1));
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    await tester.pump();

    expect(_text(tester, const Key('otp-expiry')), '00:00');
    expect(find.text('Mã đã hết hạn. Hãy gửi lại mã mới.'), findsOneWidget);
  });

  testWidgets('resend lỗi không reset cooldown hoặc thời hạn', (tester) async {
    now = issuedAt.add(const Duration(seconds: 61));
    var calls = 0;
    await tester.pumpWidget(
      screen(
        onResend: () async {
          calls++;
          return false;
        },
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('otp-resend-button')), findsOneWidget);
    expect(_text(tester, const Key('otp-expiry')), '03:59');
    await tester.tap(find.byKey(const Key('otp-resend-button')));
    await tester.pump();

    expect(calls, 1);
    expect(find.byKey(const Key('otp-resend-button')), findsOneWidget);
    expect(_text(tester, const Key('otp-expiry')), '03:59');
  });

  testWidgets('resend thành công tạo deadline và cooldown mới', (tester) async {
    now = issuedAt.add(const Duration(seconds: 61));
    await tester.pumpWidget(screen(onResend: () async => true));
    await tester.pump();

    await tester.tap(find.byKey(const Key('otp-resend-button')));
    await tester.pump();

    expect(_text(tester, const Key('otp-expiry')), '05:00');
    expect(
      _richText(tester, const Key('otp-resend-cooldown')),
      'Gửi lại sau 01:00',
    );
  });

  testWidgets('hiển thị lỗi API và cho quay lại sửa email', (tester) async {
    var edited = false;
    await tester.pumpWidget(
      screen(
        errorMessage: 'Mã OTP không đúng hoặc đã hết hạn.',
        onEditEmail: () => edited = true,
      ),
    );
    await tester.pump();

    expect(find.text('Mã OTP không đúng hoặc đã hết hạn.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('edit-email-button')));
    expect(edited, isTrue);
  });

  for (final size in const [
    Size(320, 568),
    Size(360, 640),
    Size(412, 915),
    Size(480, 1000),
  ]) {
    testWidgets('OTP không tràn layout ở ${size.width} × ${size.height}', (
      tester,
    ) async {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
      view.physicalSize = size;
      view.devicePixelRatio = 1;

      await tester.pumpWidget(
        screen(padding: const EdgeInsets.only(top: 48, bottom: 24)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('otp-verify-button')), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const Key('otp-responsive-viewport'))).width,
        size.width,
      );
    });
  }

  testWidgets('OTP có thể cuộn để không bị bàn phím che', (tester) async {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(360, 640);
    view.devicePixelRatio = 1;

    await tester.pumpWidget(
      screen(padding: const EdgeInsets.only(top: 48, bottom: 24)),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('otp-field')));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getBottomRight(find.byKey(const Key('otp-field'))).dy,
      lessThanOrEqualTo(340),
    );
  });
}

String _text(WidgetTester tester, Key key) {
  return tester.widget<Text>(find.byKey(key)).data!;
}

String _richText(WidgetTester tester, Key key) {
  return tester.widget<Text>(find.byKey(key)).textSpan!.toPlainText();
}

List<String> _otpDigits(WidgetTester tester) {
  return List.generate(6, (index) {
    final text = find.descendant(
      of: find.byKey(Key('otp-box-$index')),
      matching: find.byType(Text),
    );
    return tester.widget<Text>(text).data!;
  });
}
