import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/payment_screen.dart';

import 'support/fake_booking_api.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  double width = 412,
  double height = 900,
  DateTime Function()? now,
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
      home: PaymentScreen(booking: sampleBooking(), now: now),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets(
    'hiện đơn thật: mã đơn, hành khách, giảm giá, tổng; nút thanh toán khóa',
    (tester) async {
      await _pumpScreen(tester);
      expect(find.byKey(const Key('payment-booking-code')), findsOneWidget);
      expect(find.text('Trần Thị Bình'), findsOneWidget);
      expect(find.text('-50.000 ₫'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('payment-order-total'))).data,
        '550.000 ₫',
      );
      expect(find.byKey(const Key('payment-pending-notice')), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('payment-submit')))
            .onPressed,
        isNull,
      );
      expect(find.textContaining('VNPay'), findsNothing);
      expect(find.textContaining('MoMo'), findsNothing);
    },
  );

  testWidgets('quá hạn thanh toán thì báo đơn đã hết hạn', (tester) async {
    await _pumpScreen(
      tester,
      now: () => DateTime.now().add(const Duration(minutes: 9)),
    );
    expect(find.text('Đã hết hạn'), findsOneWidget);
    expect(find.textContaining('đã quá hạn thanh toán'), findsOneWidget);
  });

  testWidgets('viewport 320x568 không bottom overflow', (tester) async {
    await _pumpScreen(tester, width: 320, height: 568);
    await tester.drag(
      find.byKey(const Key('payment-scroll')),
      const Offset(0, -600),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
