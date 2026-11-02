import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/account/loyalty_screen.dart';

const _rules = LoyaltyProgramRules(
  earnUnit: 10000,
  pointValue: 1000,
  minRedeemPoints: 100,
  pointExpiryMonths: 12,
  voucherValidityDays: 30,
  tiers: [
    LoyaltyTierRule(tier: 'BRONZE', minPoints: 0, multiplierPercent: 100),
    LoyaltyTierRule(tier: 'SILVER', minPoints: 2000, multiplierPercent: 120),
    LoyaltyTierRule(tier: 'GOLD', minPoints: 5000, multiplierPercent: 150),
    LoyaltyTierRule(tier: 'PLATINUM', minPoints: 10000, multiplierPercent: 200),
  ],
);

const _silver = LoyaltyProgress(
  accountActive: true,
  availablePoints: 1250,
  earned12m: 2450,
  tier: 'SILVER',
  nextTier: LoyaltyNextTier(tier: 'GOLD', minPoints: 5000, remaining: 2550),
  rules: _rules,
);

final _voucher = RedeemedLoyaltyVoucher(
  discountAmount: 500000,
  expiresAt: DateTime.utc(2026, 12, 1),
);

Future<void> _pumpScreen(
  WidgetTester tester, {
  LoyaltyProgressLoader? loader,
  LoyaltyPointsRedeemer? redeem,
  VoidCallback? onBack,
  VoidCallback? onPointHistory,
  VoidCallback? onVoucherWallet,
  VoidCallback? onFindTrips,
  double width = 412,
  double height = 900,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: LoyaltyScreen(
        loadProgress: loader ?? () async => _silver,
        redeemPoints: redeem ?? (_, _) async => _voucher,
        onBack: onBack ?? () {},
        onPointHistory: onPointHistory ?? () {},
        onVoucherWallet: onVoucherWallet ?? () {},
        onFindTrips: onFindTrips,
        now: () => DateTime.utc(2026, 11, 1),
      ),
    ),
  );
}

FilledButton _confirmButton(WidgetTester tester) => tester.widget<FilledButton>(
  find.byKey(const Key('loyalty-redeem-confirm')),
);

Future<void> _openRedeem(WidgetTester tester) async {
  final button = find.byKey(const Key('loyalty-redeem'));
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('loyalty-redeem-sheet')), findsOneWidget);
}

Future<void> _tapInSheet(WidgetTester tester, Key key) async {
  final target = find.byKey(key);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pump();
}

void main() {
  testWidgets('hiện hạng, điểm khả dụng, giá trị quy đổi và bảng hạng', (
    tester,
  ) async {
    await _pumpScreen(tester);

    expect(find.byKey(const Key('loyalty-loading')), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Hạng Bạc'), findsOneWidget);
    expect(find.text('Hệ số ×1,2'), findsOneWidget);
    expect(
      find.text('Cần thêm 2.550 điểm để lên hạng Vàng (×1,5)'),
      findsOneWidget,
    );
    expect(
      find.text('Ước tính quy đổi ≈ 1.250.000 ₫ voucher'),
      findsOneWidget,
    );
    final progress = tester.widget<LinearProgressIndicator>(
      find.byKey(const Key('loyalty-tier-progress')),
    );
    expect(progress.value, closeTo(.49, .001));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('loyalty-redeem')))
          .onPressed,
      isNotNull,
    );
    expect(find.byKey(const Key('loyalty-redeem-hint')), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('loyalty-tier-PLATINUM')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Hạng của bạn'), findsOneWidget);
    expect(find.text('×2,0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('thành viên mới chưa đủ điểm: khóa đổi điểm, giải thích, mời tìm chuyến', (
    tester,
  ) async {
    var findTrips = false;
    await _pumpScreen(
      tester,
      onFindTrips: () => findTrips = true,
      loader: () async => const LoyaltyProgress(
        accountActive: true,
        availablePoints: 0,
        earned12m: 0,
        tier: 'BRONZE',
        nextTier: LoyaltyNextTier(tier: 'SILVER', minPoints: 2000, remaining: 2000),
        rules: _rules,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hạng Đồng'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('loyalty-redeem')))
          .onPressed,
      isNull,
    );
    expect(
      find.text('Bạn cần ít nhất 100 điểm để đổi voucher, còn thiếu 100 điểm.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('loyalty-find-trips')));
    expect(findTrips, isTrue);
  });

  testWidgets('chưa có chính sách: giữ số dư, khóa đổi điểm, không ước tính giá trị', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      loader: () async => const LoyaltyProgress(
        accountActive: true,
        availablePoints: 300,
        earned12m: 300,
        tier: 'BRONZE',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('300'), findsNothing);
    expect(find.byKey(const Key('loyalty-available-points')), findsOneWidget);
    expect(find.byKey(const Key('loyalty-estimated-value')), findsNothing);
    expect(
      find.text(
        'Chưa có chính sách đổi điểm đang áp dụng. Số dư điểm của bạn vẫn được giữ nguyên.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Chính sách xét hạng đang được cập nhật.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('loyalty-redeem')))
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('hạng cao nhất không hiện tiến độ; tài khoản bị khóa không đổi được', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      loader: () async => const LoyaltyProgress(
        accountActive: false,
        availablePoints: 5000,
        earned12m: 12000,
        tier: 'PLATINUM',
        rules: _rules,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('loyalty-tier-progress')), findsNothing);
    expect(find.text('Bạn đang ở hạng thành viên cao nhất.'), findsOneWidget);
    expect(find.text('Tài khoản hiện chưa thể đổi điểm.'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('loyalty-redeem')))
          .onPressed,
      isNull,
    );
  });

  testWidgets('lỗi tải có nút thử lại; mở lịch sử và ví đúng màn', (tester) async {
    var calls = 0;
    var history = false;
    var wallet = false;
    await _pumpScreen(
      tester,
      onPointHistory: () => history = true,
      onVoucherWallet: () => wallet = true,
      loader: () async {
        calls++;
        if (calls == 1) throw StateError('offline');
        return _silver;
      },
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('loyalty-error')), findsOneWidget);

    await tester.tap(find.byKey(const Key('loyalty-retry')));
    await tester.pumpAndSettle();
    expect(find.text('Hạng Bạc'), findsOneWidget);

    await tester.tap(find.byKey(const Key('loyalty-history')));
    await tester.tap(find.byKey(const Key('loyalty-vouchers')));
    expect(history, isTrue);
    expect(wallet, isTrue);
  });

  testWidgets('bảng đổi điểm tính voucher, điểm còn lại, hạn dùng theo chính sách', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await tester.pumpAndSettle();
    await _openRedeem(tester);

    expect(find.text('1 điểm = 1.000 ₫'), findsOneWidget);
    expect(find.text('Giảm 100.000 ₫'), findsOneWidget);
    expect(find.text('1.150 điểm'), findsOneWidget);
    expect(find.text('30 ngày · đến 01/12/2026'), findsOneWidget);
    expect(find.text('Xác nhận đổi 100 điểm'), findsOneWidget);

    await _tapInSheet(tester, const Key('loyalty-quick-500'));
    expect(find.text('Giảm 500.000 ₫'), findsOneWidget);
    expect(find.text('750 điểm'), findsOneWidget);

    await _tapInSheet(tester, const Key('loyalty-quick-all'));
    expect(find.text('Giảm 1.250.000 ₫'), findsOneWidget);
    expect(find.text('0 điểm'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nhập dưới tối thiểu hoặc vượt số dư thì báo tại ô và khóa xác nhận', (
    tester,
  ) async {
    var calls = 0;
    await _pumpScreen(
      tester,
      redeem: (_, _) async {
        calls++;
        return _voucher;
      },
    );
    await tester.pumpAndSettle();
    await _openRedeem(tester);

    final input = find.byKey(const Key('loyalty-redeem-input'));
    await tester.enterText(input, '50');
    await tester.pump();
    expect(find.text('Số điểm đổi tối thiểu là 100 điểm.'), findsOneWidget);
    expect(_confirmButton(tester).onPressed, isNull);

    await tester.enterText(input, '1251');
    await tester.pump();
    expect(find.text('Bạn chỉ có thể đổi tối đa 1.250 điểm.'), findsOneWidget);
    expect(_confirmButton(tester).onPressed, isNull);

    await tester.enterText(input, '');
    await tester.pump();
    expect(_confirmButton(tester).onPressed, isNull);

    await tester.enterText(input, '1250');
    await tester.pump();
    expect(_confirmButton(tester).onPressed, isNotNull);
    expect(calls, 0);
  });

  testWidgets('đổi thành công: gửi đúng điểm, tải lại số dư, mở được ví', (
    tester,
  ) async {
    final requests = <(int, String)>[];
    var loads = 0;
    var walletOpened = false;
    await _pumpScreen(
      tester,
      loader: () async {
        loads++;
        return _silver;
      },
      onVoucherWallet: () => walletOpened = true,
      redeem: (points, key) async {
        requests.add((points, key));
        return _voucher;
      },
    );
    await tester.pumpAndSettle();
    await _openRedeem(tester);
    await _tapInSheet(tester, const Key('loyalty-quick-500'));
    await _tapInSheet(tester, const Key('loyalty-redeem-confirm'));
    await tester.pumpAndSettle();

    expect(requests.single.$1, 500);
    expect(
      RegExp(r'^[A-Za-z0-9_-]{8,128}$').hasMatch(requests.single.$2),
      isTrue,
      reason: 'khóa phải đúng định dạng Idempotency-Key của API',
    );
    expect(find.byKey(const Key('loyalty-redeem-success')), findsOneWidget);
    expect(find.text('Đến 01/12/2026'), findsOneWidget);
    expect(find.text('750 điểm'), findsOneWidget);
    expect(loads, 2);

    await tester.tap(find.byKey(const Key('loyalty-redeem-open-wallet')));
    await tester.pumpAndSettle();
    expect(walletOpened, isTrue);
    expect(find.byKey(const Key('loyalty-redeem-sheet')), findsNothing);
  });

  testWidgets('idempotency: thử lại cùng số điểm dùng lại khóa, đổi số điểm thì khóa mới', (
    tester,
  ) async {
    final keys = <String>[];
    final failures = <Object>[
      const ApiFailure(status: 0, code: 'NETWORK_ERROR', detail: 'mất mạng'),
      const ApiFailure(status: 0, code: 'NETWORK_ERROR', detail: 'mất mạng'),
    ];
    await _pumpScreen(
      tester,
      redeem: (_, key) async {
        keys.add(key);
        if (failures.isNotEmpty) throw failures.removeAt(0);
        return _voucher;
      },
    );
    await tester.pumpAndSettle();
    await _openRedeem(tester);

    await _tapInSheet(tester, const Key('loyalty-redeem-confirm'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('loyalty-redeem-error')), findsOneWidget);
    expect(find.byKey(const Key('loyalty-redeem-sheet')), findsOneWidget);

    // Lần đầu có thể đã trừ điểm nhưng mất phản hồi: thử lại phải cùng khóa.
    await _tapInSheet(tester, const Key('loyalty-quick-200'));
    await _tapInSheet(tester, const Key('loyalty-quick-100'));
    await _tapInSheet(tester, const Key('loyalty-redeem-confirm'));
    await tester.pumpAndSettle();
    expect(keys, hasLength(2));
    expect(keys[1], keys[0]);

    await _tapInSheet(tester, const Key('loyalty-quick-200'));
    await _tapInSheet(tester, const Key('loyalty-redeem-confirm'));
    await tester.pumpAndSettle();
    expect(keys, hasLength(3));
    expect(keys[2], isNot(keys[0]));
    expect(find.byKey(const Key('loyalty-redeem-success')), findsOneWidget);
  });

  testWidgets('đang gửi: khóa nút và không gửi lần hai; lỗi API hiện đúng câu', (
    tester,
  ) async {
    final pending = Completer<RedeemedLoyaltyVoucher>();
    var calls = 0;
    await _pumpScreen(
      tester,
      redeem: (_, _) {
        calls++;
        return pending.future;
      },
    );
    await tester.pumpAndSettle();
    await _openRedeem(tester);
    await _tapInSheet(tester, const Key('loyalty-redeem-confirm'));

    expect(_confirmButton(tester).onPressed, isNull);
    expect(
      tester
          .widget<OutlinedButton>(find.byKey(const Key('loyalty-redeem-cancel')))
          .onPressed,
      isNull,
    );
    await tester.tap(
      find.byKey(const Key('loyalty-redeem-confirm')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(calls, 1);

    pending.completeError(
      const ApiFailure(
        status: 409,
        code: 'LOYALTY_INSUFFICIENT_POINTS',
        detail: 'Số điểm trừ vượt điểm khả dụng (50).',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Số điểm trừ vượt điểm khả dụng (50).'), findsOneWidget);
    expect(_confirmButton(tester).onPressed, isNotNull);
  });

  testWidgets('điểm vừa bằng mức tối thiểu: không có thanh trượt, vẫn đổi được', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      loader: () async => const LoyaltyProgress(
        accountActive: true,
        availablePoints: 100,
        earned12m: 100,
        tier: 'BRONZE',
        rules: _rules,
      ),
    );
    await tester.pumpAndSettle();
    await _openRedeem(tester);

    expect(find.byKey(const Key('loyalty-redeem-slider')), findsNothing);
    expect(_confirmButton(tester).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('màn và bảng đổi điểm không tràn ở máy hẹp, chữ phóng to', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpScreen(tester, width: 320, height: 640);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await _openRedeem(tester);
    expect(tester.takeException(), isNull);
  });
}
