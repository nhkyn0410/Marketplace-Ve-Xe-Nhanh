import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminRefundsApi
void main() {
  final instance = ApiClientDart().getAdminRefundsApi();

  group(AdminRefundsApi, () {
    //Future<AdminRefundDetailDtoOutput> adminRefundControllerGet(String refundId) async
    test('test adminRefundControllerGet', () async {
      // TODO
    });

    //Future<AdminRefundPageDtoOutput> adminRefundControllerList({ Date from, Date to, String operatorId, String source_, String status, String q, String cursor, num limit }) async
    test('test adminRefundControllerList', () async {
      // TODO
    });

    //Future<AdminRefundDetailDtoOutput> adminRefundControllerRefundPayment(String paymentId, RefundReasonInputDto refundReasonInputDto) async
    test('test adminRefundControllerRefundPayment', () async {
      // TODO
    });

    //Future<AdminRefundDetailDtoOutput> adminRefundControllerResolve(String refundId, RefundResolveInputDto refundResolveInputDto) async
    test('test adminRefundControllerResolve', () async {
      // TODO
    });

    //Future<AdminRefundDetailDtoOutput> adminRefundControllerRetry(String refundId, RefundReasonInputDto refundReasonInputDto) async
    test('test adminRefundControllerRetry', () async {
      // TODO
    });

  });
}
