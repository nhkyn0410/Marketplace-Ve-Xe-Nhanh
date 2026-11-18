import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

void main() {
  group('compareVietnamese', () {
    test('tỉnh / thành xếp theo bảng chữ cái tiếng Việt, không theo mã ký tự', () {
      final provinces = [
        'Tuyên Quang',
        'Đắk Lắk',
        'TP. Hồ Chí Minh',
        'Tây Ninh',
        'An Giang',
        'Điện Biên',
        'TP. Đà Nẵng',
        'Lâm Đồng',
        'Hà Tĩnh',
        'TP. Hải Phòng',
        'Cà Mau',
        'TP. Hà Nội',
        'Lào Cai',
        'TP. Cần Thơ',
      ]..sort(compareVietnamese);

      expect(provinces, [
        'An Giang',
        'Cà Mau',
        'Đắk Lắk',
        'Điện Biên',
        'Hà Tĩnh',
        'Lào Cai',
        'Lâm Đồng',
        'Tây Ninh',
        'TP. Cần Thơ',
        'TP. Đà Nẵng',
        'TP. Hà Nội',
        'TP. Hải Phòng',
        'TP. Hồ Chí Minh',
        'Tuyên Quang',
      ]);
    });

    test('đ đứng sau d và trước e; ă, â đứng sau a', () {
      final words = ['e', 'đ', 'd', 'â', 'ă', 'a', 'b']..sort(compareVietnamese);
      expect(words, ['a', 'ă', 'â', 'b', 'd', 'đ', 'e']);
    });

    test('dấu thanh chỉ phân định khi chữ giống nhau: ma, mà, mả, mã, má, mạ', () {
      final words = ['mạ', 'má', 'mã', 'mả', 'mà', 'ma']..sort(compareVietnamese);
      expect(words, ['ma', 'mà', 'mả', 'mã', 'má', 'mạ']);
      // Chữ khác nhau thì chữ quyết định, không phải dấu thanh.
      expect(compareVietnamese('má', 'mb'), lessThan(0));
    });

    test('không phân biệt hoa thường; chuỗi ngắn hơn đứng trước', () {
      expect(compareVietnamese('đà nẵng', 'Hà Nội'), lessThan(0));
      expect(compareVietnamese('Hà', 'Hà Nội'), lessThan(0));
      expect(compareVietnamese('Huế', 'Huế'), 0);
    });
  });
}
