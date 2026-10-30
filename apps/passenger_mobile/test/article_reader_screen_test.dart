import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/explore/article_api.dart';
import 'package:passenger_mobile/features/explore/article_reader_screen.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';

final _article = ArticleDetail(
  slug: 'di-da-lat',
  title: 'Đi Đà Lạt cuối tuần',
  summary: 'Lịch trình hai ngày gọn nhẹ.',
  categoryName: 'Cẩm nang',
  publishedAt: DateTime.utc(2026, 10, 20),
  contentMarkdown:
      '## Ngày 1\n\nĐến **Hồ Xuân Hương** buổi sáng.\n\n'
      '> Nhớ mang áo ấm.\n\n- Chợ đêm\n- Quảng trường',
);

void main() {
  testWidgets('màn đọc bài hiển thị nội dung Markdown', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ArticleReaderScreen(
          slug: 'di-da-lat',
          loadArticle: (_) async => _article,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đi Đà Lạt cuối tuần'), findsOneWidget);
    expect(find.text('Cẩm nang'), findsOneWidget);
    expect(find.text('Ngày 1'), findsOneWidget);
    expect(find.textContaining('Hồ Xuân Hương', findRichText: true), findsOne);
    expect(find.text('Nhớ mang áo ấm.'), findsOneWidget);
    expect(find.text('Chợ đêm'), findsOneWidget);
    expect(find.textContaining('1 phút đọc'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tải lỗi thì cho thử lại', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ArticleReaderScreen(
          slug: 'di-da-lat',
          loadArticle: (_) async {
            calls++;
            if (calls == 1) throw Exception('mạng');
            return _article;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Không tải được bài viết. Vui lòng thử lại.'), findsOne);

    await tester.tap(find.byKey(const Key('article-reader-retry')));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('Đi Đà Lạt cuối tuần'), findsOneWidget);
  });

  group('Khám phá lấy bài viết từ API', () {
    Future<void> pumpExplore(
      WidgetTester tester,
      Future<ExploreFeed> Function(String? category) loadFeed,
    ) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: ExploreScreen(
            onTabSelected: (_) {},
            loadFeed: loadFeed,
            loadArticle: (_) async => _article,
          ),
        ),
      );
    }

    testWidgets('chưa có bài thì báo trống, không hiện bài mẫu', (
      tester,
    ) async {
      final pending = Completer<ExploreFeed>();
      await pumpExplore(tester, (_) => pending.future);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(const ExploreFeed(featured: null, latest: []));
      await tester.pumpAndSettle();
      expect(
        find.text('Chưa có bài viết phù hợp. Hãy thử chuyên mục khác.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('explore-featured-card')), findsNothing);
    });

    testWidgets('chạm bài nổi bật mở màn đọc bài', (tester) async {
      String? requested;
      await pumpExplore(tester, (category) async {
        requested = category;
        return ExploreFeed(
          featured: ExploreArticle(
            slug: 'di-da-lat',
            title: 'Đi Đà Lạt cuối tuần',
            category: 'Cẩm nang',
            publishedAt: DateTime.utc(2026, 10, 20),
            fallbackAsset: articleFallbackAsset,
          ),
          latest: const [],
        );
      });
      await tester.pumpAndSettle();
      expect(requested, isNull);

      await tester.tap(find.byKey(const Key('explore-featured-action')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('article-reader-screen')), findsOneWidget);
      expect(find.text('Ngày 1'), findsOneWidget);
    });
  });
}
