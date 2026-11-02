import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

const hcm = HomeLocation(id: 'hcm', name: 'TP. Hồ Chí Minh');
const lamDong = HomeLocation(id: 'lam-dong', name: 'Lâm Đồng');
const khanhHoa = HomeLocation(id: 'khanh-hoa', name: 'Khánh Hòa');
const mienDong = HomeLocation(
  id: 'mien-dong',
  name: 'Bến xe Miền Đông',
  kind: HomeLocationKind.stopPoint,
  detail: '292 Đinh Bộ Lĩnh',
);

/// Khu vực (đơn vị hành chính cũ) như API gợi ý khi gõ "Đà Lạt".
const daLatArea = HomeLocation(
  id: '68-thanh-pho-da-lat',
  name: 'Đà Lạt',
  kind: HomeLocationKind.area,
  detail: 'Thành phố Đà Lạt cũ · nay thuộc Tỉnh Lâm Đồng',
);

const phuongTrang = HomeOperator(
  id: 'op-pt',
  name: 'Phương Trang',
  averageRating: 4.7,
  reviewCount: 12,
  routes: [
    HomeOperatorRoute(from: hcm, to: lamDong),
    HomeOperatorRoute(from: lamDong, to: hcm),
  ],
);

const thanhBuoi = HomeOperator(
  id: 'op-tb',
  name: 'Thành Bưởi',
  averageRating: 4.6,
  reviewCount: 980,
  routes: [HomeOperatorRoute(from: hcm, to: lamDong)],
);

const dienLinh = HomeOperator(
  id: 'op-dl',
  name: 'Điền Linh',
  averageRating: 4.9,
  reviewCount: 1200,
  routes: [HomeOperatorRoute(from: hcm, to: khanhHoa)],
);

final sampleQuery = HomeSearchQuery(
  mode: HomeSearchMode.route,
  from: hcm,
  to: lamDong,
  date: DateTime(2026, 10, 30),
  passengers: 1,
);

/// Chuyến mẫu; giờ là UTC nên 00:00Z = 07:00 giờ VN.
TripSummary sampleTrip(
  String id, {
  String operatorName = 'Phương Trang',
  int seats = 12,
  int price = 280000,
  double? rating = 4.7,
  int reviewCount = 12,
  String? operatorLogoUrl,
}) {
  return TripSummary(
    tripId: id,
    operatorId: 'op-$operatorName',
    operatorName: operatorName,
    operatorLogoUrl: operatorLogoUrl,
    averageRating: rating,
    reviewCount: reviewCount,
    vehicleTypeName: 'Limousine giường',
    pickup: TripStopSummary(
      sequence: 1,
      name: 'Bến xe Miền Đông',
      address: '292 Đinh Bộ Lĩnh',
      plannedAt: DateTime.utc(2026, 10, 30),
    ),
    dropoff: TripStopSummary(
      sequence: 3,
      name: 'Bến xe Đà Lạt',
      address: '01 Tô Hiến Thành',
      plannedAt: DateTime.utc(2026, 10, 30, 6, 30),
    ),
    durationMinutes: 390,
    availableSeats: seats,
    minPrice: price,
    amenityNames: const ['Wi-Fi', 'Nước uống'],
  );
}

TripSearchPage samplePage(
  List<TripSummary> items, {
  int total = -1,
  int page = 1,
  int limit = 20,
}) {
  return TripSearchPage(
    items: items,
    total: total < 0 ? items.length : total,
    page: page,
    limit: limit,
    operators: const [
      TripOperatorFacet(id: 'op-Phương Trang', name: 'Phương Trang', count: 2),
    ],
    priceMin: 250000,
    priceMax: 350000,
  );
}

/// Danh mục giả cho form tìm chuyến; [places] là gợi ý API trả cho mọi từ khóa.
TripSearchCatalog fakeCatalog({
  List<HomeLocation> provinces = const [hcm, lamDong],
  List<HomeLocation> places = const [hcm, daLatArea, mienDong],
  List<HomeOperator> operators = const [phuongTrang],
}) {
  return TripSearchCatalog(
    loadProvinces: () async => provinces,
    searchPlaces: (_) async => places,
    loadOperators: () async => operators,
    loadAmenities: () async => const [
      TripAmenityOption(id: 'wifi', name: 'Wi-Fi'),
    ],
  );
}

/// Một lần gọi tìm chuyến mà test ghi lại.
class SearchCall {
  SearchCall(this.query, this.filters, this.page);

  final HomeSearchQuery query;
  final TripSearchFilters filters;
  final int page;
}
