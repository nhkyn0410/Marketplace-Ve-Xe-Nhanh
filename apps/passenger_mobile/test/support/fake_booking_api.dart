import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
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
