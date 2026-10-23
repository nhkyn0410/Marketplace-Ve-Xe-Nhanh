import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminAuditLogsApi
void main() {
  final instance = ApiClientDart().getAdminAuditLogsApi();

  group(AdminAuditLogsApi, () {
    //Future<AdminAuditLogDetailDtoOutput> adminAuditLogControllerGet(String id) async
    test('test adminAuditLogControllerGet', () async {
      // TODO
    });

    //Future<AdminAuditLogListDtoOutput> adminAuditLogControllerList({ DateTime from, DateTime to, String actorType, String module, String result, String q, String cursor, int limit }) async
    test('test adminAuditLogControllerList', () async {
      // TODO
    });

  });
}
