import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';

Future<void> _pumpTicket(
  WidgetTester tester, {
  required double width,
  double height = 800,
  double textScale = 1,
  ValueChanged<int>? onTabSelected,
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
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: TicketScreen(onTabSelected: onTabSelected ?? (_) {}),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Mua vé responsive không bottom overflow ở các viewport', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 375, 390, 412, 430, 480]) {
      await _pumpTicket(tester, width: width, height: 720);
      expect(find.byKey(const Key('ticket-screen')), findsOneWidget);
      expect(find.byKey(const Key('ticket-journey-planner')), findsOneWidget);
      expect(find.byKey(const Key('route-dock-tabbar')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets('màn hình thấp và cỡ chữ lớn vẫn cuộn không overflow', (
    tester,
  ) async {
    await _pumpTicket(tester, width: 320, height: 568, textScale: 1.5);

    await tester.drag(
      find.byKey(const Key('ticket-content-scroll')),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();

    expect(find.text('Điền Linh'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chuyển Theo chuyến và Theo nhà xe giữ animation', (
    tester,
  ) async {
    await _pumpTicket(tester, width: 390);
    final indicator = find.byKey(const Key('ticket-search-mode-indicator'));
    final startX = tester.getCenter(indicator).dx;

    await tester.tap(find.byKey(const Key('ticket-mode-operator')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final movingX = tester.getCenter(indicator).dx;

    expect(movingX, greaterThan(startX));
    expect(find.byKey(const ValueKey('ticket-operator-input')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Phương Trang'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ba thẻ chuyến giữ đúng nội dung Figma', (tester) async {
    await _pumpTicket(tester, width: 412, height: 1000);

    expect(
      find.byKey(const ValueKey('ticket-trip-Phương Trang')),
      findsOneWidget,
    );
    expect(find.text('280.000 ₫'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('ticket-content-scroll')),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('ticket-trip-Điền Linh')), findsOneWidget);
    expect(find.text('250.000 ₫'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom sheet bộ lọc cuộn và áp dụng không overflow', (
    tester,
  ) async {
    await _pumpTicket(tester, width: 320, height: 568, textScale: 1.3);

    await tester.drag(
      find.byKey(const Key('ticket-content-scroll')),
      const Offset(0, -140),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.ensureVisible(find.byKey(const Key('ticket-filter-chip')));
    await tester.tap(find.byKey(const Key('ticket-filter-chip')));
    await tester.pumpAndSettle();
    expect(find.text('Lọc chuyến'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Nhà xe'),
      350,
      scrollable: find.descendant(
        of: find.byKey(const Key('ticket-filter-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nhà xe'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('ticket-filter-apply')));
    await tester.pumpAndSettle();
    expect(find.text('Lọc chuyến'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
