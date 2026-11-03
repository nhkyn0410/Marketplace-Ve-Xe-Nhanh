import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for JourneyDemoApi
void main() {
  final instance = ApiClientDart().getJourneyDemoApi();

  group(JourneyDemoApi, () {
    //Future<JourneyDemoCurrentDtoOutput> journeyDemoControllerCurrent(String deviceId) async
    test('test journeyDemoControllerCurrent', () async {
      // TODO
    });

    //Future<JourneyDemoSnapshotDtoOutput> journeyDemoControllerStart(JourneyDemoStartDto journeyDemoStartDto) async
    test('test journeyDemoControllerStart', () async {
      // TODO
    });

    //Future journeyDemoControllerStop(String sessionId) async
    test('test journeyDemoControllerStop', () async {
      // TODO
    });

  });
}
