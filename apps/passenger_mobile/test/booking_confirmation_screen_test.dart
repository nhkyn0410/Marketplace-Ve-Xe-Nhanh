import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/booking_confirmation_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  double width = 412,
  double height = 900,
  required DateTime now,
  DateTime Function()? nowProvider,
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E8ABE)),
      ),
      home: BookingConfirmationScreen(
        selectedSeats: const ['A01', 'A02'],
        passengerNames: const ['Nguyễn Văn Minh', 'Trần Thị Lan'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: nowProvider ?? () => now,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('hiển thị đủ snapshot booking tĩnh theo Figma', (tester) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now);

    expect(
      find.byKey(const Key('booking-confirmation-screen')),
      findsOneWidget,
    );
    expect(find.text('Xác nhận booking'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Phương Trang'), findsOneWidget);
    expect(find.text('Nguyễn Văn Minh'), findsOneWidget);
    expect(find.text('Trần Thị Lan'), findsOneWidget);
    expect(find.text('Bến xe Miền Đông'), findsWidgets);
    expect(find.text('Bến xe Đà Lạt'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('VXN50K'),
      250,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('booking-confirmation-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('VXN50K'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Tiền vé (2 ghế x 280.000 đ)'),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('booking-confirmation-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Tiền vé (2 ghế x 280.000 đ)'), findsOneWidget);
    expect(find.text('530.000 đ'), findsNWidgets(2));
    expect(find.byKey(const Key('booking-continue-payment')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bỏ điều khoản sẽ khóa nút tiếp tục thanh toán', (tester) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now);

    await tester.scrollUntilVisible(
      find.byKey(const Key('booking-terms-checkbox')),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.byKey(const Key('booking-terms-checkbox')));
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('booking-continue-payment')),
    );
    expect(button.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tiếp tục mở màn thanh toán với cùng hạn giữ ghế', (
    tester,
  ) async {
    var now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now, nowProvider: () => now);

    now = now.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('booking-continue-payment')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('payment-screen')), findsOneWidget);
    expect(find.text('09:30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('viewport 320x568 cuộn được và không bottom overflow', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, width: 320, height: 568, now: now);

    await tester.drag(
      find.byKey(const Key('booking-confirmation-scroll')),
      const Offset(0, -1200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết thanh toán'), findsOneWidget);
    expect(find.text('Tổng thanh toán'), findsWidgets);
    expect(find.byKey(const Key('booking-continue-payment')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
