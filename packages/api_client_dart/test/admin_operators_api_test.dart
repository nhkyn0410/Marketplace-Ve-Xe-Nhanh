import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminOperatorsApi
void main() {
  final instance = ApiClientDart().getAdminOperatorsApi();

  group(AdminOperatorsApi, () {
    //Future adminOperatorControllerApproveBankChange(String id, AdminBankChangeApproveDto adminBankChangeApproveDto) async
    test('test adminOperatorControllerApproveBankChange', () async {
      // TODO
    });

    //Future<AdminBankChangeDtoOutput> adminOperatorControllerGetBankChange(String id) async
    test('test adminOperatorControllerGetBankChange', () async {
      // TODO
    });

    //Future<AdminOperatorPageDtoOutput> adminOperatorControllerList({ String q, String status, String bankChange, String cursor, int limit }) async
    test('test adminOperatorControllerList', () async {
      // TODO
    });

    //Future adminOperatorControllerRejectBankChange(String id, AdminBankChangeRejectDto adminBankChangeRejectDto) async
    test('test adminOperatorControllerRejectBankChange', () async {
      // TODO
    });

    //Future adminOperatorControllerSuspend(String id, AdminOperatorSuspendDto adminOperatorSuspendDto) async
    test('test adminOperatorControllerSuspend', () async {
      // TODO
    });

    //Future adminOperatorControllerUnsuspend(String id) async
    test('test adminOperatorControllerUnsuspend', () async {
      // TODO
    });

  });
}
