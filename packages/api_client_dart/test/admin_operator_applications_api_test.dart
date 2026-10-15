import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminOperatorApplicationsApi
void main() {
  final instance = ApiClientDart().getAdminOperatorApplicationsApi();

  group(AdminOperatorApplicationsApi, () {
    //Future<ApprovalResponseDtoOutput> operatorApplicationReviewControllerApprove(String applicationId, String idempotencyKey, ApprovalInputDto approvalInputDto) async
    test('test operatorApplicationReviewControllerApprove', () async {
      // TODO
    });

    //Future<DocumentDownloadResponseDtoOutput> operatorApplicationReviewControllerCreateDocumentDownload(String applicationId, String type) async
    test('test operatorApplicationReviewControllerCreateDocumentDownload', () async {
      // TODO
    });

    //Future<AdminApplicationDetailDtoOutput> operatorApplicationReviewControllerGet(String applicationId) async
    test('test operatorApplicationReviewControllerGet', () async {
      // TODO
    });

    //Future<AdminApplicationListResponseDtoOutput> operatorApplicationReviewControllerList({ String status, String q, String cursor, int limit }) async
    test('test operatorApplicationReviewControllerList', () async {
      // TODO
    });

    //Future<DecisionResponseDtoOutput> operatorApplicationReviewControllerReject(String applicationId, DecisionInputDto decisionInputDto) async
    test('test operatorApplicationReviewControllerReject', () async {
      // TODO
    });

    //Future<DecisionResponseDtoOutput> operatorApplicationReviewControllerRequestInfo(String applicationId, DecisionInputDto decisionInputDto) async
    test('test operatorApplicationReviewControllerRequestInfo', () async {
      // TODO
    });

    //Future<ApprovalResponseDtoOutput> operatorApplicationReviewControllerResendOwnerCredentials(String applicationId) async
    test('test operatorApplicationReviewControllerResendOwnerCredentials', () async {
      // TODO
    });

  });
}
