import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';
import 'package:passenger_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
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

  testWidgets('màn đăng nhập mở ở bước nhập email', (tester) async {
    await tester.pumpWidget(const PassengerApp());

    expect(find.text('Đang chuẩn bị chuyến đi của bạn…'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Tiếp tục'), findsOneWidget);
    expect(find.byKey(const Key('email-field')), findsOneWidget);

    // OTP chỉ xuất hiện sau khi request API thành công.
    expect(find.text('Mã OTP (6 chữ số)'), findsNothing);
  });

  testWidgets('kiểm tra email trước khi gọi API', (tester) async {
    var apiCalls = 0;
    await tester.pumpWidget(
      _reducedMotionApp(
        AuthEntryScreen(
          onRequestOtp: (_) async {
            apiCalls++;
          },
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('email-field')),
      'email-khong-hop-le',
    );
    await tester.tap(find.byKey(const Key('continue-button')));
    await tester.pump();

    expect(apiCalls, 0);
    expect(
      find.text('Vui lòng nhập một địa chỉ email hợp lệ.'),
      findsOneWidget,
    );
  });

  testWidgets('OAuth chưa tích hợp không điều hướng giả', (tester) async {
    await tester.pumpWidget(
      _reducedMotionApp(AuthEntryScreen(onRequestOtp: (_) async {})),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('oauth-google')));
    await tester.pump();

    expect(
      find.text('Đăng nhập Google chưa được tích hợp trong giai đoạn này.'),
      findsOneWidget,
    );
    expect(find.byType(AuthEntryScreen), findsOneWidget);
  });

  testWidgets('reduced motion chuyển thẳng đến trạng thái hoàn chỉnh', (
    tester,
  ) async {
    await tester.pumpWidget(
      _reducedMotionApp(AuthEntryScreen(onRequestOtp: (_) async {})),
    );
    await tester.pump();

    expect(find.byType(AuthMotionNode), findsNWidgets(35));
    expect(_node(tester, '1259:260').opacity, 0);
    expect(_node(tester, '1256:214').x, 0);
    expect(_node(tester, '1257:253').opacity, 1);
  });

  testWidgets('dùng đúng Be Vietnam Pro 400, 500 và 600', (tester) async {
    await tester.pumpWidget(
      _reducedMotionApp(AuthEntryScreen(onRequestOtp: (_) async {})),
    );
    await tester.pump();

    final heading = tester.widget<Text>(find.text('Đăng nhập'));
    final subtitle = tester.widget<Text>(
      find.text('Nhập email để nhận mã xác minh'),
    );
    final emailLabel = tester.widget<Text>(find.text('Email'));

    expect(heading.style?.fontFamily, 'Be Vietnam Pro');
    expect(heading.style?.fontWeight, FontWeight.w600);
    expect(subtitle.style?.fontFamily, 'Be Vietnam Pro');
    expect(subtitle.style?.fontWeight, FontWeight.w400);
    expect(emailLabel.style?.fontFamily, 'Be Vietnam Pro');
    expect(emailLabel.style?.fontWeight, FontWeight.w500);
  });

  testWidgets('shadow sóng dùng alpha-mask Flutter và giữ nguyên motion node', (
    tester,
  ) async {
    await tester.pumpWidget(
      _reducedMotionApp(AuthEntryScreen(onRequestOtp: (_) async {})),
    );
    await tester.pump();

    expect(find.byKey(const Key('wave-form-shadow')), findsOneWidget);
    expect(find.byKey(const Key('wave-form-shape')), findsOneWidget);
    expect(find.byType(AuthMotionNode), findsNWidgets(35));
    expect(tester.takeException(), isNull);
  });

  testWidgets('timeline dùng đúng 35 node tại các mốc yêu cầu', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthEntryScreen(
          precacheMotionAssets: false,
          onRequestOtp: (_) async {},
        ),
      ),
    );

    // 0 ms
    expect(find.byType(AuthMotionNode), findsNWidgets(35));
    expect(_node(tester, '1259:260').opacity, 1);
    expect(_node(tester, '1256:214').x, -330);

    // 500 ms
    await tester.pump(const Duration(milliseconds: 500));
    expect(_node(tester, '1255:219').opacity, 0);
    expect(_node(tester, '1255:219').y, 36);
    expect(_node(tester, '1259:260').opacity, inExclusiveRange(0, 1));

    // 1.000 ms
    await tester.pump(const Duration(milliseconds: 500));
    expect(_node(tester, '1255:215').opacity, closeTo(1, 0.0001));
    expect(_node(tester, '1259:261').scale, closeTo(0.489, 0.0001));

    // 1.500 ms
    await tester.pump(const Duration(milliseconds: 500));
    expect(_node(tester, '1255:215').y, closeTo(0, 0.0001));
    expect(_node(tester, '1255:231').scale, closeTo(1, 0.0001));

    // 2.000 ms
    await tester.pump(const Duration(milliseconds: 500));
    expect(_node(tester, '1257:221').opacity, closeTo(1, 0.0001));
    expect(_node(tester, '1256:221').rotationRadians, greaterThan(0));

    // 3.000 ms
    await tester.pump(const Duration(milliseconds: 1000));
    expect(_node(tester, '1259:240').x, inExclusiveRange(0, 500));
    expect(_node(tester, '1257:253').opacity, closeTo(1, 0.0001));

    // 4.000 ms
    await tester.pump(const Duration(milliseconds: 1000));
    expect(_node(tester, '1259:260').opacity, 0);
    expect(_node(tester, '1256:214').x, 0);
    expect(_node(tester, '1256:237').rotationRadians, 0);
    expect(_node(tester, '1257:253').opacity, 1);
  });

  for (final size in const [
    Size(320, 568),
    Size(360, 640),
    Size(360, 800),
    Size(412, 915),
    Size(480, 1000),
  ]) {
    testWidgets('không tràn layout ở ${size.width} × ${size.height}', (
      tester,
    ) async {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
      view.physicalSize = size;
      view.devicePixelRatio = 1;

      await tester.pumpWidget(
        _reducedMotionApp(AuthEntryScreen(onRequestOtp: (_) async {})),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('continue-button')), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const Key('auth-responsive-viewport'))).width,
        size.width,
      );
    });
  }

  testWidgets('tôn trọng vùng an toàn của màn hình có camera đục lỗ', (
    tester,
  ) async {
    await tester.pumpWidget(
      _reducedMotionApp(
        AuthEntryScreen(onRequestOtp: (_) async {}),
        padding: const EdgeInsets.only(top: 80, bottom: 24),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.byKey(const Key('motion-1259:253'))).dy,
      greaterThanOrEqualTo(92),
    );
  });

  testWidgets('form cuộn lên và không bị bàn phím che', (tester) async {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(360, 640);
    view.devicePixelRatio = 1;

    await tester.pumpWidget(
      _reducedMotionApp(
        AuthEntryScreen(onRequestOtp: (_) async {}),
        padding: const EdgeInsets.only(top: 48, bottom: 24),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('email-field')));
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getBottomRight(find.byKey(const Key('email-field'))).dy,
      lessThanOrEqualTo(340),
    );
  });
}

AuthMotionNode _node(WidgetTester tester, String nodeId) {
  return tester.widget<AuthMotionNode>(
    find.byWidgetPredicate(
      (widget) => widget is AuthMotionNode && widget.nodeId == nodeId,
    ),
  );
}

Widget _reducedMotionApp(Widget home, {EdgeInsets padding = EdgeInsets.zero}) {
  return MaterialApp(
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: true, padding: padding),
        child: child!,
      );
    },
    home: home,
  );
}
