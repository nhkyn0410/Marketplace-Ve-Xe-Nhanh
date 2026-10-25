import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/home_screen.dart';

const _locations = <HomeLocation>[
  HomeLocation(id: 'hcm', name: 'TP. Hồ Chí Minh'),
  HomeLocation(id: 'lam-dong', name: 'Lâm Đồng'),
];

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
        loadLocations: () async => _locations,
        loadPopularRoutes: loadPopularRoutes,
        loadFaqs: loadFaqs,
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

  testWidgets('bỏ tìm kiếm gần đây và thẻ nội dung dùng kích thước mới', (
    tester,
  ) async {
    await _pumpHome(tester, width: 390);

    expect(find.text('Tìm kiếm gần đây'), findsNothing);

    final operator = find.byKey(
      const ValueKey('featured-operator-Phương Trang'),
    );
    expect(operator, findsOneWidget);
    expect(tester.getSize(operator), const Size(158, 76));
    expect(
      find.descendant(of: operator, matching: find.text('Phương Trang')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: operator, matching: find.text('★ 4.8')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: operator, matching: find.text('(12.5K đánh giá)')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: operator, matching: find.text('TP.HCM → Đà Lạt')),
      findsNothing,
    );

    final article = find.byKey(
      const ValueKey(
        'home-article-assets/home/articles/da_lat_coach_guide.jpg',
      ),
    );
    expect(article, findsOneWidget);
    expect(tester.getSize(article), const Size(154, 86));
    expect(tester.takeException(), isNull);
  });

  testWidgets('tuyến phổ biến dùng dữ liệu động và điền lại form tìm kiếm', (
    tester,
  ) async {
    const route = HomePopularRoute(
      tripId: 'trip-1',
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
    expect(find.byKey(const Key('origin-input')), findsOneWidget);

    await tester.tap(find.byKey(const Key('search-mode-operator')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('operator-input')), findsOneWidget);
    expect(find.text('Phương Trang'), findsWidgets);

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
    await _pumpHome(
      tester,
      width: 412,
      onSearch: (query) async {
        submitted = query;
        return 3;
      },
    );

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
    expect(find.text('Tìm thấy 3 chuyến phù hợp.'), findsOneWidget);
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
