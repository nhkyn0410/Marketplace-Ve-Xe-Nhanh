import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminCatalogApi
void main() {
  final instance = ApiClientDart().getAdminCatalogApi();

  group(AdminCatalogApi, () {
    //Future adminCatalogControllerActivate(String kind, String id) async
    test('test adminCatalogControllerActivate', () async {
      // TODO
    });

    //Future<AdminAmenityDtoOutput> adminCatalogControllerCreateAmenity(AdminAmenityInputDto adminAmenityInputDto) async
    test('test adminCatalogControllerCreateAmenity', () async {
      // TODO
    });

    //Future<AdminProvinceDtoOutput> adminCatalogControllerCreateProvince(AdminProvinceInputDto adminProvinceInputDto) async
    test('test adminCatalogControllerCreateProvince', () async {
      // TODO
    });

    //Future<AdminVehicleTypeDtoOutput> adminCatalogControllerCreateVehicleType(AdminVehicleTypeInputDto adminVehicleTypeInputDto) async
    test('test adminCatalogControllerCreateVehicleType', () async {
      // TODO
    });

    //Future<AdminWardDtoOutput> adminCatalogControllerCreateWard(AdminWardInputDto adminWardInputDto) async
    test('test adminCatalogControllerCreateWard', () async {
      // TODO
    });

    //Future adminCatalogControllerDeactivate(String kind, String id, AdminCatalogDeactivateDto adminCatalogDeactivateDto) async
    test('test adminCatalogControllerDeactivate', () async {
      // TODO
    });

    //Future<AdminAmenityListDtoOutput> adminCatalogControllerListAmenities({ String status }) async
    test('test adminCatalogControllerListAmenities', () async {
      // TODO
    });

    //Future<AdminProvincePageDtoOutput> adminCatalogControllerListProvinces({ String q, String status, String cursor, int limit }) async
    test('test adminCatalogControllerListProvinces', () async {
      // TODO
    });

    //Future<AdminVehicleTypeListDtoOutput> adminCatalogControllerListVehicleTypes({ String status }) async
    test('test adminCatalogControllerListVehicleTypes', () async {
      // TODO
    });

    //Future<AdminWardPageDtoOutput> adminCatalogControllerListWards({ String provinceId, String q, String status, String cursor, int limit }) async
    test('test adminCatalogControllerListWards', () async {
      // TODO
    });

    //Future<AdminAmenityDtoOutput> adminCatalogControllerRenameAmenity(String id, AdminCatalogRenameDto adminCatalogRenameDto) async
    test('test adminCatalogControllerRenameAmenity', () async {
      // TODO
    });

    //Future<AdminProvinceDtoOutput> adminCatalogControllerRenameProvince(String id, AdminCatalogRenameDto adminCatalogRenameDto) async
    test('test adminCatalogControllerRenameProvince', () async {
      // TODO
    });

    //Future<AdminWardDtoOutput> adminCatalogControllerRenameWard(String id, AdminCatalogRenameDto adminCatalogRenameDto) async
    test('test adminCatalogControllerRenameWard', () async {
      // TODO
    });

    //Future<AdminVehicleTypeDtoOutput> adminCatalogControllerUpdateVehicleType(String id, AdminVehicleTypeUpdateDto adminVehicleTypeUpdateDto) async
    test('test adminCatalogControllerUpdateVehicleType', () async {
      // TODO
    });

  });
}
