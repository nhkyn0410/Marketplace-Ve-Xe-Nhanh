import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/common/support_contact.dart';

void main() {
  group('SupportContact — tổng đài đọc từ một cấu hình', () {
    test('có số tổng đài: hiển thị đúng số, mở ứng dụng gọi điện', () {
      const support = SupportContact(hotline: ' 1900 1234 ');
      expect(support.hasHotline, isTrue);
      expect(support.label, '1900 1234');
      expect(support.uri.toString(), 'tel:19001234');
      expect(support.instruction, 'gọi tổng đài 1900 1234');
      expect(
        support.launchFailureMessage,
        'Không thể mở ứng dụng gọi điện trên thiết bị này.',
      );
    });

    test('chưa cấu hình hoặc cấu hình không phải số: chuyển sang email', () {
      for (final raw in ['', '   ', 'chưa có']) {
        final support = SupportContact(hotline: raw);
        expect(support.hasHotline, isFalse, reason: '"$raw"');
        expect(support.label, 'support@vexenhanh.vn');
        expect(support.uri.toString(), 'mailto:support@vexenhanh.vn');
        expect(support.instruction, 'gửi email tới support@vexenhanh.vn');
      }
    });

    test('không khai SUPPORT_HOTLINE thì dùng số chung của sàn, giống web', () {
      // PASSENGER-PARITY Q1 (Khanh chốt 16/11/2026): một số cho cả web và app.
      expect(SupportContact.configured.label, defaultSupportHotline);
      expect(SupportContact.configured.label, '1900 636 707');
      expect(SupportContact.configured.uri.toString(), 'tel:1900636707');
    });
  });
}
