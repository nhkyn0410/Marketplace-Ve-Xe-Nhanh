import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorPromotionsApi
void main() {
  final instance = ApiClientDart().getOperatorPromotionsApi();

  group(OperatorPromotionsApi, () {
    //Future<PromotionDtoOutput> operatorPromotionControllerCreate(PromotionInputDto promotionInputDto) async
    test('test operatorPromotionControllerCreate', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> operatorPromotionControllerGet(String promotionId) async
    test('test operatorPromotionControllerGet', () async {
      // TODO
    });

    //Future<PromotionPageDtoOutput> operatorPromotionControllerList({ String scope, String display, String q, String routeId, String operatorId, String cursor, num limit }) async
    test('test operatorPromotionControllerList', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> operatorPromotionControllerParticipate(String promotionId, ParticipationInputDto participationInputDto) async
    test('test operatorPromotionControllerParticipate', () async {
      // TODO
    });

    //Future<PermissionDtoOutput> operatorPromotionControllerPermission() async
    test('test operatorPromotionControllerPermission', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> operatorPromotionControllerSetStatus(String promotionId, PromotionStatusInputDto promotionStatusInputDto) async
    test('test operatorPromotionControllerSetStatus', () async {
      // TODO
    });

    //Future<PromotionDtoOutput> operatorPromotionControllerUpdate(String promotionId, PromotionInputDto promotionInputDto) async
    test('test operatorPromotionControllerUpdate', () async {
      // TODO
    });

  });
}
