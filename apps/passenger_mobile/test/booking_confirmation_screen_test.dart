import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/ticket/booking_confirmation_screen.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';

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
  SeatHold? hold,
  DateTime Function()? now,
  BookingDraft draft = _draft,
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
        hold: hold ?? sampleHold(),
        draft: draft,
        now: now,
      ),
    ),
  );
  await tester.pump();
}

Future<void> _acceptAndSubmit(WidgetTester tester) async {
  await _scrollToTerms(tester);
  await tester.tap(find.byKey(const Key('booking-terms-checkbox')));
  await tester.pump();
  await tester.tap(find.byKey(const Key('booking-continue-payment')));
  await tester.pumpAndSettle();
}

Future<void> _scrollToTerms(WidgetTester tester) async {
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
}

void main() {
  testWidgets('xem và đóng điều khoản / chính sách giữ nguyên đơn và đồng hồ', (
    tester,
  ) async {
    final api = FakeBookingApi()
      ..bookingTermsLoader = () async => const [
        BookingPolicyDocument(
          title: 'Quy chế hoạt động',
          bodyMarkdown: 'Nội dung điều khoản đã công bố.',
        ),
      ];
    final hold = sampleHold();
    var now = hold.expiresAt.subtract(const Duration(minutes: 10));
    await _pumpScreen(tester, api, hold: hold, now: () => now);
    final confirmationState = tester.state(
      find.byType(BookingConfirmationScreen),
    );
    await _scrollToTerms(tester);
    await tester.tap(find.byKey(const Key('booking-terms-checkbox')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('booking-view-terms')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('booking-policy-sheet')), findsOneWidget);
    expect(find.text('Quy chế hoạt động'), findsOneWidget);
    expect(
      find.text('Nội dung điều khoản đã công bố.', findRichText: true),
      findsOneWidget,
    );
    expect(api.bookingTermsLoads, 1);
    now = now.add(const Duration(minutes: 2));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('booking-policy-close')));
    await tester.pumpAndSettle();
    expect(find.text('08:00'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('booking-view-cancellation-policy')),
    );
    await tester.tap(find.byKey(const Key('booking-view-cancellation-policy')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Hủy trước ít nhất 24 giờ: hoàn 90%',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'Hủy trước ít nhất 4 giờ: hoàn 50%',
        findRichText: true,
      ),
      findsOneWidget,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(
      tester.state(find.byType(BookingConfirmationScreen)),
      same(confirmationState),
    );
    expect(
      tester
          .widget<Checkbox>(find.byKey(const Key('booking-terms-checkbox')))
          .value,
      isTrue,
    );
    expect(find.text('08:00'), findsOneWidget);
    expect(api.holds, isEmpty);
    expect(api.released, isEmpty);
    expect(api.bookings, isEmpty);
    await tester.tap(find.byKey(const Key('booking-continue-payment')));
    await tester.pumpAndSettle();
    final booking = api.bookings.single;
    expect(booking.holdId, hold.holdId);
    expect(booking.draft.contact, same(_draft.contact));
    expect(booking.draft.passengers, same(_draft.passengers));
    expect(booking.draft.promotion, same(_draft.promotion));
    expect(booking.expectedTotal, 550000);
  });

  testWidgets('hết giờ khi đang xem chính sách không gia hạn giữ ghế', (
    tester,
  ) async {
    final api = FakeBookingApi();
    final hold = sampleHold();
    var now = hold.expiresAt.subtract(const Duration(minutes: 10));
    await _pumpScreen(tester, api, hold: hold, now: () => now);
    await _scrollToTerms(tester);
    await tester.tap(find.byKey(const Key('booking-terms-checkbox')));
    await tester.pump();
    await tester.ensureVisible(
      find.byKey(const Key('booking-view-cancellation-policy')),
    );
    await tester.tap(find.byKey(const Key('booking-view-cancellation-policy')));
    await tester.pumpAndSettle();
    now = hold.expiresAt.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('booking-policy-close')));
    await tester.pumpAndSettle();

    expect(find.text('Đã hết hạn'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('booking-continue-payment')),
          )
          .onPressed,
      isNull,
    );
    expect(api.holds, isEmpty);
    expect(api.bookings, isEmpty);
  });

  testWidgets(
    'điều khoản tải, lỗi, chưa công bố và thử lại an toàn ở màn nhỏ',
    (tester) async {
      final pending = Completer<List<BookingPolicyDocument>>();
      final api = FakeBookingApi()..bookingTermsLoader = () => pending.future;
      await _pumpScreen(tester, api, width: 320, height: 568);
      await _scrollToTerms(tester);
      await tester.ensureVisible(find.byKey(const Key('booking-view-terms')));
      await tester.tap(find.byKey(const Key('booking-view-terms')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      pending.completeError(Exception('Không kết nối được'));
      await tester.pumpAndSettle();
      expect(
        find.text('Chưa tải được nội dung. Vui lòng thử lại.'),
        findsOneWidget,
      );

      api.bookingTermsLoader = () async => const [];
      await tester.tap(find.byKey(const Key('booking-policy-retry')));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có nội dung được công bố.'), findsOneWidget);
      api.bookingTermsLoader = () async => const [
        BookingPolicyDocument(
          title: 'Quy chế',
          bodyMarkdown: 'Nội dung quy chế.',
        ),
        BookingPolicyDocument(
          title: 'Bảo mật',
          bodyMarkdown: 'Nội dung bảo mật.',
        ),
      ];
      await tester.tap(find.byKey(const Key('booking-policy-retry')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quy chế'));
      await tester.pumpAndSettle();
      expect(
        find.text('Nội dung quy chế.', findRichText: true),
        findsOneWidget,
      );
      expect(api.bookingTermsLoads, 3);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const Key('booking-policy-close')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Checkbox>(find.byKey(const Key('booking-terms-checkbox')))
            .value,
        isFalse,
      );
      expect(
        tester
            .widget<FilledButton>(
              find.byKey(const Key('booking-continue-payment')),
            )
            .onPressed,
        isNull,
      );
      expect(api.bookings, isEmpty);
    },
  );

  testWidgets('hiện đúng hành khách, giá từng chỗ, mã giảm và tổng sau giảm', (
    tester,
  ) async {
    await _pumpScreen(tester, FakeBookingApi());
    expect(find.text('Trần Thị Bình'), findsOneWidget);
    expect(find.text('Xác nhận đặt vé'), findsOneWidget);
    expect(find.text('Sài Gòn – Đà Lạt'), findsNothing);
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

  testWidgets(
    'giá đổi vẫn kiểm lại voucher bằng ID trong ví, không đổi thành mã nhập tay',
    (tester) async {
      final api = FakeBookingApi()
        ..bookingError = const ApiFailure(
          status: 409,
          code: 'BOOKING_SNAPSHOT_CHANGED',
          detail: 'Giá đổi',
        )
        ..reloadedSeatPrice = 320000;
      final draft = BookingDraft(
        contact: _draft.contact,
        passengers: _draft.passengers,
        promotion: const PromotionQuote(
          code: 'WALLET50',
          name: 'Voucher trong ví',
          discount: 50000,
          total: 550000,
          userVoucherId: 'wallet-1',
        ),
      );
      await _pumpScreen(tester, api, draft: draft);
      await _acceptAndSubmit(tester);
      expect(api.voucherChecks.single, (
        tripId: 'trip-1',
        userVoucherId: 'wallet-1',
        subtotal: 640000,
      ));
      expect(find.textContaining('Tổng mới: 590.000 ₫'), findsOneWidget);
      await tester.tap(find.byKey(const Key('booking-continue-payment')));
      await tester.pumpAndSettle();
      expect(api.bookings.single.draft.promotion?.userVoucherId, 'wallet-1');
      expect(api.bookings.single.expectedTotal, 590000);
    },
  );

  testWidgets(
    'voucher hết hạn khi tạo đơn được bỏ và khách phải xem lại tổng tiền',
    (tester) async {
      final api = FakeBookingApi()
        ..bookingError = const ApiFailure(
          status: 422,
          code: 'VOUCHER_EXPIRED',
          detail: 'Voucher đã hết hạn.',
        );
      final draft = BookingDraft(
        contact: _draft.contact,
        passengers: _draft.passengers,
        promotion: const PromotionQuote(
          code: 'WALLET50',
          name: 'Voucher trong ví',
          discount: 50000,
          total: 550000,
          userVoucherId: 'wallet-1',
        ),
      );
      await _pumpScreen(tester, api, draft: draft);
      await _acceptAndSubmit(tester);
      expect(find.textContaining('Ưu đãi đã được bỏ'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('booking-total-amount'))).data,
        '600.000 ₫',
      );
      expect(api.bookings, isEmpty);
      await tester.tap(find.byKey(const Key('booking-continue-payment')));
      await tester.pumpAndSettle();
      expect(api.bookings.single.draft.promotion, isNull);
      expect(api.bookings.single.expectedTotal, 600000);
    },
  );
}
