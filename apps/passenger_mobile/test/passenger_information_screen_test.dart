import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
import 'package:passenger_mobile/features/ticket/booking_confirmation_screen.dart';
import 'package:passenger_mobile/features/ticket/passenger_information_screen.dart';
import 'package:passenger_mobile/features/ticket/seat_selection_screen.dart';

import 'support/fake_booking_api.dart';

Future<void> _pumpApp(
  WidgetTester tester, {
  required Widget home,
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
      home: home,
    ),
  );
  await tester.pump();
}

Widget _screen(
  FakeBookingApi api, {
  DateTime Function()? now,
  Set<String> doubleSeats = const {},
  List<String> seats = const ['A01', 'A03'],
}) => PassengerInformationScreen(
  api: api,
  trip: api.trip,
  hold: sampleHold(seats: seats, doubleSeats: doubleSeats),
  now: now,
);

Future<void> _fillContact(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('contact-name-field')),
    'Lê Văn An',
  );
  await tester.enterText(
    find.byKey(const Key('contact-email-field')),
    'an@vidu.com',
  );
  await tester.enterText(
    find.byKey(const Key('contact-phone-field')),
    '0901 234 567',
  );
  await tester.pump();
}

Future<void> _fillForm(WidgetTester tester) async {
  await _fillContact(tester);
  await tester.scrollUntilVisible(
    find.byKey(const Key('passenger-name-A03')),
    200,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('passenger-information-scroll')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.enterText(
    find.byKey(const Key('passenger-name-A03')),
    'Trần Thị Bình',
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    final font = FontLoader('Be Vietnam Pro')
      ..addFont(rootBundle.load('assets/fonts/BeVietnamPro-Regular.ttf'));
    await font.load();
  });

  testWidgets(
    'khách vãng lai: form trống, không có nút hành khách đã lưu, tổng theo giữ chỗ',
    (tester) async {
      await _pumpApp(tester, home: _screen(FakeBookingApi()));

      expect(find.text('A01, A03'), findsOneWidget);
      expect(find.text('2 hành khách'), findsOneWidget);
      expect(find.text('600.000 ₫'), findsOneWidget);
      expect(find.text('Tạm tính'), findsOneWidget);
      expect(
        (tester.getTopLeft(find.text('Tạm tính')).dy -
                tester.getTopLeft(find.text('2 hành khách')).dy)
            .abs(),
        lessThan(3),
      );
      expect(find.byKey(const Key('passenger-name-A01')), findsNothing);
      expect(find.byKey(const Key('saved-passenger-A01')), findsNothing);
      final continueButton = tester.widget<FilledButton>(
        find.byKey(const Key('passenger-information-continue')),
      );
      expect(continueButton.onPressed, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  for (final doubleSeats in [
    <String>{},
    {'A01'},
  ]) {
    testWidgets('một vé $doubleSeats dùng liên hệ, không có form hành khách', (
      tester,
    ) async {
      final api = FakeBookingApi()
        ..prefill = const BookingPrefill(
          contact: BookingContact(
            fullName: 'Tên đã lưu',
            phone: '0909000111',
            email: 'cu@vidu.com',
          ),
          travellers: [],
        );
      await _pumpApp(
        tester,
        home: _screen(api, seats: ['A01'], doubleSeats: doubleSeats),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('passenger-card-A01')), findsNothing);
      expect(find.text('Hành khách bổ sung (tùy chọn)'), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const Key('passenger-information-header')),
          matching: find.text(api.trip.routeName),
        ),
        findsNothing,
      );
      await _fillContact(tester);
      await tester.tap(find.byKey(const Key('passenger-information-continue')));
      await tester.pumpAndSettle();
      final draft = tester
          .widget<BookingConfirmationScreen>(
            find.byType(BookingConfirmationScreen),
          )
          .draft;
      expect(draft.passengers.length, 1);
      expect(draft.passengers.single.seatCode, 'A01');
      expect(draft.passengers.single.fullName, 'Lê Văn An');
      expect(draft.passengers.single.phone, '0901234567');
      expect(draft.passengers.single.companionName, isNull);
    });
  }

  testWidgets('nhiều vé để trống hành khách bổ sung vẫn tiếp tục được', (
    tester,
  ) async {
    await _pumpApp(tester, home: _screen(FakeBookingApi()));
    await _fillContact(tester);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('passenger-information-continue')),
          )
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byKey(const Key('passenger-information-continue')));
    await tester.pumpAndSettle();
    final draft = tester
        .widget<BookingConfirmationScreen>(
          find.byType(BookingConfirmationScreen),
        )
        .draft;
    expect(draft.passengers.map((passenger) => passenger.seatCode), [
      'A01',
      'A03',
    ]);
    expect(draft.passengers.map((passenger) => passenger.fullName), [
      'Lê Văn An',
      'Lê Văn An',
    ]);
    expect(draft.passengers.last.phone, isNull);
  });

  testWidgets(
    'hành khách bổ sung chỉ nhập điện thoại: kiểm tra và giữ đúng chỗ',
    (tester) async {
      await _pumpApp(tester, home: _screen(FakeBookingApi()));
      await _fillContact(tester);
      await tester.scrollUntilVisible(
        find.byKey(const Key('passenger-phone-A03')),
        200,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('passenger-information-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.enterText(
        find.byKey(const Key('passenger-phone-A03')),
        '123',
      );
      await tester.pump();
      expect(find.textContaining('Số điện thoại gồm 10 số'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.byKey(const Key('passenger-information-continue')),
            )
            .onPressed,
        isNull,
      );
      await tester.enterText(
        find.byKey(const Key('passenger-phone-A03')),
        '+84 901.222-333',
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('passenger-information-continue')));
      await tester.pumpAndSettle();
      final draft = tester
          .widget<BookingConfirmationScreen>(
            find.byType(BookingConfirmationScreen),
          )
          .draft;
      expect(draft.passengers.last.fullName, 'Lê Văn An');
      expect(draft.passengers.last.phone, '+84901222333');
      expect(draft.passengers.last.seatCode, 'A03');
    },
  );

  testWidgets(
    'số điện thoại / email sai thì báo lỗi và khóa Tiếp tục; đúng thì mở',
    (tester) async {
      await _pumpApp(tester, home: _screen(FakeBookingApi()));
      await _fillForm(tester);
      await tester.drag(
        find.byKey(const Key('passenger-information-scroll')),
        const Offset(0, 1000),
      );
      await tester.pump();
      await tester.enterText(
        find.byKey(const Key('contact-phone-field')),
        '12345',
      );
      await tester.pump();
      expect(find.textContaining('Số điện thoại gồm 10 số'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.byKey(const Key('passenger-information-continue')),
            )
            .onPressed,
        isNull,
      );

      await tester.enterText(
        find.byKey(const Key('contact-phone-field')),
        '+84901234567',
      );
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(
              find.byKey(const Key('passenger-information-continue')),
            )
            .onPressed,
        isNotNull,
      );
    },
  );

  testWidgets('đã đăng nhập: điền sẵn liên hệ và chọn được hành khách đã lưu', (
    tester,
  ) async {
    final api = FakeBookingApi()
      ..prefill = const BookingPrefill(
        contact: BookingContact(
          fullName: 'Nguyễn Khanh',
          phone: '0909000111',
          email: 'khanh@vidu.com',
        ),
        travellers: [
          SavedTraveller(fullName: 'Trần Thị Lan', phone: '0909000222'),
        ],
      );
    await _pumpApp(tester, home: _screen(api));
    await tester.pumpAndSettle();

    expect(find.text('khanh@vidu.com'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('saved-passenger-A03')),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('passenger-information-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find.byKey(const Key('passenger-information-scroll')),
      const Offset(0, -150),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saved-passenger-A03')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saved-passenger-Trần Thị Lan')));
    await tester.pumpAndSettle();
    expect(find.text('Trần Thị Lan'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('passenger-phone-A03')))
          .controller!
          .text,
      '0909000222',
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('passenger-information-continue')),
          )
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('mã khuyến mãi: sai thì báo lỗi; đúng thì giảm tổng, gỡ được', (
    tester,
  ) async {
    await _pumpApp(tester, home: _screen(FakeBookingApi()));
    await tester.scrollUntilVisible(
      find.byKey(const Key('voucher-field')),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('passenger-information-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.enterText(find.byKey(const Key('voucher-field')), 'SAIMA');
    await tester.tap(find.byKey(const Key('voucher-apply')));
    await tester.pumpAndSettle();
    expect(
      find.text('Mã khuyến mãi không tồn tại hoặc đã hết hạn.'),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('voucher-field')), 'giam50');
    await tester.tap(find.byKey(const Key('voucher-apply')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('voucher-applied')), findsOneWidget);
    expect(find.text('550.000 ₫'), findsOneWidget);

    await tester.tap(find.byKey(const Key('voucher-remove')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('voucher-applied')), findsNothing);
    expect(find.text('600.000 ₫'), findsOneWidget);
  });

  testWidgets('đồng hồ bước 2 đếm theo hạn giữ chỗ server trả', (tester) async {
    final api = FakeBookingApi();
    await _pumpApp(
      tester,
      home: SeatSelectionScreen(
        api: api,
        trip: api.trip,
        pickupSequence: 1,
        dropoffSequence: 5,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('seat-A01')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('passenger-information-screen')),
      findsOneWidget,
    );
    expect(find.textContaining(RegExp(r'^(10:00|09:5\d)$')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tiếp tục mang thông tin sang bước xác nhận', (tester) async {
    await _pumpApp(tester, home: _screen(FakeBookingApi()));
    await _fillForm(tester);
    await tester.tap(find.byKey(const Key('passenger-information-continue')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('booking-confirmation-screen')),
      findsOneWidget,
    );
    expect(
      find.text('Liên hệ: Lê Văn An · 0901234567 · an@vidu.com'),
      findsOneWidget,
    );
    expect(find.text('Trần Thị Bình'), findsOneWidget);
  });

  testWidgets(
    'chỗ đôi có ô người đi cùng (không bắt buộc), sang bước xác nhận hiện "A và B"',
    (tester) async {
      await _pumpApp(
        tester,
        home: _screen(FakeBookingApi(), doubleSeats: {'A03'}),
      );
      expect(find.byKey(const Key('companion-name-A01')), findsNothing);
      await _fillForm(tester);
      expect(find.byKey(const Key('companion-name-A03')), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('companion-name-A03')),
        '  Lê Thị Cúc  ',
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('passenger-information-continue')));
      await tester.pumpAndSettle();
      expect(find.text('Trần Thị Bình và Lê Thị Cúc'), findsOneWidget);
    },
  );

  testWidgets('viewport nhỏ cuộn toàn bộ form không bottom overflow', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      home: _screen(FakeBookingApi()),
      width: 320,
      height: 568,
    );
    for (var index = 0; index < 4; index++) {
      await tester.drag(
        find.byKey(const Key('passenger-information-scroll')),
        const Offset(0, -400),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });
}
