import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/explore/article_api.dart';
import 'package:passenger_mobile/features/explore/article_reader_screen.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';
import 'package:passenger_mobile/features/home/home_models.dart';

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
      Future<ExploreFeed> Function(String? category, String? query) loadFeed, {
      Future<List<HomePromotion>> Function()? loadPromotions,
    }) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: ExploreScreen(
            onTabSelected: (_) {},
            loadFeed: loadFeed,
            loadArticle: (_) async => _article,
            loadPromotions: loadPromotions,
          ),
        ),
      );
    }

    testWidgets('chưa có bài thì báo trống, không hiện bài mẫu', (
      tester,
    ) async {
      final pending = Completer<ExploreFeed>();
      await pumpExplore(tester, (_, _) => pending.future);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(const ExploreFeed(featured: null, latest: []));
      await tester.pumpAndSettle();
      expect(
        find.text('Chưa có bài viết phù hợp. Hãy thử chuyên mục khác.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('explore-featured-card')), findsNothing);
      expect(find.text('Chưa có bài viết trong chuyên mục này.'), findsNothing);
    });

    testWidgets('chạm bài nổi bật mở màn đọc bài', (tester) async {
      String? requested;
      await pumpExplore(tester, (category, _) async {
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

    testWidgets('gửi từ khóa ở ô tìm kiếm thì tải lại theo từ khóa', (
      tester,
    ) async {
      final calls = <(String?, String?)>[];
      await pumpExplore(tester, (category, query) async {
        calls.add((category, query));
        return const ExploreFeed(featured: null, latest: []);
      });
      await tester.pumpAndSettle();
      expect(calls, [(null, null)]);

      await tester.enterText(
        find.byKey(const Key('explore-search-field')),
        '  Đà Lạt ',
      );
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(calls.last, (null, 'Đà Lạt'));

      await tester.enterText(find.byKey(const Key('explore-search-field')), '');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      // Bỏ lọc: dùng lại feed đã tải, không gọi thêm.
      expect(calls, hasLength(2));
    });

    testWidgets('khối khuyến mãi: không có thì ẩn, có thì hiện mã thật', (
      tester,
    ) async {
      await pumpExplore(
        tester,
        (_, _) async => const ExploreFeed(featured: null, latest: []),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('explore-promotion-card')), findsNothing);
      // Dựng lại màn (như mở lại tab) để tải khuyến mãi.
      await tester.pumpWidget(const SizedBox());

      await pumpExplore(
        tester,
        (_, _) async => const ExploreFeed(featured: null, latest: []),
        loadPromotions: () async => const [
          HomePromotion(
            code: 'VXN20',
            name: 'Giảm 20% cuối tuần',
            isPercent: true,
            discountValue: 20,
            minOrder: 0,
          ),
        ],
      );
      await tester.pumpAndSettle();
      final card = find.byKey(const Key('explore-promotion-card'));
      await tester.scrollUntilVisible(
        card,
        300,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('explore-content-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Giảm 20% cuối tuần'), findsOneWidget);
      expect(find.textContaining('Mã: VXN20'), findsOneWidget);
      expect(find.text('20%'), findsOneWidget);
    });
  });
}
