import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/passenger_information_screen.dart';
import 'package:passenger_mobile/features/ticket/seat_selection_screen.dart';

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

void main() {
  testWidgets('hiển thị đúng số ghế, hành khách và tổng tiền từ bước 1', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpApp(
      tester,
      home: PassengerInformationScreen(
        selectedSeats: const ['A02', 'A01'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
    );

    expect(
      find.byKey(const Key('passenger-information-screen')),
      findsOneWidget,
    );
    expect(find.text('Thông tin hành khách'), findsOneWidget);
    expect(find.text('Số ghế\nđã chọn'), findsOneWidget);
    final selectedSeatCount = tester.widget<Text>(
      find.byKey(const Key('selected-seat-count')),
    );
    expect(selectedSeatCount.data, '2');
    expect(selectedSeatCount.style?.fontSize, 16);
    expect(find.byKey(const Key('passenger-card-A01')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('passenger-card-A02')),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('passenger-information-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.byKey(const Key('passenger-card-A02')), findsOneWidget);
    final passengerCount = tester.widget<Text>(
      find.byKey(const Key('passenger-count')),
    );
    expect(passengerCount.data, '2 khách hàng');
    expect(passengerCount.style?.fontSize, 14);
    expect(find.text('A01, A02'), findsNothing);
    final totalAmount = tester.widget<Text>(
      find.byKey(const Key('passenger-total-amount')),
    );
    expect(totalAmount.data, '560.000 đ');
    expect(totalAmount.style?.fontSize, 19);
    expect(totalAmount.style?.fontWeight, FontWeight.w700);
    expect(find.text('560.000 đ'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('countdown giữ nguyên thời gian khi chuyển từ bước 1', (
    tester,
  ) async {
    var now = DateTime(2026, 10, 26, 10);
    await _pumpApp(tester, home: SeatSelectionScreen(now: () => now));

    now = now.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('09:30'), findsOneWidget);

    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('passenger-information-screen')),
      findsOneWidget,
    );
    expect(find.text('09:30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('form mỗi ghế và chọn hành khách đã lưu hoạt động', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpApp(
      tester,
      home: PassengerInformationScreen(
        selectedSeats: const ['A01', 'A02', 'A03'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
    );

    final continueButton = tester.widget<FilledButton>(
      find.byKey(const Key('passenger-information-continue')),
    );
    expect(continueButton.onPressed, isNull);

    await tester.scrollUntilVisible(
      find.byKey(const Key('saved-passenger-A03')),
      250,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('passenger-information-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byKey(const Key('saved-passenger-A03')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('saved-passenger-sheet')), findsOneWidget);
    await tester.tap(find.byKey(const Key('saved-passenger-Trần Thị Lan')));
    await tester.pumpAndSettle();

    expect(find.text('Trần Thị Lan'), findsWidgets);
    final enabledButton = tester.widget<FilledButton>(
      find.byKey(const Key('passenger-information-continue')),
    );
    expect(enabledButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tiếp tục mở màn xác nhận với cùng hạn giữ ghế', (tester) async {
    var now = DateTime(2026, 10, 26, 10);
    await _pumpApp(
      tester,
      home: PassengerInformationScreen(
        selectedSeats: const ['A01', 'A02'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
    );

    now = now.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('passenger-information-continue')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('booking-confirmation-screen')),
      findsOneWidget,
    );
    expect(find.text('09:30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('viewport nhỏ cuộn toàn bộ form không bottom overflow', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpApp(
      tester,
      width: 320,
      height: 568,
      home: PassengerInformationScreen(
        selectedSeats: const ['A01', 'A02'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
    );

    await tester.drag(
      find.byKey(const Key('passenger-information-scroll')),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ưu đãi'), findsOneWidget);
    expect(find.text('Voucher của tôi'), findsOneWidget);
    expect(
      find.byKey(const Key('passenger-information-continue')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
