import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for TicketsApi
void main() {
  final instance = ApiClientDart().getTicketsApi();

  group(TicketsApi, () {
    //Future<TicketResponseDtoOutput> ticketControllerGet(String ticketId, { String xBookingToken }) async
    test('test ticketControllerGet', () async {
      // TODO
    });

    //Future<BookingResponseDtoOutput> ticketControllerLookup(TicketLookupInputDto ticketLookupInputDto) async
    test('test ticketControllerLookup', () async {
      // TODO
    });

  });
}
