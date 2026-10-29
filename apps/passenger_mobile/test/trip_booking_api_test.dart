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

(TripBookingApi, _FakeAdapter) _api(Map<String, Object> responses) {
  final adapter = _FakeAdapter(responses);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = adapter;
  return (TripBookingApi(ApiClientDart(dio: dio)), adapter);
}

void main() {
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
