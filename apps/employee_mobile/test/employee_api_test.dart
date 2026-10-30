import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/employee_api.dart';
import 'package:flutter_test/flutter_test.dart';

const _tripId = '11111111-1111-4111-8111-111111111111';
const _token = 'aBcDeFgHiJkLmNoPqRsTuVwXyZ0123456789_-abcde';
const _ticketCode = 'VXNABC123-01';

class _Tokens implements EmployeeTokenStore {
  String? access = 'access';
  String? refresh = 'refresh';
  DateTime? expiry = DateTime.now().add(const Duration(hours: 1));
  @override
  Future<String?> readAccessToken() async => access;
  @override
  Future<String?> readRefreshToken() async => refresh;
  @override
  Future<DateTime?> readExpiresAt() async => expiry;
  @override
  Future<void> saveAccessToken(String token) async => access = token;
  @override
  Future<void> saveSession(String a, String r, DateTime e) async {
    access = a;
    refresh = r;
    expiry = e;
  }

  @override
  Future<void> clear() async {
    access = refresh = null;
    expiry = null;
  }
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.reply);
  final ResponseBody Function(RequestOptions) reply;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? stream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return reply(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int status = 200]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

Map<String, Object?> _ticket([String status = 'VALID']) => {
  'ticketId': '22222222-2222-4222-8222-222222222222',
  'ticketCode': _ticketCode,
  'seatCode': 'A1',
  'passengerName': 'Nguyễn Văn An',
  'phoneMasked': '0*** *** 789',
  'pickup': {
    'sequence': 0,
    'name': 'Bến đi',
    'pickupWindowStart': null,
    'pickupWindowEnd': null,
  },
  'dropoff': {
    'sequence': 1,
    'name': 'Bến đến',
    'pickupWindowStart': null,
    'pickupWindowEnd': null,
  },
  'status': status,
  'checkedInAt': status == 'CHECKED_IN' ? '2026-10-31T03:00:00.000Z' : null,
};

Map<String, Object?> _verify([String result = 'OK']) => {
  'result': result,
  'ticket': result == 'WRONG_TRIP' ? null : _ticket(),
  'ticketCode': _ticketCode,
  'ticketTrip': null,
};

DemoTrip _trip() => DemoTrip(
  id: 'Chuyến thử',
  serverId: _tripId,
  origin: 'TP.HCM',
  destination: 'Đà Lạt',
  departure: '10:00',
  operatingNote: '',
  passengers: [DemoPassenger('An', 'A1', _ticketCode, '0***')],
);

(EmployeeApi, _Adapter) _api(
  ResponseBody Function(RequestOptions) reply, {
  _Tokens? tokens,
}) {
  final adapter = _Adapter(reply);
  final client = ApiClientDart(basePathOverride: 'http://localhost:3000');
  client.dio.httpClientAdapter = adapter;
  return (EmployeeApi(client: client, tokens: tokens ?? _Tokens()), adapter);
}

Map<String, dynamic> _body(RequestOptions request) => request.data is String
    ? jsonDecode(request.data as String) as Map<String, dynamic>
    : Map<String, dynamic>.from(request.data as Map);

void main() {
  test('QR token is preserved and local passenger changes only after server commit', () async {
    final trip = _trip();
    final (api, adapter) = _api((request) {
      expect(_body(request)['code'], _token);
      expect(trip.boardedCount, 0);
      return request.path.endsWith('/verify')
          ? _json(_verify())
          : _json({
              'ticket': _ticket('CHECKED_IN'),
              'checkedInCount': 1,
              'ticketCount': 1,
            });
    });
    expect(_token.length, 43);
    final passenger = await api.board(trip, _token);
    expect(passenger.boarded, isTrue);
    expect(trip.boardedCount, 1);
    expect(adapter.requests.length, 2);
    expect(_body(adapter.requests.last)['status'], 'CHECKED_IN');
  });

  test('URLs, arbitrary QR and human ticket code cannot check in', () async {
    final (api, adapter) = _api((_) => fail('No API request expected'));
    for (final value in ['https://example.com', _ticketCode, 'VX102001', '']) {
      await expectLater(
        api.board(_trip(), value),
        throwsA(isA<EmployeeTicketException>()),
      );
    }
    expect(adapter.requests, isEmpty);
  });

  for (final result in [
    'WRONG_TRIP',
    'CANCELLED',
    'REFUNDED',
    'ALREADY_CHECKED_IN',
    'NO_SHOW',
    'USED',
  ]) {
    test('$result never submits check-in or marks passenger boarded', () async {
      final trip = _trip();
      final (api, adapter) = _api((_) => _json(_verify(result)));
      await expectLater(
        api.board(trip, _token),
        throwsA(
          isA<EmployeeTicketException>().having(
            (e) => e.result,
            'result',
            result,
          ),
        ),
      );
      expect(adapter.requests.length, 1);
      expect(trip.boardedCount, 0);
    });
  }

  test('Unknown server token maps to not-found', () async {
    final (api, _) = _api(
      (_) => _json({
        'code': 'TICKET_NOT_FOUND',
        'detail': 'Không tìm thấy vé.',
      }, 404),
    );
    await expectLater(
      api.board(_trip(), _token),
      throwsA(
        isA<EmployeeTicketException>().having(
          (e) => e.result,
          'result',
          'NOT_FOUND',
        ),
      ),
    );
  });

  test(
    'Server failure after verification never produces local success',
    () async {
      final trip = _trip();
      final (api, _) = _api(
        (r) => r.path.endsWith('/verify') ? _json(_verify()) : _json({}, 503),
      );
      await expectLater(
        api.board(trip, _token),
        throwsA(isA<EmployeeApiException>()),
      );
      expect(trip.boardedCount, 0);
    },
  );

  test(
    'Concurrent scan conflict rereads the status and reports already boarded',
    () async {
      var verifies = 0;
      final (api, adapter) = _api((r) {
        if (r.path.endsWith('/verify')) {
          return _json(_verify(++verifies == 1 ? 'OK' : 'ALREADY_CHECKED_IN'));
        }
        return _json({
          'code': 'CHECK_IN_REJECTED',
          'detail': 'Vé đã check-in.',
        }, 409);
      });
      await expectLater(
        api.board(_trip(), _token),
        throwsA(
          isA<EmployeeTicketException>().having(
            (e) => e.result,
            'result',
            'ALREADY_CHECKED_IN',
          ),
        ),
      );
      expect(adapter.requests.length, 3);
    },
  );

  test(
    'Expired access refreshes before verification and uses rotated token',
    () async {
      final tokens = _Tokens()
        ..expiry = DateTime.now().subtract(const Duration(minutes: 1));
      final (api, adapter) = _api((r) {
        if (r.path.endsWith('/refresh')) {
          expect(_body(r)['refreshToken'], 'refresh');
          return _json({
            'accessToken': 'rotated-access',
            'refreshToken': 'rotated-refresh',
            'tokenType': 'Bearer',
            'scope': 'operator',
            'role': 'EMPLOYEE',
            'expiresIn': 900,
            'refreshExpiresIn': 2592000,
          });
        }
        expect(r.headers['authorization'], 'Bearer rotated-access');
        return _json(_verify('CANCELLED'));
      }, tokens: tokens);
      await expectLater(
        api.board(_trip(), _token),
        throwsA(isA<EmployeeTicketException>()),
      );
      expect(adapter.requests.first.path, '/v1/auth/refresh');
      expect(tokens.refresh, 'rotated-refresh');
    },
  );

  test('401 clears the session and never marks a ticket boarded', () async {
    final tokens = _Tokens();
    final trip = _trip();
    final (api, _) = _api(
      (_) => _json({
        'code': 'AUTH_TOKEN_INVALID',
        'detail': 'Đăng nhập lại.',
      }, 401),
      tokens: tokens,
    );
    await expectLater(
      api.board(trip, _token),
      throwsA(isA<EmployeeApiException>()),
    );
    expect(tokens.access, isNull);
    expect(tokens.refresh, isNull);
    expect(trip.boardedCount, 0);
  });

  test('Login uses employee endpoint and stores server session', () async {
    final tokens = _Tokens();
    final (api, adapter) = _api(
      (_) => _json({
        'accessToken': 'new-access',
        'tokenType': 'Bearer',
        'expiresIn': 900,
        'scope': 'operator',
        'role': 'EMPLOYEE',
        'refreshToken': 'new-refresh',
        'refreshExpiresIn': 2592000,
        'mfaRequired': false,
      }),
      tokens: tokens,
    );
    await api.login('nhaxe/taixe', 'password');
    expect(adapter.requests.single.path, '/v1/auth/employee/login');
    expect(adapter.requests.single.headers['X-Auth-Transport'], 'bearer');
    expect(tokens.access, 'new-access');
    expect(tokens.refresh, 'new-refresh');
  });

  test(
    'Assignments load server passenger list and attach live scanner callback',
    () async {
      final assignment = {
        'tripId': _tripId,
        'role': 'DRIVER',
        'routeName': 'TP.HCM → Đà Lạt',
        'departureAt': '2026-10-31T03:00:00.000Z',
        'arrivalAt': '2026-10-31T10:00:00.000Z',
        'status': 'BOARDING',
        'vehiclePlateNumber': '51B-12345',
        'origin': 'TP.HCM',
        'destination': 'Đà Lạt',
        'ticketCount': 1,
        'checkedInCount': 0,
      };
      final (api, adapter) = _api(
        (r) => r.path.endsWith('/assignments')
            ? _json({
                'items': [assignment],
              })
            : _json({
                'trip': assignment,
                'passengers': [_ticket()],
              }),
      );
      final trips = await api.assignments(day: DateTime(2026, 10, 31));
      expect(trips.single.serverId, _tripId);
      expect(trips.single.departure, '10:00');
      expect(trips.single.plate, '51B-12345');
      expect(trips.single.seats, ['A1']);
      expect(trips.single.checkInTicket, isNotNull);
      expect(trips.single.reloadManifest, isNotNull);
      expect(
        adapter.requests.first.queryParameters['from'].toString(),
        '2026-10-31',
      );
    },
  );
}
