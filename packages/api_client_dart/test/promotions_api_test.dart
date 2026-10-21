import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for PromotionsApi
void main() {
  final instance = ApiClientDart().getPromotionsApi();

  group(PromotionsApi, () {
    //Future<PromotionCheckDtoOutput> publicPromotionControllerCheck(PromotionCheckInputDto promotionCheckInputDto) async
    test('test publicPromotionControllerCheck', () async {
      // TODO
    });

  });
}
