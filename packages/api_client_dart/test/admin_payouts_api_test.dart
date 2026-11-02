import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminPayoutsApi
void main() {
  final instance = ApiClientDart().getAdminPayoutsApi();

  group(AdminPayoutsApi, () {
    //Future<PayoutDetailDtoOutput> adminPayoutControllerCancel(String payoutId, PayoutReasonInputDto payoutReasonInputDto) async
    test('test adminPayoutControllerCancel', () async {
      // TODO
    });

    //Future<PayoutDetailDtoOutput> adminPayoutControllerConfirm(String payoutId, PayoutConfirmInputDto payoutConfirmInputDto) async
    test('test adminPayoutControllerConfirm', () async {
      // TODO
    });

    //Future<PayoutDetailDtoOutput> adminPayoutControllerGet(String payoutId) async
    test('test adminPayoutControllerGet', () async {
      // TODO
    });

    //Future<PayoutDetailDtoOutput> adminPayoutControllerHold(String payoutId, PayoutReasonInputDto payoutReasonInputDto) async
    test('test adminPayoutControllerHold', () async {
      // TODO
    });

    //Future<PayoutPageDtoOutput> adminPayoutControllerList({ Date period, String operatorId, String status, String q, String cursor, num limit }) async
    test('test adminPayoutControllerList', () async {
      // TODO
    });

    //Future<PayoutDetailDtoOutput> adminPayoutControllerRelease(String payoutId) async
    test('test adminPayoutControllerRelease', () async {
      // TODO
    });

    //Future<PayoutBankAccountDtoOutput> adminPayoutControllerRevealBank(String payoutId) async
    test('test adminPayoutControllerRevealBank', () async {
      // TODO
    });

    //Future<PayoutDetailDtoOutput> adminPayoutControllerReview(String payoutId) async
    test('test adminPayoutControllerReview', () async {
      // TODO
    });

    //Future<AdminPayoutStatsDtoOutput> adminPayoutControllerStats() async
    test('test adminPayoutControllerStats', () async {
      // TODO
    });

  });
}
