import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/point_history_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  required PointHistoryLoader loader,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: PointHistoryScreen(loadHistory: loader, onBack: () {}),
    ),
  );
}

void main() {
  testWidgets('hiển thị trạng thái chưa có giao dịch', (tester) async {
    await _pumpScreen(
      tester,
      loader: (_) async => const PointHistoryData(
        availablePoints: 0,
        earnedPoints: 0,
        redeemedPoints: 0,
        expiredPoints: 0,
        transactions: [],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('point-history-empty')), findsOneWidget);
    expect(find.text('Chưa có giao dịch điểm'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('point-history-learn-more'))),
      const Size(364, 56),
    );
  });

  testWidgets('fixture Figma hiển thị tổng quan và giao dịch theo tháng', (
    tester,
  ) async {
    final requested = <PointHistoryQuery>[];
    await _pumpScreen(
      tester,
      loader: (query) async {
        requested.add(query);
        return figmaPointHistorySample(query);
      },
    );
    await tester.pumpAndSettle();

    expect(find.text('1.250'), findsOneWidget);
    expect(find.text('+250'), findsOneWidget);
    expect(find.text('−500'), findsOneWidget);
    expect(find.text('Tháng 10/2026'), findsOneWidget);
    expect(find.text('Tháng 09/2026'), findsOneWidget);
    for (final id in const [
      'figma-earn-october-1',
      'figma-earn-october-2',
      'figma-earn-september',
    ]) {
      expect(
        tester.getSize(find.byKey(Key('point-artwork-$id'))),
        const Size(58, 47),
      );
      expect(
        tester.getSize(find.byKey(Key('point-artwork-image-$id'))),
        const Size(58, 47),
      );
    }
    final redeemIconSize = tester.getSize(
      find.byKey(const Key('point-artwork-icon-figma-redeem-october')),
    );
    expect(redeemIconSize.width, closeTo(20.45, .01));
    expect(redeemIconSize.height, closeTo(18.3667, .01));
    final septemberRedeemIconSize = tester.getSize(
      find.byKey(const Key('point-artwork-icon-figma-redeem-september')),
    );
    expect(septemberRedeemIconSize.width, closeTo(20.45, .01));
    expect(septemberRedeemIconSize.height, closeTo(18.3667, .01));
    final expireIconSize = tester.getSize(
      find.byKey(const Key('point-artwork-icon-figma-expire-october')),
    );
    expect(expireIconSize.width, closeTo(20.45, .01));
    expect(expireIconSize.height, closeTo(20.45, .01));
    expect(
      tester.getSize(
        find.byKey(const Key('point-artwork-icon-figma-adjust-september')),
      ),
      const Size(24, 24),
    );
    final chevronSize = tester.getSize(
      find.byKey(const Key('point-chevron-figma-earn-october-1')),
    );
    expect(chevronSize.width, closeTo(5.2, .01));
    expect(chevronSize.height, closeTo(8.7, .01));
    expect(
      tester.getSize(find.byKey(const Key('point-history-overview'))).height,
      145,
    );

    await tester.tap(find.byKey(const Key('point-date-filter')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('point-date-filter-sheet')), findsOneWidget);
    await tester.tap(find.byKey(const Key('point-date-previousMonth')));
    expect(requested.length, 1);
    await tester.tap(find.byKey(const Key('point-date-filter-apply')));
    await tester.pumpAndSettle();
    expect(requested.last.date, PointDateFilter.previousMonth);
  });
}
