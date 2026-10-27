import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

/// Lời gọi API của luồng tìm chuyến – đặt vé cho app hành khách; lỗi API ném ra dạng [ApiFailure].
class TripBookingApi {
  TripBookingApi(this._client);

  final ApiClientDart _client;
  List<HomeLocation>? _provinces;
  List<TripAmenityOption>? _amenities;

  /// Tỉnh/thành đang hoạt động, tên rút gọn ("TP. Hồ Chí Minh", "Lâm Đồng"); tải một lần mỗi phiên.
  Future<List<HomeLocation>> loadProvinces() async {
    final cached = _provinces;
    if (cached != null) return cached;
    final response = await _call(
      () => _client.getCatalogApi().catalogControllerListProvinces(),
    );
    return _provinces = [
      for (final item in response.data!.items)
        HomeLocation(id: item.id, name: shortProvinceName(item.name)),
    ];
  }

  /// Bến xe, địa danh dùng chung khớp từ khóa (không phân biệt dấu); bỏ trạm dừng nghỉ vì không đón / trả khách (BR-79).
  Future<List<HomeLocation>> searchStopPoints(String keyword) async {
    final response = await _call(
      () => _client.getCatalogApi().catalogControllerListStopPoints(
        q: keyword,
        limit: 20,
      ),
    );
    return [
      for (final item in response.data!.items)
        if (item.type.name != 'REST_STOP')
          HomeLocation(
            id: item.id,
            name: item.name,
            kind: HomeLocationKind.stopPoint,
            detail: item.address,
          ),
    ];
  }

  /// Nhà xe đang mở bán, mỗi nhà xe kèm tối đa 6 tuyến — nguồn của chế độ "Theo nhà xe".
  Future<List<HomeOperator>> loadOperators() async {
    final response = await _call(
      () => _client.getCatalogApi().catalogControllerListFeaturedOperators(
        limit: 20,
      ),
    );
    return [
      for (final item in response.data!.items)
        HomeOperator(
          id: item.operatorId,
          name: item.displayName,
          averageRating: item.averageRating?.toDouble(),
          reviewCount: item.reviewCount,
          routes: [
            for (final route in item.routes)
              HomeOperatorRoute(
                from: HomeLocation(
                  id: route.originProvinceId,
                  name: route.originName,
                ),
                to: HomeLocation(
                  id: route.destinationProvinceId,
                  name: route.destinationName,
                ),
              ),
          ],
        ),
    ];
  }

  /// Danh mục tiện ích để lọc chuyến; tải một lần mỗi phiên.
  Future<List<TripAmenityOption>> loadAmenities() async {
    final cached = _amenities;
    if (cached != null) return cached;
    final response = await _call(
      () => _client.getCatalogApi().catalogControllerListAmenities(),
    );
    return _amenities = [
      for (final item in response.data!.items)
        TripAmenityOption(id: item.id, name: item.name),
    ];
  }

  /// Một trang chuyến khớp điều kiện tìm + bộ lọc.
  Future<TripSearchPage> searchTrips(
    HomeSearchQuery query,
    TripSearchFilters filters,
    int page,
  ) async {
    final fromProvince = query.from.kind == HomeLocationKind.province;
    final toProvince = query.to.kind == HomeLocationKind.province;
    final amenityIds = filters.amenityIds.join(',');
    final response = await _call(
      () => _client.getTripsApi().publicTripControllerSearch(
        date: Date(query.date.year, query.date.month, query.date.day),
        fromProvinceId: fromProvince ? query.from.id : null,
        fromStopPointId: fromProvince ? null : query.from.id,
        toProvinceId: toProvince ? query.to.id : null,
        toStopPointId: toProvince ? null : query.to.id,
        passengers: query.passengers,
        operatorId: filters.operatorId ?? query.operatorId,
        vehicleForm: filters.vehicleForm?.apiValue,
        vehicleClass: filters.vehicleClass?.apiValue,
        departureFrom: filters.departureSlot?.from,
        departureTo: filters.departureSlot?.to,
        priceMin: filters.priceMin,
        priceMax: filters.priceMax,
        amenityIds: amenityIds.isEmpty ? null : amenityIds,
        sort: filters.sort.apiValue,
        page: page,
        limit: 20,
      ),
    );
    final data = response.data!;
    return TripSearchPage(
      total: data.total,
      page: data.page,
      limit: data.limit,
      priceMin: data.facets.priceMin,
      priceMax: data.facets.priceMax,
      operators: [
        for (final facet in data.facets.operators)
          TripOperatorFacet(id: facet.id, name: facet.name, count: facet.count),
      ],
      items: [
        for (final item in data.items)
          TripSummary(
            tripId: item.tripId,
            operatorId: item.operator_.id,
            operatorName: item.operator_.name,
            averageRating: item.operator_.averageRating?.toDouble(),
            reviewCount: item.operator_.reviewCount,
            vehicleTypeName: item.vehicleType.name,
            pickup: TripStopSummary(
              sequence: item.pickup.sequence,
              name: item.pickup.name,
              address: item.pickup.address,
              plannedAt: item.pickup.plannedAt,
            ),
            dropoff: TripStopSummary(
              sequence: item.dropoff.sequence,
              name: item.dropoff.name,
              address: item.dropoff.address,
              plannedAt: item.dropoff.plannedAt,
            ),
            durationMinutes: item.durationMinutes,
            availableSeats: item.availableSeats,
            minPrice: item.minPrice,
            amenityNames: [for (final amenity in item.amenities) amenity.name],
            coverImageUrl: item.vehicleCoverImageUrl,
          ),
      ],
    );
  }

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw toApiFailure(error, _client.serializers);
    }
  }
}

/// "Thành phố Hồ Chí Minh" → "TP. Hồ Chí Minh", "Tỉnh Lâm Đồng" → "Lâm Đồng" (cùng quy tắc với API).
String shortProvinceName(String name) {
  if (name.startsWith('Thành phố ')) {
    return 'TP. ${name.substring('Thành phố '.length)}';
  }
  if (name.startsWith('Tỉnh ')) return name.substring('Tỉnh '.length);
  return name;
}
