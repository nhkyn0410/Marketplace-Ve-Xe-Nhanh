import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7EAD)),
      ),
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('mũi tên Phương Trang mở màn chi tiết chuyến', (tester) async {
    await _pumpApp(tester, home: TicketScreen(onTabSelected: (_) {}));

    final arrow = find.byKey(const Key('phuong-trang-detail-arrow'));
    await tester.ensureVisible(arrow);
    await tester.pumpAndSettle();
    await tester.tap(arrow);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('trip-detail-screen')), findsOneWidget);
    expect(find.text('Chi tiết chuyến'), findsOneWidget);
    expect(find.text('Bản đồ tuyến đường'), findsOneWidget);
    expect(find.text('Chọn chỗ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chi tiết chuyến cuộn trên màn hình nhỏ không overflow', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      home: const TripDetailScreen(),
      width: 320,
      height: 568,
    );

    expect(find.text('Phương Trang'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('trip-detail-scroll')),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tiện ích trên xe'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nút quay lại trở về danh sách chuyến', (tester) async {
    await _pumpApp(tester, home: TicketScreen(onTabSelected: (_) {}));

    final arrow = find.byKey(const Key('phuong-trang-detail-arrow'));
    await tester.ensureVisible(arrow);
    await tester.pumpAndSettle();
    await tester.tap(arrow);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('trip-detail-back')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ticket-screen')), findsOneWidget);
    expect(find.byKey(const Key('trip-detail-screen')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
