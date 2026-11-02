import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Cấu hình Firebase lấy từ `--dart-define` / `--dart-define-from-file` (cùng file `.env.*` với `API_BASE_URL`),
/// nên không cần `google-services.json` hay plugin Gradle. Thiếu một giá trị thì tắt push.
class PushConfig {
  const PushConfig._();

  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _senderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');

  /// `null` = chưa cấu hình Firebase cho bản build này.
  static FirebaseOptions? get options {
    if ([
      _apiKey,
      _appId,
      _senderId,
      _projectId,
    ].any((value) => value.isEmpty)) {
      return null;
    }
    return const FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      messagingSenderId: _senderId,
      projectId: _projectId,
    );
  }
}

/// Thông báo đến khi app đang mở (hệ thống không tự hiện) hoặc khi người dùng chạm thông báo.
class PushMessage {
  const PushMessage({required this.title, required this.body, this.kind});

  /// Loại tin liên quan tới một đơn vé: chạm vào thì mở tab Hành trình.
  static const _journeyKinds = {
    'BOOKING_CONFIRMED',
    'TICKETS_CANCELLED',
    'REFUND_SUCCEEDED',
    'TRIP_CHANGED',
    'TRIP_CANCELLED',
    'MANUAL_REFUND',
  };

  final String title;
  final String body;

  /// Loại thông báo máy chủ gửi kèm trong `data`.
  final String? kind;

  /// `false` = mở hộp thư (khuyến mãi, tin tức, thông báo dịch vụ...).
  bool get opensJourney => kind == null || _journeyKinds.contains(kind);
}

/// Push FCM cho hành khách đăng nhập (ADR-020/028): xin quyền, đăng ký token với API
/// (`POST /me/push-devices`), gỡ khi đăng xuất. Máy chủ gửi tiêu đề, nội dung và loại tin.
class PushService {
  PushService({
    required this.registerDevice,
    required this.removeDevice,
    FirebaseOptions? Function()? options,
  }) : _options = options ?? (() => PushConfig.options);

  /// Đăng ký token, trả id thiết bị ở máy chủ.
  final Future<String> Function(String token) registerDevice;
  final Future<void> Function(String deviceId) removeDevice;
  final FirebaseOptions? Function() _options;

  final _foreground = StreamController<PushMessage>.broadcast();
  final _opened = StreamController<PushMessage>.broadcast();
  bool _initialized = false;
  String? _deviceId;
  StreamSubscription<String>? _tokenRefresh;

  /// Thông báo đến khi app đang mở.
  Stream<PushMessage> get foregroundMessages => _foreground.stream;

  /// Người dùng chạm thông báo (app ở nền hoặc vừa được mở từ thông báo).
  Stream<PushMessage> get openedMessages => _opened.stream;

  Future<bool> _ensureInitialized() async {
    if (_initialized) return true;
    final options = _options();
    if (options == null) return false;
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp(options: options);
      FirebaseMessaging.onMessage.listen((message) {
        final note = _toMessage(message);
        if (note != null) _foreground.add(note);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        final note = _toMessage(message);
        if (note != null) _opened.add(note);
      });
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      final note = initial == null ? null : _toMessage(initial);
      if (note != null) _opened.add(note);
      _initialized = true;
      return true;
    } catch (error) {
      debugPrint('Push tắt: không khởi tạo được Firebase ($error).');
      return false;
    }
  }

  /// Sau khi đăng nhập: xin quyền thông báo, đăng ký token; token đổi thì đăng ký lại.
  /// Không cấu hình Firebase, người dùng từ chối quyền hoặc lỗi mạng thì bỏ qua (không chặn đăng nhập).
  Future<void> enable() async {
    if (!await _ensureInitialized()) return;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await messaging.getToken();
      if (token == null) return;
      // Bản debug in token để gửi thử từ Firebase Console (RB-11); bản release không in.
      if (kDebugMode) debugPrint('FCM token: $token');
      _deviceId = await registerDevice(token);
      await _tokenRefresh?.cancel();
      _tokenRefresh = messaging.onTokenRefresh.listen((fresh) async {
        try {
          _deviceId = await registerDevice(fresh);
        } catch (error) {
          debugPrint('Không đăng ký lại được token push ($error).');
        }
      });
    } catch (error) {
      debugPrint('Không bật được push ($error).');
    }
  }

  /// Trước khi đăng xuất (còn phiên): gỡ thiết bị khỏi tài khoản và xóa token trên máy.
  Future<void> disable() async {
    await _tokenRefresh?.cancel();
    _tokenRefresh = null;
    final deviceId = _deviceId;
    _deviceId = null;
    if (!_initialized) return;
    try {
      if (deviceId != null) await removeDevice(deviceId);
    } catch (error) {
      debugPrint('Không gỡ được thiết bị push ($error).');
    }
    // Phiên đã hết thì máy chủ từ chối lệnh gỡ; xóa token trên máy để lần gửi sau
    // máy chủ nhận `UNREGISTERED` và tự tắt thiết bị.
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (error) {
      debugPrint('Không xóa được token push ($error).');
    }
  }

  static PushMessage? _toMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return null;
    return PushMessage(
      title: notification.title ?? 'Vé Xe Nhanh',
      body: notification.body ?? '',
      kind: message.data['kind'] as String?,
    );
  }
}
