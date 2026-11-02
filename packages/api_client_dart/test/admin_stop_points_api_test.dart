import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminStopPointsApi
void main() {
  final instance = ApiClientDart().getAdminStopPointsApi();

  group(AdminStopPointsApi, () {
    //Future<AdminOperatorStopPointListDtoOutput> adminOperatorStopPointControllerList({ String operatorId, String type, String provinceId, String status, String q, String cursor, int limit }) async
    test('test adminOperatorStopPointControllerList', () async {
      // TODO
    });

    //Future<AdminOperatorStopPointDtoOutput> adminOperatorStopPointControllerSuspend(String id, StopPointReasonInputDto stopPointReasonInputDto) async
    test('test adminOperatorStopPointControllerSuspend', () async {
      // TODO
    });

    //Future<AdminOperatorStopPointDtoOutput> adminOperatorStopPointControllerUnsuspend(String id) async
    test('test adminOperatorStopPointControllerUnsuspend', () async {
      // TODO
    });

    //Future<AdminSharedStopPointDtoOutput> adminSharedStopPointControllerCreate(AdminSharedStopPointInputDto adminSharedStopPointInputDto) async
    test('test adminSharedStopPointControllerCreate', () async {
      // TODO
    });

    //Future<AdminSharedStopPointDtoOutput> adminSharedStopPointControllerGet(String id) async
    test('test adminSharedStopPointControllerGet', () async {
      // TODO
    });

    //Future<AdminSharedStopPointListDtoOutput> adminSharedStopPointControllerList({ String type, String provinceId, String status, String q, String cursor, int limit }) async
    test('test adminSharedStopPointControllerList', () async {
      // TODO
    });

    //Future<AdminSharedStopPointDtoOutput> adminSharedStopPointControllerUpdate(String id, AdminSharedStopPointInputDto adminSharedStopPointInputDto) async
    test('test adminSharedStopPointControllerUpdate', () async {
      // TODO
    });

    //Future<AdminStopPointProposalDtoOutput> adminStopPointProposalControllerApprove(String id, AdminStopPointProposalApprovalDto adminStopPointProposalApprovalDto) async
    test('test adminStopPointProposalControllerApprove', () async {
      // TODO
    });

    //Future<AdminStopPointProposalDtoOutput> adminStopPointProposalControllerGet(String id) async
    test('test adminStopPointProposalControllerGet', () async {
      // TODO
    });

    //Future<AdminStopPointProposalListDtoOutput> adminStopPointProposalControllerList({ String status, String type, String operatorId, String cursor, int limit }) async
    test('test adminStopPointProposalControllerList', () async {
      // TODO
    });

    //Future<AdminStopPointProposalDtoOutput> adminStopPointProposalControllerReject(String id, StopPointReasonInputDto stopPointReasonInputDto) async
    test('test adminStopPointProposalControllerReject', () async {
      // TODO
    });

  });
}
