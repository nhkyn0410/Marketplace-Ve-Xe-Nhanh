import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';

/// Kênh mà `flutter_secure_storage` dùng để nói chuyện với native.
///
/// Đây là **chi tiết nội bộ của plugin**, không phải API công khai. Nếu nâng
/// phiên bản plugin mà test này vỡ trong khi app thật vẫn chạy, hãy đọc lại
/// `flutter_secure_storage_platform_interface/lib/src/
/// method_channel_flutter_secure_storage.dart` trước khi nghi ngờ code của mình.
const _channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Đóng vai Keystore (Android) / Keychain (iOS) trong bộ nhớ.
  late Map<String, String> native;
  late List<MethodCall> calls;

  setUp(() {
    native = <String, String>{};
    calls = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      final args = (call.arguments as Map?) ?? const <Object?, Object?>{};
      switch (call.method) {
        case 'write':
          native[args['key'] as String] = args['value'] as String;
          return null;
        case 'read':
          return native[args['key'] as String];
        case 'delete':
          native.remove(args['key'] as String);
          return null;
        case 'deleteAll':
          native.clear();
          return null;
        case 'containsKey':
          return native.containsKey(args['key'] as String);
        default:
          return null;
      }
    });
  });

  tearDown(() {
    // Bắt buộc gỡ: handler còn treo sẽ rò sang file test khác chạy sau.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  test('lưu rồi đọc lại đúng token', () async {
    const storage = TokenStorage();

    await storage.saveAccessToken('token-abc');

    expect(await storage.readAccessToken(), 'token-abc');
  });

  test('chưa lưu gì thì đọc ra null', () async {
    expect(await const TokenStorage().readAccessToken(), isNull);
  });

  test('clear() xoá token khỏi native store', () async {
    const storage = TokenStorage();
    await storage.saveAccessToken('token-abc');

    await storage.clear();

    expect(await storage.readAccessToken(), isNull);
    expect(native, isEmpty);
  });

  test('ghi/đọc/xoá đúng ba method native và đúng một key cố định', () async {
    // Khoá đổi tên = mọi người dùng đang đăng nhập bị văng ra sau khi cập nhật
    // app, mà không có lỗi nào hiện ra. Ghim lại bằng test.
    const storage = TokenStorage();

    await storage.saveAccessToken('x');
    await storage.readAccessToken();
    await storage.clear();

    expect(calls.map((c) => c.method).toList(), ['write', 'read', 'delete']);
    for (final call in calls) {
      expect((call.arguments as Map)['key'], 'access_token');
    }
  });
}
