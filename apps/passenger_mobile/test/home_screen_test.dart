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
        isLoggedIn: isLoggedIn,
        userName: isLoggedIn ? 'Khanh' : null,
        initialMode: initialMode,
        initialDate: DateTime(2026, 10, 22),
        loadLocations: () async => _locations,
        onSearch: onSearch,
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
    expect(find.text('Phương Trang'), findsOneWidget);

    await tester.tap(find.byKey(const Key('search-mode-route')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('origin-input')), findsOneWidget);
    expect(find.byKey(const Key('route-dock-tab-2')), findsOneWidget);
    expect(tester.takeException(), isNull);
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
