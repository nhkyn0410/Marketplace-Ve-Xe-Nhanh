import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_lookup_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  required double width,
  double height = 956,
  double textScale = 1,
  VoidCallback? onLoginRequested,
  GuestTicketLookupCallback? onRequestOtp,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7EAD)),
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: GuestTicketLookupScreen(
        onLoginRequested: onLoginRequested ?? () {},
        onTabSelected: (_) {},
        onRequestOtp: onRequestOtp,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('hiển thị đúng nội dung tra cứu khách vãng lai từ Figma', (
    tester,
  ) async {
    await _pumpScreen(tester, width: 412);

    expect(find.text('Tra cứu hành trình'), findsOneWidget);
    expect(find.text('Tra cứu vé khách vãng lai'), findsOneWidget);
    // Như bản web: chỉ cần email liên hệ, không có ô mã đặt vé.
    expect(find.text('Mã đặt vé'), findsNothing);
    expect(find.byKey(const Key('guest-booking-code-field')), findsNothing);
    expect(find.text('Email liên hệ'), findsOneWidget);
    final helper = find.text('Mã OTP được gửi đến email liên hệ để xác minh');
    expect(helper, findsOneWidget);
    // Câu ghi chú nằm trên một dòng (font test rộng hơn font thật nên không kiểm chữ có bị cắt).
    final line = tester.renderObject<RenderParagraph>(helper);
    expect(line.size.height, lessThan(2 * 17));
    expect(find.text('Nhận mã OTP'), findsOneWidget);
    expect(find.text('Cần hỗ trợ?'), findsOneWidget);
    expect(find.byKey(const Key('route-dock-tabbar')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('form kiểm tra email trước khi nhận OTP', (tester) async {
    await _pumpScreen(tester, width: 390);

    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pump();
    expect(find.text('Vui lòng nhập email liên hệ.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      'email-khong-hop-le',
    );
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pump();
    expect(find.text('Email liên hệ chưa đúng định dạng.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gửi đúng email sau khi form hợp lệ', (tester) async {
    String? email;
    await _pumpScreen(
      tester,
      width: 390,
      onRequestOtp: (contactEmail) async => email = contactEmail,
    );

    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      '  guest@example.com  ',
    );
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pumpAndSettle();

    expect(email, 'guest@example.com');
    expect(tester.takeException(), isNull);
  });

  testWidgets('màn hình thấp và chữ lớn vẫn cuộn, không bottom overflow', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 375, 390, 412, 430]) {
      await _pumpScreen(tester, width: width, height: 568, textScale: 1.5);
      await tester.drag(
        find.byKey(const Key('guest-ticket-lookup-scroll')),
        const Offset(0, -700),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cần hỗ trợ?'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets('nút đăng nhập trả về luồng xác thực', (tester) async {
    var requested = false;
    await _pumpScreen(
      tester,
      width: 412,
      onLoginRequested: () => requested = true,
    );

    await tester.tap(find.byKey(const Key('guest-journey-login-button')));
    expect(requested, isTrue);
  });
}
