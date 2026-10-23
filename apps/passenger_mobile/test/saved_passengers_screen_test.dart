import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/saved_passengers_screen.dart';

Future<void> _pumpScreen(
  WidgetTester tester, {
  required SavedPassengerLoader loader,
  SavedPassengerCreator? creator,
  SavedPassengerUpdater? updater,
  SavedPassengerDeleter? deleter,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: SavedPassengersScreen(
        loadPassengers: loader,
        createPassenger: creator ?? (_) async => true,
        updatePassenger: updater ?? (_, _) async => true,
        deletePassenger: deleter ?? (_) async => true,
        onBack: () {},
      ),
    ),
  );
}

void main() {
  testWidgets('hiển thị trạng thái rỗng 0/5 và mở floating thêm', (
    tester,
  ) async {
    await _pumpScreen(tester, loader: () async => []);

    expect(find.byKey(const Key('saved-passengers-loading')), findsOneWidget);
    await tester.pumpAndSettle();

    expect(
      (await rootBundle.load('assets/account/saved_passengers/back.svg'))
          .lengthInBytes,
      greaterThan(0),
    );
    expect(
      (await rootBundle.load('assets/account/saved_passengers/plus.svg'))
          .lengthInBytes,
      greaterThan(0),
    );
    expect(find.text('0/5 hành khách'), findsOneWidget);
    expect(find.byKey(const Key('saved-passengers-empty')), findsOneWidget);
    expect(find.byKey(const Key('saved-passengers-add')), findsOneWidget);

    await tester.tap(find.byKey(const Key('saved-passengers-add')));
    await tester.pumpAndSettle();
    expect(find.text('Thêm hành khách'), findsOneWidget);
    expect(find.text('Lưu hành khách'), findsOneWidget);

    final nameField = find.byKey(const Key('saved-passenger-name'));
    await tester.tap(nameField);
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);
    tester.testTextInput.enterText('Nguyễn Văn An');
    await tester.pump();
    expect(find.text('Nguyễn Văn An'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('thêm hành khách bằng đúng fullName và phone của API', (
    tester,
  ) async {
    var items = <SavedPassengerData>[];
    SavedPassengerFormInput? submitted;
    await _pumpScreen(
      tester,
      loader: () async => List.of(items),
      creator: (input) async {
        submitted = input;
        items = [
          SavedPassengerData(
            passengerId: 'passenger-1',
            fullName: input.fullName,
            phone: input.phone,
          ),
        ];
        return true;
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('saved-passengers-add')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('saved-passenger-name')),
      'Nguyễn Văn An',
    );
    await tester.enterText(
      find.byKey(const Key('saved-passenger-phone')),
      '0912345678',
    );
    await tester.tap(find.byKey(const Key('saved-passenger-submit')));
    await tester.pumpAndSettle();

    expect(submitted?.fullName, 'Nguyễn Văn An');
    expect(submitted?.phone, '0912345678');
    expect(find.text('1/5 hành khách'), findsOneWidget);
    expect(find.text('Nguyễn Văn An'), findsOneWidget);
  });

  testWidgets('mở được floating chỉnh sửa và xác nhận xóa', (tester) async {
    var items = const [
      SavedPassengerData(
        passengerId: 'passenger-1',
        fullName: 'Nguyễn Văn An',
        phone: '0912345678',
      ),
    ];
    await _pumpScreen(
      tester,
      loader: () async => List.of(items),
      updater: (id, input) async {
        items = [
          SavedPassengerData(
            passengerId: id,
            fullName: input.fullName,
            phone: input.phone,
          ),
        ];
        return true;
      },
      deleter: (_) async {
        items = const [];
        return true;
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('saved-passenger-edit-passenger-1')));
    await tester.pumpAndSettle();
    expect(find.text('Chỉnh sửa thông tin'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('saved-passenger-name')),
      'Nguyễn Văn Bình',
    );
    await tester.tap(find.byKey(const Key('saved-passenger-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Nguyễn Văn Bình'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('saved-passenger-delete-passenger-1')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xóa hành khách'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saved-passenger-confirm-delete')));
    await tester.pumpAndSettle();

    expect(find.text('0/5 hành khách'), findsOneWidget);
    expect(find.byKey(const Key('saved-passengers-empty')), findsOneWidget);
  });
}
