import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_shared/mobile_shared.dart';

import 'demo_data.dart';

String resolveEmployeeApiBaseUrl({
  String configured = const String.fromEnvironment('API_BASE_URL'),
  TargetPlatform? platform,
}) {
  final android = (platform ?? defaultTargetPlatform) == TargetPlatform.android;
  final value = configured.trim();
  if (value.isEmpty) {
    return android && !kIsWeb
        ? 'http://10.0.2.2:3000'
        : 'http://localhost:3000';
  }
  final uri = Uri.tryParse(value);
  return android && uri?.host == 'localhost'
      ? uri!.replace(host: '127.0.0.1').toString()
      : value;
}

class EmployeeApiException implements Exception {
  const EmployeeApiException(this.code, this.message);
  final String code;
  final String message;
  @override
  String toString() => message;
}

class EmployeeTicketException extends EmployeeApiException {
  const EmployeeTicketException(
    String result, {
    this.ticketCode,
    String? message,
  }) : super(result, message ?? result);
  final String? ticketCode;
  String get result => code;
}

abstract interface class EmployeeTokenStore implements TokenStore {
  Future<String?> readRefreshToken();
  Future<DateTime?> readExpiresAt();
  Future<void> saveSession(String access, String refresh, DateTime expiresAt);
}

/// Refresh token and expiry stay beside the access token in secure storage.
class SecureEmployeeTokenStore implements EmployeeTokenStore {
  const SecureEmployeeTokenStore([this.storage = const FlutterSecureStorage()]);
  final FlutterSecureStorage storage;
  static const _access = 'employee_access_token';
  static const _refresh = 'employee_refresh_token';
  static const _expiry = 'employee_access_expires_at';
  @override
  Future<String?> readAccessToken() => storage.read(key: _access);
  @override
  Future<String?> readRefreshToken() => storage.read(key: _refresh);
  @override
  Future<DateTime?> readExpiresAt() async =>
      DateTime.tryParse(await storage.read(key: _expiry) ?? '');
  @override
  Future<void> saveAccessToken(String token) =>
      storage.write(key: _access, value: token);
  @override
  Future<void> saveSession(
    String access,
    String refresh,
    DateTime expiresAt,
  ) async {
    await storage.write(key: _refresh, value: refresh);
    await storage.write(
      key: _expiry,
      value: expiresAt.toUtc().toIso8601String(),
    );
    await saveAccessToken(access);
  }

  @override
  Future<void> clear() async {
    await storage.delete(key: _access);
    await storage.delete(key: _refresh);
    await storage.delete(key: _expiry);
  }
}

class EmployeeApi {
  EmployeeApi({
    String? baseUrl,
    ApiClientDart? client,
    EmployeeTokenStore? tokens,
  }) : tokens = tokens ?? const SecureEmployeeTokenStore() {
    _client =
        client ??
        createApiClient(
          baseUrl: baseUrl ?? resolveEmployeeApiBaseUrl(),
          tokens: this.tokens,
        );
    if (client != null) {
      _client.dio.interceptors.add(AuthInterceptor(this.tokens));
    }
  }

  final EmployeeTokenStore tokens;
  late final ApiClientDart _client;
  Future<void>? _refreshing;

  Future<T> _request<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      final failure = toApiFailure(error, _client.serializers);
      if (failure.status == 401) await tokens.clear();
      if (failure.code == 'TICKET_NOT_FOUND') {
        throw const EmployeeTicketException(
          'NOT_FOUND',
          message: 'Không tìm thấy vé.',
        );
      }
      throw EmployeeApiException(failure.code, failure.detail);
    }
  }

  Future<void> login(String identifier, String password) async {
    await tokens.clear();
    await _request(() async {
      Response<CredentialLoginResponseDtoOutput> response;
      try {
        response = await _client.getAuthApi().authControllerEmployeeLogin(
          credentialLoginDto: CredentialLoginDto(
            (b) => b
              ..identifier = identifier.trim()
              ..password = password,
          ),
          headers: const {'X-Auth-Transport': 'bearer'},
        );
      } on DioException catch (error) {
        // OpenAPI currently generates boolean literals in this auth union as
        // string enums. A valid HTTP 200 therefore needs a narrow wire fallback.
        if (error.response?.statusCode == 200 && error.response?.data is Map) {
          await _saveLoginPayload(
            Map<String, dynamic>.from(error.response!.data as Map),
          );
          return;
        }
        rethrow;
      }
      final values = response.data?.anyOf.values.values;
      final sessions = values?.whereType<CredentialTokenResponse>();
      if (sessions == null || sessions.isEmpty) {
        final passwordChange =
            values?.any((v) => v is PasswordChangeChallengeResponse) ?? false;
        throw EmployeeApiException(
          passwordChange
              ? 'AUTH_PASSWORD_CHANGE_REQUIRED'
              : 'AUTH_MFA_REQUIRED',
          passwordChange
              ? 'Tài khoản cần đổi mật khẩu trước khi đăng nhập. Vui lòng liên hệ nhà xe.'
              : 'Tài khoản yêu cầu xác thực hai bước. Vui lòng liên hệ nhà xe.',
        );
      }
      final session = sessions.first;
      await tokens.saveSession(
        session.accessToken,
        session.refreshToken,
        DateTime.now().add(Duration(seconds: session.expiresIn ?? 900)),
      );
    });
  }

  Future<void> _saveLoginPayload(Map<String, dynamic> payload) async {
    if (payload['passwordChangeRequired'] == true) {
      throw const EmployeeApiException(
        'AUTH_PASSWORD_CHANGE_REQUIRED',
        'Tài khoản cần đổi mật khẩu trước khi đăng nhập. Vui lòng liên hệ nhà xe.',
      );
    }
    if (payload['mfaRequired'] == true) {
      throw const EmployeeApiException(
        'AUTH_MFA_REQUIRED',
        'Tài khoản yêu cầu xác thực hai bước. Vui lòng liên hệ nhà xe.',
      );
    }
    final access = payload['accessToken'];
    final refresh = payload['refreshToken'];
    final expiry = payload['expiresIn'];
    if (access is! String ||
        access.isEmpty ||
        refresh is! String ||
        refresh.isEmpty ||
        payload['tokenType'] != 'Bearer' ||
        payload['scope'] != 'operator' ||
        payload['role'] != 'EMPLOYEE' ||
        payload['mfaRequired'] != false ||
        (expiry != null && expiry is! int)) {
      throw const EmployeeApiException(
        'UNEXPECTED_RESPONSE',
        'Máy chủ chưa xác nhận đăng nhập.',
      );
    }
    await tokens.saveSession(
      access,
      refresh,
      DateTime.now().add(Duration(seconds: expiry as int? ?? 900)),
    );
  }

  Future<void> _ensureSession() async {
    final access = await tokens.readAccessToken();
    if (access == null || access.isEmpty) {
      throw const EmployeeApiException(
        'AUTH_REQUIRED',
        'Vui lòng đăng nhập lại.',
      );
    }
    final expiry = await tokens.readExpiresAt();
    if (expiry == null ||
        expiry.isAfter(DateTime.now().add(const Duration(seconds: 30)))) {
      return;
    }
    await (_refreshing ??= _refresh().whenComplete(() => _refreshing = null));
  }

  Future<void> _refresh() => _request(() async {
    final refresh = await tokens.readRefreshToken();
    if (refresh == null) {
      throw const EmployeeApiException(
        'AUTH_REQUIRED',
        'Vui lòng đăng nhập lại.',
      );
    }
    final response = await _client.getAuthApi().authControllerRefresh(
      refreshTokenDto: RefreshTokenDto((b) => b..refreshToken = refresh),
      headers: const {'X-Auth-Transport': 'bearer'},
    );
    final session = response.data?.anyOf.values.values
        .whereType<RefreshTokenPairResponse>()
        .firstOrNull;
    if (session == null) {
      await tokens.clear();
      throw const EmployeeApiException(
        'AUTH_REQUIRED',
        'Vui lòng đăng nhập lại.',
      );
    }
    await tokens.saveSession(
      session.accessToken,
      session.refreshToken,
      DateTime.now().add(Duration(seconds: session.expiresIn ?? 900)),
    );
  });

  Future<void> logout() async {
    try {
      await _request(
        () =>
            _client.getAuthApi().authControllerLogout(xAuthTransport: 'bearer'),
      );
    } finally {
      await tokens.clear();
    }
  }

  Future<List<DemoTrip>> assignments({DateTime? day}) async {
    await _ensureSession();
    return _request(() async {
      final date = day == null ? null : Date(day.year, day.month, day.day);
      final assignments =
          (await _client
                  .getEmployeeOperationsApi()
                  .employeeOperationsControllerAssignments(
                    from: date,
                    to: date,
                  ))
              .data;
      if (assignments == null) {
        throw const EmployeeApiException(
          'UNEXPECTED_RESPONSE',
          'Không tải được chuyến.',
        );
      }
      final trips = <DemoTrip>[];
      for (final item in assignments.items) {
        final manifest =
            (await _client
                    .getEmployeeOperationsApi()
                    .employeeOperationsControllerPassengers(
                      tripId: item.tripId,
                    ))
                .data;
        if (manifest == null) {
          throw const EmployeeApiException(
            'UNEXPECTED_RESPONSE',
            'Không tải được danh sách khách.',
          );
        }
        final departure = item.departureAt.toUtc().add(
          const Duration(hours: 7),
        );
        final passengers = manifest.passengers
            .map(
              (p) => _passenger(
                p.passengerName,
                p.seatCode,
                p.ticketCode,
                p.phoneMasked,
                p.status.name,
                p.checkedInAt,
              ),
            )
            .toList();
        final trip = DemoTrip(
          id: item.routeName,
          serverId: item.tripId,
          serviceDate: DateTime(departure.year, departure.month, departure.day),
          origin: item.origin,
          destination: item.destination,
          departure:
              '${departure.hour.toString().padLeft(2, '0')}:${departure.minute.toString().padLeft(2, '0')}',
          operatingNote: '',
          passengers: passengers,
          status: _tripStatus(item.status.name),
          vehiclePlate: item.vehiclePlateNumber ?? 'Chưa phân xe',
          pickupName: item.origin,
          dropoffName: item.destination,
          // Manifest lists ticketed seats, not the full vehicle layout.
          seats: passengers.map((p) => p.seat).toSet().toList(),
        );
        trip.serverBoardedCount = manifest.trip.checkedInCount;
        trip.serverTicketCount = manifest.trip.ticketCount;
        trip.checkInTicket = (code) => board(trip, code);
        trip.reloadManifest = () => reloadManifest(trip);
        trips.add(trip);
      }
      return trips;
    });
  }

  Future<void> reloadManifest(DemoTrip trip) async {
    await _ensureSession();
    await _request(() async {
      final manifest =
          (await _client
                  .getEmployeeOperationsApi()
                  .employeeOperationsControllerPassengers(
                    tripId: trip.serverId!,
                  ))
              .data;
      if (manifest == null) {
        throw const EmployeeApiException(
          'UNEXPECTED_RESPONSE',
          'Không tải được danh sách khách.',
        );
      }
      trip.passengers
        ..clear()
        ..addAll(
          manifest.passengers.map(
            (p) => _passenger(
              p.passengerName,
              p.seatCode,
              p.ticketCode,
              p.phoneMasked,
              p.status.name,
              p.checkedInAt,
            ),
          ),
        );
      trip.seats
        ..clear()
        ..addAll(trip.passengers.map((p) => p.seat).toSet());
      trip.serverBoardedCount = manifest.trip.checkedInCount;
      trip.serverTicketCount = manifest.trip.ticketCount;
    });
  }

  Future<DemoPassenger> board(DemoTrip trip, String rawCode) async {
    // Only a server-issued QR token is accepted here; human ticket codes are
    // reserved for other API callers. Never uppercase a base64url token.
    if (!RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(rawCode)) {
      throw const EmployeeTicketException(
        'NOT_FOUND',
        message: 'Không tìm thấy vé.',
      );
    }
    final tripId = trip.serverId;
    if (tripId == null) {
      throw const EmployeeApiException(
        'ASSIGNMENT_NOT_FOUND',
        'Không có phân công chuyến hợp lệ.',
      );
    }
    await _ensureSession();
    return _request(() async {
      final api = _client.getEmployeeOperationsApi();
      final verified = (await api.employeeOperationsControllerVerify(
        ticketVerifyInputDto: TicketVerifyInputDto(
          (b) => b
            ..tripId = tripId
            ..code = rawCode,
        ),
      )).data;
      if (verified == null) {
        throw const EmployeeApiException(
          'UNEXPECTED_RESPONSE',
          'Chưa xác minh được vé.',
        );
      }
      if (verified.result != TicketVerifyResultDtoOutputResultEnum.OK) {
        throw EmployeeTicketException(
          verified.result.name,
          ticketCode: verified.ticketCode,
          message: _ticketMessage(verified.result.name),
        );
      }
      CheckInResultDtoOutput? checked;
      try {
        checked = (await api.employeeOperationsControllerCheckIn(
          checkInInputDto: CheckInInputDto(
            (b) => b
              ..tripId = tripId
              ..code = rawCode
              ..status = CheckInInputDtoStatusEnum.CHECKED_IN,
          ),
        )).data;
      } on DioException catch (error) {
        // Another scanner may have accepted/cancelled this ticket between the
        // two requests. Re-read state for an accurate rejection screen.
        if (error.response?.statusCode == 409) {
          final latest = (await api.employeeOperationsControllerVerify(
            ticketVerifyInputDto: TicketVerifyInputDto(
              (b) => b
                ..tripId = tripId
                ..code = rawCode,
            ),
          )).data;
          if (latest != null &&
              latest.result != TicketVerifyResultDtoOutputResultEnum.OK) {
            throw EmployeeTicketException(
              latest.result.name,
              ticketCode: latest.ticketCode,
              message: _ticketMessage(latest.result.name),
            );
          }
        }
        rethrow;
      }
      final ticket = checked?.ticket;
      if (ticket == null ||
          ticket.status !=
              TicketVerifyResultDtoOutputTicketStatusEnum.CHECKED_IN) {
        throw const EmployeeApiException(
          'UNEXPECTED_RESPONSE',
          'Chưa xác nhận lên xe. Vui lòng kiểm tra lại vé.',
        );
      }
      final passenger = _passenger(
        ticket.passengerName,
        ticket.seatCode,
        ticket.ticketCode,
        ticket.phoneMasked,
        ticket.status.name,
        ticket.checkedInAt,
      );
      final index = trip.passengers.indexWhere(
        (p) => p.ticket == passenger.ticket,
      );
      if (index >= 0) {
        trip.passengers[index] = passenger;
      } else {
        trip.passengers.add(passenger);
      }
      trip.serverBoardedCount = checked!.checkedInCount;
      trip.serverTicketCount = checked.ticketCount;
      return passenger;
    });
  }

  static DemoPassenger _passenger(
    String name,
    String seat,
    String ticket,
    String phone,
    String status,
    DateTime? checkedInAt,
  ) => DemoPassenger(name, seat, ticket, phone)
    ..boarded = status == 'CHECKED_IN' || status == 'USED'
    ..absent = status == 'NO_SHOW'
    ..checkedInAt = checkedInAt;

  static String _tripStatus(String status) => switch (status) {
    'BOARDING' => 'Đón khách',
    'DEPARTED' => 'Đã khởi hành',
    'IN_PROGRESS' => 'Đang chạy',
    'COMPLETED' => 'Hoàn thành',
    'CANCELLED' => 'Đã hủy',
    'INCIDENT' => 'Sự cố',
    _ => 'Sắp khởi hành',
  };

  static String _ticketMessage(String result) => switch (result) {
    'WRONG_TRIP' => 'Vé thuộc chuyến khác.',
    'CANCELLED' => 'Vé đã hủy.',
    'REFUNDED' => 'Vé đã hoàn tiền.',
    'ALREADY_CHECKED_IN' => 'Vé đã lên xe trước đó.',
    'NO_SHOW' => 'Vé đã được ghi nhận vắng mặt.',
    'USED' => 'Vé đã sử dụng cho chuyến đã hoàn thành.',
    _ => 'Vé không hợp lệ.',
  };
}
