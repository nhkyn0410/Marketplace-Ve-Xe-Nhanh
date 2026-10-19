import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminDisputesApi
void main() {
  final instance = ApiClientDart().getAdminDisputesApi();

  group(AdminDisputesApi, () {
    //Future<DisputeDetailDtoOutput> adminDisputeControllerDecide(String disputeId, DecisionInputDto decisionInputDto) async
    test('test adminDisputeControllerDecide', () async {
      // TODO
    });

    //Future<DisputeDetailDtoOutput> adminDisputeControllerEscalate(String ticketId, EscalateInputDto escalateInputDto) async
    test('test adminDisputeControllerEscalate', () async {
      // TODO
    });

    //Future<DisputeDetailDtoOutput> adminDisputeControllerGet(String disputeId) async
    test('test adminDisputeControllerGet', () async {
      // TODO
    });

    //Future<DisputePageDtoOutput> adminDisputeControllerList({ String status, String operatorId, String due, AdminSupportControllerListAssigneeIdParameter assigneeId, String q, String cursor, num limit }) async
    test('test adminDisputeControllerList', () async {
      // TODO
    });

    //Future<DisputeDetailDtoOutput> adminDisputeControllerRequestEvidence(String disputeId, RequestEvidenceInputDto requestEvidenceInputDto) async
    test('test adminDisputeControllerRequestEvidence', () async {
      // TODO
    });

    //Future<DisputeDetailDtoOutput> adminDisputeControllerSetStatus(String disputeId, DisputeStatusInputDto disputeStatusInputDto) async
    test('test adminDisputeControllerSetStatus', () async {
      // TODO
    });

    //Future<AttachmentUploadResponseDtoOutput> adminDisputeControllerUpload(String disputeId, AttachmentUploadInputDto attachmentUploadInputDto) async
    test('test adminDisputeControllerUpload', () async {
      // TODO
    });

  });
}
