import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for CounterSalesApi
void main() {
  final instance = ApiClientDart().getCounterSalesApi();

  group(CounterSalesApi, () {
    //Future<CounterReceiptResultDtoOutput> counterSalesControllerCollect(String bookingId, CounterReceiptInputDto counterReceiptInputDto) async
    test('test counterSalesControllerCollect', () async {
      // TODO
    });

    //Future<CounterBookingDtoOutput> counterSalesControllerCreate(CounterBookingInputDto counterBookingInputDto) async
    test('test counterSalesControllerCreate', () async {
      // TODO
    });

    //Future<CounterBookingDtoOutput> counterSalesControllerGet(String bookingId) async
    test('test counterSalesControllerGet', () async {
      // TODO
    });

    //Future<CounterHoldDtoOutput> counterSalesControllerGetHold(String holdId) async
    test('test counterSalesControllerGetHold', () async {
      // TODO
    });

    //Future<CounterHoldDtoOutput> counterSalesControllerHold(CounterHoldInputDto counterHoldInputDto) async
    test('test counterSalesControllerHold', () async {
      // TODO
    });

    //Future<CounterBookingListDtoOutput> counterSalesControllerList(String officeId, { String cursor, num limit }) async
    test('test counterSalesControllerList', () async {
      // TODO
    });

    //Future counterSalesControllerRelease(String holdId) async
    test('test counterSalesControllerRelease', () async {
      // TODO
    });

    //Future<CounterReportDtoOutput> counterSalesControllerReport(String officeId, Date date) async
    test('test counterSalesControllerReport', () async {
      // TODO
    });

    //Future<CounterTripListDtoOutput> counterSalesControllerTrips(String officeId, Date date) async
    test('test counterSalesControllerTrips', () async {
      // TODO
    });

  });
}
