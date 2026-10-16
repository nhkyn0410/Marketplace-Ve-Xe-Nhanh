import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminUsersApi
void main() {
  final instance = ApiClientDart().getAdminUsersApi();

  group(AdminUsersApi, () {
    //Future<AdminEmployeePageDtoOutput> adminEmployeeControllerList({ String q, String operatorId, String role, String status, String cursor, int limit }) async
    test('test adminEmployeeControllerList', () async {
      // TODO
    });

    //Future<AdminPassengerPageDtoOutput> adminPassengerControllerList({ String q, String status, String cursor, int limit }) async
    test('test adminPassengerControllerList', () async {
      // TODO
    });

    //Future adminPassengerControllerLock(String id, AdminAccountLockDto adminAccountLockDto) async
    test('test adminPassengerControllerLock', () async {
      // TODO
    });

    //Future adminPassengerControllerUnlock(String id) async
    test('test adminPassengerControllerUnlock', () async {
      // TODO
    });

    //Future<AdminPlatformAccountDtoOutput> adminPlatformAccountControllerCreate(AdminPlatformAccountCreateDto adminPlatformAccountCreateDto) async
    test('test adminPlatformAccountControllerCreate', () async {
      // TODO
    });

    //Future<AdminPlatformAccountListDtoOutput> adminPlatformAccountControllerList({ String q, String role, String status }) async
    test('test adminPlatformAccountControllerList', () async {
      // TODO
    });

    //Future adminPlatformAccountControllerLock(String id, AdminAccountLockDto adminAccountLockDto) async
    test('test adminPlatformAccountControllerLock', () async {
      // TODO
    });

    //Future<AdminPlatformAccountDtoOutput> adminPlatformAccountControllerResetMfa(String id) async
    test('test adminPlatformAccountControllerResetMfa', () async {
      // TODO
    });

    //Future<AdminPlatformAccountDtoOutput> adminPlatformAccountControllerResetPassword(String id) async
    test('test adminPlatformAccountControllerResetPassword', () async {
      // TODO
    });

    //Future adminPlatformAccountControllerUnlock(String id) async
    test('test adminPlatformAccountControllerUnlock', () async {
      // TODO
    });

  });
}
