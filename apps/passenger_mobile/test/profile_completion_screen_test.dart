import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(412, 915);
    view.devicePixelRatio = 1;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  Widget screen({
    ProfileCompletionCallback? onComplete,
    bool busy = false,
    String? errorMessage,
    EdgeInsets padding = EdgeInsets.zero,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(padding: padding, textScaler: textScaler),
        child: child!,
      ),
      home: ProfileCompletionScreen(
        email: 'khach@example.com',
        busy: busy,
        errorMessage: errorMessage,
        onComplete: onComplete ?? (_, _) async => false,
      ),
    );
  }

  testWidgets('hiển thị đúng các trường trong thiết kế Figma', (tester) async {
    await tester.pumpWidget(screen());
    await tester.pump();

    expect(find.text('Hoàn thiện hồ sơ'), findsOneWidget);
    expect(
      find.text('Thêm thông tin để sẵn sàng cho chuyến đi.'),
      findsOneWidget,
    );
    expect(find.text('Đã xác minh'), findsOneWidget);
    expect(find.text('Không bắt buộc (Tùy chọn)'), findsOneWidget);
    expect(find.byKey(const Key('profile-name-field')), findsOneWidget);
    expect(find.byKey(const Key('profile-phone-field')), findsOneWidget);
    expect(find.byKey(const Key('profile-complete-button')), findsOneWidget);

    final email = tester.widget<TextField>(
      find.byKey(const Key('profile-email')),
    );
    expect(email.readOnly, isTrue);
    expect(email.controller?.text, 'khach@example.com');
    expect(tester.takeException(), isNull);
  });

  testWidgets('bắt buộc nhập họ tên', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      screen(
        onComplete: (_, _) async {
          calls++;
          return true;
        },
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('profile-complete-button')));
    await tester.pump();

    expect(calls, 0);
    expect(find.text('Vui lòng nhập họ và tên hành khách.'), findsOneWidget);
  });

  testWidgets('chuẩn hóa số điện thoại Việt Nam trước khi gửi', (tester) async {
    String? submittedName;
    String? submittedPhone;
    await tester.pumpWidget(
      screen(
        onComplete: (name, phone) async {
          submittedName = name;
          submittedPhone = phone;
          return true;
        },
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('profile-name-field')),
      '  Trần Nhật Trường  ',
    );
    await tester.enterText(
      find.byKey(const Key('profile-phone-field')),
      '912 345 678',
    );
    await tester.tap(find.byKey(const Key('profile-complete-button')));
    await tester.pump();

    expect(submittedName, 'Trần Nhật Trường');
    expect(submittedPhone, '+84912345678');
  });

  testWidgets('cho phép bỏ trống số điện thoại', (tester) async {
    String? submittedPhone = 'not-called';
    await tester.pumpWidget(
      screen(
        onComplete: (_, phone) async {
          submittedPhone = phone;
          return true;
        },
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('profile-name-field')),
      'Nguyễn Văn An',
    );
    await tester.tap(find.byKey(const Key('profile-complete-button')));
    await tester.pump();

    expect(submittedPhone, isNull);
  });

  for (final size in const [Size(320, 568), Size(412, 915), Size(480, 1000)]) {
    testWidgets('hồ sơ không tràn ở ${size.width} × ${size.height}', (
      tester,
    ) async {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
      view.physicalSize = size;
      view.devicePixelRatio = 1;

      await tester.pumpWidget(
        screen(
          padding: const EdgeInsets.only(top: 48, bottom: 24),
          textScaler: const TextScaler.linear(1.3),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('profile-complete-button')), findsOneWidget);
      expect(
        tester
            .getSize(find.byKey(const Key('profile-responsive-viewport')))
            .width,
        size.width,
      );
    });
  }

  testWidgets('có thể cuộn trường đang nhập lên trên bàn phím', (tester) async {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(360, 640);
    view.devicePixelRatio = 1;

    await tester.pumpWidget(
      screen(padding: const EdgeInsets.only(top: 48, bottom: 24)),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('profile-phone-field')));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getBottomRight(find.byKey(const Key('profile-phone-field'))).dy,
      lessThanOrEqualTo(340),
    );
  });
}
