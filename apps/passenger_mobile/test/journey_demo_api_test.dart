import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart' as generated;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/journey_activity/journey_demo_api.dart';

class _DemoAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool empty = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (options.method == 'DELETE') return ResponseBody.fromString('', 204);
    return ResponseBody.fromString(
      jsonEncode(
        empty
            ? null
            : {
                'type': 'journey_demo',
                'schemaVersion': 1,
                'sessionId': '00000000-0000-4000-8000-000000000001',
                'bookingId': '00000000-0000-4000-8000-000000000002',
                'revision': 3,
                'stage': 'travelling',
                'routeLabel': 'TP. HCM → Đà Lạt',
                'provinceName': 'Đồng Nai',
                'etaAt': '2026-11-03T05:03:00.000Z',
                'progress': 500,
                'updatedAt': '2026-11-03T05:01:30.000Z',
                'expiresAt': '2026-11-03T05:04:00.000Z',
                'ended': false,
              },
      ),
      options.method == 'POST' ? 201 : 200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('client sinh từ OpenAPI đọc schemaVersion số, tỉnh và snapshot qua POST/GET', () async {
    final adapter = _DemoAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    final api = JourneyDemoApi(generated.ApiClientDart(dio: dio));
    final snapshot = await api.start(
      '00000000-0000-4000-8000-000000000002',
      '00000000-0000-4000-8000-000000000003',
    );
    expect(snapshot.toJson()['schemaVersion'], 1);
    expect(snapshot.provinceName, 'Đồng Nai');
    expect(adapter.requests.single.data, {
      'bookingId': '00000000-0000-4000-8000-000000000002',
      'deviceId': '00000000-0000-4000-8000-000000000003',
    });
    expect((await api.current('device'))?.progress, 500);
    await api.stop(snapshot.sessionId);
    expect(adapter.requests.last.method, 'DELETE');
  });

  test('GET snapshot null không tạo hoạt động hoặc lỗi deserialize', () async {
    final adapter = _DemoAdapter()..empty = true;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    final api = JourneyDemoApi(generated.ApiClientDart(dio: dio));
    expect(await api.current('device'), isNull);
  });
}
