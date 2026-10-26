import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/payment_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  double width = 412,
  double height = 900,
  required DateTime now,
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
      home: PaymentScreen(
        selectedSeats: const ['A01', 'A02'],
        passengerNames: const ['Nguyễn Văn Minh', 'Trần Thị Lan'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
    ),
  );
  await tester.pump();
}

Future<void> _openBankPicker(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(const Key('payment-bank-selector')),
    300,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('payment-scroll')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('payment-bank-selector')));
  await tester.pumpAndSettle();
}

Finder _findAsset(String assetName) {
  return find.byWidgetPredicate((widget) {
    if (widget is! Image || widget.image is! AssetImage) return false;
    return (widget.image as AssetImage).assetName == assetName;
  });
}

void main() {
  testWidgets('hiển thị cấu trúc thanh toán VNPAY và tổng tiền từ booking', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now);

    expect(find.byKey(const Key('payment-screen')), findsOneWidget);
    expect(find.text('Thanh toán'), findsWidgets);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Đơn của bạn'), findsOneWidget);
    expect(find.text('Nguyễn Văn Minh + 1 khách'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Chọn phương thức thanh toán'),
      250,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('payment-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Chọn phương thức thanh toán'), findsOneWidget);
    expect(find.text('VNPAY'), findsWidgets);
    expect(find.text('530.000 đ'), findsNWidgets(2));
    await tester.scrollUntilVisible(
      find.byKey(const Key('payment-bank-selector')),
      250,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('payment-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Vietcombank'), findsOneWidget);
    expect(find.byKey(const Key('payment-submit')), findsOneWidget);
    expect(
      _findAsset('assets/ticket/payment/payment_momo_figma.png'),
      findsOneWidget,
    );
    expect(
      _findAsset('assets/ticket/payment/payment_vnpay_figma.png'),
      findsNWidgets(2),
    );
    expect(
      _findAsset('assets/ticket/payment/payment_visa_master_figma.png'),
      findsOneWidget,
    );
    expect(
      _findAsset('assets/ticket/payment/payment_atm_figma.png'),
      findsOneWidget,
    );
    expect(
      _findAsset('assets/ticket/payment/payment_cash_figma.png'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('floating chọn ngân hàng lọc, chọn và xác nhận được', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now);
    await _openBankPicker(tester);

    expect(find.byKey(const Key('bank-picker-sheet')), findsOneWidget);
    expect(find.byKey(const Key('bank-VCB')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('bank-search')), 'Techcombank');
    await tester.pump();
    expect(find.byKey(const Key('bank-TCB')), findsOneWidget);
    expect(find.byKey(const Key('bank-VCB')), findsNothing);

    await tester.tap(find.byKey(const Key('bank-TCB')));
    await tester.tap(find.byKey(const Key('bank-confirm')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bank-picker-sheet')), findsNothing);
    expect(find.text('Techcombank'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bỏ điều khoản sẽ khóa nút thanh toán', (tester) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now);

    await tester.scrollUntilVisible(
      find.byKey(const Key('payment-terms-checkbox')),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.byKey(const Key('payment-terms-checkbox')));
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('payment-submit')),
    );
    expect(button.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('thanh toán demo chuyển sang vé của đúng hành khách', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, now: now);

    await tester.tap(find.byKey(const Key('payment-submit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('payment-completion-screen')), findsOneWidget);
    expect(find.text('Nguyễn Văn Minh'), findsWidgets);
    expect(find.text('A01'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('viewport 320x568 và floating không bottom overflow', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 26, 10);
    await _pumpScreen(tester, width: 320, height: 568, now: now);

    await tester.drag(
      find.byKey(const Key('payment-scroll')),
      const Offset(0, -1200),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('payment-submit')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _openBankPicker(tester);
    expect(find.byKey(const Key('bank-picker-sheet')), findsOneWidget);
    expect(find.byKey(const Key('bank-confirm')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
