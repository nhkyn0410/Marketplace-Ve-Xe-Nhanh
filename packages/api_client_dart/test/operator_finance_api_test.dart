import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorFinanceApi
void main() {
  final instance = ApiClientDart().getOperatorFinanceApi();

  group(OperatorFinanceApi, () {
    //Future<FinanceBookingPageDtoOutput> operatorFinanceControllerBookings(Date from, Date to, { String routeId, String state, String q, String cursor, num limit }) async
    test('test operatorFinanceControllerBookings', () async {
      // TODO
    });

    //Future<PayoutDetailDtoOutput> operatorFinanceControllerPayout(String payoutId) async
    test('test operatorFinanceControllerPayout', () async {
      // TODO
    });

    //Future<PayoutPageDtoOutput> operatorFinanceControllerPayouts({ String month, String status, String cursor, num limit }) async
    test('test operatorFinanceControllerPayouts', () async {
      // TODO
    });

    //Future<FinanceSummaryDtoOutput> operatorFinanceControllerSummary() async
    test('test operatorFinanceControllerSummary', () async {
      // TODO
    });

  });
}
