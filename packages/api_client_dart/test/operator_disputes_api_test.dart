import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorDisputesApi
void main() {
  final instance = ApiClientDart().getOperatorDisputesApi();

  group(OperatorDisputesApi, () {
    //Future<DisputeDetailDtoOutput> operatorDisputeControllerGet(String disputeId) async
    test('test operatorDisputeControllerGet', () async {
      // TODO
    });

    //Future<DisputePageDtoOutput> operatorDisputeControllerList({ String cursor, num limit }) async
    test('test operatorDisputeControllerList', () async {
      // TODO
    });

    //Future<DisputeDetailDtoOutput> operatorDisputeControllerRespond(String disputeId, EvidenceInputDto evidenceInputDto) async
    test('test operatorDisputeControllerRespond', () async {
      // TODO
    });

  });
}
