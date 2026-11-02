import 'package:passenger_mobile/features/home/home_models.dart';

/// Điểm đón hoặc trả của một chuyến trong kết quả tìm.
class TripStopSummary {
  const TripStopSummary({
    required this.sequence,
    required this.name,
    required this.address,
    required this.plannedAt,
  });

  /// Thứ tự điểm trong chuyến — dùng khi giữ chỗ / đặt vé.
  final int sequence;
  final String name;
  final String address;
  final DateTime plannedAt;
}

/// Một chuyến trong kết quả tìm chuyến (`GET /trips/search`).
class TripSummary {
  const TripSummary({
    required this.tripId,
    required this.operatorId,
    required this.operatorName,
    required this.reviewCount,
    required this.vehicleTypeName,
    required this.pickup,
    required this.dropoff,
    required this.durationMinutes,
    required this.availableSeats,
    required this.minPrice,
    required this.amenityNames,
    this.averageRating,
    this.operatorLogoUrl,
    this.coverImageUrl,
    this.segmentTitle,
  });

  final String tripId;
  final String operatorId;
  final String operatorName;
  /// Logo công khai của nhà xe; chưa có ảnh thì dùng chữ cái đầu.
  final String? operatorLogoUrl;
  final double? averageRating;
  final int reviewCount;
  final String vehicleTypeName;
  final TripStopSummary pickup;
  final TripStopSummary dropoff;
  final int durationMinutes;
  final int availableSeats;

  /// Giá thấp nhất trong các chỗ còn trống, VND.
  final int minPrice;
  final List<String> amenityNames;
  final String? coverImageUrl;

  /// Chặng theo nơi đón / trả (API ghép, vd "TP.HCM → Gia Nghĩa"); `null` = không có.
  final String? segmentTitle;

  /// Một đầu của [segmentTitle] (0 = nơi đón, 1 = nơi trả); không có → `null`.
  String? segmentPart(int index) {
    final parts = segmentTitle?.split(' → ');
    return parts != null && parts.length == 2 ? parts[index] : null;
  }
}

/// Nhà xe có trong kết quả tìm (trước khi lọc), kèm số chuyến.
class TripOperatorFacet {
  const TripOperatorFacet({
    required this.id,
    required this.name,
    required this.count,
  });

  final String id;
  final String name;
  final int count;
}

/// Một trang kết quả tìm chuyến kèm gợi ý bộ lọc.
class TripSearchPage {
  const TripSearchPage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.operators,
    this.priceMin,
    this.priceMax,
    this.widenedFrom = false,
    this.widenedTo = false,
  });

  final List<TripSummary> items;
  final int total;
  final int page;
  final int limit;
  final List<TripOperatorFacet> operators;

  /// Phía đi / đến là phường / xã hoặc khu vực mà không có chuyến → API đã nới
  /// ra cả tỉnh chứa nó; màn kết quả nhắc khách xem điểm đón / trả từng chuyến.
  final bool widenedFrom;
  final bool widenedTo;

  /// Khoảng giá của toàn bộ kết quả trước khi lọc thêm; `null` khi không có chuyến.
  final int? priceMin;
  final int? priceMax;

  bool get hasMore => page * limit < total;
}

/// Tiện ích lọc được (danh mục `GET /catalog/amenities`).
class TripAmenityOption {
  const TripAmenityOption({required this.id, required this.name});

  final String id;
  final String name;
}

/// Dạng chỗ của xe (BR-77).
enum TripVehicleForm {
  seater('SEATER', 'Ghế ngồi'),
  sleeper('SLEEPER', 'Giường nằm'),
  cabin('CABIN', 'Cabin');

  const TripVehicleForm(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

/// Hạng xe (BR-77) — limousine là hạng, không phải dạng chỗ.
enum TripVehicleClass {
  standard('STANDARD', 'Thường'),
  limousine('LIMOUSINE', 'Limousine');

  const TripVehicleClass(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

/// Khung giờ đón (giờ VN) để lọc.
enum TripDepartureSlot {
  earlyMorning('Sáng sớm', '00:00', '05:59'),
  morning('Sáng', '06:00', '11:59'),
  afternoon('Chiều', '12:00', '17:59'),
  evening('Tối', '18:00', '23:59');

  const TripDepartureSlot(this.label, this.from, this.to);

  final String label;
  final String from;
  final String to;

  String get range => '$from – ${to == '23:59' ? '24:00' : to}';
}

/// Cách sắp xếp kết quả tìm chuyến.
enum TripSearchSort {
  departure('departure', 'Khởi hành sớm nhất'),
  price('price', 'Giá từ thấp đến cao'),
  priceDesc('price_desc', 'Giá từ cao đến thấp'),
  duration('duration', 'Thời gian di chuyển ngắn nhất'),
  rating('rating', 'Đánh giá cao nhất');

  const TripSearchSort(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

/// Bộ lọc + sắp xếp kết quả tìm chuyến; ánh xạ thẳng tham số `/trips/search`.
class TripSearchFilters {
  const TripSearchFilters({
    this.vehicleForm,
    this.vehicleClass,
    this.departureSlot,
    this.priceMin,
    this.priceMax,
    this.amenityIds = const {},
    this.operatorId,
    this.sort = TripSearchSort.departure,
  });

  final TripVehicleForm? vehicleForm;
  final TripVehicleClass? vehicleClass;
  final TripDepartureSlot? departureSlot;
  final int? priceMin;
  final int? priceMax;
  final Set<String> amenityIds;

  /// Lọc một nhà xe trong kết quả (API chỉ nhận một nhà xe).
  final String? operatorId;
  final TripSearchSort sort;

  /// Số tiêu chí lọc đang bật (không tính sắp xếp).
  int get activeCount =>
      (vehicleForm == null ? 0 : 1) +
      (vehicleClass == null ? 0 : 1) +
      (departureSlot == null ? 0 : 1) +
      (priceMin == null && priceMax == null ? 0 : 1) +
      amenityIds.length +
      (operatorId == null ? 0 : 1);

  TripSearchFilters withSort(TripSearchSort value) => TripSearchFilters(
    vehicleForm: vehicleForm,
    vehicleClass: vehicleClass,
    departureSlot: departureSlot,
    priceMin: priceMin,
    priceMax: priceMax,
    amenityIds: amenityIds,
    operatorId: operatorId,
    sort: value,
  );

  /// Bỏ hết tiêu chí lọc, giữ cách sắp xếp.
  TripSearchFilters cleared() => TripSearchFilters(sort: sort);
}

/// Hàm tìm một trang chuyến theo điều kiện tìm + bộ lọc.
/// Xem chuyến sắp chạy không cần điểm đi / đến hay ngày (tab Mua vé chưa tìm lần nào).
typedef TripBrowseRunner =
    Future<TripSearchPage> Function(TripSearchFilters filters, int page);

typedef TripSearchRunner = Future<TripSearchPage> Function(
  HomeSearchQuery query,
  TripSearchFilters filters,
  int page,
);

/// `390` phút → `6h30`; `360` → `6h`.
String formatTripDuration(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (hours == 0) return '${rest}p';
  return rest == 0
      ? '${hours}h'
      : '${hours}h${rest.toString().padLeft(2, '0')}';
}

/// `Thứ Tư, 28/10/2026` theo giờ Việt Nam (UTC+7).
String formatVnDate(DateTime value) {
  const weekdays = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ nhật',
  ];
  final vn = value.toUtc().add(const Duration(hours: 7));
  String two(int part) => part.toString().padLeft(2, '0');
  return '${weekdays[vn.weekday - 1]}, ${two(vn.day)}/${two(vn.month)}/${vn.year}';
}

/// `Thứ 2` … `Thứ 7`, `Chủ nhật` của một ngày theo lịch (ngày đi người dùng chọn).
String formatVnWeekday(DateTime day) =>
    day.weekday == DateTime.sunday ? 'Chủ nhật' : 'Thứ ${day.weekday + 1}';

/// Giờ:phút theo giờ Việt Nam (UTC+7) của một mốc thời gian.
String formatVnClock(DateTime value) {
  final vn = value.toUtc().add(const Duration(hours: 7));
  String two(int part) => part.toString().padLeft(2, '0');
  return '${two(vn.hour)}:${two(vn.minute)}';
}
