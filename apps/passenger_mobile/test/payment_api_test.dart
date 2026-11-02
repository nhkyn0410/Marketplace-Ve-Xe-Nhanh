import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/payment_models.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';

import 'support/fake_booking_api.dart';

class _PaymentAdapter implements HttpClientAdapter {
  _PaymentAdapter(this.responses);

  final Map<String, Object> responses;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(responses[options.path]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(TripBookingApi, _PaymentAdapter) _api(Map<String, Object> responses) {
  final adapter = _PaymentAdapter(responses);
  final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'))
    ..httpClientAdapter = adapter;
  return (TripBookingApi(ApiClientDart(dio: dio)), adapter);
}

Map<String, Object?> _booking({
  String status = 'CONFIRMED',
  String payment = 'SUCCESS',
}) => {
  'bookingId': 'booking-1',
  'bookingCode': 'VXN-ABC123',
  'status': status,
  'tripId': 'trip-1',
  'trip': {
    'routeName': 'Sài Gòn – Đà Lạt',
    'operatorName': 'Nhà xe Sao Mai',
    'operatorHotline': null,
    'vehicleTypeName': 'Giường nằm',
    'departureAt': '2026-11-01T00:00:00Z',
    'arrivalAt': '2026-11-01T07:00:00Z',
  },
  'pickup': {
    'sequence': 1,
    'name': 'Điểm đón',
    'address': 'Địa chỉ đón',
    'plannedAt': '2026-11-01T00:00:00Z',
  },
  'dropoff': {
    'sequence': 5,
    'name': 'Điểm trả',
    'address': 'Địa chỉ trả',
    'plannedAt': '2026-11-01T07:00:00Z',
  },
  'contact': {
    'fullName': 'Khách',
    'phone': '0901234567',
    'email': 'test@example.com',
  },
  'passengers': <Object>[],
  'note': null,
  'subtotal': 550000,
  'serviceFee': 0,
  'discount': 0,
  'discountFunding': null,
  'total': 550000,
  'cancellationPolicy': {'tiers': <Object>[]},
  'expiresAt': '2026-11-01T00:10:00Z',
  'createdAt': '2026-11-01T00:00:00Z',
  'payment': {
    'paymentCode': 'PAY123',
    'provider': 'PAYOS',
    'status': payment,
    'amount': 550000,
    'paidAt': '2026-11-01T00:01:00Z',
  },
  'tickets': [
    if (status == 'CONFIRMED')
      {
        'ticketId': 'ticket-1',
        'ticketCode': 'TKT-SERVER-1',
        'seatCode': 'A01',
        'passengerName': 'Khách',
        'companionName': 'Bạn',
        'status': 'VALID',
        'qrToken': 'signed-server-ticket-token',
      },
  ],
  'refunds': <Object>[],
  'tripChanges': <Object>[],
};

void main() {
  test(
    'tạo payOS gửi provider và mã truy cập guest; đọc nội dung QR từ server',
    () async {
      final (api, adapter) = _api({
        '/v1/bookings/booking-1/payments': {
          'paymentId': 'payment-1',
          'paymentCode': 'PAY123',
          'provider': 'PAYOS',
          'status': 'PROCESSING',
          'amount': 550000,
          'paymentUrl': 'https://pay.payos.vn/web/payment-1',
          'expiresAt': '2026-11-01T00:10:00Z',
          'transfer': {
            'qrCode': 'qr-from-signed-response',
            'bin': '970422',
            'accountNumber': '123456789',
            'accountName': 'NGUYEN VAN A',
            'amount': '550000',
            'description': 'SERVER123',
            'paymentLinkId': 'link-1',
          },
        },
      });
      final session = await api.startPayment(
        sampleBooking(),
        PassengerPaymentMethod.payos,
      );
      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.headers['X-Booking-Token'], 'token');
      expect(request.data, {'provider': 'PAYOS'});
      expect(session.transfer!.qrCode, 'qr-from-signed-response');
      expect(session.transfer!.description, 'SERVER123');
      expect(session.transfer!.amount, '550000');
      expect(session.paymentUrl.host, 'pay.payos.vn');
    },
  );

  test(
    'link demo localhost được đổi theo API trên thiết bị, không sửa link payOS',
    () async {
      final (api, _) = _api({
        '/v1/bookings/booking-1/payments': {
          'paymentId': 'payment-1',
          'paymentCode': 'PAY123',
          'provider': 'DEMO',
          'status': 'PROCESSING',
          'amount': 550000,
          'paymentUrl':
              'http://localhost:3000/v1/dev/payment-gateway/demo?code=PAY123',
          'expiresAt': '2026-11-01T00:10:00Z',
        },
      });
      final session = await api.startPayment(
        sampleBooking(),
        PassengerPaymentMethod.demo,
      );
      expect(
        session.paymentUrl.toString(),
        'http://10.0.2.2:3000/v1/dev/payment-gateway/demo?code=PAY123',
      );
      expect(session.transfer, isNull);
    },
  );

  test(
    'đọc trạng thái guest và vé đã ký; chỉ confirmed mới hoàn tất',
    () async {
      final responses = <String, Object>{'/v1/bookings/booking-1': _booking()};
      final (api, adapter) = _api(responses);
      final state = await api.loadPaymentState(sampleBooking());
      expect(adapter.requests.single.headers['X-Booking-Token'], 'token');
      expect(state.isConfirmed, isTrue);
      expect(state.tickets.single.ticketCode, 'TKT-SERVER-1');
      expect(state.tickets.single.qrToken, 'signed-server-ticket-token');
      expect(state.tickets.single.companionName, 'Bạn');
      responses['/v1/bookings/booking-1'] = _booking(status: 'PAID');
      expect(
        (await api.loadPaymentState(sampleBooking())).isConfirmed,
        isFalse,
      );
      responses['/v1/bookings/booking-1'] = _booking(
        status: 'EXPIRED',
        payment: 'RECONCILING',
      );
      final late = await api.loadPaymentState(sampleBooking());
      expect(late.isConfirmed, isFalse);
      expect(late.isClosed, isTrue);
      expect(late.needsReconciliation, isTrue);
    },
  );
}
