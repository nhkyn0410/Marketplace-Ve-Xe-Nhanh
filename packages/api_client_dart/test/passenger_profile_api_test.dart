import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for PassengerProfileApi
void main() {
  final instance = ApiClientDart().getPassengerProfileApi();

  group(PassengerProfileApi, () {
    //Future<PassengerBookingPageDtoOutput> passengerProfileControllerBookings({ String cursor, num limit }) async
    test('test passengerProfileControllerBookings', () async {
      // TODO
    });

    //Future<SavedPassengerDtoOutput> passengerProfileControllerCreateSaved(SavedPassengerInputDto savedPassengerInputDto) async
    test('test passengerProfileControllerCreateSaved', () async {
      // TODO
    });

    //Future passengerProfileControllerDeleteSaved(String passengerId) async
    test('test passengerProfileControllerDeleteSaved', () async {
      // TODO
    });

    //Future<PassengerDisputePageDtoOutput> passengerProfileControllerDisputes({ String cursor, num limit }) async
    test('test passengerProfileControllerDisputes', () async {
      // TODO
    });

    //Future<PassengerProfileDtoOutput> passengerProfileControllerGet() async
    test('test passengerProfileControllerGet', () async {
      // TODO
    });

    //Future<SavedPassengerListDtoOutput> passengerProfileControllerSaved() async
    test('test passengerProfileControllerSaved', () async {
      // TODO
    });

    //Future<PassengerSupportPageDtoOutput> passengerProfileControllerSupportTickets({ String cursor, num limit }) async
    test('test passengerProfileControllerSupportTickets', () async {
      // TODO
    });

    //Future<PassengerTicketPageDtoOutput> passengerProfileControllerTickets({ String cursor, num limit }) async
    test('test passengerProfileControllerTickets', () async {
      // TODO
    });

    //Future<PassengerProfileDtoOutput> passengerProfileControllerUpdate(PassengerProfileUpdateDto passengerProfileUpdateDto) async
    test('test passengerProfileControllerUpdate', () async {
      // TODO
    });

    //Future<SavedPassengerDtoOutput> passengerProfileControllerUpdateSaved(String passengerId, SavedPassengerInputDto savedPassengerInputDto) async
    test('test passengerProfileControllerUpdateSaved', () async {
      // TODO
    });

  });
}
