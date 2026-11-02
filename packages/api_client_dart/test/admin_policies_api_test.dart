import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminPoliciesApi
void main() {
  final instance = ApiClientDart().getAdminPoliciesApi();

  group(AdminPoliciesApi, () {
    //Future<PolicyVersionDtoOutput> adminPolicyControllerCancel(String id, PolicyCancelDto policyCancelDto) async
    test('test adminPolicyControllerCancel', () async {
      // TODO
    });

    //Future<FareBandDtoOutput> adminPolicyControllerCancelFareBand(String id, PolicyCancelDto policyCancelDto) async
    test('test adminPolicyControllerCancelFareBand', () async {
      // TODO
    });

    //Future<PolicyVersionDtoOutput> adminPolicyControllerCreateDraft(String type, PolicyDraftCreateDto policyDraftCreateDto) async
    test('test adminPolicyControllerCreateDraft', () async {
      // TODO
    });

    //Future<FareBandDtoOutput> adminPolicyControllerCreateFareBand(FareBandCreateDto fareBandCreateDto) async
    test('test adminPolicyControllerCreateFareBand', () async {
      // TODO
    });

    //Future<PolicyVersionDtoOutput> adminPolicyControllerGet(String id) async
    test('test adminPolicyControllerGet', () async {
      // TODO
    });

    //Future<FareBandListDtoOutput> adminPolicyControllerListFareBands() async
    test('test adminPolicyControllerListFareBands', () async {
      // TODO
    });

    //Future<PolicyOverviewDtoOutput> adminPolicyControllerOverview(String type, { String operatorId }) async
    test('test adminPolicyControllerOverview', () async {
      // TODO
    });

    //Future<PolicyVersionDtoOutput> adminPolicyControllerPublish(String id, PolicyPublishDto policyPublishDto) async
    test('test adminPolicyControllerPublish', () async {
      // TODO
    });

    //Future<PolicyVersionDtoOutput> adminPolicyControllerUpdateDraft(String id, PolicyDraftUpdateDto policyDraftUpdateDto) async
    test('test adminPolicyControllerUpdateDraft', () async {
      // TODO
    });

  });
}
