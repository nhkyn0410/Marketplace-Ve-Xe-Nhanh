import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/home_screen.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';

import 'support/trip_search_fakes.dart';

/// Thanh cuộn dọc của trang chủ (bỏ qua các carousel ngang bên trong).
Finder _homeScrollable() => find
    .descendant(
      of: find.byKey(const Key('home-content-scroll')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> _pumpHome(
  WidgetTester tester, {
  required double width,
  double height = 915,
  double textScale = 1,
  bool isLoggedIn = false,
  HomeSearchMode initialMode = HomeSearchMode.route,
  HomeTripSearch? onSearch,
  HomePopularRoutesLoader? loadPopularRoutes,
  HomeFaqLoader? loadFaqs,
  HomePromotionsLoader? loadPromotions,
  HomeOperatorsLoader? loadFeaturedOperators,
  TripSearchCatalog? searchCatalog,
  HomeArticlesLoader? loadArticles,
  ValueChanged<ExploreArticle>? onArticleSelected,
  ValueChanged<HomeOperator>? onOperatorSelected,
  HomeHotlineLauncher? onCallHotline,
  VoidCallback? onFeedbackRequested,
  VoidCallback? onLoginRequested,
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
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: HomeScreen(
        key: ValueKey('home-$isLoggedIn'),
        isLoggedIn: isLoggedIn,
        userName: isLoggedIn ? 'Khanh' : null,
        initialMode: initialMode,
        initialDate: DateTime(2026, 10, 22),
        searchCatalog: searchCatalog ?? fakeCatalog(),
        loadPopularRoutes: loadPopularRoutes,
        loadFaqs: loadFaqs,
        loadPromotions: loadPromotions,
        loadFeaturedOperators: loadFeaturedOperators,
        onOperatorSelected: onOperatorSelected,
        loadArticles: loadArticles,
        onArticleSelected: onArticleSelected,
        onSearch: onSearch,
        onCallHotline: onCallHotline,
        onFeedbackRequested: onFeedbackRequested,
        onLoginRequested: onLoginRequested,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('thẻ nhà xe và danh sách chọn dùng logo, tải lỗi vẫn hiện chữ thay thế', (
    tester,
  ) async {
    const logo = 'https://cdn.example.test/operator-logo.png';
    const operators = [
      HomeOperator(
        id: 'logo-operator',
        name: 'Nhà xe Sao Mai',
        logoUrl: logo,
        reviewCount: 0,
        routes: [],
      ),
    ];
    await _pumpHome(
      tester,
      width: 412,
      initialMode: HomeSearchMode.operator,
      loadFeaturedOperators: () async => operators,
      searchCatalog: fakeCatalog(operators: operators),
    );
    final card = find.byKey(const ValueKey('featured-operator-logo-operator'));
    await tester.scrollUntilVisible(card, 200, scrollable: _homeScrollable());
    final logoImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == logo,
    );
    expect(find.descendant(of: card, matching: logoImage), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('operator-input')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operator-input')));
    await tester.pumpAndSettle();
    final option = find.byKey(const ValueKey('operator-option-logo-operator'));
    expect(find.descendant(of: option, matching: logoImage), findsOneWidget);
    expect(find.descendant(of: option, matching: find.text('N')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bấm thẻ Nhà xe nổi bật mở trang của nhà xe đó', (tester) async {
    const operators = [
      HomeOperator(id: 'op-1', name: 'Sao Mai', reviewCount: 0, routes: []),
    ];
    HomeOperator? selected;
    await _pumpHome(
      tester,
      width: 412,
      loadFeaturedOperators: () async => operators,
      onOperatorSelected: (operator) => selected = operator,
    );
    final card = find.byKey(const ValueKey('featured-operator-op-1'));
    await tester.scrollUntilVisible(card, 200, scrollable: _homeScrollable());
    await tester.pumpAndSettle();

    await tester.tap(card);

    expect(selected?.id, 'op-1');
  });

  testWidgets('Home responsive không overflow ở các viewport bắt buộc', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 375, 390, 412, 430, 480]) {
      await _pumpHome(tester, width: width, height: 760);
      expect(find.byKey(const Key('home-screen')), findsOneWidget);
      expect(find.byKey(const Key('journey-planner')), findsOneWidget);
      expect(find.byKey(const Key('route-dock-tabbar')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets('Home thích ứng màn hình thấp và cỡ chữ lớn', (tester) async {
    await _pumpHome(tester, width: 320, height: 568, textScale: 1.5);
    expect(find.byKey(const Key('home-content-scroll')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byKey(const Key('home-content-scroll')),
      const Offset(0, -1200),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-station')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Guest và logged-in dùng đúng biến thể nội dung', (tester) async {
    var loginRequested = false;
    await _pumpHome(
      tester,
      width: 412,
      onLoginRequested: () => loginRequested = true,
    );
    expect(find.byKey(const Key('guest-login-banner')), findsOneWidget);
    await tester.ensureVisible(find.text('Đăng nhập  →'));
    await tester.tap(find.text('Đăng nhập  →'));
    expect(loginRequested, isTrue);

    await _pumpHome(tester, width: 412, isLoggedIn: true);
    expect(find.text('Xin chào, Khanh!'), findsOneWidget);
    expect(find.byKey(const Key('guest-login-banner')), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.endsWith('user_avatar.png'),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('ưu đãi, nhà xe, bài viết lấy từ API và giữ kích thước thẻ', (
    tester,
  ) async {
    ExploreArticle? opened;
    await _pumpHome(
      tester,
      width: 390,
      loadPromotions: () async => const [
        HomePromotion(
          code: 'VXN20',
          name: 'Giảm 20%',
          isPercent: true,
          discountValue: 20,
          maxDiscount: 50000,
          minOrder: 0,
        ),
        HomePromotion(
          code: 'SAOMAI50',
          name: 'Giảm 50K',
          isPercent: false,
          discountValue: 50000,
          minOrder: 300000,
          operatorName: 'Nhà xe Sao Mai',
        ),
      ],
      loadFeaturedOperators: () async => const [
        HomeOperator(
          id: 'op-1',
          name: 'Nhà xe Sao Mai',
          averageRating: 4.75,
          reviewCount: 120,
          routes: [],
        ),
        HomeOperator(id: 'op-2', name: 'An Phú', reviewCount: 0, routes: []),
      ],
      loadArticles: () async => [
        ExploreArticle(
          slug: 'di-da-lat',
          title: 'Kinh nghiệm đi Đà Lạt',
          category: 'Cẩm nang',
          publishedAt: DateTime.utc(2026, 10, 20),
          fallbackAsset: 'assets/explore/article_road_trip.png',
        ),
      ],
      onArticleSelected: (article) => opened = article,
    );

    expect(find.text('Tìm kiếm gần đây'), findsNothing);
    final percent = find.byKey(const ValueKey('home-promotion-VXN20'));
    expect(
      find.descendant(of: percent, matching: find.text('Giảm 20%')),
      findsOne,
    );
    expect(
      find.descendant(of: percent, matching: find.text('Tối đa 50K')),
      findsOne,
    );
    expect(find.text('Nhà xe Sao Mai · Đơn từ 300K'), findsOneWidget);
    expect(find.text('Mã: SAOMAI50'), findsOneWidget);

    final operator = find.byKey(const ValueKey('featured-operator-op-1'));
    await tester.scrollUntilVisible(
      operator,
      200,
      scrollable: _homeScrollable(),
    );
    expect(tester.getSize(operator), const Size(158, 76));
    expect(find.descendant(of: operator, matching: find.text('SM')), findsOne);
    expect(
      find.descendant(of: operator, matching: find.text('★ 4.8')),
      findsOne,
    );
    expect(
      find.descendant(of: operator, matching: find.text('(120 đánh giá)')),
      findsOneWidget,
    );
    expect(find.text('Chưa có đánh giá'), findsOneWidget);

    final article = find.byKey(const ValueKey('home-article-di-da-lat'));
    await tester.scrollUntilVisible(
      article,
      200,
      scrollable: _homeScrollable(),
    );
    expect(tester.getSize(article), const Size(154, 86));
    await tester.tap(article);
    expect(opened?.slug, 'di-da-lat');
    expect(tester.takeException(), isNull);
  });

  testWidgets('chạm thẻ ưu đãi chép mã', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await _pumpHome(
      tester,
      width: 390,
      loadPromotions: () async => const [
        HomePromotion(
          code: 'VXN20',
          name: 'Giảm 20%',
          isPercent: true,
          discountValue: 20,
          minOrder: 0,
        ),
      ],
    );

    await tester.tap(find.byKey(const ValueKey('home-promotion-VXN20')));
    await tester.pump();
    expect(copied, 'VXN20');
    expect(find.text('Đã chép mã VXN20. Dán mã khi đặt vé.'), findsOneWidget);
  });

  testWidgets('API rỗng hoặc lỗi thì ẩn mục, không hiện dữ liệu mẫu', (
    tester,
  ) async {
    await _pumpHome(
      tester,
      width: 390,
      loadPromotions: () async => const [],
      loadFeaturedOperators: () async => throw Exception('mạng'),
      loadArticles: () async => const [],
    );

    expect(find.text('Ưu đãi nổi bật'), findsNothing);
    expect(find.text('Nhà xe nổi bật'), findsNothing);
    expect(find.text('Khám phá & cẩm nang'), findsNothing);
    expect(find.text('Phương Trang'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tuyến phổ biến dùng dữ liệu động và điền lại form tìm kiếm', (
    tester,
  ) async {
    const route = HomePopularRoute(
      from: HomeLocation(id: 'hn', name: 'Hà Nội'),
      to: HomeLocation(id: 'dn', name: 'Đà Nẵng'),
      fromLabel: 'Hà Nội',
      toLabel: 'Đà Nẵng',
      minPriceVnd: 450000,
      fallbackAsset: 'assets/home/destinations/da_nang.jpg',
    );
    await _pumpHome(
      tester,
      width: 390,
      loadPopularRoutes: (_) async => const [route],
    );

    expect(find.text('450.000đ'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('popular-route-card-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('popular-route-card-0')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('origin-input')),
        matching: find.text('Hà Nội'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('destination-input')),
        matching: find.text('Đà Nẵng'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('trung tâm trợ giúp tải FAQ và nút tổng đài gọi callback', (
    tester,
  ) async {
    String? calledNumber;
    await _pumpHome(
      tester,
      width: 390,
      loadFaqs: () async => const [
        HomeFaqItem(
          title: 'Làm sao đổi vé?',
          body: 'Vui lòng mở chi tiết vé để kiểm tra điều kiện.',
        ),
      ],
      onCallHotline: (number) async {
        calledNumber = number;
        return true;
      },
    );

    await tester.drag(
      find.byKey(const Key('home-content-scroll')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'khối hỗ trợ bị overflow');
    final helpCenter = find.byKey(const Key('support-help-center'));
    await tester.tap(helpCenter);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'FAQ sheet bị overflow');
    expect(find.text('Làm sao đổi vé?'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'đóng FAQ sheet bị lỗi');
    final callHotline = find.byKey(
      const Key('support-call-hotline'),
      skipOffstage: false,
    );
    await tester.ensureVisible(callHotline);
    await tester.pumpAndSettle();
    await tester.tap(callHotline);
    await tester.pump();
    expect(calledNumber, '1900 636 707');
    expect(tester.takeException(), isNull);
  });

  testWidgets('dock trượt ẩn khi cuộn xuống và hiện khi cuộn lên', (
    tester,
  ) async {
    await _pumpHome(tester, width: 390, height: 760);
    final dock = find.byKey(const Key('home-bottom-dock-animation'));
    expect(tester.widget<AnimatedSlide>(dock).offset, Offset.zero);

    await tester.drag(
      find.byKey(const Key('home-content-scroll')),
      const Offset(0, -500),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<AnimatedSlide>(dock).offset, const Offset(0, 1));

    await tester.drag(
      find.byKey(const Key('home-content-scroll')),
      const Offset(0, 250),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<AnimatedSlide>(dock).offset, Offset.zero);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chuyển đủ hai chế độ tìm kiếm mà không đổi tab Home', (
    tester,
  ) async {
    await _pumpHome(tester, width: 412);
    expect(find.text('Theo chuyến'), findsOneWidget);
    expect(find.text('Theo tuyến'), findsNothing);
    expect(find.byKey(const Key('origin-input')), findsOneWidget);
    expect(find.text('Chọn điểm đi'), findsOneWidget);
    expect(find.text('Chọn điểm đến'), findsOneWidget);

    await tester.tap(find.byKey(const Key('search-mode-operator')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('operator-input')), findsOneWidget);
    // Lần đầu mở: ô trống để chọn, không điền sẵn nhà xe / tuyến.
    expect(find.text('Chọn nhà xe'), findsOneWidget);
    expect(find.text('Chọn nhà xe trước'), findsOneWidget);

    await tester.tap(find.byKey(const Key('search-mode-route')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('origin-input')), findsOneWidget);
    expect(find.byKey(const Key('route-dock-tab-2')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chỉ báo và nội dung tìm kiếm chuyển chế độ mượt', (
    tester,
  ) async {
    await _pumpHome(tester, width: 412);
    final indicator = find.byKey(const Key('search-mode-indicator'));
    final operatorTab = find.byKey(const Key('search-mode-operator'));
    final startX = tester.getCenter(indicator).dx;
    final endX = tester.getCenter(operatorTab).dx;

    await tester.tap(operatorTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final movingX = tester.getCenter(indicator).dx;
    expect(movingX, greaterThan(startX));
    expect(movingX, lessThan(endX));
    expect(find.byKey(const Key('origin-input')), findsOneWidget);
    expect(find.byKey(const Key('operator-input')), findsOneWidget);

    await tester.pumpAndSettle();
    expect(tester.getCenter(indicator).dx, closeTo(endX, .01));
    expect(find.byKey(const Key('origin-input')), findsNothing);
    expect(find.byKey(const Key('operator-input')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hai tab tìm kiếm chia đều và giữ chiều cao ở mọi viewport', (
    tester,
  ) async {
    for (final width in <double>[320, 430]) {
      await _pumpHome(tester, width: width);

      final routeSize = tester.getSize(
        find.byKey(const Key('search-mode-route')),
      );
      final operatorSize = tester.getSize(
        find.byKey(const Key('search-mode-operator')),
      );

      expect(routeSize.width, closeTo(operatorSize.width, 0.01));
      expect(routeSize.height, 40);
      expect(operatorSize.height, 40);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets('route search chỉ gọi callback sau khi chọn dữ liệu Catalog', (
    tester,
  ) async {
    HomeSearchQuery? submitted;
    await _pumpHome(tester, width: 412, onSearch: (query) => submitted = query);

    await tester.tap(find.byKey(const Key('home-search-button')));
    await tester.pump();
    expect(
      find.text('Vui lòng chọn điểm đi và điểm đến từ danh mục.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('origin-input')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('TP. Hồ Chí Minh').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('destination-input')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lâm Đồng').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home-search-button')));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);
    expect(submitted!.from.id, 'hcm');
    expect(submitted!.to.id, 'lam-dong');
    expect(submitted!.passengers, 1);
    expect(submitted!.operatorId, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    '1 ký tự lọc tỉnh không dấu; từ 2 ký tự gợi ý như web (tỉnh, khu vực, bến)',
    (tester) async {
      HomeSearchQuery? submitted;
      await _pumpHome(
        tester,
        width: 412,
        onSearch: (query) => submitted = query,
      );

      await tester.tap(find.byKey(const Key('origin-input')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('location-search-field')),
        'l',
      );
      await tester.pumpAndSettle();
      expect(find.text('Lâm Đồng'), findsWidgets);
      expect(find.text('TP. Hồ Chí Minh'), findsNothing);

      await tester.enterText(
        find.byKey(const Key('location-search-field')),
        'mien dong',
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Bến xe Miền Đông'), findsOneWidget);
      expect(find.text('Đà Lạt'), findsOneWidget);
      expect(
        find.text('Thành phố Đà Lạt cũ · nay thuộc Tỉnh Lâm Đồng'),
        findsOneWidget,
      );

      await tester.tap(find.text('Bến xe Miền Đông'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('destination-input')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('location-search-field')),
        'da lat',
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đà Lạt'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home-search-button')));
      await tester.pumpAndSettle();
      expect(submitted!.from.kind, HomeLocationKind.stopPoint);
      expect(submitted!.from.id, 'mien-dong');
      expect(submitted!.to.kind, HomeLocationKind.area);
      expect(submitted!.to.id, '68-thanh-pho-da-lat');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('theo nhà xe: chọn nhà xe rồi chọn tuyến (đủ điểm đi và đến)', (
    tester,
  ) async {
    HomeSearchQuery? submitted;
    await _pumpHome(tester, width: 412, onSearch: (query) => submitted = query);
    await tester.tap(find.byKey(const Key('search-mode-operator')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home-search-button')));
    await tester.pump();
    expect(find.text('Vui lòng chọn nhà xe.'), findsOneWidget);

    // Bấm ô Tuyến khi chưa có nhà xe thì mở chọn nhà xe trước.
    await tester.tap(find.byKey(const Key('operator-route-input')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn nhà xe'), findsWidgets);
    expect(find.text('★ 4.7 (12 đánh giá) · 2 tuyến'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('operator-option-op-pt')));
    await tester.pumpAndSettle();

    // Nhà xe có nhiều tuyến → tự mở bước chọn tuyến.
    expect(find.text('Chọn tuyến · Phương Trang'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('operator-route-option-1')));
    await tester.pumpAndSettle();
    expect(find.text('Lâm Đồng → TP. Hồ Chí Minh'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-search-button')));
    await tester.pumpAndSettle();
    expect(submitted!.mode, HomeSearchMode.operator);
    expect(submitted!.operatorId, 'op-pt');
    expect(submitted!.from.id, 'lam-dong');
    expect(submitted!.to.id, 'hcm');
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab chưa triển khai không tạo điều hướng giả', (tester) async {
    await _pumpHome(tester, width: 390);
    await tester.tap(find.byKey(const Key('route-dock-tab-0')));
    await tester.pump();
    expect(find.text('Khám phá chưa được triển khai.'), findsOneWidget);
    expect(find.byKey(const Key('home-screen')), findsOneWidget);
  });
}
