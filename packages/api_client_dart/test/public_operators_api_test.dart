import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for PublicOperatorsApi
void main() {
  final instance = ApiClientDart().getPublicOperatorsApi();

  group(PublicOperatorsApi, () {
    //Future<PublicOperatorProfileDtoOutput> publicOperatorProfileControllerGet(String operatorId, { String cursor, num limit }) async
    test('test publicOperatorProfileControllerGet', () async {
      // TODO
    });

  });
}
