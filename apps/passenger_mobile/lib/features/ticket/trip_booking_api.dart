import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

/// Lời gọi API của luồng tìm chuyến – đặt vé cho app hành khách; lỗi API ném ra dạng [ApiFailure].
class TripBookingApi {
  TripBookingApi(this._client, {bool Function()? isSignedIn})
    : _isSignedIn = isSignedIn ?? (() => false);

  final ApiClientDart _client;
  final bool Function() _isSignedIn;
  List<HomeLocation>? _provinces;
  List<TripAmenityOption>? _amenities;

  /// Trang điều khoản / chính sách đã công bố; slug do quản trị cấu hình.
  Future<List<BookingPolicyDocument>> loadBookingTerms() async {
    final response = await _call(
      () =>
          _client.getContentPagesApi().contentPageControllerList(type: 'PAGE'),
    );
    return [
      for (final item in response.data!.items)
        if (item.bodyMarkdown.trim().isNotEmpty)
          BookingPolicyDocument(
            title: item.title,
            bodyMarkdown: item.bodyMarkdown,
          ),
    ];
  }

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

  /// Gợi ý điểm đi / điểm đến khớp từ khóa, cùng nguồn với web
  /// (`GET /catalog/places`): tỉnh / thành, khu vực (đơn vị hành chính cũ như
  /// "Đà Lạt", "Vũng Tàu"), phường / xã, bến xe – địa danh (đã bỏ trạm dừng
  /// nghỉ, BR-79) và tên phường / xã cũ dẫn tới phường mới.
  Future<List<HomeLocation>> searchPlaces(String keyword) async {
    final response = await _call(
      () => _client.getCatalogApi().catalogControllerListPlaces(
        q: keyword,
        limit: 20,
      ),
    );
    return [
      for (final item in response.data!.items)
        HomeLocation(
          id: item.target.id,
          name: item.kind.name == 'PROVINCE'
              ? shortProvinceName(item.label)
              : item.label,
          kind: switch (item.target.type.name) {
            'ward' => HomeLocationKind.ward,
            'area' => HomeLocationKind.area,
            'stopPoint' => HomeLocationKind.stopPoint,
            _ => HomeLocationKind.province,
          },
          detail: item.detail,
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
          logoUrl: _publicImageUrl(item.logoUrl),
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
    String? idOf(HomeLocation place, HomeLocationKind kind) =>
        place.kind == kind ? place.id : null;
    final amenityIds = filters.amenityIds.join(',');
    final response = await _call(
      () => _client.getTripsApi().publicTripControllerSearch(
        date: Date(query.date.year, query.date.month, query.date.day),
        fromProvinceId: idOf(query.from, HomeLocationKind.province),
        fromWardId: idOf(query.from, HomeLocationKind.ward),
        fromAreaId: idOf(query.from, HomeLocationKind.area),
        fromStopPointId: idOf(query.from, HomeLocationKind.stopPoint),
        toProvinceId: idOf(query.to, HomeLocationKind.province),
        toWardId: idOf(query.to, HomeLocationKind.ward),
        toAreaId: idOf(query.to, HomeLocationKind.area),
        toStopPointId: idOf(query.to, HomeLocationKind.stopPoint),
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
    return _tripPage(response.data!);
  }

  /// Chuyến sắp chạy của mọi tuyến trong vài ngày tới — không gửi điểm đi / đến hay ngày (chờ duyệt 30/10/2026).
  Future<TripSearchPage> browseTrips(
    TripSearchFilters filters,
    int page,
  ) async {
    final amenityIds = filters.amenityIds.join(',');
    final response = await _call(
      () => _client.getTripsApi().publicTripControllerSearch(
        passengers: 1,
        operatorId: filters.operatorId,
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
    return _tripPage(response.data!);
  }

  TripSearchPage _tripPage(TripSearchResponseDtoOutput data) {
    return TripSearchPage(
      total: data.total,
      page: data.page,
      limit: data.limit,
      priceMin: data.facets.priceMin,
      priceMax: data.facets.priceMax,
      widenedFrom: data.widenedToProvince.from,
      widenedTo: data.widenedToProvince.to,
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
            operatorLogoUrl: _publicImageUrl(item.operator_.logoUrl),
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
            coverImageUrl: _publicImageUrl(item.vehicleCoverImageUrl),
            segmentTitle: item.segmentTitle,
          ),
      ],
    );
  }

  /// Ảnh kho dev dùng cùng địa chỉ API mà thiết bị kết nối, thay cho localhost của server.
  String? _publicImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        const {'localhost', '127.0.0.1', '::1', '[::1]'}.contains(uri.host) &&
        uri.path.startsWith('/v1/dev-storage/public/')) {
      final api = Uri.parse(_client.dio.options.baseUrl);
      return uri
          .replace(scheme: api.scheme, host: api.host, port: api.port)
          .toString();
    }
    return value;
  }

  /// Giá vé thấp nhất của nhà xe trên một tuyến vào ngày đi; `null` khi ngày đó
  /// nhà xe không có chuyến mở bán. API nhà xe nổi bật chưa trả giá nên lấy
  /// chuyến rẻ nhất qua tìm chuyến.
  Future<int?> loadOperatorMinFare(
    String operatorId,
    HomeOperatorRoute route,
    DateTime date,
  ) async {
    final response = await _call(
      () => _client.getTripsApi().publicTripControllerSearch(
        date: Date(date.year, date.month, date.day),
        fromProvinceId: route.from.id,
        toProvinceId: route.to.id,
        passengers: 1,
        operatorId: operatorId,
        sort: TripSearchSort.price.apiValue,
        page: 1,
        limit: 1,
      ),
    );
    final items = response.data!.items;
    return items.isEmpty ? null : items.first.minPrice;
  }

  /// Chi tiết chuyến đang mở bán; chỗ đang có người giữ hiện là không đặt được. Kèm chặng khách đi thì giá chỗ +
  /// tiêu đề theo chặng (3.3).
  Future<TripDetail> loadTrip(
    String tripId, {
    int? pickupSequence,
    int? dropoffSequence,
  }) async {
    final response = await _call(
      () => _client.getTripsApi().publicTripControllerGet(
        tripId: tripId,
        pickupSequence: pickupSequence,
        dropoffSequence: dropoffSequence,
      ),
    );
    final data = response.data!;
    return TripDetail(
      tripId: data.tripId,
      operatorName: data.operator_.name,
      operatorLogoUrl: _publicImageUrl(data.operator_.logoUrl),
      operatorHotline: data.operator_.hotline,
      averageRating: data.operator_.averageRating?.toDouble(),
      reviewCount: data.operator_.reviewCount,
      routeName: data.routeName,
      segmentTitle: data.segment?.title,
      departureAt: data.departureAt,
      arrivalAt: data.arrivalAt,
      note: data.note,
      vehicleTypeName: data.vehicleType.name,
      amenityNames: [for (final amenity in data.amenities) amenity.name],
      imageUrls: data.vehicleImages
          .map((image) => _publicImageUrl(image.url))
          .whereType<String>()
          .toList(growable: false),
      stops: [
        for (final stop in data.stops)
          TripStop(
            sequence: stop.sequence,
            name: stop.name,
            address: stop.address,
            type: stop.type.name,
            plannedAt: stop.plannedAt,
            allowPickup: stop.allowPickup,
            allowDropoff: stop.allowDropoff,
            pickupOpen: stop.pickupOpen,
          ),
      ],
      seats: [
        for (final seat in data.seats)
          TripSeat(
            code: seat.code,
            deck: seat.deck,
            row: seat.row,
            column: seat.column,
            type: seat.type.name,
            available: seat.status.name == 'AVAILABLE',
            price: seat.price,
          ),
      ],
      cancellationTiers: [
        for (final tier in data.cancellationPolicy.tiers)
          CancellationTier(
            minHoursBefore: tier.minHoursBefore,
            refundPercent: tier.refundPercent,
          ),
      ],
    );
  }

  /// Giữ các chỗ của chuyến kèm điểm đón / trả (10 phút theo chính sách giữ chỗ).
  Future<SeatHold> holdSeats({
    required String tripId,
    required List<String> seatCodes,
    required int pickupSequence,
    required int dropoffSequence,
  }) async {
    final input = SeatHoldInputDto(
      (b) => b
        ..tripId = tripId
        ..seatCodes.addAll(seatCodes)
        ..pickupSequence = pickupSequence
        ..dropoffSequence = dropoffSequence,
    );
    final response = await _call(
      () => _client.getSeatHoldsApi().seatHoldControllerCreate(
        seatHoldInputDto: input,
      ),
    );
    final data = response.data!;
    return SeatHold(
      holdId: data.holdId,
      tripId: data.tripId,
      pickup: SeatHoldStop(
        sequence: data.pickup.sequence,
        name: data.pickup.name,
        plannedAt: data.pickup.plannedAt,
      ),
      dropoff: SeatHoldStop(
        sequence: data.dropoff.sequence,
        name: data.dropoff.name,
        plannedAt: data.dropoff.plannedAt,
      ),
      seats: [
        for (final seat in data.seats)
          HeldSeat(code: seat.code, type: seat.type.name, price: seat.price),
      ],
      subtotal: data.subtotal,
      expiresAt: data.expiresAt,
    );
  }

  /// Bỏ giữ chỗ khi khách quay lại chọn chỗ khác; giữ chỗ đã hết hạn thì coi như xong.
  Future<void> releaseHold(String holdId) async {
    try {
      await _call(
        () =>
            _client.getSeatHoldsApi().seatHoldControllerRelease(holdId: holdId),
      );
    } on ApiFailure catch (failure) {
      if (failure.code != 'SEAT_HOLD_EXPIRED') rethrow;
    }
  }

  /// Đọc lại phiên giữ chỗ (giá mới nhất) — dùng khi đặt vé báo giá vừa đổi.
  Future<SeatHold> reloadHold(String holdId) async {
    final response = await _call(
      () => _client.getSeatHoldsApi().seatHoldControllerGet(holdId: holdId),
    );
    final data = response.data!;
    return SeatHold(
      holdId: data.holdId,
      tripId: data.tripId,
      pickup: SeatHoldStop(
        sequence: data.pickup.sequence,
        name: data.pickup.name,
        plannedAt: data.pickup.plannedAt,
      ),
      dropoff: SeatHoldStop(
        sequence: data.dropoff.sequence,
        name: data.dropoff.name,
        plannedAt: data.dropoff.plannedAt,
      ),
      seats: [
        for (final seat in data.seats)
          HeldSeat(code: seat.code, type: seat.type.name, price: seat.price),
      ],
      subtotal: data.subtotal,
      expiresAt: data.expiresAt,
    );
  }

  /// Hồ sơ + hành khách đã lưu để điền sẵn form; khách vãng lai → `null`.
  Future<BookingPrefill?> loadPrefill() async {
    if (!_isSignedIn()) return null;
    final profileApi = _client.getPassengerProfileApi();
    final results = await Future.wait([
      _call(() => profileApi.passengerProfileControllerGet()),
      _call(() => profileApi.passengerProfileControllerSaved()),
    ]);
    final profile = (results[0].data as PassengerProfileDtoOutput?)!;
    final saved = (results[1].data as SavedPassengerListDtoOutput?)!;
    return BookingPrefill(
      contact: BookingContact(
        fullName: profile.name?.trim() ?? '',
        phone: profile.phone ?? '',
        email: profile.email,
      ),
      travellers: [
        for (final item in saved.items)
          SavedTraveller(fullName: item.fullName, phone: item.phone),
      ],
    );
  }

  /// Khuyến mãi công khai đang chạy, sắp hết hạn trước — mục "Ưu đãi nổi bật".
  Future<List<HomePromotion>> loadPromotions() async {
    final response = await _call(
      () => _client.getPromotionsApi().publicPromotionControllerList(limit: 10),
    );
    return [
      for (final item in response.data!.items)
        HomePromotion(
          code: item.code,
          name: item.name,
          isPercent: item.discountType.name == 'PERCENT',
          discountValue: item.discountValue,
          maxDiscount: item.maxDiscount,
          minOrder: item.minOrder,
          operatorName: item.operatorName,
        ),
    ];
  }

  /// Kiểm tra mã khuyến mãi cho chuyến + tiền vé (không giữ lượt dùng).
  Future<PromotionQuote> checkPromotion({
    required String tripId,
    required String code,
    required int subtotal,
  }) async {
    final input = PromotionCheckInputDto(
      (b) => b
        ..tripId = tripId
        ..code = code
        ..subtotal = subtotal,
    );
    final response = await _call(
      () => _client.getPromotionsApi().publicPromotionControllerCheck(
        promotionCheckInputDto: input,
      ),
    );
    final data = response.data!;
    return PromotionQuote(
      code: data.code,
      name: data.name,
      discount: data.discount,
      total: data.total,
    );
  }

  /// Tạo đơn chờ thanh toán từ phiên giữ chỗ; [expectedTotal] là tổng sau giảm khách đã thấy.
  Future<CreatedBooking> createBooking({
    required String holdId,
    required BookingDraft draft,
    required int expectedTotal,
  }) async {
    final input = BookingInputDto(
      (b) => b
        ..holdId = holdId
        ..contact.fullName = draft.contact.fullName
        ..contact.phone = draft.contact.phone
        ..contact.email = draft.contact.email
        ..passengers.addAll([
          for (final passenger in draft.passengers)
            BookingInputDtoPassengersInner(
              (p) => p
                ..seatCode = passenger.seatCode
                ..fullName = passenger.fullName
                ..phone = passenger.phone
                ..companionName = passenger.companionName,
            ),
        ])
        ..note = null
        ..expectedTotal = expectedTotal
        ..promotionCode = draft.promotion?.code,
    );
    final response = await _call(
      () => _client.getBookingsApi().bookingControllerCreate(
        bookingInputDto: input,
      ),
    );
    final data = response.data!;
    return CreatedBooking(
      bookingId: data.bookingId,
      bookingCode: data.bookingCode,
      status: data.status.name,
      routeName: data.trip.routeName,
      operatorName: data.trip.operatorName,
      vehicleTypeName: data.trip.vehicleTypeName,
      pickupName: data.pickup.name,
      pickupAt: data.pickup.plannedAt,
      dropoffName: data.dropoff.name,
      dropoffAt: data.dropoff.plannedAt,
      contact: BookingContact(
        fullName: data.contact.fullName,
        phone: data.contact.phone,
        email: data.contact.email,
      ),
      passengers: [
        for (final passenger in data.passengers)
          BookedPassenger(
            seatCode: passenger.seatCode,
            fullName: passenger.fullName,
            price: passenger.price,
            companionName: passenger.companionName,
          ),
      ],
      subtotal: data.subtotal,
      serviceFee: data.serviceFee,
      discount: data.discount,
      total: data.total,
      expiresAt: data.expiresAt,
      accessToken: data.accessToken,
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

/// Câu tiếng Việt cho lỗi của luồng đặt vé (giữ chỗ, xem chuyến); lỗi lạ dùng `detail` của API.
String describeBookingFailure(Object error) {
  if (error is! ApiFailure) return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  if (error.isNetworkError) {
    return 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
  }
  return switch (error.code) {
    'TRIP_NOT_FOUND' => 'Chuyến không còn mở bán.',
    'SEAT_NOT_AVAILABLE' || 'SEAT_HOLD_CONFLICT' =>
      'Chỗ bạn chọn vừa có người giữ hoặc đặt. Vui lòng chọn chỗ khác.',
    'SEAT_HOLD_STOPS_INVALID' => 'Điểm đón / trả không hợp lệ cho chuyến này.',
    'TRIP_SEAT_UNKNOWN' => 'Sơ đồ chỗ vừa thay đổi. Vui lòng chọn lại.',
    'SEAT_HOLD_RATE_LIMITED' =>
      'Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút.',
    'SEAT_HOLD_EXPIRED' => 'Thời gian giữ chỗ đã hết. Vui lòng chọn lại.',
    'BOOKING_SNAPSHOT_CHANGED' =>
      'Giá vé vừa thay đổi. Vui lòng xem lại tổng tiền.',
    'BOOKING_ALREADY_CREATED' => 'Đơn cho lượt giữ chỗ này đã được tạo.',
    'TRIP_NOT_ON_SALE' => 'Chuyến đã ngừng bán online.',
    _ =>
      error.status == 503
          ? 'Hệ thống giữ chỗ đang bận. Vui lòng thử lại.'
          : error.detail,
  };
}

/// "Thành phố Hồ Chí Minh" → "TP. Hồ Chí Minh", "Tỉnh Lâm Đồng" → "Lâm Đồng" (cùng quy tắc với API).
String shortProvinceName(String name) {
  if (name.startsWith('Thành phố ')) {
    return 'TP. ${name.substring('Thành phố '.length)}';
  }
  if (name.startsWith('Tỉnh ')) return name.substring('Tỉnh '.length);
  return name;
}
