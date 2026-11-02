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
  testWidgets('nút Đổi điểm chỉ hiện khi có đường sang màn đổi điểm', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
        home: PointHistoryScreen(
          loadHistory: (query) async => figmaPointHistorySample(query),
          onBack: () {},
          onRedeem: () => opened = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('point-history-redeem')));
    expect(opened, isTrue);

    await _pumpScreen(
      tester,
      loader: (query) async => figmaPointHistorySample(query),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('point-history-redeem')), findsNothing);
  });

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

  testWidgets('số điểm lớn vẫn nằm trên một dòng', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: PointHistoryScreen(
          loadHistory: (query) async => PointHistoryData(
            availablePoints: 12500,
            earnedPoints: 12500,
            redeemedPoints: 0,
            expiredPoints: 0,
            transactions: [
              PointTransactionItem(
                id: 'lon',
                kind: PointTransactionKind.earn,
                points: 12500,
                title: 'Đơn VXN100099 · hệ số ×1',
                detail: 'Tích điểm',
                createdAt: DateTime(2026, 9, 12),
              ),
            ],
          ),
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final amount = find.byKey(const Key('point-amount-lon'));
    expect(tester.widget<Text>(amount).data, '+12.500');
    expect(tester.getSize(amount).height, lessThan(30));
    expect(tester.takeException(), isNull);
  });

  testWidgets('lọc theo loại giao dịch, giữ nguyên bộ lọc thời gian', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 915);
    addTearDown(tester.view.reset);
    final requested = <PointHistoryQuery>[];
    await tester.pumpWidget(
      MaterialApp(
        home: PointHistoryScreen(
          loadHistory: (query) async {
            requested.add(query);
            return figmaPointHistorySample(query);
          },
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('point-type-filter')), findsOneWidget);

    await tester.tap(find.byKey(const Key('point-date-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('point-date-all')));
    await tester.tap(find.byKey(const Key('point-date-filter-apply')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('point-type-redeem')));
    await tester.pumpAndSettle();
    expect(requested.last.type, PointTypeFilter.redeem);
    expect(requested.last.date, PointDateFilter.all);
    expect(find.text('Đổi điểm lấy voucher'), findsWidgets);

    // Bấm lại đúng loại đang chọn thì không tải lại.
    final calls = requested.length;
    await tester.tap(find.byKey(const Key('point-type-redeem')));
    await tester.pumpAndSettle();
    expect(requested.length, calls);

    // Font test rộng hơn font thật nên chip cuối có thể nằm ngoài màn, phải cuộn tới.
    await tester.ensureVisible(find.byKey(const Key('point-type-expire')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('point-type-expire')));
    await tester.pumpAndSettle();
    expect(requested.last.type, PointTypeFilter.expire);

    // Bộ lọc vẫn hiện khi không có kết quả để còn đổi loại khác.
    await tester.ensureVisible(find.byKey(const Key('point-type-all')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('point-type-all')));
    await tester.pumpAndSettle();
    expect(requested.last.type, PointTypeFilter.all);
    expect(tester.takeException(), isNull);
  });
}
