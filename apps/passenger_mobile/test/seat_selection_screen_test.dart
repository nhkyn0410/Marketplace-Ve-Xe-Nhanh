import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/seat_selection_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';

Future<void> _pumpApp(
  WidgetTester tester, {
  Widget home = const SeatSelectionScreen(),
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
  testWidgets('nút Chọn chỗ từ chi tiết chuyến mở màn sơ đồ ghế', (
    tester,
  ) async {
    await _pumpApp(tester, home: const TripDetailScreen());

    await tester.tap(find.byKey(const Key('trip-detail-cta')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('seat-selection-screen')), findsOneWidget);
    expect(find.text('Chọn chỗ'), findsOneWidget);
    expect(find.text('TP.HCM → Đà Lạt'), findsOneWidget);
    expect(find.byKey(const Key('seat-A01')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đếm giữ ghế thật từ 10 phút theo SDLC', (tester) async {
    var now = DateTime(2026, 10, 26, 10);
    await _pumpApp(tester, home: SeatSelectionScreen(now: () => now));

    expect(find.text('10:00'), findsOneWidget);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('09:59'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nhiều ghế được truyền sang bước thông tin hành khách', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(
      tester.getSize(find.byKey(const Key('seat-bus-frame'))),
      const Size(185, 352),
    );
    await tester.ensureVisible(find.byKey(const Key('seat-A02')));
    await tester.tap(find.byKey(const Key('seat-A02')));
    await tester.pump();

    final selectedSeatCount = tester.widget<Text>(
      find.byKey(const Key('seat-selection-count')),
    );
    expect(selectedSeatCount.data, '2 ghế');
    expect(selectedSeatCount.style?.fontSize, 13);
    expect(find.text('2 ghế  –  A01, A02'), findsNothing);
    expect(find.text('560.000 đ'), findsOneWidget);

    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('passenger-information-screen')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('passenger-card-A01')), findsOneWidget);
    expect(find.byKey(const Key('passenger-card-A02')), findsOneWidget);
    expect(find.text('Số ghế\nđã chọn'), findsOneWidget);
    final summarySeatCount = tester.widget<Text>(
      find.byKey(const Key('selected-seat-count')),
    );
    expect(summarySeatCount.data, '2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet điểm đón chọn và xác nhận được', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('pickup-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pickup-sheet')), findsOneWidget);
    expect(find.text('Chọn điểm đón'), findsOneWidget);
    expect(find.text('Ngã tư Bình Phước'), findsOneWidget);

    await tester.tap(find.byKey(const Key('stop-07:20-Ngã tư Bình Phước')));
    await tester.tap(find.byKey(const Key('confirm-stop')));
    await tester.pumpAndSettle();

    expect(find.text('Ngã tư Bình Phước'), findsOneWidget);
    expect(find.byKey(const Key('pickup-sheet')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('màn nhỏ và sheet điểm trả không bottom overflow', (
    tester,
  ) async {
    await _pumpApp(tester, width: 320, height: 568);

    await tester.tap(find.byKey(const Key('dropoff-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('dropoff-sheet')), findsOneWidget);
    expect(find.text('Trung tâm Đà Lạt'), findsOneWidget);

    await tester.tap(find.byKey(const Key('stop-sheet-close')));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('seat-selection-scroll')),
      const Offset(0, -700),
    );
    await tester.pump();
    expect(find.text('Không khả dụng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
