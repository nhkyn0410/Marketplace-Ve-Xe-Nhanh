import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminCommissionApi
void main() {
  final instance = ApiClientDart().getAdminCommissionApi();

  group(AdminCommissionApi, () {
    //Future<CommissionRuleDtoOutput> adminCommissionControllerCancel(String id, CommissionRuleCancelDto commissionRuleCancelDto) async
    test('test adminCommissionControllerCancel', () async {
      // TODO
    });

    //Future<CommissionRuleDtoOutput> adminCommissionControllerCreate(CommissionRuleCreateDto commissionRuleCreateDto) async
    test('test adminCommissionControllerCreate', () async {
      // TODO
    });

    //Future<CommissionOverviewDtoOutput> adminCommissionControllerOverview() async
    test('test adminCommissionControllerOverview', () async {
      // TODO
    });

    //Future<CommissionRuleDtoOutput> adminCommissionControllerUpdate(String id, CommissionRuleUpdateDto commissionRuleUpdateDto) async
    test('test adminCommissionControllerUpdate', () async {
      // TODO
    });

  });
}
