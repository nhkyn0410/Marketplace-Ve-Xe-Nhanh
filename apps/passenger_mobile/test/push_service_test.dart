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

  test('chạm tin về đơn vé mở Hành trình, tin khác mở hộp thư', () {
    PushMessage message(String? kind) =>
        PushMessage(title: 't', body: 'b', kind: kind);

    for (final kind in [
      'BOOKING_CONFIRMED',
      'TICKETS_CANCELLED',
      'REFUND_SUCCEEDED',
      'TRIP_CHANGED',
      'TRIP_CANCELLED',
      'MANUAL_REFUND',
    ]) {
      expect(message(kind).opensJourney, isTrue, reason: kind);
    }
    for (final kind in [
      'PROMOTION',
      'NEWS',
      'SERVICE_NOTICE',
      'LOYALTY_UPDATED',
      'CASE_UPDATED',
    ]) {
      expect(message(kind).opensJourney, isFalse, reason: kind);
    }
    // Tin cũ chưa có `kind` giữ hành vi trước đây.
    expect(message(null).opensJourney, isTrue);
  });
}
