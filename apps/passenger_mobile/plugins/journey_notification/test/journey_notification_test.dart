import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_notification/journey_notification.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('vexenhanh/journey_notification');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return call.method == 'consumeOpenedBooking' ? 'booking-42' : null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'enrollment precedes updates and disabling reaches the native renderer',
    () async {
      final snapshot = <String, dynamic>{
        'type': 'journey_demo',
        'sessionId': 'session-42',
        'provinceName': 'Đồng Nai',
        'progress': 680,
      };
      await JourneyNotification.setEnabled(true);
      await JourneyNotification.startSession('session-42');
      await JourneyNotification.update(snapshot);
      await JourneyNotification.setEnabled(false);

      expect(calls.map((call) => call.method), [
        'setEnabled',
        'startSession',
        'update',
        'setEnabled',
      ]);
      expect(calls[1].arguments, 'session-42');
      expect(calls[2].arguments, snapshot);
      expect(calls.last.arguments, false);
    },
  );

  test(
    'booking handoff can be consumed without an update or enrollment',
    () async {
      expect(await JourneyNotification.consumeOpenedBooking(), 'booking-42');
      expect(calls.single.method, 'consumeOpenedBooking');
      await JourneyNotification.clear();
      expect(calls.last.method, 'clear');
    },
  );
}
