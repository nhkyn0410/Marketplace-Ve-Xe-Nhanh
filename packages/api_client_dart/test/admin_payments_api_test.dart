import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminPaymentsApi
void main() {
  final instance = ApiClientDart().getAdminPaymentsApi();

  group(AdminPaymentsApi, () {
    //Future<AdminPaymentDetailDtoOutput> adminPaymentControllerGet(String paymentId) async
    test('test adminPaymentControllerGet', () async {
      // TODO
    });

    //Future<AdminPaymentPageDtoOutput> adminPaymentControllerList({ Date from, Date to, String operatorId, String provider, String status, String reconcile, String q, String cursor, num limit }) async
    test('test adminPaymentControllerList', () async {
      // TODO
    });

  });
}
