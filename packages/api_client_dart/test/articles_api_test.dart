import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for ArticlesApi
void main() {
  final instance = ApiClientDart().getArticlesApi();

  group(ArticlesApi, () {
    //Future<ArticleDtoOutput> articleControllerGet(String slug) async
    test('test articleControllerGet', () async {
      // TODO
    });

    //Future<ArticlePageDtoOutput> articleControllerList({ String category, String q, String featured, String cursor, int limit }) async
    test('test articleControllerList', () async {
      // TODO
    });

    //Future<ArticleCategoryListDtoOutput> articleControllerListCategories() async
    test('test articleControllerListCategories', () async {
      // TODO
    });

    //Future articleControllerRecordView(String slug) async
    test('test articleControllerRecordView', () async {
      // TODO
    });

  });
}
