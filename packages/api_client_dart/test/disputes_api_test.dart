import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for DisputesApi
void main() {
  final instance = ApiClientDart().getDisputesApi();

  group(DisputesApi, () {
    //Future<DisputeDetailDtoOutput> customerDisputeControllerGet(String bookingId, String disputeId, { String xBookingToken }) async
    test('test customerDisputeControllerGet', () async {
      // TODO
    });

    //Future<CustomerDisputeListDtoOutput> customerDisputeControllerList(String bookingId, { String xBookingToken }) async
    test('test customerDisputeControllerList', () async {
      // TODO
    });

    //Future<DisputeDetailDtoOutput> customerDisputeControllerRespond(String bookingId, String disputeId, EvidenceInputDto evidenceInputDto, { String xBookingToken }) async
    test('test customerDisputeControllerRespond', () async {
      // TODO
    });

  });
}
