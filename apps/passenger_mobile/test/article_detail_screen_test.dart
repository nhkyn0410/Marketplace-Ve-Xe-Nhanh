import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/explore/article_detail_screen.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';

Future<void> _pumpDetail(
  WidgetTester tester, {
  double width = 412,
  double height = 760,
  VoidCallback? onFindTrip,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(home: ArticleDetailScreen(onFindTrip: onFindTrip)),
  );
  await tester.pumpAndSettle();
}

String _assetNameIn(WidgetTester tester, Finder scope) {
  final image = tester.widget<Image>(
    find.descendant(of: scope, matching: find.byType(Image)),
  );
  return (image.image as AssetImage).assetName;
}

void main() {
  setUpAll(() async {
    final fontLoader = FontLoader('Be Vietnam Pro')
      ..addFont(rootBundle.load('assets/fonts/BeVietnamPro-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/BeVietnamPro-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/BeVietnamPro-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/BeVietnamPro-Bold.ttf'));
    await fontLoader.load();
  });

  testWidgets('chi tiết Phú Yên giữ đúng geometry và asset của Figma', (
    tester,
  ) async {
    await _pumpDetail(tester, height: 1584);

    expect(
      tester.getSize(find.byKey(const Key('article-detail-hero'))),
      const Size(412, 194),
    );
    expect(
      tester.getSize(find.byKey(const Key('article-detail-category'))),
      const Size(72, 23),
    );
    expect(
      tester.getSize(find.byKey(const Key('article-detail-divider'))),
      const Size(376, 1),
    );
    expect(
      tester.getSize(find.byKey(const Key('article-detail-quote-card'))),
      const Size(376, 205),
    );
    expect(
      tester.getSize(find.byKey(const Key('article-detail-cta-card'))).width,
      376,
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('article-detail-title'))),
      const Offset(18, 247),
    );
    // Dưới tiêu đề không so toạ độ tuyệt đối (Figma: giới thiệu y=398, mục 1 y=512, trích dẫn y=742,
    // CTA y=1399): chiều cao dòng lẻ nửa pixel (21 × 1.5 = 31.5…) được làm tròn từng dòng khác nhau
    // giữa Windows và Linux CI. Kiểm khoảng cách 14 giữa các khối liền nhau — đúng trên mọi nền tảng.
    const column = [
      'article-detail-title',
      'article-detail-metadata',
      'article-detail-divider',
      'article-detail-introduction',
      'article-detail-section-1',
      'article-detail-quote-card',
      'article-detail-section-2',
      'article-detail-section-3',
      'article-detail-cta-card',
    ];
    for (var i = 1; i < column.length; i++) {
      final above = tester.getBottomLeft(find.byKey(Key(column[i - 1])));
      expect(
        tester.getTopLeft(find.byKey(Key(column[i]))),
        Offset(18, above.dy + 14),
        reason: '${column[i]} nằm dưới ${column[i - 1]} 14px',
      );
    }
    for (var section = 1; section <= 3; section++) {
      expect(
        tester.getSize(
          find.byKey(Key('article-detail-section-image-$section')),
        ),
        const Size(158, 160),
      );
    }

    expect(
      _assetNameIn(tester, find.byKey(const Key('article-detail-hero'))),
      'assets/explore/detail_phu_yen_hero.png',
    );
    expect(
      _assetNameIn(tester, find.byKey(const Key('article-detail-quote-card'))),
      'assets/explore/detail_blue_sea_quote.png',
    );
    expect(
      [
        for (var section = 1; section <= 3; section++)
          _assetNameIn(
            tester,
            find.byKey(Key('article-detail-section-image-$section')),
          ),
      ],
      const [
        'assets/explore/detail_rock_coast.png',
        'assets/explore/detail_phu_yen_sunset.png',
        'assets/explore/detail_phu_yen_food.png',
      ],
    );
    expect(find.text('Cẩm nang'), findsOneWidget);
    expect(find.textContaining('Phú Yên xanh ngây ngất'), findsOneWidget);
    expect(find.text('Ẩm thực dân dã, đậm vị biển cả'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mở cùng chi tiết từ tab Tất cả và Cẩm nang rồi quay lại', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(home: ExploreScreen(onTabSelected: (_) {})),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('explore-featured-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('article-detail-screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('article-detail-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('explore-category-guide')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('explore-featured-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('article-detail-screen')), findsOneWidget);
    expect(find.textContaining('Phú Yên xanh ngây ngất'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CTA hoạt động và bài không overflow trên các viewport mobile', (
    tester,
  ) async {
    var pressed = false;
    await _pumpDetail(tester, onFindTrip: () => pressed = true);
    for (var index = 0; index < 2; index++) {
      await tester.drag(
        find.byKey(const Key('article-detail-scroll')),
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byKey(const Key('article-detail-find-trip')));
    expect(pressed, isTrue);
    expect(tester.takeException(), isNull);

    for (final width in <double>[320, 360, 375, 390, 412, 430, 480]) {
      await _pumpDetail(tester, width: width);
      expect(find.byKey(const Key('article-detail-screen')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });
}
