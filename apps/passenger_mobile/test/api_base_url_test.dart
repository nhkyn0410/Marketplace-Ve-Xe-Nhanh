import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/main.dart';

void main() {
  group('resolveApiBaseUrl', () {
    test('Android Emulator mặc định dùng alias của máy host', () {
      expect(
        resolveApiBaseUrl(configured: '', platform: TargetPlatform.android),
        'http://10.0.2.2:3000',
      );
    });

    test('Android dùng loopback dạng số khi đã cấu hình localhost', () {
      expect(
        resolveApiBaseUrl(
          configured: 'http://localhost:3000',
          platform: TargetPlatform.android,
        ),
        'http://127.0.0.1:3000',
      );
    });

    test('Android giữ nguyên API host được cấu hình tường minh', () {
      expect(
        resolveApiBaseUrl(
          configured: 'https://api.example.com',
          platform: TargetPlatform.android,
        ),
        'https://api.example.com',
      );
    });

    test('iOS local giữ localhost', () {
      expect(
        resolveApiBaseUrl(configured: '', platform: TargetPlatform.iOS),
        'http://localhost:3000',
      );
    });
  });
}
