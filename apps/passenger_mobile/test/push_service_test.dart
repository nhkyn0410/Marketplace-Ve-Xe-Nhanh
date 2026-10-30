import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/notification/push_service.dart';

void main() {
  test(
    'chưa cấu hình Firebase: bật / tắt push không gọi API, không lỗi',
    () async {
      final calls = <String>[];
      final push = PushService(
        registerDevice: (token) async {
          calls.add('register:$token');
          return 'device-1';
        },
        removeDevice: (id) async => calls.add('remove:$id'),
        options: () => null,
      );

      await push.enable();
      await push.disable();

      expect(calls, isEmpty);
    },
  );

  test('bản build không truyền FIREBASE_* thì PushConfig tắt push', () {
    expect(PushConfig.options, isNull);
  });
}
