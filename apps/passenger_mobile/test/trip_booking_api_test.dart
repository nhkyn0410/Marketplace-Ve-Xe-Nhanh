import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

/// Trả JSON cố định theo đường dẫn API và ghi lại request đã gửi.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.responses);

  final Map<String, Object> responses;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = responses[options.uri.path];
    return ResponseBody.fromString(
      jsonEncode(body ?? {'detail': 'Không có'}),
      body == null ? 404 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(TripBookingApi, _FakeAdapter) _api(
  Map<String, Object> responses, {
  String baseUrl = 'http://api.test',
}) {
  final adapter = _FakeAdapter(responses);
  final dio = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
  return (TripBookingApi(ApiClientDart(dio: dio)), adapter);
}

void main() {
  test(
    'điều khoản lấy các trang đã công bố theo cấu hình, không cố định slug',
    () async {
      final (api, adapter) = _api({
        '/v1/content-pages': {
          'items': [
            for (final body in ['Điều khoản đã công bố.', ' '])
              {
                'id': 'page-1',
                'type': 'PAGE',
                'placement': 'FOOTER',
                'title': 'Quy chế hoạt động',
                'slug': 'quy-che-hoat-dong',
                'bodyMarkdown': body,
                'imageUrl': null,
                'linkUrl': null,
                'displayOrder': 0,
                'updatedAt': '2026-10-30T00:00:00Z',
              },
          ],
        },
      });
      final documents = await api.loadBookingTerms();
      expect(adapter.requests.single.uri.queryParameters, {'type': 'PAGE'});
      expect(documents.single.title, 'Quy chế hoạt động');
      expect(documents.single.bodyMarkdown, 'Điều khoản đã công bố.');
    },
  );


  test('logo nhà xe dùng API trên thiết bị, giữ URL CDN và logo thiếu', () async {
    const path = '/v1/dev-storage/public/operator-logos/operator/logo.png';
    final (api, _) = _api({
      '/v1/catalog/featured-operators': {
        'items': [
          for (final logo in [
            'http://localhost:3000$path',
            'https://cdn.example.com/logo.png',
            null,
          ])
            {
              'operatorId': 'operator',
              'displayName': 'Nhà xe',
              'logoUrl': logo,
              'averageRating': null,
              'reviewCount': 0,
              'routes': <Object>[],
            },
        ],
      },
    }, baseUrl: 'http://10.0.2.2:3000');
    final operators = await api.loadOperators();
    expect(
      [for (final operator in operators) operator.logoUrl],
      ['http://10.0.2.2:3000$path', 'https://cdn.example.com/logo.png', null],
    );
  });

  test(
    'ảnh kho dev theo API trên thiết bị, giữ ảnh CDN và ảnh thiếu',
    () async {
      const path = '/v1/dev-storage/public/vehicles/test/bus.jpg';
      const logoPath = '/v1/dev-storage/public/operator-logos/operator/logo.png';
      final sources = <String?>[
        'http://localhost:3000$path',
        'http://127.0.0.1:3000$path',
        'http://[::1]:3000$path',
        'https://cdn.example.com/bus.jpg',
        'http://localhost:9000/other/bus.jpg',
        null,
      ];
      Map<String, Object?> item(String? image) => {
        'tripId': 'trip-1',
        'operator': {
          'id': 'op-1',
          'name': 'Nhà xe',
          'slug': 'nha-xe',
          'logoUrl': image == null ? null : 'http://localhost:3000$logoPath',
          'averageRating': null,
          'reviewCount': 0,
        },
        'routeName': 'A → B',
        'segmentTitle': 'A → B',
        'vehicleType': {
          'name': 'Giường nằm',
          'form': 'SLEEPER',
          'class': 'STANDARD',
        },
        'departureAt': '2026-10-30T00:00:00Z',
        'arrivalAt': '2026-10-30T06:00:00Z',
        'pickup': {
          'sequence': 1,
          'name': 'A',
          'address': 'A',
          'plannedAt': '2026-10-30T00:00:00Z',
        },
        'dropoff': {
          'sequence': 2,
          'name': 'B',
          'address': 'B',
          'plannedAt': '2026-10-30T06:00:00Z',
        },
        'durationMinutes': 360,
        'availableSeats': 10,
        'minPrice': 300000,
        'vehicleCoverImageUrl': image,
        'amenities': <Object>[],
        'onlineSaleClosesAt': '2026-10-29T23:00:00Z',
      };
      final (api, _) = _api({
        '/v1/trips/search': {
          'items': [for (final source in sources) item(source)],
          'total': sources.length,
          'page': 1,
          'limit': 20,
          'facets': {
            'operators': <Object>[],
            'priceMin': 300000,
            'priceMax': 300000,
          },
          'widenedToProvince': {'from': false, 'to': false},
        },
        '/v1/trips/trip-1': {
          'tripId': 'trip-1',
          'operator': {
            'id': 'op-1',
            'name': 'Nhà xe',
            'slug': 'nha-xe',
            'hotline': null,
            'logoUrl': 'http://localhost:3000$logoPath',
            'averageRating': null,
            'reviewCount': 0,
          },
          'routeName': 'A → B',
          'segment': null,
          'departureAt': '2026-10-30T00:00:00Z',
          'arrivalAt': '2026-10-30T06:00:00Z',
          'onlineSaleClosesAt': '2026-10-29T23:00:00Z',
          'note': null,
          'vehicleType': {
            'name': 'Giường nằm',
            'form': 'SLEEPER',
            'class': 'STANDARD',
          },
          'amenities': <Object>[],
          'stops': <Object>[],
          'seats': <Object>[],
          'vehicleImages': [
            for (final source in sources.whereType<String>())
              {'url': source, 'caption': null},
          ],
          'cancellationPolicy': {'tiers': <Object>[]},
        },
      }, baseUrl: 'http://10.0.2.2:3000');
      final expected = [
        for (var index = 0; index < 3; index++) 'http://10.0.2.2:3000$path',
        ...sources.skip(3),
      ];
      final trips = await api.browseTrips(const TripSearchFilters(), 1);
      expect([for (final trip in trips.items) trip.coverImageUrl], expected);
      expect(trips.items.first.operatorLogoUrl, 'http://10.0.2.2:3000$logoPath');
      expect(trips.items.last.operatorLogoUrl, isNull);
      final detail = await api.loadTrip('trip-1');
      expect(detail.operatorLogoUrl, 'http://10.0.2.2:3000$logoPath');
      expect(
        detail.imageUrls,
        expected.whereType<String>().toList(),
      );
    },
  );

  test('gợi ý địa điểm: đúng loại theo target.type, tỉnh dùng tên rút gọn', () async {
    final (api, _) = _api({
      '/v1/catalog/places': {
        'items': [
          {
            'kind': 'PROVINCE',
            'label': 'Thành phố Hồ Chí Minh',
            'detail': null,
            'target': {'type': 'province', 'id': 'p-hcm'},
          },
          {
            'kind': 'AREA',
            'label': 'Vũng Tàu',
            'detail': 'Thành phố Vũng Tàu cũ · nay thuộc Thành phố Hồ Chí Minh',
            'target': {'type': 'area', 'id': '77-thanh-pho-vung-tau'},
          },
          {
            'kind': 'LEGACY',
            'label': 'Phường Thắng Tam',
            'detail': 'Cũ: … · Nay: Phường Tam Thắng',
            'target': {'type': 'ward', 'id': 'w-tam-thang'},
          },
          {
            'kind': 'STOP_POINT',
            'label': 'Bến xe Vũng Tàu',
            'detail': '192 Nam Kỳ Khởi Nghĩa',
            'target': {'type': 'stopPoint', 'id': 's-vt'},
          },
        ],
      },
    });

    final places = await api.searchPlaces('vung tau');
    expect(
      [for (final place in places) (place.kind, place.id, place.name)],
      [
        (HomeLocationKind.province, 'p-hcm', 'TP. Hồ Chí Minh'),
        (HomeLocationKind.area, '77-thanh-pho-vung-tau', 'Vũng Tàu'),
        (HomeLocationKind.ward, 'w-tam-thang', 'Phường Thắng Tam'),
        (HomeLocationKind.stopPoint, 's-vt', 'Bến xe Vũng Tàu'),
      ],
    );
  });

  test(
    'tìm chuyến: mỗi loại điểm gửi đúng tham số; đọc cờ đã nới ra cả tỉnh',
    () async {
      final (api, adapter) = _api({
        '/v1/trips/search': {
          'items': <Object>[],
          'total': 0,
          'page': 1,
          'limit': 20,
          'facets': {
            'operators': <Object>[],
            'priceMin': null,
            'priceMax': null,
          },
          'widenedToProvince': {'from': false, 'to': true},
        },
      });

      final page = await api.searchTrips(
        HomeSearchQuery(
          mode: HomeSearchMode.route,
          from: const HomeLocation(id: 'p-hcm', name: 'TP. Hồ Chí Minh'),
          to: const HomeLocation(
            id: '77-thanh-pho-vung-tau',
            name: 'Vũng Tàu',
            kind: HomeLocationKind.area,
          ),
          date: DateTime(2026, 10, 30),
          passengers: 2,
        ),
        const TripSearchFilters(),
        1,
      );

      final params = adapter.requests.single.uri.queryParameters;
      expect(params['fromProvinceId'], 'p-hcm');
      expect(params['toAreaId'], '77-thanh-pho-vung-tau');
      expect(params.containsKey('toProvinceId'), isFalse);
      expect(params.containsKey('toStopPointId'), isFalse);
      expect(params['date'], '2026-10-30');
      expect(page.widenedFrom, isFalse);
      expect(page.widenedTo, isTrue);

      await api.searchTrips(
        HomeSearchQuery(
          mode: HomeSearchMode.route,
          from: const HomeLocation(
            id: 'w-1',
            name: 'Phường A',
            kind: HomeLocationKind.ward,
          ),
          to: const HomeLocation(
            id: 's-1',
            name: 'Bến B',
            kind: HomeLocationKind.stopPoint,
          ),
          date: DateTime(2026, 10, 30),
          passengers: 1,
        ),
        const TripSearchFilters(),
        1,
      );
      final second = adapter.requests.last.uri.queryParameters;
      expect(second['fromWardId'], 'w-1');
      expect(second['toStopPointId'], 's-1');
      expect(second.containsKey('fromProvinceId'), isFalse);
    },
  );
}
