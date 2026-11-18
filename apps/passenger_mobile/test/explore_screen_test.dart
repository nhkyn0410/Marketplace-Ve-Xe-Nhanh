import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';

Future<void> _pumpExplore(
  WidgetTester tester, {
  double width = 412,
  double height = 1440,
  ValueChanged<int>? onTabSelected,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7EAD)),
      ),
      home: ExploreScreen(onTabSelected: onTabSelected ?? (_) {}),
    ),
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
  testWidgets('màn Khám phá giữ đúng geometry card của Figma ở 412dp', (
    tester,
  ) async {
    await _pumpExplore(tester);

    expect(
      tester.getSize(find.byKey(const Key('explore-featured-card'))),
      const Size(384, 271),
    );
    expect(
      tester.getSize(find.byKey(const Key('explore-search-frame'))),
      const Size(376, 40),
    );
    expect(
      tester.getSize(find.byKey(const Key('explore-category-all'))),
      const Size(70, 30),
    );
    for (var index = 0; index < 3; index++) {
      expect(
        tester.getSize(find.byKey(Key('explore-latest-row-$index'))),
        const Size(384, 196),
      );
      expect(
        tester.getSize(find.byKey(Key('explore-latest-image-$index'))),
        const Size(116, 148),
      );
    }
    final firstBadge = find.byKey(const Key('explore-latest-badge-0'));
    final tipBadge = find.byKey(const Key('explore-latest-badge-1'));
    final firstBadgeText = find.descendant(
      of: firstBadge,
      matching: find.text('Cẩm nang'),
    );
    final tipBadgeText = find.descendant(
      of: tipBadge,
      matching: find.text('Mẹo du lịch'),
    );
    expect(tester.getSize(firstBadge).height, 20);
    expect(
      tester.getSize(firstBadge).width,
      tester.getSize(firstBadgeText).width + 20,
    );
    expect(
      tester.getSize(tipBadge).width,
      tester.getSize(tipBadgeText).width + 20,
    );
    expect(tester.getSize(firstBadge).width, lessThan(240));
    expect(tester.getSize(tipBadge).width, lessThan(240));
    expect(
      tester.getSize(tipBadge).width,
      greaterThan(tester.getSize(firstBadge).width),
    );
    expect(tester.getTopLeft(firstBadge).dx, tester.getTopLeft(tipBadge).dx);
    expect(
      tester.getSize(find.byKey(const Key('explore-promotion-card'))),
      const Size(384, 98),
    );
    final heading = tester.widget<Text>(
      find.byKey(const Key('explore-heading-primary')),
    );
    expect(heading.style?.fontFamily, 'Be Vietnam Pro');
    // Cùng kiểu với tiêu đề tab Mua vé.
    expect(heading.data, 'Khám phá hành trình');
    expect(heading.style?.fontSize, 24);
    expect(heading.style?.height, 34 / 24);
    expect(heading.style?.fontWeight, FontWeight.w600);
    expect(find.byKey(const Key('route-dock-tabbar')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hai tab danh mục dùng đúng bài và ảnh local theo Figma', (
    tester,
  ) async {
    int? selectedTab;
    await _pumpExplore(
      tester,
      height: 900,
      onTabSelected: (index) => selectedTab = index,
    );

    await tester.tap(find.byKey(const Key('explore-category-guide')));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byKey(const Key('explore-featured-card'))),
      const Size(384, 271),
    );
    expect(find.byKey(const Key('explore-latest-row-3')), findsOneWidget);
    for (var index = 0; index < 4; index++) {
      expect(
        tester.getSize(find.byKey(Key('explore-latest-image-$index'))),
        const Size(116, 148),
      );
    }
    expect(
      find.text(
        'Lào Cai: Bản làng H’Mông, ruộng bậc thang và văn hóa vùng biên',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Lạc bước giữa thung lũng thiêng, nghe gạch cổ kể chuyện nghìn năm',
      ),
      findsOneWidget,
    );
    expect(
      [
        for (var index = 0; index < 4; index++)
          _assetNameIn(tester, find.byKey(Key('explore-latest-image-$index'))),
      ],
      const [
        'assets/explore/article_da_lat_church.jpg',
        'assets/explore/article_stop.png',
        'assets/explore/guide_lao_cai.png',
        'assets/explore/guide_sacred_valley.png',
      ],
    );
    expect(find.byKey(const Key('explore-promotion-card')), findsNothing);

    await tester.tap(find.byKey(const Key('explore-category-tips')));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byKey(const Key('explore-featured-card'))),
      const Size(384, 252),
    );
    expect(
      find.text(
        'Đừng để chuyến đi mất vui chỉ vì chiếc ghế: mẹo nhỏ, khác biệt lớn !',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Kinh nghiệm chuẩn bị cho chuyến đi xa cho người mới'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Lên xe rồi mới biết mình quên đồ ? Checklist gọn cho người hay vội',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('explore-latest-row-3')), findsOneWidget);
    expect(
      _assetNameIn(tester, find.byKey(const Key('explore-featured-card'))),
      'assets/explore/tips_featured_seat.png',
    );
    expect(
      [
        for (var index = 0; index < 4; index++)
          _assetNameIn(tester, find.byKey(Key('explore-latest-image-$index'))),
      ],
      const [
        'assets/explore/article_road_trip.png',
        'assets/explore/tips_checklist.png',
        'assets/explore/tips_night_bus.png',
        'assets/explore/tips_pickup_point.png',
      ],
    );

    await tester.enterText(
      find.byKey(const Key('explore-search-field')),
      'Đà Lạt',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Đà Lạt'), findsOneWidget);
    expect(find.byKey(const Key('explore-featured-card')), findsOneWidget);

    await tester.tap(find.byKey(const Key('route-dock-tab-2')));
    expect(selectedTab, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('màn Khám phá không overflow trên các viewport mobile', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 375, 390, 412, 430, 480]) {
      await _pumpExplore(tester, width: width, height: 760);
      expect(find.byKey(const Key('explore-screen')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Tất cả, $width dp');

      await tester.tap(find.byKey(const Key('explore-category-guide')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Cẩm nang, $width dp');

      await tester.tap(find.byKey(const Key('explore-category-tips')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Mẹo du lịch, $width dp');
    }
  });

  testWidgets(
    'chỉ có một bài thì hiện ở thẻ nổi bật, không báo "chưa có bài viết"',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 1440);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        MaterialApp(
          home: ExploreScreen(
            onTabSelected: (_) {},
            loadFeed: (category, query) async => ExploreFeed(
              featured: ExploreArticle(
                slug: 'huong-dan-ma-ve-qr',
                title: 'Hướng dẫn sử dụng mã vé điện tử QR',
                category: 'Kinh nghiệm đi xe khách',
                publishedAt: DateTime.utc(2026, 4, 20),
                fallbackAsset: 'assets/explore/featured_phu_yen.png',
              ),
              latest: const [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('explore-featured-card')), findsOneWidget);
      expect(find.text('Hướng dẫn sử dụng mã vé điện tử QR'), findsOneWidget);
      expect(find.textContaining('Chưa có bài viết'), findsNothing);
      expect(find.text('Bài viết mới nhất'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  // PASSENGER-PARITY A19 (4.7): chuyên mục lấy từ API kèm số bài, như web.
  Future<List<String?>> pumpApiExplore(
    WidgetTester tester,
    Future<List<ExploreCategory>> Function() loadCategories,
  ) async {
    final requested = <String?>[];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 1440);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: ExploreScreen(
          onTabSelected: (_) {},
          loadCategories: loadCategories,
          loadFeed: (category, query) async {
            requested.add(category);
            return const ExploreFeed(featured: null, latest: []);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return requested;
  }

  testWidgets('chế độ API: chuyên mục từ máy chủ kèm số bài, chọn thì tải đúng slug', (
    tester,
  ) async {
    final requested = await pumpApiExplore(
      tester,
      () async => const [
        ExploreCategory(slug: 'kinh-nghiem', name: 'Kinh nghiệm', count: 3),
        ExploreCategory(slug: 'am-thuc', name: 'Ẩm thực', count: 2),
      ],
    );
    expect(find.text('Tất cả (5)'), findsOneWidget);
    expect(find.text('Kinh nghiệm (3)'), findsOneWidget);
    expect(find.byKey(const Key('explore-category-guide')), findsNothing);

    // Chuyên mục thứ ba nằm ngoài mép phải: vuốt ngang tới rồi chọn.
    final dining = find.byKey(const Key('explore-category-am-thuc'));
    await tester.scrollUntilVisible(
      dining,
      120,
      scrollable: find.descendant(
        of: find.byKey(const Key('explore-categories-api')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Ẩm thực (2)'), findsOneWidget);
    await tester.tap(dining);
    await tester.pumpAndSettle();
    expect(requested, [null, 'am-thuc']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tải chuyên mục lỗi: chỉ còn "Tất cả", không hiện chuyên mục mẫu', (
    tester,
  ) async {
    await pumpApiExplore(tester, () async => throw StateError('offline'));
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Cẩm nang'), findsNothing);
    expect(find.text('Mẹo du lịch'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
