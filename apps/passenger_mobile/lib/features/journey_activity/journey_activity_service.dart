import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:journey_notification/journey_notification.dart';
import 'package:passenger_mobile/features/journey_activity/journey_activity_snapshot.dart';

const _demoConfigured = bool.fromEnvironment('JOURNEY_DEMO_ENABLED');

bool get journeyDemoAvailable =>
    _demoConfigured &&
    !kIsWeb &&
    defaultTargetPlatform == TargetPlatform.android;

abstract interface class JourneyDemoGateway {
  Future<JourneyActivitySnapshot> start(String bookingId, String deviceId);
  Future<JourneyActivitySnapshot?> current(String deviceId);
  Future<void> stop(String sessionId);
}

/// Plugin được đăng ký cả với engine chính và background isolate của FCM.
class JourneyActivityPlatform {
  Future<void> enable(bool enabled) => JourneyNotification.setEnabled(enabled);
  Future<void> startSession(String id) => JourneyNotification.startSession(id);
  Future<void> update(JourneyActivitySnapshot value) =>
      JourneyNotification.update(value.toJson());
}

JourneyActivitySnapshot parseJourneyActivityData(Map<String, dynamic> data) {
  final raw = data['snapshot'];
  if (data['type'] != 'journey_demo' || raw is! String || raw.length > 8192) {
    throw const FormatException('Invalid journey demo message');
  }
  final decoded = jsonDecode(raw);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Invalid journey demo message');
  }
  return JourneyActivitySnapshot.fromJson(decoded);
}

/// Không dùng Timer/UI trong isolate nhận tin; native lưu revision và session.
Future<void> handleJourneyActivityData(Map<String, dynamic> data) async {
  if (!journeyDemoAvailable) return;
  try {
    final snapshot = parseJourneyActivityData(data);
    if (!snapshot.isExpired(DateTime.now())) {
      await JourneyNotification.update(snapshot.toJson());
    }
  } catch (_) {
    // Payload lỗi hoặc plugin không khả dụng không ảnh hưởng thông báo về vé.
    debugPrint('Không cập nhật được thông báo hành trình mô phỏng.');
  }
}

class JourneyActivityService extends ChangeNotifier {
  JourneyActivityService({
    required this.api,
    required this.ensureDevice,
    required this.registeredDevice,
    JourneyActivityPlatform? platform,
    DateTime Function()? now,
  }) : _platform = platform ?? JourneyActivityPlatform(),
       _now = now ?? DateTime.now;

  final JourneyDemoGateway api;
  final Future<String?> Function() ensureDevice;
  final String? Function() registeredDevice;
  final JourneyActivityPlatform _platform;
  final DateTime Function() _now;
  JourneyActivitySnapshot? _current;
  int _generation = 0;
  bool _starting = false;

  JourneyActivitySnapshot? get current => _current;

  Future<void> start(String bookingId) async {
    if (_starting) throw StateError('Đang khởi tạo mô phỏng, vui lòng chờ.');
    _starting = true;
    try {
      await _start(bookingId);
    } finally {
      _starting = false;
    }
  }

  Future<void> _start(String bookingId) async {
    final generation = ++_generation;
    final deviceId = await ensureDevice();
    if (generation != _generation) return;
    if (deviceId == null) {
      throw StateError(
        'Cần bật quyền thông báo và cấu hình Firebase để chạy thử.',
      );
    }
    final snapshot = await api.start(bookingId, deviceId);
    if (generation != _generation) {
      await api.stop(snapshot.sessionId);
      return;
    }
    try {
      await _platform.enable(true);
      await _platform.startSession(snapshot.sessionId);
      if (generation != _generation) {
        await _platform.enable(false);
        await api.stop(snapshot.sessionId);
        return;
      }
      await _platform.update(snapshot);
      if (generation != _generation) return;
      _current = snapshot;
      notifyListeners();
    } catch (_) {
      await _platform.enable(false);
      await api.stop(snapshot.sessionId);
      rethrow;
    }
  }

  Future<void> acceptPush(Map<String, dynamic> data) async {
    await handleJourneyActivityData(data);
    try {
      final next = parseJourneyActivityData(data);
      final old = _current;
      if (old == null ||
          next.sessionId != old.sessionId ||
          next.revision <= old.revision ||
          next.isExpired(_now())) {
        return;
      }
      _current = next.ended ? null : next;
      notifyListeners();
    } on FormatException {
      return;
    }
  }

  Future<void> restore() async {
    final deviceId = registeredDevice();
    if (deviceId == null) return;
    final generation = _generation;
    final snapshot = await api.current(deviceId);
    if (generation != _generation) return;
    if (snapshot == null || snapshot.ended || snapshot.isExpired(_now())) {
      await _platform.enable(false);
      if (generation != _generation) return;
      _current = null;
    } else {
      final old = _current;
      if (old != null &&
          old.sessionId == snapshot.sessionId &&
          old.revision > snapshot.revision) {
        return;
      }
      // Không enroll lại: native phải giữ việc người dùng đã tắt thông báo.
      await _platform.update(snapshot);
      if (generation != _generation) return;
      _current = snapshot;
    }
    notifyListeners();
  }

  Future<void> stop({bool ignoreNetworkError = false}) async {
    ++_generation;
    final sessionId = _current?.sessionId;
    _current = null;
    await _platform.enable(false);
    notifyListeners();
    if (sessionId != null) {
      try {
        await api.stop(sessionId);
      } catch (_) {
        if (!ignoreNetworkError) rethrow;
      }
    }
  }
}
