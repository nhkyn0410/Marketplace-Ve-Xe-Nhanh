import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminNotificationApi
void main() {
  final instance = ApiClientDart().getAdminNotificationApi();

  group(AdminNotificationApi, () {
    //Future<NotificationLogDtoOutput> adminNotificationControllerHistory({ int offset, int limit }) async
    test('test adminNotificationControllerHistory', () async {
      // TODO
    });

  });
}
