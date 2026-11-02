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

TripDetail _withSeats(TripDetail trip, List<TripSeat> seats) => TripDetail(
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
  seats: seats,
);

/// Bản sao chuyến mẫu với chỗ [code] đã không còn đặt được.
TripDetail _withTaken(TripDetail trip, String code) => _withSeats(trip, [
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
]);

TripSeat _seat(String code, int row, int column, {String type = 'SEAT'}) =>
    TripSeat(
      code: code,
      deck: 1,
      row: row,
      column: column,
      type: type,
      available: true,
      price: 300000,
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
      expect(find.text('Sài Gòn – Đà Lạt'), findsNothing);
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
    expect(find.byKey(const Key('passenger-card-A01')), findsNothing);
    expect(find.byKey(const Key('passenger-card-A03')), findsOneWidget);

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

  testWidgets('xe nhiều ghế giữ lối đi và chọn được hàng cuối trên màn nhỏ', (
    tester,
  ) async {
    final api = FakeBookingApi(
      trip: _withSeats(sampleTripDetail(), [
        for (var row = 1; row <= 10; row++)
          for (var column = 1; column <= 5; column++)
            if (row == 10 || column != 3)
              _seat(
                'A${((row - 1) * 5 + column).toString().padLeft(2, '0')}',
                row,
                column,
              ),
      ]),
    );
    await _pumpApp(tester, home: _seats(api), width: 320, height: 568);

    final first = tester.getRect(find.byKey(const Key('seat-A01')));
    final second = tester.getRect(find.byKey(const Key('seat-A02')));
    final fourth = tester.getRect(find.byKey(const Key('seat-A04')));
    expect(first.width, greaterThanOrEqualTo(48));
    expect(first.height, greaterThanOrEqualTo(48));
    expect(fourth.top, first.top);
    expect(
      fourth.left - second.right,
      greaterThan(second.left - first.right + first.width),
    );
    expect(find.byKey(const Key('seat-A03')), findsNothing);
    expect(
      tester.getRect(find.byKey(const Key('seat-A46'))).top,
      greaterThan(tester.getRect(find.byKey(const Key('seat-A41'))).bottom),
    );

    await tester.ensureVisible(find.byKey(const Key('seat-A50')));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('seat-A50'))).bottom,
      lessThan(
        tester.getRect(find.byKey(const Key('seat-selection-continue'))).top,
      ),
    );
    await tester.tap(find.byKey(const Key('seat-A50')));
    await tester.pump();
    expect(find.text('1 chỗ — A50'), findsOneWidget);
    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();
    expect(api.holds.single.seats, ['A50']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sơ đồ rộng vuốt ngang, không thu nhỏ vùng bấm', (tester) async {
    final api = FakeBookingApi(
      trip: _withSeats(sampleTripDetail(), [
        for (var column = 1; column <= 10; column++)
          _seat('A${column.toString().padLeft(2, '0')}', 1, column),
      ]),
    );
    await _pumpApp(tester, home: _seats(api), width: 320);
    expect(find.text('Vuốt ngang để xem toàn bộ chỗ'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('seat-A10'))).width,
      greaterThanOrEqualTo(48),
    );
    await tester.drag(
      find.byKey(const Key('seat-map-horizontal-scroll')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('seat-A10')));
    await tester.pump();
    expect(find.text('1 chỗ — A10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ghế, giường, cabin có kích thước riêng; chỗ đôi giữ một mã', (
    tester,
  ) async {
    final api = FakeBookingApi(
      trip: _withSeats(sampleTripDetail(), [
        _seat('S01', 1, 1),
        _seat('B01', 1, 3, type: 'BED'),
        _seat('C01', 1, 5, type: 'CABIN'),
        _seat('D01', 2, 1, type: 'BED_DOUBLE'),
        _seat('D02', 2, 3, type: 'CABIN_DOUBLE'),
      ]),
    );
    await _pumpApp(tester, home: _seats(api));
    final seat = tester.getSize(find.byKey(const Key('seat-S01')));
    final bed = tester.getSize(find.byKey(const Key('seat-B01')));
    final cabin = tester.getSize(find.byKey(const Key('seat-C01')));
    final doubleBed = tester.getSize(find.byKey(const Key('seat-D01')));
    final doubleCabin = tester.getSize(find.byKey(const Key('seat-D02')));
    expect(seat.height, lessThan(bed.height));
    expect(bed.width, lessThan(cabin.width));
    expect(bed.width, lessThan(doubleBed.width));
    expect(cabin.width, lessThan(doubleCabin.width));
    expect(find.text('2 người'), findsNWidgets(2));

    await tester.ensureVisible(find.byKey(const Key('seat-D01')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('seat-D01')));
    await tester.pump();
    expect(find.text('1 chỗ — D01'), findsOneWidget);
    await tester.tap(find.byKey(const Key('seat-selection-continue')));
    await tester.pumpAndSettle();
    expect(api.holds.single.seats, ['D01']);
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
