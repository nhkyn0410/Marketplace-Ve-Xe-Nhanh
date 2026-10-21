import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminContentPagesApi
void main() {
  final instance = ApiClientDart().getAdminContentPagesApi();

  group(AdminContentPagesApi, () {
    //Future<ContentPageDetailDtoOutput> adminContentPageControllerCreate(ContentPageInputDto contentPageInputDto) async
    test('test adminContentPageControllerCreate', () async {
      // TODO
    });

    //Future<ContentImageUploadResponseDtoOutput> adminContentPageControllerCreateImageUploadUrl(ContentImageUploadInputDto contentImageUploadInputDto) async
    test('test adminContentPageControllerCreateImageUploadUrl', () async {
      // TODO
    });

    //Future<ContentPageDetailDtoOutput> adminContentPageControllerGet(String id) async
    test('test adminContentPageControllerGet', () async {
      // TODO
    });

    //Future<ContentPagePageDtoOutput> adminContentPageControllerList({ String type, String status, String q, String cursor, num limit }) async
    test('test adminContentPageControllerList', () async {
      // TODO
    });

    //Future<ContentPageDetailDtoOutput> adminContentPageControllerSetStatus(String id, ContentPageStatusInputDto contentPageStatusInputDto) async
    test('test adminContentPageControllerSetStatus', () async {
      // TODO
    });

    //Future<ContentPageDetailDtoOutput> adminContentPageControllerUpdate(String id, ContentPageInputDto contentPageInputDto) async
    test('test adminContentPageControllerUpdate', () async {
      // TODO
    });

  });
}
