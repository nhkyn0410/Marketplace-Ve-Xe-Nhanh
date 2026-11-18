import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/journey_activity/journey_activity_service.dart';
import 'package:passenger_mobile/features/journey_activity/journey_activity_snapshot.dart';
import 'package:passenger_mobile/features/journey_activity/journey_demo_panel.dart';

final _now = DateTime.utc(2026, 11, 3, 5);

Map<String, dynamic> snapshotJson({int revision = 0, bool ended = false}) => {
  'type': 'journey_demo',
  'schemaVersion': 1,
  'sessionId': '00000000-0000-4000-8000-000000000001',
  'bookingId': '00000000-0000-4000-8000-000000000002',
  'revision': revision,
  'stage': ended ? 'stopped' : 'travelling',
  'routeLabel': 'TP. HCM → Đà Lạt',
  'provinceName': 'Đồng Nai',
  'etaAt': _now.add(const Duration(minutes: 3)).toIso8601String(),
  'progress': 680,
  'updatedAt': _now.toIso8601String(),
  'expiresAt': _now.add(const Duration(minutes: 4)).toIso8601String(),
  'ended': ended,
};

class FakeGateway implements JourneyDemoGateway {
  final calls = <String>[];
  Completer<JourneyActivitySnapshot>? pendingStart;
  JourneyActivitySnapshot? snapshot = JourneyActivitySnapshot.fromJson(
    snapshotJson(),
  );

  @override
  Future<JourneyActivitySnapshot> start(
    String bookingId,
    String deviceId,
  ) async {
    calls.add('start:$bookingId:$deviceId');
    return pendingStart == null ? snapshot! : pendingStart!.future;
  }

  @override
  Future<JourneyActivitySnapshot?> current(String deviceId) async => snapshot;

  @override
  Future<void> stop(String sessionId) async => calls.add('stop:$sessionId');
}

class FakePlatform extends JourneyActivityPlatform {
  final calls = <String>[];
  @override
  Future<void> enable(bool enabled) async => calls.add('enabled:$enabled');
  @override
  Future<void> startSession(String id) async => calls.add('enroll:$id');
  @override
  Future<void> update(JourneyActivitySnapshot value) async =>
      calls.add('update:${value.revision}');
}

void main() {
  testWidgets('khối demo chạy/dừng và hiện tỉnh; thao tác không sửa booking', (
    tester,
  ) async {
    final api = FakeGateway();
    final service = JourneyActivityService(
      api: api,
      platform: FakePlatform(),
      ensureDevice: () async => 'device',
      registeredDevice: () => 'device',
      now: () => _now,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyDemoPanel(
            service: service,
            bookingId: api.snapshot!.bookingId,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Chạy thử hành trình'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đang qua Đồng Nai'), findsOneWidget);
    await tester.tap(find.text('Dừng mô phỏng'));
    await tester.pumpAndSettle();
    expect(service.current, isNull);
    expect(api.calls.length, 2);
    await tester.pumpWidget(const SizedBox());
    service.dispose();
  });

  test('restore không kéo giao diện về revision cũ', () async {
    final api = FakeGateway()
      ..snapshot = JourneyActivitySnapshot.fromJson(snapshotJson(revision: 4));
    final service = JourneyActivityService(
      api: api,
      platform: FakePlatform(),
      ensureDevice: () async => 'device',
      registeredDevice: () => 'device',
      now: () => _now,
    );
    await service.start('booking');
    api.snapshot = JourneyActivitySnapshot.fromJson(snapshotJson());
    await service.restore();
    expect(service.current?.revision, 4);
    service.dispose();
  });

  test(
    'restore xóa thẻ khi server đã dọn phiên dù push kết thúc bị mất',
    () async {
      final api = FakeGateway()..snapshot = null;
      final native = FakePlatform();
      final service = JourneyActivityService(
        api: api,
        platform: native,
        ensureDevice: () async => 'device',
        registeredDevice: () => 'device',
        now: () => _now,
      );
      await service.restore();
      expect(native.calls, ['enabled:false']);
      expect(service.current, isNull);
      service.dispose();
    },
  );

  test('snapshot giữ tỉnh, tiến độ và mốc thời gian khi chuyển qua native', () {
    final snapshot = JourneyActivitySnapshot.fromJson(snapshotJson());
    expect(snapshot.provinceName, 'Đồng Nai');
    expect(snapshot.toJson(), snapshotJson());
    expect(snapshot.isExpired(_now.add(const Duration(minutes: 5))), isTrue);
  });

  test('loại payload sai phiên bản, tiến độ hoặc trạng thái kết thúc', () {
    for (final change in [
      {'schemaVersion': 2},
      {'progress': 1001},
      {'progress': -1},
      {'stage': 'COMPLETED'},
      {'ended': true},
      {'etaAt': 'not-a-date'},
    ]) {
      expect(
        () => JourneyActivitySnapshot.fromJson({...snapshotJson(), ...change}),
        throwsFormatException,
        reason: change.toString(),
      );
    }
    expect(
      () =>
          parseJourneyActivityData({'type': 'journey_demo', 'snapshot': '[]'}),
      throwsFormatException,
    );
  });

  test(
    'FCM snapshot data-only được đọc, không dùng notification title/body',
    () {
      final snapshot = parseJourneyActivityData({
        'type': 'journey_demo',
        'snapshot': jsonEncode(snapshotJson()),
      });
      expect(snapshot.progress, 680);
      expect(snapshot.provinceName, 'Đồng Nai');
    },
  );

  test(
    'start đăng ký session trước khi render; stop tắt native trước khi gọi API',
    () async {
      final api = FakeGateway();
      final native = FakePlatform();
      final service = JourneyActivityService(
        api: api,
        platform: native,
        ensureDevice: () async => 'device',
        registeredDevice: () => 'device',
        now: () => _now,
      );
      await service.start('booking');
      expect(native.calls, [
        'enabled:true',
        'enroll:${api.snapshot!.sessionId}',
        'update:0',
      ]);
      expect(service.current?.provinceName, 'Đồng Nai');
      await service.stop();
      expect(native.calls.last, 'enabled:false');
      expect(api.calls.last, 'stop:${api.snapshot!.sessionId}');
      expect(service.current, isNull);
      service.dispose();
    },
  );

  test('restore không enroll/bật lại thông báo đã bị người dùng tắt', () async {
    final native = FakePlatform();
    final service = JourneyActivityService(
      api: FakeGateway(),
      platform: native,
      ensureDevice: () async => 'device',
      registeredDevice: () => 'device',
      now: () => _now,
    );
    await service.restore();
    expect(native.calls, ['update:0']);
    service.dispose();
  });

  test(
    'logout trong lúc start đang chờ không bật lại thông báo sau phản hồi API',
    () async {
      final api = FakeGateway()
        ..pendingStart = Completer<JourneyActivitySnapshot>();
      final native = FakePlatform();
      final service = JourneyActivityService(
        api: api,
        platform: native,
        ensureDevice: () async => 'device',
        registeredDevice: () => 'device',
        now: () => _now,
      );
      final starting = service.start('booking');
      await Future<void>.delayed(Duration.zero);
      await expectLater(service.start('another-booking'), throwsStateError);
      await service.stop();
      api.pendingStart!.complete(api.snapshot!);
      await starting;
      expect(native.calls, ['enabled:false']);
      expect(api.calls.last, 'stop:${api.snapshot!.sessionId}');
      expect(service.current, isNull);
      service.dispose();
    },
  );

  test('thiếu quyền hoặc Firebase thì không tạo phiên server', () async {
    final api = FakeGateway();
    final service = JourneyActivityService(
      api: api,
      platform: FakePlatform(),
      ensureDevice: () async => null,
      registeredDevice: () => null,
      now: () => _now,
    );
    await expectLater(service.start('booking'), throwsStateError);
    expect(api.calls, isEmpty);
    service.dispose();
  });
}
