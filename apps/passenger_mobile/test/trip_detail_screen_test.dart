import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
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
  testWidgets('logo nhà xe đi theo chuyến từ chi tiết qua chọn chỗ tới xác nhận', (
    tester,
  ) async {
    const logo = 'https://cdn.example.test/sao-mai-logo.png';
    final api = FakeBookingApi(trip: sampleTripDetail(operatorLogoUrl: logo));
    final avatar = find.byType(OperatorInitialAvatar);
    final logoImage = find.byWidgetPredicate(
      (widget) => widget is Image && widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == logo,
    );
    void expectLogo() {
      expect(avatar, findsOneWidget);
      expect(tester.widget<OperatorInitialAvatar>(avatar).logoUrl, logo);
      expect(find.descendant(of: avatar, matching: logoImage), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await _pumpApp(tester, home: TripDetailScreen(api: api, tripId: api.trip.tripId));
    expectLogo();
    await tester.tap(find.byKey(const Key('trip-detail-cta')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('seat-selection-screen')), findsOneWidget);
    expectLogo();
    await tester.tap(find.byKey(const Key('seat-A01')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('contact-name-field')), 'Lê Văn An');
    await tester.enterText(find.byKey(const Key('contact-email-field')), 'an@example.com');
    await tester.enterText(find.byKey(const Key('contact-phone-field')), '0901234567');
    await tester.pump();
    await tester.tap(find.byKey(const Key('passenger-information-continue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('booking-confirmation-screen')), findsOneWidget);
    expectLogo();
  });

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

  testWidgets('xe chỉ có một ảnh vẫn dùng ảnh thật ở phần tóm tắt', (
    tester,
  ) async {
    const image = 'https://cdn.example.test/vehicle.jpg';
    await _pumpApp(
      tester,
      home: TripDetailScreen(
        api: FakeBookingApi(trip: sampleTripDetail(imageUrls: [image])),
        tripId: 'trip-1',
      ),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is NetworkImage &&
            (widget.image as NetworkImage).url == image,
      ),
      findsNWidgets(2),
    );
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

  testWidgets(
    'chặng (3.3): tải chi tiết theo chặng của lần tìm; nhãn thành phố theo chặng, không theo chữ trên ô tìm',
    (tester) async {
      final base = sampleTripDetail();
      final api = FakeBookingApi(
        trip: TripDetail(
          tripId: base.tripId,
          operatorName: base.operatorName,
          averageRating: base.averageRating,
          reviewCount: base.reviewCount,
          routeName: base.routeName,
          segmentTitle: 'Dầu Giây → Bảo Lộc',
          departureAt: base.departureAt,
          arrivalAt: base.arrivalAt,
          vehicleTypeName: base.vehicleTypeName,
          amenityNames: base.amenityNames,
          imageUrls: base.imageUrls,
          stops: base.stops,
          seats: base.seats,
          cancellationTiers: base.cancellationTiers,
        ),
      );
      await _pumpApp(
        tester,
        home: TripDetailScreen(
          api: api,
          tripId: 'trip-1',
          fromLabel: 'TP. Hồ Chí Minh',
          toLabel: 'Lâm Đồng',
          pickupSequence: 2,
          dropoffSequence: 4,
        ),
      );

      expect(api.loadedLegs.first, (pickup: 2, dropoff: 4));
      expect(find.text('Dầu Giây'), findsWidgets);
      expect(find.text('Bảo Lộc'), findsWidgets);
      expect(find.text('TP. Hồ Chí Minh'), findsNothing);
      await tester.ensureVisible(
        find.byKey(const Key('trip-segment-itinerary')),
      );
      await tester.pumpAndSettle();
      final schedule = find.byKey(const Key('trip-segment-itinerary'));
      for (final stop in base.stops) {
        expect(
          find.descendant(of: schedule, matching: find.text(stop.name)),
          stop.sequence >= 2 && stop.sequence <= 4
              ? findsOneWidget
              : findsNothing,
        );
      }
      expect(find.text('3 điểm dừng'), findsOneWidget);
      _expectNoFlutterException(tester);
    },
  );
}
