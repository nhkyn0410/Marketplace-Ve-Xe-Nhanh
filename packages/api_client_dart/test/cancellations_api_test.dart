import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for CancellationsApi
void main() {
  final instance = ApiClientDart().getCancellationsApi();

  group(CancellationsApi, () {
    //Future<CancellationResultDtoOutput> cancellationControllerCancel(String bookingId, CancellationInputDto cancellationInputDto, { String xBookingToken }) async
    test('test cancellationControllerCancel', () async {
      // TODO
    });

    //Future<CancellationQuoteDtoOutput> cancellationControllerQuote(String bookingId, String ticketIds, { String xBookingToken }) async
    test('test cancellationControllerQuote', () async {
      // TODO
    });

  });
}
