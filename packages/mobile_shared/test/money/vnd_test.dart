import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

void main() {
  group('formatVnd', () {
    test('nhóm nghìn bằng dấu chấm', () {
      expect(formatVnd(1234567), '1.234.567 ₫');
      expect(formatVnd(1000), '1.000 ₫');
      expect(formatVnd(999), '999 ₫');
      expect(formatVnd(0), '0 ₫');
    });

    test('giữ dấu âm ở ngoài cùng', () {
      expect(formatVnd(-50000), '-50.000 ₫');
    });

    test('bỏ ký hiệu khi withSymbol = false', () {
      expect(formatVnd(250000, withSymbol: false), '250.000');
    });

    test('không mất chính xác ở số lớn hơn 2^53', () {
      // Đây là lý do cấm `double`: 9007199254740993 không biểu diễn được bằng
      // double, đổi qua lại sẽ ra 9007199254740992.
      const beyondDouble = 9007199254740993;
      expect(formatVnd(beyondDouble), '9.007.199.254.740.993 ₫');
      expect(parseVnd(formatVnd(beyondDouble)), beyondDouble);
    });
  });

  group('parseVnd', () {
    test('đảo ngược được formatVnd', () {
      for (final amount in [0, 999, 1000, 1234567, -50000]) {
        expect(parseVnd(formatVnd(amount)), amount, reason: 'với $amount');
      }
    });

    test('ném FormatException khi chuỗi không hợp lệ', () {
      expect(() => parseVnd('một triệu'), throwsFormatException);
    });
  });
}
