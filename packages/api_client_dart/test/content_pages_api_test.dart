import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for ContentPagesApi
void main() {
  final instance = ApiClientDart().getContentPagesApi();

  group(ContentPagesApi, () {
    //Future<PublicContentItemDtoOutput> contentPageControllerGet(String slug) async
    test('test contentPageControllerGet', () async {
      // TODO
    });

    //Future<PublicContentListDtoOutput> contentPageControllerList(String type, { String placement }) async
    test('test contentPageControllerList', () async {
      // TODO
    });

  });
}
