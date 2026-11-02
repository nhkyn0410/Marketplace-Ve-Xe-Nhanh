import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminCounterCommissionsApi
void main() {
  final instance = ApiClientDart().getAdminCounterCommissionsApi();

  group(AdminCounterCommissionsApi, () {
    //Future<CounterCommissionOverviewDtoOutput> counterCommissionControllerOverview(String operatorId, { DateTime from, DateTime to }) async
    test('test counterCommissionControllerOverview', () async {
      // TODO
    });

    //Future<CounterCommissionSettlementDtoOutput> counterCommissionControllerSettle(CounterCommissionSettlementInputDto counterCommissionSettlementInputDto) async
    test('test counterCommissionControllerSettle', () async {
      // TODO
    });

  });
}
