import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for NotificationApi
void main() {
  final instance = ApiClientDart().getNotificationApi();

  group(NotificationApi, () {
    //Future<DeviceDtoOutput> preferenceControllerDevice(DeviceInputDto deviceInputDto) async
    test('test preferenceControllerDevice', () async {
      // TODO
    });

    //Future<NotificationLogDtoOutput> preferenceControllerHistory({ int offset, int limit }) async
    test('test preferenceControllerHistory', () async {
      // TODO
    });

    //Future<PreferencesDtoOutput> preferenceControllerPreferences() async
    test('test preferenceControllerPreferences', () async {
      // TODO
    });

    //Future preferenceControllerRemove(String id) async
    test('test preferenceControllerRemove', () async {
      // TODO
    });

    //Future<PreferencesDtoOutput> preferenceControllerSave(PreferenceInputDto preferenceInputDto) async
    test('test preferenceControllerSave', () async {
      // TODO
    });

  });
}
