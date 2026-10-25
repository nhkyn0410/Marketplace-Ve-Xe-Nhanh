import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/edit_profile_screen.dart';
import 'package:passenger_mobile/features/account/passenger_avatar.dart';

const _profile = PassengerProfileFormData(
  name: 'Nguyễn Văn Khanh',
  email: 'nguyenvankhanh@gmail.com',
  emailVerified: true,
  phone: '0901234567',
  dateOfBirth: null,
  imageUrl: null,
);

Future<void> _pumpEditProfile(
  WidgetTester tester, {
  required PassengerProfileLoader loader,
  PassengerProfileSaver? saver,
  VoidCallback? onSaved,
  String? errorMessage,
  double width = 390,
  double height = 844,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: EditProfileScreen(
        loadProfile: loader,
        saveProfile: saver ?? (_) async => true,
        onBack: () {},
        onSaved: onSaved ?? () {},
        errorMessage: errorMessage,
      ),
    ),
  );
}

Finder _textField(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(TextFormField),
);

void main() {
  testWidgets('tải hồ sơ thật và dùng avatar mặc định khi chưa có ảnh', (
    tester,
  ) async {
    await _pumpEditProfile(tester, loader: () async => _profile);

    expect(find.byKey(const Key('edit-profile-loading')), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Chỉnh sửa thông tin'), findsOneWidget);
    expect(find.text('Nguyễn Văn Khanh'), findsOneWidget);
    expect(find.text('nguyenvankhanh@gmail.com'), findsOneWidget);
    final avatar = tester.widget<Image>(
      find.byKey(const Key('passenger-default-avatar')),
    );
    expect((avatar.image as AssetImage).assetName, passengerDefaultAvatarAsset);
    final avatarRect = tester.getRect(find.byType(PassengerAvatar));
    final formRect = tester.getRect(
      find.byKey(const Key('edit-profile-form-card')),
    );
    expect(formRect.top - avatarRect.bottom, 12);
    expect(find.text('Giới tính'), findsNothing);
    expect(find.text('Địa chỉ liên hệ'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lưu đúng các field mà Passenger profile API hỗ trợ', (
    tester,
  ) async {
    PassengerProfileFormUpdate? submitted;
    var saved = false;
    await _pumpEditProfile(
      tester,
      loader: () async => _profile,
      saver: (update) async {
        submitted = update;
        return true;
      },
      onSaved: () => saved = true,
    );
    await tester.pumpAndSettle();

    await tester.enterText(_textField('edit-profile-name'), 'Nguyễn Văn An');
    await tester.enterText(_textField('edit-profile-phone'), '0912345678');
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('edit-profile-save')));
    await tester.tap(find.byKey(const Key('edit-profile-save')));
    await tester.pumpAndSettle();

    expect(submitted?.name, 'Nguyễn Văn An');
    expect(submitted?.phone, '0912345678');
    expect(saved, isTrue);
  });

  testWidgets('không gửi số điện thoại sai định dạng', (tester) async {
    var calls = 0;
    await _pumpEditProfile(
      tester,
      loader: () async => _profile,
      saver: (_) async {
        calls++;
        return true;
      },
    );
    await tester.pumpAndSettle();

    await tester.enterText(_textField('edit-profile-phone'), '123');
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('edit-profile-save')));
    await tester.tap(find.byKey(const Key('edit-profile-save')));
    await tester.pump();

    expect(calls, 0);
    expect(
      find.text('Số điện thoại phải bắt đầu bằng 0 hoặc +84.'),
      findsOneWidget,
    );
  });

  testWidgets('lỗi tải hồ sơ có thể thử lại', (tester) async {
    var attempts = 0;
    await _pumpEditProfile(
      tester,
      loader: () async {
        attempts++;
        if (attempts == 1) throw StateError('offline');
        return _profile;
      },
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa thể tải thông tin cá nhân'), findsOneWidget);
    await tester.tap(find.byKey(const Key('edit-profile-retry')));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Thông tin cá nhân'), findsOneWidget);
  });
}
