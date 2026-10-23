import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for PaymentsApi
void main() {
  final instance = ApiClientDart().getPaymentsApi();

  group(PaymentsApi, () {
    //Future<PaymentResponseDtoOutput> paymentControllerCreate(String bookingId, PaymentInputDto paymentInputDto, { String xBookingToken }) async
    test('test paymentControllerCreate', () async {
      // TODO
    });

  });
}
