import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/main.dart';

// PASSENGER-PARITY A21: OTP đăng nhập sai hiện số lần thử còn lại do máy chủ ghi.
void main() {
  test('OTP sai: hiện câu của máy chủ khi có số lần thử, còn lại giữ câu chung', () {
    expect(
      describePassengerAuthFailure(
        const ApiFailure(
          status: 401,
          code: 'AUTH_INVALID_CREDENTIALS',
          detail: 'Mã xác minh không đúng. Còn 2 lần thử.',
        ),
      ),
      'Mã xác minh không đúng. Còn 2 lần thử.',
    );
    expect(
      describePassengerAuthFailure(
        const ApiFailure(
          status: 401,
          code: 'AUTH_INVALID_CREDENTIALS',
          detail: 'Thông tin đăng nhập không hợp lệ.',
        ),
      ),
      'Mã OTP không đúng hoặc đã hết hạn.',
    );
  });
}
