import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for JourneyLogsApi
void main() {
  final instance = ApiClientDart().getJourneyLogsApi();

  group(JourneyLogsApi, () {
    //Future<JourneyLogPageDtoOutput> adminJourneyLogControllerList({ String tripId, String cursor, int limit }) async
    test('test adminJourneyLogControllerList', () async {
      // TODO
    });

    //Future<JourneyLogDtoOutput> employeeJourneyLogControllerCreate(JourneyLogInputDto journeyLogInputDto) async
    test('test employeeJourneyLogControllerCreate', () async {
      // TODO
    });

    //Future<JourneyLogPageDtoOutput> employeeJourneyLogControllerList({ String tripId, String cursor, int limit }) async
    test('test employeeJourneyLogControllerList', () async {
      // TODO
    });

    //Future<JourneyLogPageDtoOutput> operatorJourneyLogControllerList({ String tripId, String cursor, int limit }) async
    test('test operatorJourneyLogControllerList', () async {
      // TODO
    });

  });
}
