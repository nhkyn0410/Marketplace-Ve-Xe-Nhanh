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

    test('KHÔNG được nhận chuỗi sai thành một số tiền khác', () {
      // Hồi quy: bản đầu bỏ dấu chấm TRƯỚC khi kiểm tra, nên '1.5' lọt thành 15
      // và '1.2.3' thành 123 — sai số tiền mà không một tín hiệu nào.
      for (final bad in ['1.5', '1.2.3', '1.23', '1234.567', '.5', '5.']) {
        expect(() => parseVnd(bad), throwsFormatException, reason: 'với "\$bad"');
      }
    });

    test('KHÔNG được nhận số hex', () {
      // Hồi quy: `int.parse` không truyền radix sẽ đọc tiền tố 0x, và
      // '0xffffffffffffffff' cuộn vòng im lặng thành -1.
      for (final bad in ['0xffffffffffffffff', '0x10', '-0x10', '1e3', '+5']) {
        expect(() => parseVnd(bad), throwsFormatException, reason: 'với "\$bad"');
      }
    });

    test('vẫn nhận đúng các dạng hợp lệ', () {
      expect(parseVnd('1.234.567 ₫'), 1234567);
      expect(parseVnd('1234567'), 1234567);
      expect(parseVnd('-50.000'), -50000);
      expect(parseVnd('0'), 0);
      expect(parseVnd('999'), 999);
    });
  });
}
