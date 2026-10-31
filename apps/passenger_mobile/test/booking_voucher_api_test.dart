import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';

class _VoucherAdapter implements HttpClientAdapter {
  _VoucherAdapter(this.responseFor, {this.status = 200});
  final Object Function(RequestOptions) responseFor;
  final int status;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(responseFor(options)),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(TripBookingApi, _VoucherAdapter) _api(
  Object Function(RequestOptions) responseFor, {
  int status = 200,
}) {
  final adapter = _VoucherAdapter(responseFor, status: status);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  return (TripBookingApi(ApiClientDart(dio: dio)), adapter);
}

Map<String, Object?> _voucher(String id) => {
  'userVoucherId': id,
  'source': 'LOYALTY_REDEMPTION',
  'status': 'AVAILABLE',
  'promotionCode': null,
  'name': 'Voucher đã đổi điểm',
  'discountAmount': '50000',
  'discountType': 'AMOUNT',
  'discountValue': '50000',
  'maxDiscount': null,
  'minOrder': '300000',
  'expiresAt': '2027-01-01T00:00:00Z',
  'createdAt': '2026-10-31T00:00:00Z',
};

void main() {
  test(
    'ví tải đúng AVAILABLE và đọc hết các trang thật, không tạo mẫu khi rỗng',
    () async {
      final (api, adapter) = _api(
        (request) => {
          'items': [
            _voucher(
              request.uri.queryParameters['offset'] == '0'
                  ? 'wallet-1'
                  : 'wallet-2',
            ),
          ],
          'total': 2,
        },
      );
      final wallet = await api.loadBookingVouchers();
      expect(wallet.map((item) => item.id), ['wallet-1', 'wallet-2']);
      expect(wallet.first.discountValue, '50000');
      expect(wallet.first.minOrder, '300000');
      expect(adapter.requests.map((r) => r.uri.path), [
        '/v1/me/vouchers',
        '/v1/me/vouchers',
      ]);
      expect(adapter.requests.map((r) => r.uri.queryParameters), [
        {'status': 'AVAILABLE', 'offset': '0', 'limit': '50'},
        {'status': 'AVAILABLE', 'offset': '1', 'limit': '50'},
      ]);
      final (emptyApi, _) = _api((_) => {'items': <Object>[], 'total': 0});
      expect(await emptyApi.loadBookingVouchers(), isEmpty);
    },
  );

  test(
    'kiểm voucher gửi ID thay vì code, lấy số tiền và mã hiển thị từ server',
    () async {
      final (api, adapter) = _api(
        (_) => {
          'code': 'SERVER-CODE',
          'name': 'Voucher server',
          'discount': 23456,
          'total': 576544,
        },
      );
      final quote = await api.checkVoucher(
        tripId: 'trip-1',
        userVoucherId: 'wallet-1',
        subtotal: 600000,
      );
      final body = adapter.requests.single.data as Map;
      expect(body, {
        'tripId': 'trip-1',
        'userVoucherId': 'wallet-1',
        'subtotal': 600000,
      });
      expect(body.containsKey('code'), isFalse);
      expect(quote.userVoucherId, 'wallet-1');
      expect(quote.code, 'SERVER-CODE');
      expect(quote.discount, 23456);
      expect(quote.total, 576544);
    },
  );

  for (final useWallet in [true, false]) {
    test('tạo booking gửi đúng một ưu đãi: ví=$useWallet', () async {
      final (api, adapter) = _api(
        (_) => {
          'type': 'about:blank',
          'title': 'Test rejected after capture',
          'status': 422,
          'detail': 'Chỉ kiểm request đã gửi.',
          'code': 'BOOKING_SNAPSHOT_CHANGED',
          'instance': '/v1/bookings',
        },
        status: 422,
      );
      await expectLater(
        api.createBooking(
          holdId: 'hold-1',
          expectedTotal: 550000,
          draft: BookingDraft(
            contact: const BookingContact(
              fullName: 'Hành khách',
              phone: '0901234567',
              email: 'a@example.com',
            ),
            passengers: const [
              BookingPassenger(seatCode: 'A01', fullName: 'Hành khách'),
            ],
            promotion: PromotionQuote(
              code: 'GIAM50',
              name: 'Giảm 50K',
              discount: 50000,
              total: 550000,
              userVoucherId: useWallet ? 'wallet-1' : null,
            ),
          ),
        ),
        throwsA(isA<ApiFailure>()),
      );
      final body = adapter.requests.single.data as Map;
      expect(body['expectedTotal'], 550000);
      expect(
        body[useWallet ? 'userVoucherId' : 'promotionCode'],
        useWallet ? 'wallet-1' : 'GIAM50',
      );
      expect(
        body.containsKey(useWallet ? 'promotionCode' : 'userVoucherId'),
        isFalse,
      );
    });
  }
}
