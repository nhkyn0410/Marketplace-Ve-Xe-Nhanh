import 'dart:math' as math;

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';

/// Ảnh khi bài viết chưa có ảnh bìa.
const articleFallbackAsset = 'assets/explore/article_road_trip.png';

/// Một bài viết đã xuất bản, đủ nội dung Markdown để đọc.
class ArticleDetail {
  const ArticleDetail({
    required this.slug,
    required this.title,
    required this.summary,
    required this.categoryName,
    required this.publishedAt,
    required this.contentMarkdown,
    this.coverImageUrl,
  });

  final String slug;
  final String title;
  final String summary;
  final String categoryName;
  final DateTime publishedAt;
  final String contentMarkdown;
  final String? coverImageUrl;

  /// Thời gian đọc ước tính, khoảng 200 từ mỗi phút.
  int get readingMinutes {
    final words = contentMarkdown
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    return math.max(1, (words / 200).ceil());
  }
}

/// Bài viết công khai cho tab Khám phá (`/v1/articles`); lỗi API ném ra dạng [ApiFailure].
class ArticleApi {
  ArticleApi(this._client);

  final ApiClientDart _client;

  /// Bài nổi bật và các bài mới nhất của chuyên mục [category] (`null` = tất cả), khớp từ khóa [query].
  ///
  /// Trang "Tất cả" còn khối ưu đãi phía dưới nên chỉ lấy 3 bài mới nhất, trang chuyên mục lấy 4.
  Future<ExploreFeed> loadFeed(String? category, [String? query]) async {
    final response = await _call(
      () => _client.getArticlesApi().articleControllerList(
        category: category,
        q: query,
        limit: 12,
      ),
    );
    final items = response.data!.items.toList();
    if (items.isEmpty) return const ExploreFeed(featured: null, latest: []);
    final featured = items.firstWhere(
      (item) => item.featured,
      orElse: () => items.first,
    );
    ExploreArticle toArticle(ArticlePageDtoOutputItemsInner item) {
      return ExploreArticle(
        slug: item.slug,
        title: item.title,
        category: item.category.name,
        publishedAt: item.publishedAt,
        coverImageUrl: item.coverImageUrl,
        fallbackAsset: articleFallbackAsset,
      );
    }

    return ExploreFeed(
      featured: toArticle(featured),
      latest: [
        for (final item in items)
          if (item.slug != featured.slug) toArticle(item),
      ].take(category == null ? 3 : 4).toList(growable: false),
    );
  }

  /// Bài viết mới nhất (mọi chuyên mục) cho mục "Khám phá & cẩm nang" ở Trang chủ.
  Future<List<ExploreArticle>> loadLatest() async {
    final feed = await loadFeed(null);
    return [?feed.featured, ...feed.latest];
  }

  /// Toàn bộ bài viết theo [slug]; ghi một lượt xem, lỗi ghi lượt xem thì bỏ qua.
  Future<ArticleDetail> loadArticle(String slug) async {
    final response = await _call(
      () => _client.getArticlesApi().articleControllerGet(slug: slug),
    );
    final data = response.data!;
    _client.getArticlesApi().articleControllerRecordView(slug: slug).ignore();
    return ArticleDetail(
      slug: data.slug,
      title: data.title,
      summary: data.summary,
      categoryName: data.category.name,
      publishedAt: data.publishedAt,
      contentMarkdown: data.contentMarkdown,
      coverImageUrl: data.coverImageUrl,
    );
  }

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw toApiFailure(error, _client.serializers);
    }
  }
}
