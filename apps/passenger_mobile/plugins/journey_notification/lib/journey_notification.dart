import 'package:flutter/services.dart';

/// Native renderer registered in both the foreground and FCM background engines.
class JourneyNotification {
  JourneyNotification._();

  static const _channel = MethodChannel('vexenhanh/journey_notification');

  /// Only foreground enrollment may switch the session accepted by the renderer.
  static Future<void> startSession(String sessionId) =>
      _channel.invokeMethod<void>('startSession', sessionId);

  static Future<void> update(Map<String, dynamic> snapshot) =>
      _channel.invokeMethod<void>('update', snapshot);

  /// Clears and tombstones the current session, including delayed push updates.
  static Future<void> clear() => _channel.invokeMethod<void>('clear');

  /// Disable before logout so background messages cannot reveal the old journey.
  static Future<void> setEnabled(bool enabled) =>
      _channel.invokeMethod<void>('setEnabled', enabled);

  static Future<String?> consumeOpenedBooking() =>
      _channel.invokeMethod<String>('consumeOpenedBooking');
}
