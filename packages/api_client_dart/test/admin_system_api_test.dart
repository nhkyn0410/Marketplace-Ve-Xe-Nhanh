import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminSystemApi
void main() {
  final instance = ApiClientDart().getAdminSystemApi();

  group(AdminSystemApi, () {
    //Future<SystemIntegrationsDtoOutput> systemStatusControllerIntegrations() async
    test('test systemStatusControllerIntegrations', () async {
      // TODO
    });

    //Future<BackgroundJobsDtoOutput> systemStatusControllerJobs() async
    test('test systemStatusControllerJobs', () async {
      // TODO
    });

  });
}
