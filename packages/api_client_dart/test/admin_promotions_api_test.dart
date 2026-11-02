import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminPromotionsApi
void main() {
  final instance = ApiClientDart().getAdminPromotionsApi();

  group(AdminPromotionsApi, () {
    //Future<PromotionDtoOutput> adminPromotionControllerCreate(PromotionInputDto promotionInputDto) async
    test('test adminPromotionControllerCreate', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> adminPromotionControllerGet(String promotionId) async
    test('test adminPromotionControllerGet', () async {
      // TODO
    });

    //Future<PromotionPageDtoOutput> adminPromotionControllerList({ String scope, String display, String q, String routeId, String operatorId, String cursor, num limit }) async
    test('test adminPromotionControllerList', () async {
      // TODO
    });

    //Future<PermissionPageDtoOutput> adminPromotionControllerPermissions({ String q, String enabled, String cursor, num limit }) async
    test('test adminPromotionControllerPermissions', () async {
      // TODO
    });

    //Future<PermissionDtoOutput> adminPromotionControllerSetPermission(String operatorId, PermissionInputDto permissionInputDto) async
    test('test adminPromotionControllerSetPermission', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> adminPromotionControllerSetStatus(String promotionId, PromotionStatusInputDto promotionStatusInputDto) async
    test('test adminPromotionControllerSetStatus', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> adminPromotionControllerUpdate(String promotionId, PromotionInputDto promotionInputDto) async
    test('test adminPromotionControllerUpdate', () async {
      // TODO
    });

  });
}
