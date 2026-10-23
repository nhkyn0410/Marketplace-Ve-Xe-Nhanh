import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/account_screen.dart';
import 'package:passenger_mobile/features/account/passenger_avatar.dart';

const _overview = AccountOverview(
  name: 'Nguyễn Văn Khanh',
  email: 'nguyenvankhanh@gmail.com',
  emailVerified: true,
  availablePoints: 1250,
  loyaltyTier: 'SILVER',
  savedPassengerCount: 2,
);

Future<void> _pumpAccount(
  WidgetTester tester, {
  required AccountOverviewLoader loader,
  AccountLogout? onLogout,
  ValueChanged<int>? onTabSelected,
  VoidCallback? onEditProfile,
  VoidCallback? onSavedPassengers,
  VoidCallback? onVoucherWallet,
  VoidCallback? onPointHistory,
  VoidCallback? onMyReviews,
  String? logoutErrorMessage,
  double width = 390,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: AccountScreen(
        loadOverview: loader,
        onLogout: onLogout ?? () async => true,
        onTabSelected: onTabSelected ?? (_) {},
        onEditProfile: onEditProfile ?? () {},
        onSavedPassengers: onSavedPassengers ?? () {},
        onVoucherWallet: onVoucherWallet ?? () {},
        onPointHistory: onPointHistory ?? () {},
        onMyReviews: onMyReviews ?? () {},
        logoutErrorMessage: logoutErrorMessage,
      ),
    ),
  );
}

void main() {
  testWidgets('hiển thị dữ liệu tài khoản thật và trạng thái tổng quan', (
    tester,
  ) async {
    await _pumpAccount(tester, loader: () async => _overview, width: 320);

    expect(find.byKey(const Key('account-loading')), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Tài khoản của tôi'), findsOneWidget);
    expect(find.byKey(const Key('account-name')), findsOneWidget);
    expect(find.text('Nguyễn Văn Khanh'), findsOneWidget);
    expect(find.text('nguyenvankhanh@gmail.com'), findsOneWidget);
    expect(find.text('1.250'), findsOneWidget);
    expect(find.text('Hạng Bạc'), findsOneWidget);
    expect(find.text('2/5 hành khách'), findsOneWidget);
    expect(find.byKey(const Key('route-dock-tab-4')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tài khoản chưa có ảnh dùng đúng avatar mặc định', (
    tester,
  ) async {
    await _pumpAccount(tester, loader: () async => _overview);
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(
      find.byKey(const Key('passenger-default-avatar')),
    );
    expect((image.image as AssetImage).assetName, passengerDefaultAvatarAsset);
  });

  testWidgets('nút chỉnh sửa mở luồng hồ sơ thay vì thông báo sắp có', (
    tester,
  ) async {
    var opened = false;
    await _pumpAccount(
      tester,
      loader: () async => _overview,
      onEditProfile: () => opened = true,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('account-edit-button')));
    expect(opened, isTrue);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('mục hành khách đã lưu mở màn quản lý', (tester) async {
    var opened = false;
    await _pumpAccount(
      tester,
      loader: () async => _overview,
      onSavedPassengers: () => opened = true,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hành khách đã lưu'));
    expect(opened, isTrue);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('mục voucher và lịch sử điểm mở đúng màn hình', (tester) async {
    var voucherOpened = false;
    var pointsOpened = false;
    await _pumpAccount(
      tester,
      loader: () async => _overview,
      onVoucherWallet: () => voucherOpened = true,
      onPointHistory: () => pointsOpened = true,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ví voucher'));
    await tester.tap(find.text('Lịch sử điểm'));

    expect(voucherOpened, isTrue);
    expect(pointsOpened, isTrue);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('mục đánh giá của tôi mở màn quản lý đánh giá', (tester) async {
    var opened = false;
    await _pumpAccount(
      tester,
      loader: () async => _overview,
      onMyReviews: () => opened = true,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đánh giá của tôi'));

    expect(opened, isTrue);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('dock điều hướng về Home và nút đăng xuất không gửi lặp', (
    tester,
  ) async {
    final logoutResult = Completer<bool>();
    var logoutCalls = 0;
    int? selectedTab;
    await _pumpAccount(
      tester,
      loader: () async => _overview,
      onLogout: () {
        logoutCalls++;
        return logoutResult.future;
      },
      onTabSelected: (index) => selectedTab = index,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('route-dock-tab-2')));
    expect(selectedTab, 2);

    await tester.scrollUntilVisible(
      find.byKey(const Key('account-logout-button')),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('account-content-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const Key('account-logout-button')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('account-logout-button')));
    expect(logoutCalls, 1);
    expect(find.text('Đang đăng xuất...'), findsOneWidget);

    logoutResult.complete(false);
    await tester.pumpAndSettle();
    expect(find.text('Đăng xuất'), findsOneWidget);
  });

  testWidgets('lỗi tải hồ sơ có thể thử lại', (tester) async {
    var attempts = 0;
    await _pumpAccount(
      tester,
      loader: () async {
        attempts++;
        if (attempts == 1) throw StateError('offline');
        return _overview;
      },
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa thể tải thông tin tài khoản'), findsOneWidget);
    await tester.tap(find.byKey(const Key('account-retry-button')));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Tài khoản của tôi'), findsOneWidget);
  });
}
