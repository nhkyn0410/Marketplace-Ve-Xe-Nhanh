import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorManagersApi
void main() {
  final instance = ApiClientDart().getOperatorManagersApi();

  group(OperatorManagersApi, () {
    //Future<ManagerAccountDtoOutput> operatorManagerControllerCreate(ManagerCreateDto managerCreateDto) async
    test('test operatorManagerControllerCreate', () async {
      // TODO
    });

    //Future<ManagerListDtoOutput> operatorManagerControllerList() async
    test('test operatorManagerControllerList', () async {
      // TODO
    });

    //Future<ManagerAccountDtoOutput> operatorManagerControllerResetMfa(String managerId, ManagerReasonDto managerReasonDto) async
    test('test operatorManagerControllerResetMfa', () async {
      // TODO
    });

    //Future<ManagerAccountDtoOutput> operatorManagerControllerResetPassword(String managerId, ManagerReasonDto managerReasonDto) async
    test('test operatorManagerControllerResetPassword', () async {
      // TODO
    });

    //Future<ManagerAccountDtoOutput> operatorManagerControllerUpdate(String managerId, ManagerUpdateDto managerUpdateDto) async
    test('test operatorManagerControllerUpdate', () async {
      // TODO
    });

  });
}
