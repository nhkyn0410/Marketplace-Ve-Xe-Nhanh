import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/account_screen.dart';
import 'package:passenger_mobile/features/account/edit_profile_screen.dart';
import 'package:passenger_mobile/features/account/guest_account_screen.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_lookup_screen.dart';
import 'package:passenger_mobile/system_navigation_bar.dart';

Future<void> _pumpApp(
  WidgetTester tester,
  Widget home, {
  GlobalKey<NavigatorState>? navigatorKey,
  double bottomPadding = 24,
  double keyboardInset = 0,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 900);
  tester.view.padding = FakeViewPadding(
    top: 24,
    bottom: keyboardInset > 0 ? 0 : bottomPadding,
  );
  tester.view.viewPadding = FakeViewPadding(top: 24, bottom: bottomPadding);
  tester.view.viewInsets = FakeViewPadding(bottom: keyboardInset);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetViewPadding);
  addTearDown(tester.view.resetViewInsets);
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigatorKey,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: PassengerSystemNavigation(child: child!),
      ),
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

SystemUiOverlayStyle? _styleAt(WidgetTester tester, Offset point) => tester
    .binding
    .renderViews
    .single
    .debugLayer!
    .find<SystemUiOverlayStyle>(point);

void _expectBlackNavigation(WidgetTester tester, {double bottomPadding = 24}) {
  final bottomStyle = _styleAt(tester, Offset(206, 899 - bottomPadding / 2));
  expect(bottomStyle?.systemNavigationBarIconBrightness, Brightness.dark);
  expect(bottomStyle?.systemNavigationBarColor, passengerNavigationBarColor);
  expect(bottomStyle?.systemNavigationBarContrastEnforced, isFalse);
  expect(bottomStyle?.statusBarIconBrightness, isNull);
  final background = find.byKey(
    const Key('passenger-system-navigation-background'),
  );
  if (bottomPadding > 0) {
    expect(
      tester.widget<ColoredBox>(background).color,
      passengerNavigationBarColor,
    );
    expect(tester.getSize(background), Size(412, bottomPadding));
    expect(tester.getBottomRight(background).dy, 900);
  } else {
    expect(background, findsNothing);
  }
}

void main() {
  testWidgets('nền xanh nhạt và nút tối giữ nguyên khi bàn phím mở', (
    tester,
  ) async {
    await _pumpApp(tester, const Scaffold(), keyboardInset: 300);
    _expectBlackNavigation(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'trang mới và AppBar không thay màu biểu tượng hệ thống phía dưới',
    (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      await _pumpApp(
        tester,
        Scaffold(
          appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle.light),
          body: const ColoredBox(color: Colors.blue),
        ),
        navigatorKey: navigator,
      );
      _expectBlackNavigation(tester);
      expect(
        _styleAt(tester, const Offset(206, 12))?.statusBarIconBrightness,
        Brightness.light,
      );

      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(backgroundColor: Colors.green),
          ),
        ),
      );
      await tester.pumpAndSettle();
      _expectBlackNavigation(tester);
      expect(
        _styleAt(tester, const Offset(206, 12))?.statusBarIconBrightness,
        Brightness.light,
      );
      expect(
        tester.widget<Scaffold>(find.byType(Scaffold).last).backgroundColor,
        Colors.green,
      );

      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      _expectBlackNavigation(tester);
    },
  );

  testWidgets('modal và đóng modal giữ biểu tượng đen, không chặn thao tác', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Đóng'),
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('Mở'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở'));
    await tester.pumpAndSettle();
    _expectBlackNavigation(tester);
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();
    _expectBlackNavigation(tester);
  });

  testWidgets(
    'không có safe inset dưới vẫn áp dụng tại điểm Flutter đọc kiểu điều hướng',
    (tester) async {
      await _pumpApp(tester, const Scaffold(), bottomPadding: 0);
      _expectBlackNavigation(tester, bottomPadding: 0);
    },
  );

  final screens = <String, Widget Function()>{
    'Hành trình': () =>
        GuestTicketLookupScreen(onLoginRequested: () {}, onTabSelected: (_) {}),
    'Tài khoản khách': () =>
        GuestAccountScreen(onLoginRequested: () {}, onTabSelected: (_) {}),
    'Tài khoản đăng nhập': () => AccountScreen(
      loadOverview: () async => const AccountOverview(
        name: 'Khanh',
        email: 'khanh@example.com',
        emailVerified: true,
      ),
      onLogout: () async => true,
      onTabSelected: (_) {},
      onEditProfile: () {},
      onSavedPassengers: () {},
      onVoucherWallet: () {},
      onLoyalty: () {},
      onPointHistory: () {},
      onMyReviews: () {},
      onNotificationSettings: () {},
      onLoginSessions: () {},
    ),
    'Đăng nhập': () => AuthEntryScreen(onRequestOtp: (_) async {}),
    'Chỉnh sửa hồ sơ': () => EditProfileScreen(
      loadProfile: () async => const PassengerProfileFormData(
        name: 'Khanh',
        email: 'khanh@example.com',
        emailVerified: true,
        phone: null,
        dateOfBirth: null,
        imageUrl: null,
      ),
      saveProfile: (_) async => true,
      onBack: () {},
      onSaved: () {},
    ),
  };
  for (final entry in screens.entries) {
    testWidgets(
      '${entry.key}: biểu tượng Android đen, giữ kiểu status bar của màn',
      (tester) async {
        await _pumpApp(tester, entry.value());
        _expectBlackNavigation(tester);
        expect(tester.takeException(), isNull);
        if (entry.key == 'Chỉnh sửa hồ sơ') {
          expect(
            _styleAt(tester, const Offset(206, 12))?.statusBarIconBrightness,
            Brightness.light,
          );
        }
      },
    );
  }
}
