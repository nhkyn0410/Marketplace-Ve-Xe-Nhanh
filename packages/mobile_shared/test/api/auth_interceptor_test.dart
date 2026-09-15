import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

class _InMemoryTokenStore implements TokenStore {
  String? token;
  int clearCount = 0;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> saveAccessToken(String value) async => token = value;

  @override
  Future<void> clear() async {
    token = null;
    clearCount++;
  }
}

/// Adapter giả: không mở socket, trả sẵn response test dựng và ghi lại request
/// để kiểm header.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;
  final List<RequestOptions> captured = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured.add(options);
    return _respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(String body, int status) => ResponseBody.fromString(
  body,
  status,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

void main() {
  late _InMemoryTokenStore tokens;

  setUp(() => tokens = _InMemoryTokenStore());

  Dio dioWith(_FakeAdapter adapter, {Future<void> Function()? onUnauthorized}) {
    return Dio(BaseOptions(baseUrl: 'http://test.local'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(tokens, onUnauthorized: onUnauthorized),
      );
  }

  test('có token thì gắn header Bearer', () async {
    tokens.token = 'abc123';
    final adapter = _FakeAdapter((_) => _json('{}', 200));

    await dioWith(adapter).get<dynamic>('/v1/anything');

    expect(
      adapter.captured.single.headers[authorizationHeader],
      'Bearer abc123',
    );
  });

  test('không có token thì không gắn header', () async {
    final adapter = _FakeAdapter((_) => _json('{}', 200));

    await dioWith(adapter).get<dynamic>('/v1/anything');

    expect(
      adapter.captured.single.headers.containsKey(authorizationHeader),
      isFalse,
    );
  });

  test('không ghi đè header mà lời gọi đã tự đặt', () async {
    tokens.token = 'abc123';
    final adapter = _FakeAdapter((_) => _json('{}', 200));

    await dioWith(adapter).get<dynamic>(
      '/v1/anything',
      options: Options(headers: {authorizationHeader: 'Bearer da-dat-san'}),
    );

    expect(
      adapter.captured.single.headers[authorizationHeader],
      'Bearer da-dat-san',
    );
  });

  test('401 thì xoá token và gọi onUnauthorized', () async {
    tokens.token = 'het-han';
    var signalled = 0;
    final adapter = _FakeAdapter(
      (_) => _json('{"code":"AUTH_INVALID_CREDENTIALS"}', 401),
    );

    await expectLater(
      dioWith(
        adapter,
        onUnauthorized: () async => signalled++,
      ).get<dynamic>('/v1/anything'),
      throwsA(isA<DioException>()),
    );

    expect(tokens.token, isNull);
    expect(tokens.clearCount, 1);
    expect(signalled, 1);
  });

  test('500 thì KHÔNG xoá token', () async {
    // API sập không có nghĩa phiên đăng nhập hỏng. Xoá token ở đây là đá người
    // dùng ra màn đăng nhập mỗi lần backend gặp sự cố.
    tokens.token = 'con-tot';
    final adapter = _FakeAdapter((_) => _json('{}', 500));

    await expectLater(
      dioWith(adapter).get<dynamic>('/v1/anything'),
      throwsA(isA<DioException>()),
    );

    expect(tokens.token, 'con-tot');
    expect(tokens.clearCount, 0);
  });
}
