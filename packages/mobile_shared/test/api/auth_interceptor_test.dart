import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

class _InMemoryTokenStore implements TokenStore {
  String? token;
  String? refresh;
  int clearCount = 0;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> saveAccessToken(String value) async => token = value;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    token = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> clear() async {
    token = null;
    refresh = null;
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

  test('request ẩn danh trả 401 thì không đụng tới phiên (OTP sai)', () async {
    var signalled = 0;
    final adapter = _FakeAdapter((_) => _json('{}', 401));

    await expectLater(
      dioWith(
        adapter,
        onUnauthorized: () async => signalled++,
      ).get<dynamic>('/v1/auth/otp/verify'),
      throwsA(isA<DioException>()),
    );

    expect(tokens.clearCount, 0);
    expect(signalled, 0);
  });

  group('access token hết hạn', () {
    /// Máy chủ giả: chỉ chấp nhận token `moi`; các token khác trả 401.
    ResponseBody server(RequestOptions options) =>
        options.headers[authorizationHeader] == 'Bearer moi'
        ? _json('{"ok":true}', 200)
        : _json('{"code":"AUTH_SESSION_EXPIRED"}', 401);

    Dio refreshingDio(
      _FakeAdapter adapter,
      SessionRefresher refresh, {
      Future<void> Function()? onUnauthorized,
    }) {
      final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(
        AuthInterceptor(
          tokens,
          onUnauthorized: onUnauthorized,
          refreshSession: refresh,
          retry: dio.fetch,
        ),
      );
      return dio;
    }

    setUp(() {
      tokens
        ..token = 'cu'
        ..refresh = 'refresh-cu';
    });

    test('đổi token, lưu cặp mới và gửi lại request', () async {
      final used = <String>[];
      final adapter = _FakeAdapter(server);

      final response = await refreshingDio(adapter, (refreshToken) async {
        used.add(refreshToken);
        return (accessToken: 'moi', refreshToken: 'refresh-moi');
      }).get<dynamic>('/v1/me');

      expect(response.data, {'ok': true});
      expect(used, ['refresh-cu']);
      expect(tokens.token, 'moi');
      expect(tokens.refresh, 'refresh-moi');
      expect(adapter.captured, hasLength(2));
      expect(tokens.clearCount, 0);
    });

    test('nhiều request 401 cùng lúc chỉ đổi token một lần', () async {
      // Refresh token xoay vòng: gửi lại token cũ là máy chủ thu hồi cả phiên.
      var refreshes = 0;
      final dio = refreshingDio(_FakeAdapter(server), (_) async {
        refreshes++;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        return (accessToken: 'moi', refreshToken: 'refresh-moi');
      });

      final responses = await Future.wait([
        dio.get<dynamic>('/v1/a'),
        dio.get<dynamic>('/v1/b'),
        dio.get<dynamic>('/v1/c'),
      ]);

      expect(responses.map((r) => r.statusCode), [200, 200, 200]);
      expect(refreshes, 1);
    });

    test('refresh token bị từ chối thì hết phiên, báo một lần', () async {
      var signalled = 0;
      final dio = refreshingDio(
        _FakeAdapter(server),
        (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/v1/auth/refresh'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/v1/auth/refresh'),
            statusCode: 401,
          ),
        ),
        onUnauthorized: () async => signalled++,
      );

      await expectLater(
        dio.get<dynamic>('/v1/me'),
        throwsA(isA<DioException>()),
      );

      expect(tokens.token, isNull);
      expect(tokens.refresh, isNull);
      expect(signalled, 1);
    });

    test('đổi token lỗi tạm thời thì giữ nguyên phiên', () async {
      var signalled = 0;
      final dio = refreshingDio(
        _FakeAdapter(server),
        (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/v1/auth/refresh'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/v1/auth/refresh'),
            statusCode: 503,
          ),
        ),
        onUnauthorized: () async => signalled++,
      );

      await expectLater(
        dio.get<dynamic>('/v1/me'),
        throwsA(isA<DioException>()),
      );

      expect(tokens.token, 'cu');
      expect(tokens.refresh, 'refresh-cu');
      expect(signalled, 0);
    });

    test('token mới vẫn 401 thì hết phiên, không lặp vô hạn', () async {
      var refreshes = 0;
      var signalled = 0;
      final adapter = _FakeAdapter((_) => _json('{}', 401));
      final dio = refreshingDio(adapter, (_) async {
        refreshes++;
        return (accessToken: 'moi', refreshToken: 'refresh-moi');
      }, onUnauthorized: () async => signalled++);

      await expectLater(
        dio.get<dynamic>('/v1/me'),
        throwsA(isA<DioException>()),
      );

      expect(refreshes, 1);
      expect(adapter.captured, hasLength(2));
      expect(tokens.token, isNull);
      expect(signalled, 1);
    });
  });

  test('bearerSessionRefresher gọi đúng endpoint và đọc cặp token', () async {
    final adapter = _FakeAdapter(
      (_) => _json('{"accessToken":"a","refreshToken":"r"}', 200),
    );
    final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
      ..httpClientAdapter = adapter;

    final tokens = await bearerSessionRefresher(dio)('refresh-cu');

    expect(tokens.accessToken, 'a');
    expect(tokens.refreshToken, 'r');
    expect(adapter.captured.single.path, '/v1/auth/refresh');
    expect(adapter.captured.single.data, {'refreshToken': 'refresh-cu'});
  });
}
