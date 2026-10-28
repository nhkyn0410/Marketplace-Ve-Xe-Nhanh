import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';

import 'support/fake_booking_api.dart';
import 'support/trip_search_fakes.dart';

Widget _detail() => TripDetailScreen(api: FakeBookingApi(), tripId: 'trip-1');

Widget _ticketWithOneTrip() => Builder(
  builder: (context) => TicketScreen(
    onTabSelected: (_) {},
    searchCatalog: fakeCatalog(),
    initialQuery: sampleQuery,
    searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
    onTripSelected: (trip, query) => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _detail()),
    ),
  ),
);

Future<void> _pumpApp(
  WidgetTester tester, {
  required Widget home,
  double width = 412,
  double height = 900,
  double textScaleFactor = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  tester.platformDispatcher.textScaleFactorTestValue = textScaleFactor;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

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

void _expectNoFlutterException(WidgetTester tester) {
  final exception = tester.takeException();
  expect(
    exception,
    isNull,
    reason: exception is FlutterError ? exception.toStringDeep() : '$exception',
  );
}

void main() {
  testWidgets('bấm thẻ chuyến mở màn chi tiết chuyến', (tester) async {
    await _pumpApp(tester, home: _ticketWithOneTrip());

    final card = find.byKey(const ValueKey('ticket-trip-t1'));
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('trip-detail-screen')), findsOneWidget);
    expect(find.text('Chi tiết chuyến'), findsOneWidget);
    expect(find.text('Chọn chỗ'), findsOneWidget);
    _expectNoFlutterException(tester);
  });

  testWidgets('chi tiết chuyến cuộn trên màn hình nhỏ không overflow', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      home: _detail(),
      width: 320,
      height: 568,
    );

    expect(find.text('Nhà xe Sao Mai'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Tiện ích trên xe'),
      find.byKey(const Key('trip-detail-scroll')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tiện ích trên xe'), findsOneWidget);
    _expectNoFlutterException(tester);
  });

  testWidgets('header cố định khi nội dung cuộn', (tester) async {
    await _pumpApp(tester, home: _detail());

    final header = find.byKey(const Key('trip-detail-header'));
    final initialTop = tester.getTopLeft(header).dy;

    await tester.dragFrom(const Offset(206, 450), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết chuyến'), findsOneWidget);
    expect(tester.getTopLeft(header).dy, initialTop);
    _expectNoFlutterException(tester);
  });

  testWidgets('nút Xem nhà xe vừa với nội dung', (tester) async {
    await _pumpApp(tester, home: _detail());

    final operatorLink = find.byKey(const Key('trip-detail-operator-link'));
    final operatorLinkContent = find.byKey(
      const Key('trip-detail-operator-link-content'),
    );

    expect(operatorLink, findsOneWidget);
    expect(
      tester.getSize(operatorLink).width,
      closeTo(tester.getSize(operatorLinkContent).width + 20, 0.1),
    );
    _expectNoFlutterException(tester);
  });

  for (final width in [360.0, 430.0]) {
    testWidgets('không overflow ở ${width.toInt()}dp với cỡ chữ hệ thống lớn', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        home: _detail(),
        width: width,
        height: 800,
        textScaleFactor: 1.6,
      );

      for (var index = 0; index < 5; index += 1) {
        await tester.dragFrom(Offset(width / 2, 400), const Offset(0, -600));
        await tester.pumpAndSettle();
        _expectNoFlutterException(tester);
      }

      expect(find.byKey(const Key('trip-detail-header')), findsOneWidget);
      expect(find.text('Chọn chỗ'), findsOneWidget);
    });
  }

  testWidgets('nút quay lại trở về danh sách chuyến', (tester) async {
    await _pumpApp(tester, home: _ticketWithOneTrip());

    final card = find.byKey(const ValueKey('ticket-trip-t1'));
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('trip-detail-back')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ticket-screen')), findsOneWidget);
    expect(find.byKey(const Key('trip-detail-screen')), findsNothing);
    _expectNoFlutterException(tester);
  });
}
