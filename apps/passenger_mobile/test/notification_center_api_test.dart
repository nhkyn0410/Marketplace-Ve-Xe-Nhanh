import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/notification/notification_center_api.dart';

class _Reply {
  const _Reply(this.body, {this.status = 200});

  final Object? body;
  final int status;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.replyFor);

  final _Reply Function(RequestOptions) replyFor;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final reply = replyFor(options);
    return ResponseBody.fromString(
      reply.body == null ? '' : jsonEncode(reply.body),
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(NotificationCenterApi, _Adapter) _api(
  _Reply Function(RequestOptions) replyFor,
) {
  final adapter = _Adapter(replyFor);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  return (NotificationCenterApi(ApiClientDart(dio: dio)), adapter);
}

Map<String, Object?> _preferences(Map<String, bool> optional) => {
  'items': [
    {
      'kind': 'BOOKING_CONFIRMED',
      'email': true,
      'push': true,
      'mandatory': true,
    },
    for (final MapEntry(key: kind, value: on) in optional.entries)
      {'kind': kind, 'email': on, 'push': false, 'mandatory': false},
  ],
};

void main() {
  test('đọc trang hộp thư, giữ liên kết và con trỏ trang sau', () async {
    final (api, adapter) = _api(
      (_) => const _Reply({
        'items': [
          {
            'id': '00000000-0000-4000-8000-000000000001',
            'kind': 'PROMOTION',
            'title': 'Ưu đãi',
            'body': 'Giảm giá',
            'linkType': 'PROMOTION',
            'linkTarget': 'CHAOBAN',
            'createdAt': '2026-11-02T01:00:00.000Z',
            'readAt': null,
          },
          {
            'id': '00000000-0000-4000-8000-000000000002',
            'kind': 'SERVICE_NOTICE',
            'title': 'Bảo trì',
            'body': 'Tối nay',
            'linkType': null,
            'linkTarget': null,
            'createdAt': '2026-11-01T01:00:00.000Z',
            'readAt': '2026-11-01T02:00:00.000Z',
          },
        ],
        'nextCursor': '00000000-0000-4000-8000-000000000002',
        'unreadCount': 1,
      }),
    );

    final page = await api.loadInbox(cursor: 'abc');

    expect(adapter.requests.single.path, '/v1/me/inbox');
    expect(adapter.requests.single.queryParameters['cursor'], 'abc');
    expect(page.unreadCount, 1);
    expect(page.nextCursor, '00000000-0000-4000-8000-000000000002');
    expect(page.items.first.kind, 'PROMOTION');
    expect(page.items.first.action, InboxAction.voucher);
    expect(page.items.first.linkTarget, 'CHAOBAN');
    expect(page.items.first.isUnread, isTrue);
    expect(page.items.last.action, isNull);
    expect(page.items.last.isUnread, isFalse);
  });

  test('số tin chưa đọc và đánh dấu đã đọc gọi đúng đường dẫn', () async {
    final (api, adapter) = _api((options) {
      if (options.path.endsWith('/unread-count')) {
        return const _Reply({'unreadCount': 7});
      }
      return const _Reply(null, status: 204);
    });

    expect(await api.unreadCount(), 7);
    await api.markRead('m1');
    await api.markAllRead();

    expect(adapter.requests.map((r) => '${r.method} ${r.path}'), [
      'GET /v1/me/inbox/unread-count',
      'POST /v1/me/inbox/m1/read',
      'POST /v1/me/inbox/read-all',
    ]);
  });

  test('cài đặt chỉ trả loại tùy chọn; bật khi có email hoặc push', () async {
    final (api, _) = _api(
      (_) => _Reply(
        _preferences({
          'PROMOTION': true,
          'LOYALTY_UPDATED': false,
          'NEWS': false,
        }),
      ),
    );

    expect(await api.loadPreferences(), {
      'PROMOTION': true,
      'LOYALTY_UPDATED': false,
      'NEWS': false,
    });
  });

  test('tắt thì tắt cả hai kênh', () async {
    final (api, adapter) = _api((_) => _Reply(_preferences({'NEWS': false})));

    await api.savePreference('NEWS', enabled: false);

    expect(adapter.requests.single.method, 'PUT');
    expect(jsonDecode(jsonEncode(adapter.requests.single.data)), {
      'kind': 'NEWS',
      'email': false,
      'push': false,
    });
  });

  test(
    'bật mà máy chưa đăng ký push thì vẫn bật để nhận trong hộp thư',
    () async {
      final bodies = <Object?>[];
      final (api, _) = _api((options) {
        final body =
            jsonDecode(jsonEncode(options.data)) as Map<String, Object?>;
        bodies.add(body);
        if (body['push'] == true) {
          return const _Reply({
            'type': 'about:blank',
            'title': 'Thiết bị chưa đăng ký',
            'status': 422,
            'detail': 'Thiết bị chưa đăng ký',
            'code': 'PUSH_DEVICE_REQUIRED',
          }, status: 422);
        }
        return _Reply(_preferences({'NEWS': true}));
      });

      await api.savePreference('NEWS', enabled: true);

      expect(bodies, [
        {'kind': 'NEWS', 'email': true, 'push': true},
        {'kind': 'NEWS', 'email': true, 'push': false},
      ]);
    },
  );

  test('lỗi khác không bị nuốt', () async {
    final (api, adapter) = _api(
      (_) => const _Reply({
        'type': 'about:blank',
        'title': 'Lỗi',
        'status': 500,
        'detail': 'Lỗi máy chủ',
        'code': 'INTERNAL',
      }, status: 500),
    );

    await expectLater(
      api.savePreference('NEWS', enabled: true),
      throwsA(isA<ApiFailure>()),
    );
    expect(adapter.requests, hasLength(1));
  });
}
