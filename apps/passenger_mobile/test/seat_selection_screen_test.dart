import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/ticket/seat_selection_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';

import 'support/fake_booking_api.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E8ABE)),
      ),
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

Widget _seats(FakeBookingApi api) => SeatSelectionScreen(
  api: api,
  trip: api.trip,
  pickupSequence: 1,
  dropoffSequence: 5,
);

/// Bản sao chuyến mẫu với chỗ [code] đã không còn đặt được.
TripDetail _withTaken(TripDetail trip, String code) => TripDetail(
  tripId: trip.tripId,
  operatorName: trip.operatorName,
  averageRating: trip.averageRating,
  reviewCount: trip.reviewCount,
  routeName: trip.routeName,
  departureAt: trip.departureAt,
  arrivalAt: trip.arrivalAt,
  vehicleTypeName: trip.vehicleTypeName,
  amenityNames: trip.amenityNames,
  imageUrls: trip.imageUrls,
  stops: trip.stops,
  cancellationTiers: trip.cancellationTiers,
  seats: [
    for (final seat in trip.seats)
      TripSeat(
        code: seat.code,
        deck: seat.deck,
        row: seat.row,
        column: seat.column,
        type: seat.type,
        available: seat.available && seat.code != code,
        price: seat.price,
      ),
  ],
);

void main() {
  testWidgets(
    'nút Chọn chỗ từ chi tiết chuyến mở sơ đồ chỗ theo dữ liệu chuyến',
    (tester) async {
      final api = FakeBookingApi();
      await _pumpApp(
        tester,
        home: TripDetailScreen(api: api, tripId: 'trip-1'),
      );

      await tester.tap(find.byKey(const Key('trip-detail-cta')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('seat-selection-screen')), findsOneWidget);
      expect(find.text('Sài Gòn – Đà Lạt'), findsOneWidget);
      expect(find.byKey(const Key('seat-A01')), findsOneWidget);
      // Chưa giữ chỗ thì chưa đếm giờ.
      expect(find.byKey(const Key('seat-hold-countdown')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'chỗ không đặt được bị khóa; chuyển tầng; tổng tiền theo giá từng chỗ',
    (tester) async {
      await _pumpApp(tester, home: _seats(FakeBookingApi()));

      await tester.tap(find.byKey(const Key('seat-A02')));
      await tester.tap(find.byKey(const Key('seat-A01')));
      await tester.pump();
      expect(find.text('1 chỗ — A01'), findsOneWidget);

      await tester.tap(find.byKey(const Key('seat-deck-2')));
      await tester.pump();
      expect(find.byKey(const Key('seat-A01')), findsNothing);
      await tester.tap(find.byKey(const Key('seat-B01')));
      await tester.pump();
      expect(find.text('2 chỗ — A01, B01'), findsOneWidget);
      expect(find.text('600.000 ₫'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Tiếp tục giữ chỗ với điểm đón / trả; quay lại thì bỏ giữ chỗ', (
    tester,
  ) async {
    final api = FakeBookingApi();
    await _pumpApp(tester, home: _seats(api));

    await tester.tap(find.byKey(const Key('seat-A03')));
    await tester.tap(find.byKey(const Key('seat-A01')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();

    expect(api.holds.single.seats, ['A01', 'A03']);
    expect(api.holds.single.pickup, 1);
    expect(api.holds.single.dropoff, 5);
    expect(
      find.byKey(const Key('passenger-information-screen')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('passenger-card-A01')), findsOneWidget);

    await tester.tap(find.byKey(const Key('passenger-information-back')));
    await tester.pumpAndSettle();
    expect(api.released, ['hold-1']);
    expect(find.byKey(const Key('seat-selection-screen')), findsOneWidget);
  });

  testWidgets(
    'chỗ vừa bị người khác giữ: báo lỗi, tải lại sơ đồ, bỏ chỗ đó khỏi lựa chọn',
    (tester) async {
      final api = FakeBookingApi(
        holdError: const ApiFailure(
          status: 409,
          code: 'SEAT_NOT_AVAILABLE',
          detail: 'x',
        ),
      );
      await _pumpApp(tester, home: _seats(api));
      await tester.tap(find.byKey(const Key('seat-A01')));
      await tester.pump();

      api.trip = _withTaken(api.trip, 'A01');
      await tester.tap(find.byKey(const Key('seat-selection-continue')));
      await tester.pumpAndSettle();

      expect(find.textContaining('vừa có người giữ hoặc đặt'), findsOneWidget);
      expect(find.text('Chưa chọn chỗ'), findsOneWidget);
      expect(
        find.byKey(const Key('passenger-information-screen')),
        findsNothing,
      );
    },
  );

  testWidgets('sheet điểm đón chỉ có điểm cho đón; điểm trả chỉ sau điểm đón', (
    tester,
  ) async {
    await _pumpApp(tester, home: _seats(FakeBookingApi()));

    await tester.tap(find.byKey(const Key('pickup-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pickup-sheet')), findsOneWidget);
    expect(find.text('Trạm dừng nghỉ Bảo Lộc'), findsNothing);
    await tester.tap(find.byKey(const Key('stop-2')));
    await tester.tap(find.byKey(const Key('confirm-stop')));
    await tester.pumpAndSettle();
    expect(find.text('Ngã ba Dầu Giây'), findsWidgets);

    await tester.tap(find.byKey(const Key('dropoff-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stop-2')), findsNothing);
    expect(find.byKey(const Key('stop-4')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('màn nhỏ không overflow', (tester) async {
    await _pumpApp(
      tester,
      home: _seats(FakeBookingApi()),
      width: 320,
      height: 568,
    );
    await tester.drag(
      find.byKey(const Key('seat-selection-scroll')),
      const Offset(0, -700),
    );
    await tester.pump();
    expect(find.text('Không đặt được'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
