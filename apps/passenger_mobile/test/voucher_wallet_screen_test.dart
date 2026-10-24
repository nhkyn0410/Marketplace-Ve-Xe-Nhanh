import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/voucher_wallet_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  required VoucherWalletLoader loader,
  VoucherCodeSaver? saver,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: VoucherWalletScreen(
        loadVouchers: loader,
        saveVoucherCode: saver ?? (_) async => true,
        onBack: () {},
      ),
    ),
  );
}

void main() {
  testWidgets('hiển thị trạng thái ví rỗng và kiểm tra mã', (tester) async {
    await _pumpScreen(tester, loader: () async => []);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('voucher-wallet-empty')), findsOneWidget);
    final backRect = tester.getRect(
      find.byKey(const Key('voucher-wallet-back')),
    );
    final titleRect = tester.getRect(find.text('Ví voucher'));
    expect(backRect.right, lessThan(titleRect.left));
    expect(titleRect.center.dx, closeTo(206, 1));

    await tester.enterText(find.byKey(const Key('voucher-code-input')), 'a');
    await tester.tap(find.byKey(const Key('voucher-code-save')));
    await tester.pump();
    expect(
      find.text('Mã gồm 3–20 chữ cái in hoa hoặc chữ số.'),
      findsOneWidget,
    );
  });

  testWidgets('khung voucher nhận dữ liệu và lưu mã qua callback', (
    tester,
  ) async {
    var items = <VoucherWalletItem>[
      VoucherWalletItem(
        id: 'voucher-1',
        name: 'Voucher đổi từ điểm VXN Plus',
        discountType: VoucherDiscountType.amount,
        discountValue: '50000',
        minOrder: '300000',
        expiresAt: DateTime.utc(2026, 11, 30),
        source: VoucherSource.loyaltyRedemption,
      ),
    ];
    String? savedCode;
    await _pumpScreen(
      tester,
      loader: () async => List.of(items),
      saver: (code) async {
        savedCode = code;
        items = List.of(items);
        return true;
      },
    );
    await tester.pumpAndSettle();

    expect(find.text('50.000đ'), findsOneWidget);
    expect(find.text('Đơn tối thiểu 300.000đ'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('voucher-code-input')),
      'summer26',
    );
    await tester.tap(find.byKey(const Key('voucher-code-save')));
    await tester.pumpAndSettle();
    expect(savedCode, 'SUMMER26');
  });
}
