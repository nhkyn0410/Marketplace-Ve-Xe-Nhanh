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
  });

  testWidgets('khung tổng quan và giao dịch nhận dữ liệu API', (tester) async {
    final requested = <PointHistoryQuery>[];
    await _pumpScreen(
      tester,
      loader: (query) async {
        requested.add(query);
        return PointHistoryData(
          availablePoints: 1250,
          earnedPoints: 2000,
          redeemedPoints: 500,
          expiredPoints: 250,
          transactions: [
            PointTransactionItem(
              id: 'transaction-1',
              kind: PointTransactionKind.earn,
              points: 120,
              title: 'Chuyến TP.HCM → Đà Lạt',
              createdAt: DateTime.utc(2026, 10, 24, 8, 30),
            ),
          ],
        );
      },
    );
    await tester.pumpAndSettle();

    expect(find.text('1.250'), findsOneWidget);
    expect(find.text('+120'), findsOneWidget);
    await tester.tap(find.byKey(const Key('point-filter-redeem')));
    await tester.pumpAndSettle();
    expect(requested.last.type, PointTypeFilter.redeem);
  });
}
