import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminTripsApi
void main() {
  final instance = ApiClientDart().getAdminTripsApi();

  group(AdminTripsApi, () {
    //Future<AdminTripDetailDtoOutput> adminTripControllerDetail(String id) async
    test('test adminTripControllerDetail', () async {
      // TODO
    });

    //Future<AdminTripPageDtoOutput> adminTripControllerList({ Date from, Date to, String operatorId, String routeId, String status, String q, String cursor, int limit }) async
    test('test adminTripControllerList', () async {
      // TODO
    });

  });
}
