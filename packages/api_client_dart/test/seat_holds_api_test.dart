import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for SeatHoldsApi
void main() {
  final instance = ApiClientDart().getSeatHoldsApi();

  group(SeatHoldsApi, () {
    //Future<SeatHoldResponseDtoOutput> seatHoldControllerCreate(SeatHoldInputDto seatHoldInputDto) async
    test('test seatHoldControllerCreate', () async {
      // TODO
    });

    //Future<SeatHoldResponseDtoOutput> seatHoldControllerGet(String holdId) async
    test('test seatHoldControllerGet', () async {
      // TODO
    });

    //Future seatHoldControllerRelease(String holdId) async
    test('test seatHoldControllerRelease', () async {
      // TODO
    });

  });
}
