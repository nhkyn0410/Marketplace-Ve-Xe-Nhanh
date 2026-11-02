import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminRoutesApi
void main() {
  final instance = ApiClientDart().getAdminRoutesApi();

  group(AdminRoutesApi, () {
    //Future<AdminRouteDetailDtoOutput> adminRouteControllerDetail(String id, { Date from, Date to }) async
    test('test adminRouteControllerDetail', () async {
      // TODO
    });

    //Future<AdminRoutePageDtoOutput> adminRouteControllerList({ String q, String operatorId, String status, String originProvinceId, String destinationProvinceId, Date from, Date to, String sort, String cursor, int limit }) async
    test('test adminRouteControllerList', () async {
      // TODO
    });

  });
}
