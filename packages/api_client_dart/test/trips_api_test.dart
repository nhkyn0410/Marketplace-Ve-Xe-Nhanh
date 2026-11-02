import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for TripsApi
void main() {
  final instance = ApiClientDart().getTripsApi();

  group(TripsApi, () {
    //Future<PublicTripDtoOutput> publicTripControllerGet(String tripId) async
    test('test publicTripControllerGet', () async {
      // TODO
    });

    //Future<TripSearchResponseDtoOutput> publicTripControllerSearch(Date date, { String fromProvinceId, String fromStopPointId, String toProvinceId, String toStopPointId, int passengers, String operatorId, String vehicleForm, String vehicleClass, String departureFrom, String departureTo, int priceMin, int priceMax, String amenityIds, String sort, int page, int limit }) async
    test('test publicTripControllerSearch', () async {
      // TODO
    });

  });
}
