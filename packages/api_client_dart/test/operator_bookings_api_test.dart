import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorBookingsApi
void main() {
  final instance = ApiClientDart().getOperatorBookingsApi();

  group(OperatorBookingsApi, () {
    //Future<String> operatorBookingControllerExportPassengers(String tripId) async
    test('test operatorBookingControllerExportPassengers', () async {
      // TODO
    });

    //Future<OperatorBookingDetailDtoOutput> operatorBookingControllerGet(String bookingId) async
    test('test operatorBookingControllerGet', () async {
      // TODO
    });

    //Future<OperatorBookingPageDtoOutput> operatorBookingControllerList(Date date, { String tripId, String status, String q, String cursor, num limit }) async
    test('test operatorBookingControllerList', () async {
      // TODO
    });

    //Future<TripPassengerListDtoOutput> operatorBookingControllerPassengers(String tripId, { num pickupSequence, String ticketStatus, String q }) async
    test('test operatorBookingControllerPassengers', () async {
      // TODO
    });

    //Future<BookingContactDtoOutput> operatorBookingControllerRevealContact(String bookingId) async
    test('test operatorBookingControllerRevealContact', () async {
      // TODO
    });

  });
}
