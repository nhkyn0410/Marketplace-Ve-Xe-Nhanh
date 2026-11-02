import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminVehicleImagesApi
void main() {
  final instance = ApiClientDart().getAdminVehicleImagesApi();

  group(AdminVehicleImagesApi, () {
    //Future<AdminVehicleImageListDtoOutput> adminVehicleImageControllerList({ String operatorId, DateTime uploadedSince, String cursor, int limit }) async
    test('test adminVehicleImageControllerList', () async {
      // TODO
    });

    //Future adminVehicleImageControllerRemove(String imageId, AdminRemoveVehicleImageInputDto adminRemoveVehicleImageInputDto) async
    test('test adminVehicleImageControllerRemove', () async {
      // TODO
    });

  });
}
