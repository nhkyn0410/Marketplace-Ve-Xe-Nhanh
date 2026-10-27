import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

/// Chuyến mẫu: đón Miền Đông (1) / Dầu Giây (2), trạm nghỉ (3), trả Bảo Lộc (4) / Đà Lạt (5);
/// giường 2 tầng 2 × 2, A02 không đặt được.
TripDetail sampleTripDetail() {
  final start = DateTime.utc(2026, 10, 30); // 07:00 giờ VN
  TripStop stop(
    int sequence,
    String name,
    int hours, {
    bool pickup = false,
    bool dropoff = false,
    String type = 'BUS_STATION',
  }) => TripStop(
    sequence: sequence,
    name: name,
    address: 'Địa chỉ $name',
    type: type,
    plannedAt: start.add(Duration(hours: hours)),
    allowPickup: pickup,
    allowDropoff: dropoff,
  );
  TripSeat seat(
    String code,
    int deck,
    int row,
    int column, {
    bool available = true,
  }) => TripSeat(
    code: code,
    deck: deck,
    row: row,
    column: column,
    type: 'BED',
    available: available,
    price: 300000,
  );
  return TripDetail(
    tripId: 'trip-1',
    operatorName: 'Nhà xe Sao Mai',
    averageRating: 4.7,
    reviewCount: 12,
    routeName: 'Sài Gòn – Đà Lạt',
    departureAt: start,
    arrivalAt: start.add(const Duration(hours: 7)),
    vehicleTypeName: 'Giường nằm Limousine',
    amenityNames: const ['Wi-Fi', 'Điều hòa', 'Nước uống'],
    imageUrls: const [],
    stops: [
      stop(1, 'Bến xe Miền Đông mới', 0, pickup: true),
      stop(
        2,
        'Ngã ba Dầu Giây',
        1,
        pickup: true,
        dropoff: true,
        type: 'PICKUP_POINT',
      ),
      stop(3, 'Trạm dừng nghỉ Bảo Lộc', 3, type: 'REST_STOP'),
      stop(4, 'Bến xe Bảo Lộc', 4, dropoff: true),
      stop(5, 'Bến xe liên tỉnh Đà Lạt', 7, dropoff: true),
    ],
    seats: [
      seat('A01', 1, 1, 1),
      seat('A02', 1, 1, 2, available: false),
      seat('A03', 1, 2, 1),
      seat('A04', 1, 2, 2),
      seat('B01', 2, 1, 1),
      seat('B02', 2, 1, 2),
    ],
    cancellationTiers: const [
      CancellationTier(minHoursBefore: 24, refundPercent: 90),
      CancellationTier(minHoursBefore: 4, refundPercent: 50),
    ],
  );
}

/// Phiên giữ chỗ mẫu: [seats] ở chuyến mẫu, đón 1 / trả 5, 300.000 ₫ mỗi chỗ.
SeatHold sampleHold({List<String> seats = const ['A01', 'A03']}) {
  final trip = sampleTripDetail();
  final pickup = trip.stopAt(1)!;
  final dropoff = trip.stopAt(5)!;
  return SeatHold(
    holdId: 'hold-1',
    tripId: trip.tripId,
    pickup: SeatHoldStop(
      sequence: 1,
      name: pickup.name,
      plannedAt: pickup.plannedAt,
    ),
    dropoff: SeatHoldStop(
      sequence: 5,
      name: dropoff.name,
      plannedAt: dropoff.plannedAt,
    ),
    seats: [
      for (final code in seats)
        HeldSeat(code: code, type: 'BED', price: 300000),
    ],
    subtotal: seats.length * 300000,
    expiresAt: DateTime.now().add(const Duration(minutes: 10)),
  );
}

/// Đơn mẫu chờ thanh toán: 2 chỗ, giảm 50.000 ₫, hạn sau 8 phút.
CreatedBooking sampleBooking() {
  final trip = sampleTripDetail();
  return CreatedBooking(
    bookingId: 'booking-1',
    bookingCode: 'VXN-ABC123',
    status: 'PENDING_PAYMENT',
    routeName: trip.routeName,
    operatorName: trip.operatorName,
    vehicleTypeName: trip.vehicleTypeName,
    pickupName: trip.stopAt(1)!.name,
    pickupAt: trip.stopAt(1)!.plannedAt,
    dropoffName: trip.stopAt(5)!.name,
    dropoffAt: trip.stopAt(5)!.plannedAt,
    contact: const BookingContact(
      fullName: 'Lê Văn An',
      phone: '0901234567',
      email: 'an@vidu.com',
    ),
    passengers: const [
      BookedPassenger(seatCode: 'A01', fullName: 'Lê Văn An', price: 300000),
      BookedPassenger(
        seatCode: 'A03',
        fullName: 'Trần Thị Bình',
        price: 300000,
      ),
    ],
    subtotal: 600000,
    serviceFee: 0,
    discount: 50000,
    total: 550000,
    expiresAt: DateTime.now().add(const Duration(minutes: 8)),
    accessToken: 'token',
  );
}

/// [TripBookingApi] giả: trả chuyến mẫu, ghi lại các lần giữ / bỏ giữ chỗ.
class FakeBookingApi implements TripBookingApi {
  FakeBookingApi({TripDetail? trip, this.holdError})
    : trip = trip ?? sampleTripDetail();

  TripDetail trip;

  /// Lỗi ném ra ở lần giữ chỗ tiếp theo (rồi xoá).
  ApiFailure? holdError;
  int loads = 0;
  final holds = <({List<String> seats, int pickup, int dropoff})>[];
  final released = <String>[];

  @override
  Future<TripDetail> loadTrip(String tripId) async {
    loads++;
    return trip;
  }

  @override
  Future<SeatHold> holdSeats({
    required String tripId,
    required List<String> seatCodes,
    required int pickupSequence,
    required int dropoffSequence,
  }) async {
    final error = holdError;
    if (error != null) {
      holdError = null;
      throw error;
    }
    holds.add((
      seats: seatCodes,
      pickup: pickupSequence,
      dropoff: dropoffSequence,
    ));
    final pickup = trip.stopAt(pickupSequence)!;
    final dropoff = trip.stopAt(dropoffSequence)!;
    return SeatHold(
      holdId: 'hold-${holds.length}',
      tripId: tripId,
      pickup: SeatHoldStop(
        sequence: pickup.sequence,
        name: pickup.name,
        plannedAt: pickup.plannedAt,
      ),
      dropoff: SeatHoldStop(
        sequence: dropoff.sequence,
        name: dropoff.name,
        plannedAt: dropoff.plannedAt,
      ),
      seats: [
        for (final code in seatCodes)
          HeldSeat(code: code, type: 'BED', price: 300000),
      ],
      subtotal: seatCodes.length * 300000,
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<void> releaseHold(String holdId) async => released.add(holdId);

  /// Dữ liệu điền sẵn (khách đã đăng nhập); `null` = khách vãng lai.
  BookingPrefill? prefill;

  /// Mã khuyến mãi hợp lệ: giảm 50.000 ₫.
  String validPromotion = 'GIAM50';

  /// Lỗi ném ra ở lần tạo đơn tiếp theo (rồi xoá).
  ApiFailure? bookingError;

  /// Giá mỗi chỗ khi đọc lại phiên giữ chỗ (mô phỏng bảng giá vừa đổi).
  int reloadedSeatPrice = 300000;
  final bookings = <({String holdId, BookingDraft draft, int expectedTotal})>[];

  @override
  Future<BookingPrefill?> loadPrefill() async => prefill;

  @override
  Future<PromotionQuote> checkPromotion({
    required String tripId,
    required String code,
    required int subtotal,
  }) async {
    if (code != validPromotion) {
      throw const ApiFailure(
        status: 422,
        code: 'PROMOTION_INVALID',
        detail: 'Mã khuyến mãi không tồn tại hoặc đã hết hạn.',
      );
    }
    return PromotionQuote(
      code: code,
      name: 'Giảm 50K',
      discount: 50000,
      total: subtotal - 50000,
    );
  }

  @override
  Future<SeatHold> reloadHold(String holdId) async {
    final pickup = trip.stopAt(1)!;
    final dropoff = trip.stopAt(5)!;
    // Chưa giữ chỗ qua fake thì coi như phiên mẫu `sampleHold()` (A01, A03).
    final seats = holds.isEmpty ? const ['A01', 'A03'] : holds.last.seats;
    return SeatHold(
      holdId: holdId,
      tripId: trip.tripId,
      pickup: SeatHoldStop(
        sequence: 1,
        name: pickup.name,
        plannedAt: pickup.plannedAt,
      ),
      dropoff: SeatHoldStop(
        sequence: 5,
        name: dropoff.name,
        plannedAt: dropoff.plannedAt,
      ),
      seats: [
        for (final code in seats)
          HeldSeat(code: code, type: 'BED', price: reloadedSeatPrice),
      ],
      subtotal: seats.length * reloadedSeatPrice,
      expiresAt: DateTime.now().add(const Duration(minutes: 9)),
    );
  }

  @override
  Future<CreatedBooking> createBooking({
    required String holdId,
    required BookingDraft draft,
    required int expectedTotal,
  }) async {
    final error = bookingError;
    if (error != null) {
      bookingError = null;
      throw error;
    }
    bookings.add((holdId: holdId, draft: draft, expectedTotal: expectedTotal));
    final discount = draft.promotion?.discount ?? 0;
    return CreatedBooking(
      bookingId: 'booking-1',
      bookingCode: 'VXN-ABC123',
      status: 'PENDING_PAYMENT',
      routeName: trip.routeName,
      operatorName: trip.operatorName,
      vehicleTypeName: trip.vehicleTypeName,
      pickupName: trip.stopAt(1)!.name,
      pickupAt: trip.stopAt(1)!.plannedAt,
      dropoffName: trip.stopAt(5)!.name,
      dropoffAt: trip.stopAt(5)!.plannedAt,
      contact: draft.contact,
      passengers: [
        for (final passenger in draft.passengers)
          BookedPassenger(
            seatCode: passenger.seatCode,
            fullName: passenger.fullName,
            price: 300000,
          ),
      ],
      subtotal: expectedTotal + discount,
      serviceFee: 0,
      discount: discount,
      total: expectedTotal,
      expiresAt: DateTime.now().add(const Duration(minutes: 8)),
      accessToken: 'token',
    );
  }

  @override
  Future<List<HomeLocation>> loadProvinces() async => const [];

  @override
  Future<List<HomeLocation>> searchStopPoints(String keyword) async => const [];

  @override
  Future<List<HomeOperator>> loadOperators() async => const [];

  @override
  Future<List<TripAmenityOption>> loadAmenities() async => const [];

  @override
  Future<TripSearchPage> searchTrips(
    HomeSearchQuery query,
    TripSearchFilters filters,
    int page,
  ) async => const TripSearchPage(
    items: [],
    total: 0,
    page: 1,
    limit: 20,
    operators: [],
  );
}
