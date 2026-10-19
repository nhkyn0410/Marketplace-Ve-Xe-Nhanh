import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for BookingsApi
void main() {
  final instance = ApiClientDart().getBookingsApi();

  group(BookingsApi, () {
    //Future<CreatedBookingDtoOutput> bookingControllerCreate(BookingInputDto bookingInputDto) async
    test('test bookingControllerCreate', () async {
      // TODO
    });

    //Future<BookingResponseDtoOutput> bookingControllerGet(String bookingId, { String xBookingToken }) async
    test('test bookingControllerGet', () async {
      // TODO
    });

  });
}
