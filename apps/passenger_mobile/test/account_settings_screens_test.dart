import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/login_sessions_screen.dart';
import 'package:passenger_mobile/features/account/notification_settings_screen.dart';

Future<void> _pumpScreen(WidgetTester tester, Widget screen) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: screen,
    ),
  );
}

void main() {
  testWidgets('cài đặt thông báo: tải từ máy chủ, đổi và lưu loại tùy chọn', (
    tester,
  ) async {
    var wentBack = false;
    final saved = <(String, bool)>[];
    await _pumpScreen(
      tester,
      NotificationSettingsScreen(
        loadPreferences: () async => {
          'PROMOTION': true,
          'LOYALTY_UPDATED': true,
          'NEWS': false,
        },
        savePreference: (kind, {required enabled}) async =>
            saved.add((kind, enabled)),
        onBack: () => wentBack = true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thông báo quan trọng'), findsOneWidget);
    expect(find.text('Thông báo tùy chọn'), findsOneWidget);
    expect(find.text('Bảo mật tài khoản'), findsOneWidget);
    expect(find.text('Tin tức và sản phẩm mới'), findsOneWidget);

    final newsSwitch = find.byKey(const Key('notification-switch-news'));
    expect(
      tester.getSemantics(newsSwitch),
      matchesSemantics(
        label: 'Đang tắt',
        isButton: true,
        hasToggledState: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(newsSwitch);
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(newsSwitch),
      matchesSemantics(
        label: 'Đang bật',
        isButton: true,
        hasToggledState: true,
        isToggled: true,
        hasTapAction: true,
      ),
    );
    expect(saved, [('NEWS', true)]);

    await tester.tap(find.byKey(const Key('notification-switch-promotion')));
    await tester.pumpAndSettle();
    expect(saved.last, ('PROMOTION', false));

    await tester.tap(find.byKey(const Key('account-settings-back')));
    expect(wentBack, isTrue);
  });

  testWidgets(
    'thông báo quan trọng luôn bật, chạm không đổi và không gọi API (BR-52)',
    (tester) async {
      final saved = <String>[];
      await _pumpScreen(
        tester,
        NotificationSettingsScreen(
          loadPreferences: () async => const {},
          savePreference: (kind, {required enabled}) async => saved.add(kind),
          onBack: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('notification-mandatory-note')),
        findsOneWidget,
      );
      final ticketSwitch = find.byKey(const Key('notification-switch-ticket'));
      expect(
        tester.getSemantics(ticketSwitch),
        matchesSemantics(
          label: 'Luôn bật',
          isButton: true,
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
        ),
      );
      await tester.tap(ticketSwitch);
      await tester.pumpAndSettle();
      expect(saved, isEmpty);
    },
  );

  testWidgets(
    'cài đặt thông báo: lưu lỗi trả công tắc về như cũ và báo khách',
    (tester) async {
      await _pumpScreen(
        tester,
        NotificationSettingsScreen(
          loadPreferences: () async => {'NEWS': false},
          savePreference: (kind, {required enabled}) async =>
              throw StateError('mạng'),
          onBack: () {},
        ),
      );
      await tester.pumpAndSettle();

      final newsSwitch = find.byKey(const Key('notification-switch-news'));
      await tester.tap(newsSwitch);
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(newsSwitch),
        matchesSemantics(
          label: 'Đang tắt',
          isButton: true,
          hasToggledState: true,
          hasTapAction: true,
        ),
      );
      expect(
        find.text('Chưa lưu được cài đặt. Vui lòng thử lại.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'cài đặt thông báo: tải lỗi có nút thử lại, nhóm quan trọng vẫn hiện',
    (tester) async {
      var attempts = 0;
      await _pumpScreen(
        tester,
        NotificationSettingsScreen(
          loadPreferences: () async {
            attempts++;
            if (attempts == 1) throw StateError('mạng');
            return {'NEWS': true};
          },
          savePreference: (kind, {required enabled}) async {},
          onBack: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('notification-settings-error')),
        findsOneWidget,
      );
      expect(find.text('Bảo mật tài khoản'), findsOneWidget);
      expect(find.byKey(const Key('notification-switch-news')), findsNothing);

      await tester.tap(find.byKey(const Key('notification-settings-retry')));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byKey(const Key('notification-switch-news'))),
        matchesSemantics(
          label: 'Đang bật',
          isButton: true,
          hasToggledState: true,
          isToggled: true,
          hasTapAction: true,
        ),
      );
    },
  );

  List<LoginSessionInfo> sampleSessions() => [
    LoginSessionInfo(
      id: 'current',
      current: true,
      deviceLabel: 'Mobile app on Android',
      ipAddress: '198.51.100.*',
      createdAt: DateTime(2026, 10, 17, 9, 41),
      lastUsedAt: DateTime(2026, 11, 2, 9),
    ),
    LoginSessionInfo(
      id: 'tablet',
      current: false,
      deviceLabel: 'Mobile app on iOS',
      ipAddress: '203.0.113.*',
      createdAt: DateTime(2026, 10, 12, 14, 22),
      lastUsedAt: DateTime(2026, 10, 30, 8),
    ),
    LoginSessionInfo(
      id: 'web',
      current: false,
      deviceLabel: 'Chrome on Windows',
      createdAt: DateTime(2026, 10, 10, 20, 15),
      lastUsedAt: DateTime(2026, 10, 11, 8),
    ),
  ];

  testWidgets(
    'phiên đăng nhập hiện dữ liệu thật, hủy xác nhận thì giữ nguyên',
    (tester) async {
      final revoked = <String>[];
      await _pumpScreen(
        tester,
        LoginSessionsScreen(
          loadSessions: () async => sampleSessions(),
          revokeSession: (id) async => revoked.add(id),
          onBack: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('current-session-card')), findsOneWidget);
      expect(find.text('Ứng dụng di động trên Android'), findsOneWidget);
      expect(find.text('Ứng dụng di động trên iOS'), findsOneWidget);
      expect(find.text('Chrome trên Windows'), findsOneWidget);
      expect(find.text('Không rõ địa chỉ IP'), findsOneWidget);

      await tester.tap(find.byKey(const Key('logout-session-tablet')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('logout-confirmation-sheet')),
        findsOneWidget,
      );
      expect(find.text('Đăng xuất thiết bị khác?'), findsOneWidget);
      expect(
        find.byKey(const Key('login-sessions-detailed-content')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('cancel-session-logout')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('logout-confirmation-sheet')), findsNothing);
      expect(revoked, isEmpty);
      expect(
        find.byKey(const Key('login-sessions-compact-content')),
        findsOneWidget,
      );
    },
  );

  testWidgets('xác nhận đăng xuất gọi máy chủ rồi tải lại danh sách', (
    tester,
  ) async {
    var sessions = sampleSessions();
    final revoked = <String>[];
    await _pumpScreen(
      tester,
      LoginSessionsScreen(
        loadSessions: () async => sessions,
        revokeSession: (id) async {
          revoked.add(id);
          sessions = sessions.where((item) => item.id != id).toList();
        },
        onBack: () {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('logout-session-tablet')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-session-logout')));
    await tester.pumpAndSettle();

    expect(revoked, ['tablet']);
    expect(find.text('Ứng dụng di động trên iOS'), findsNothing);
    expect(find.text('Chrome trên Windows'), findsOneWidget);
  });

  testWidgets('đăng xuất tất cả chỉ thu hồi các thiết bị khác', (tester) async {
    var sessions = sampleSessions();
    final revoked = <String>[];
    await _pumpScreen(
      tester,
      LoginSessionsScreen(
        loadSessions: () async => sessions,
        revokeSession: (id) async {
          revoked.add(id);
          sessions = sessions.where((item) => item.id != id).toList();
        },
        onBack: () {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('logout-all-other-sessions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-session-logout')));
    await tester.pumpAndSettle();

    expect(revoked, ['tablet', 'web']);
    expect(find.byKey(const Key('current-session-card')), findsOneWidget);
    expect(find.text('Không còn phiên đăng nhập nào khác.'), findsOneWidget);
  });

  testWidgets('tải danh sách lỗi thì cho thử lại', (tester) async {
    var attempts = 0;
    await _pumpScreen(
      tester,
      LoginSessionsScreen(
        loadSessions: () async {
          attempts++;
          if (attempts == 1) throw StateError('offline');
          return sampleSessions();
        },
        revokeSession: (_) async {},
        onBack: () {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login-sessions-retry')));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.byKey(const Key('current-session-card')), findsOneWidget);
  });
}
