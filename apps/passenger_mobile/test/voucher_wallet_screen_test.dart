import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/voucher_wallet_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  required VoucherWalletLoader loader,
  VoucherCodeSaver? saver,
  VoidCallback? onBack,
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
        onBack: onBack ?? () {},
      ),
    ),
  );
}

void main() {
  testWidgets('hiển thị trạng thái ví rỗng và kiểm tra mã', (tester) async {
    var wentBack = false;
    await _pumpScreen(
      tester,
      loader: () async => [],
      onBack: () => wentBack = true,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('voucher-wallet-empty')), findsOneWidget);
    final backRect = tester.getRect(
      find.byKey(const Key('voucher-wallet-back')),
    );
    final titleRect = tester.getRect(find.text('Ví voucher'));
    expect(backRect.right, lessThan(titleRect.left));
    expect(titleRect.center.dx, closeTo(206, 1));
    await tester.tap(find.byKey(const Key('voucher-wallet-back')));
    expect(wentBack, isTrue);
    expect(
      tester.getSize(find.byKey(const Key('voucher-code-box'))).height,
      84,
    );

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

  testWidgets('fixture Figma hiển thị đủ ba khung voucher đúng kích thước', (
    tester,
  ) async {
    await _pumpScreen(tester, loader: () async => figmaVoucherSamples);
    await tester.pumpAndSettle();

    expect(find.text('Đang có 3 voucher khả dụng'), findsOneWidget);
    expect(find.text('50.000đ'), findsOneWidget);
    expect(find.text('Giảm 15%'), findsOneWidget);
    expect(find.text('Miễn phí dịch vụ'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('voucher-card-figma-voucher-50k'))),
      const Size(380, 166),
    );
  });

  testWidgets('"Xem điều kiện" mở bảng điều kiện đúng của voucher', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      loader: () async => [
        VoucherWalletItem(
          id: 'saved',
          name: 'Sao Việt giảm 15%',
          discountType: VoucherDiscountType.percent,
          discountValue: '15',
          minOrder: '300000',
          maxDiscount: '45000',
          expiresAt: DateTime(2026, 12, 12),
          source: VoucherSource.savedPromotion,
          promotionCode: 'SAOVIET15',
          appliesTo: 'Nhà xe Sao Việt · Hà Nội – Sa Pa',
        ),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('voucher-conditions-saved')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('voucher-conditions-sheet')), findsOneWidget);
    expect(find.text('Giảm 15%'), findsWidgets);
    expect(find.text('45.000đ'), findsOneWidget);
    expect(find.text('300.000đ'), findsOneWidget);
    expect(find.text('Nhà xe Sao Việt · Hà Nội – Sa Pa'), findsOneWidget);
    expect(find.text('Đến hết 12/12/2026'), findsOneWidget);
    expect(find.text('Mã khuyến mãi đã lưu'), findsOneWidget);
    expect(find.text('SAOVIET15'), findsOneWidget);

    await tester.tap(find.byKey(const Key('voucher-conditions-close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('voucher-conditions-sheet')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('voucher đổi điểm không có đơn tối thiểu thì ghi rõ', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      loader: () async => [
        VoucherWalletItem(
          id: 'points',
          name: 'Voucher VXN Plus',
          discountType: VoucherDiscountType.amount,
          discountValue: '100000',
          minOrder: '0',
          expiresAt: DateTime(2026, 12, 1),
          source: VoucherSource.loyaltyRedemption,
          appliesTo: 'Mọi tuyến, mọi nhà xe',
        ),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('voucher-conditions-points')));
    await tester.pumpAndSettle();

    expect(find.text('Không yêu cầu'), findsOneWidget);
    expect(find.text('Mọi tuyến, mọi nhà xe'), findsOneWidget);
    expect(find.text('Đổi từ điểm VXN Plus'), findsOneWidget);
    expect(find.text('Giảm tối đa'), findsNothing);
  });
}
