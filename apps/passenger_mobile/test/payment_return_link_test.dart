import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/payment_return_link.dart';

const _bookingId = '6f1c2a4e-1b2c-4d3e-8f90-1234567890ab';

void main() {
  test('App Link cổng trả về cho app: lấy mã đơn, bỏ qua tham số cổng', () {
    expect(
      paymentReturnBookingId(
        Uri.parse(
          'https://vexenhanh.id.vn/app/bookings/$_bookingId/payment/result'
          '?vnp_ResponseCode=00&vnp_TxnRef=PAYABC',
        ),
      ),
      _bookingId,
    );
  });

  test('link khác dạng không mở đơn', () {
    for (final link in [
      'https://vexenhanh.id.vn/bookings/$_bookingId/payment/result',
      'http://vexenhanh.id.vn/app/bookings/$_bookingId/payment/result',
      'https://user@vexenhanh.id.vn/app/bookings/$_bookingId/payment/result',
      'https://vexenhanh.id.vn/app/bookings/../payment/result',
      'https://vexenhanh.id.vn/app/bookings/$_bookingId/payment/result/extra',
      'https://vexenhanh.id.vn/app/bookings/not-a-booking/payment/result',
      'vexenhanh://app/bookings/$_bookingId/payment/result',
    ]) {
      expect(paymentReturnBookingId(Uri.parse(link)), isNull, reason: link);
    }
  });
}
