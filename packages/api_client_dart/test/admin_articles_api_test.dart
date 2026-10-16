import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminArticlesApi
void main() {
  final instance = ApiClientDart().getAdminArticlesApi();

  group(AdminArticlesApi, () {
    //Future<AdminArticleCategoryDtoOutput> adminArticleCategoryControllerCreate(AdminArticleCategoryInputDto adminArticleCategoryInputDto) async
    test('test adminArticleCategoryControllerCreate', () async {
      // TODO
    });

    //Future<AdminArticleCategoryListDtoOutput> adminArticleCategoryControllerList() async
    test('test adminArticleCategoryControllerList', () async {
      // TODO
    });

    //Future<AdminArticleCategoryDtoOutput> adminArticleCategoryControllerUpdate(String id, AdminArticleCategoryInputDto adminArticleCategoryInputDto) async
    test('test adminArticleCategoryControllerUpdate', () async {
      // TODO
    });

    //Future<AdminArticleDtoOutput> adminArticleControllerArchive(String id) async
    test('test adminArticleControllerArchive', () async {
      // TODO
    });

    //Future<AdminArticleDtoOutput> adminArticleControllerCreate(AdminArticleInputDto adminArticleInputDto) async
    test('test adminArticleControllerCreate', () async {
      // TODO
    });

    //Future<AdminArticleImageUploadResponseDtoOutput> adminArticleControllerCreateImageUploadUrl(AdminArticleImageUploadInputDto adminArticleImageUploadInputDto) async
    test('test adminArticleControllerCreateImageUploadUrl', () async {
      // TODO
    });

    //Future<AdminArticleDtoOutput> adminArticleControllerGet(String id) async
    test('test adminArticleControllerGet', () async {
      // TODO
    });

    //Future<AdminArticlePageDtoOutput> adminArticleControllerList({ String q, String status, String categoryId, String cursor, int limit }) async
    test('test adminArticleControllerList', () async {
      // TODO
    });

    //Future<AdminArticleDtoOutput> adminArticleControllerPublish(String id, AdminArticlePublishDto adminArticlePublishDto) async
    test('test adminArticleControllerPublish', () async {
      // TODO
    });

    //Future<AdminArticleDtoOutput> adminArticleControllerUpdate(String id, AdminArticleInputDto adminArticleInputDto) async
    test('test adminArticleControllerUpdate', () async {
      // TODO
    });

  });
}
