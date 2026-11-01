/// Một điểm dừng của chuyến (`GET /trips/{tripId}`).
class TripStop {
  const TripStop({
    required this.sequence,
    required this.name,
    required this.address,
    required this.type,
    required this.plannedAt,
    required this.allowPickup,
    required this.allowDropoff,
    this.pickupOpen = true,
  });

  /// Thứ tự điểm trong chuyến — gửi khi giữ chỗ.
  final int sequence;
  final String name;
  final String address;

  /// `BUS_STATION`, `PICKUP_POINT`, `OFFICE`, `REST_STOP`…
  final String type;
  final DateTime plannedAt;
  final bool allowPickup;
  final bool allowDropoff;

  /// Điểm đón còn bán online — giờ ngừng bán tính theo giờ xe tới điểm này (3.3).
  final bool pickupOpen;
}

/// Một chỗ trên sơ đồ của chuyến.
class TripSeat {
  const TripSeat({
    required this.code,
    required this.deck,
    required this.row,
    required this.column,
    required this.type,
    required this.available,
    this.price,
  });

  final String code;
  final int deck;
  final int row;
  final int column;

  /// `SEAT`, `BED`, `BED_DOUBLE`, `CABIN`, `CABIN_DOUBLE`.
  final String type;

  /// API gộp đã bán / đang giữ / khóa thành "không đặt được".
  final bool available;

  /// VND; `null` = chỗ chưa có giá, không đặt được.
  final int? price;

  bool get bookable => available && price != null;
}

/// Mốc hủy vé: hủy khi còn ít nhất [minHoursBefore] giờ thì hoàn [refundPercent]%.
class CancellationTier {
  const CancellationTier({
    required this.minHoursBefore,
    required this.refundPercent,
  });

  final int minHoursBefore;
  final int refundPercent;
}

/// Chi tiết chuyến đang mở bán: nhà xe, lịch trình, xe, sơ đồ chỗ + giá, chính sách hủy.
class TripDetail {
  const TripDetail({
    required this.tripId,
    required this.operatorName,
    required this.reviewCount,
    required this.routeName,
    required this.departureAt,
    required this.arrivalAt,
    required this.vehicleTypeName,
    required this.amenityNames,
    required this.imageUrls,
    required this.stops,
    required this.seats,
    required this.cancellationTiers,
    this.operatorId,
    this.operatorHotline,
    this.operatorLogoUrl,
    this.averageRating,
    this.note,
    this.segmentTitle,
  });

  final String tripId;

  /// Dùng để mở trang nhà xe.
  final String? operatorId;
  final String operatorName;
  /// Logo công khai của nhà xe, dùng xuyên suốt luồng đặt vé.
  final String? operatorLogoUrl;
  final String? operatorHotline;
  final double? averageRating;
  final int reviewCount;
  final String routeName;

  /// Chặng khách đi theo nơi đón / trả (3.3), vd "TP.HCM → Gia Nghĩa"; `null` khi tải không kèm chặng.
  final String? segmentTitle;
  final DateTime departureAt;
  final DateTime arrivalAt;
  final String? note;
  final String vehicleTypeName;
  final List<String> amenityNames;
  final List<String> imageUrls;
  final List<TripStop> stops;
  final List<TripSeat> seats;
  final List<CancellationTier> cancellationTiers;

  /// Điểm đón còn bán online (đã qua giờ ngừng bán thì không chọn được — 3.3).
  List<TripStop> get pickupStops => stops
      .where((stop) => stop.allowPickup && stop.pickupOpen)
      .toList(growable: false);

  /// Điểm trả hợp lệ sau điểm đón [pickupSequence].
  List<TripStop> dropoffStopsAfter(int pickupSequence) => stops
      .where((stop) => stop.allowDropoff && stop.sequence > pickupSequence)
      .toList(growable: false);

  TripStop? stopAt(int sequence) {
    for (final stop in stops) {
      if (stop.sequence == sequence) return stop;
    }
    return null;
  }

  /// Giá thấp nhất trong các chỗ còn đặt được.
  int? get minPrice {
    int? lowest;
    for (final seat in seats) {
      final price = seat.price;
      if (!seat.bookable || price == null) continue;
      if (lowest == null || price < lowest) lowest = price;
    }
    return lowest;
  }
}

/// Điểm đón / trả ghi trong phiên giữ chỗ.
class SeatHoldStop {
  const SeatHoldStop({
    required this.sequence,
    required this.name,
    required this.plannedAt,
  });

  final int sequence;
  final String name;
  final DateTime plannedAt;
}

/// Một chỗ đã giữ kèm giá lúc giữ (VND).
class HeldSeat {
  const HeldSeat({required this.code, required this.type, required this.price});

  final String code;
  final String type;
  final int price;
}

/// Phiên giữ chỗ (`POST /seat-holds`), hết hạn ở [expiresAt].
class SeatHold {
  const SeatHold({
    required this.holdId,
    required this.tripId,
    required this.pickup,
    required this.dropoff,
    required this.seats,
    required this.subtotal,
    required this.expiresAt,
  });

  final String holdId;
  final String tripId;
  final SeatHoldStop pickup;
  final SeatHoldStop dropoff;
  final List<HeldSeat> seats;

  /// Tổng giá vé lúc giữ, VND.
  final int subtotal;
  final DateTime expiresAt;

  List<String> get seatCodes => [for (final seat in seats) seat.code];
}
