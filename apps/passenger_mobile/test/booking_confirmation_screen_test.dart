import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/ticket/booking_confirmation_screen.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';

import 'support/fake_booking_api.dart';

const _draft = BookingDraft(
  contact: BookingContact(
    fullName: 'Lê Văn An',
    phone: '0901234567',
    email: 'an@vidu.com',
  ),
  passengers: [
    BookingPassenger(seatCode: 'A01', fullName: 'Lê Văn An'),
    BookingPassenger(seatCode: 'A03', fullName: 'Trần Thị Bình'),
  ],
  promotion: PromotionQuote(
    code: 'GIAM50',
    name: 'Giảm 50K',
    discount: 50000,
    total: 550000,
  ),
);

Future<void> _pumpScreen(
  WidgetTester tester,
  FakeBookingApi api, {
  double width = 412,
  double height = 900,
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
        api: api,
        trip: api.trip,
        hold: sampleHold(),
        draft: _draft,
      ),
    ),
  );
  await tester.pump();
}

Future<void> _acceptAndSubmit(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(const Key('booking-terms-checkbox')),
    300,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('booking-confirmation-scroll')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.tap(find.byKey(const Key('booking-terms-checkbox')));
  await tester.pump();
  await tester.tap(find.byKey(const Key('booking-continue-payment')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('hiện đúng hành khách, giá từng chỗ, mã giảm và tổng sau giảm', (
    tester,
  ) async {
    await _pumpScreen(tester, FakeBookingApi());
    expect(find.text('Trần Thị Bình'), findsOneWidget);
    expect(find.text('Sài Gòn – Đà Lạt'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('booking-total-amount')),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('booking-confirmation-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Chỗ A01'), findsOneWidget);
    expect(find.text('Giảm giá (GIAM50)'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('booking-total-amount'))).data,
      '550.000 ₫',
    );
  });

  testWidgets('chưa đồng ý điều khoản thì không tạo đơn được', (tester) async {
    await _pumpScreen(tester, FakeBookingApi());
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('booking-continue-payment')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets(
    'tạo đơn với tổng sau giảm rồi sang màn thanh toán, không quay lại được bước trước',
    (tester) async {
      final api = FakeBookingApi();
      await _pumpScreen(tester, api);
      await _acceptAndSubmit(tester);

      final call = api.bookings.single;
      expect(call.holdId, 'hold-1');
      expect(call.expectedTotal, 550000);
      expect(call.draft.promotion?.code, 'GIAM50');
      expect(call.draft.passengers.map((p) => p.seatCode), ['A01', 'A03']);
      expect(find.byKey(const Key('payment-screen')), findsOneWidget);
      expect(find.text('VXN-ABC123'), findsWidgets);
      expect(
        find.byKey(const Key('booking-confirmation-screen')),
        findsNothing,
      );
    },
  );

  testWidgets('giá vừa đổi: đọc lại giữ chỗ, tính lại mã, báo tổng mới', (
    tester,
  ) async {
    final api = FakeBookingApi()
      ..bookingError = const ApiFailure(
        status: 409,
        code: 'BOOKING_SNAPSHOT_CHANGED',
        detail: 'x',
      )
      ..reloadedSeatPrice = 320000;
    await _pumpScreen(tester, api);
    await _acceptAndSubmit(tester);

    expect(find.byKey(const Key('payment-screen')), findsNothing);
    expect(find.textContaining('Tổng mới: 590.000 ₫'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('booking-total-amount'))).data,
      '590.000 ₫',
    );

    await tester.tap(find.byKey(const Key('booking-continue-payment')));
    await tester.pumpAndSettle();
    expect(api.bookings.single.expectedTotal, 590000);
    expect(find.byKey(const Key('payment-screen')), findsOneWidget);
  });

  testWidgets('viewport 320x568 cuộn được và không bottom overflow', (
    tester,
  ) async {
    await _pumpScreen(tester, FakeBookingApi(), width: 320, height: 568);
    for (var index = 0; index < 4; index++) {
      await tester.drag(
        find.byKey(const Key('booking-confirmation-scroll')),
        const Offset(0, -400),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });
}
