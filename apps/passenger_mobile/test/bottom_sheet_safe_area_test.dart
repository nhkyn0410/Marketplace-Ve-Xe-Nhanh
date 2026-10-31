import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/point_history_screen.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/stop_picker_sheet.dart';
import 'package:passenger_mobile/system_navigation_bar.dart';

import 'support/fake_booking_api.dart';
import 'support/trip_search_fakes.dart';

class _SearchSheetHost extends StatefulWidget {
  const _SearchSheetHost();

  @override
  State<_SearchSheetHost> createState() => _SearchSheetHostState();
}

class _SearchSheetHostState extends State<_SearchSheetHost>
    with TripSearchFormState<_SearchSheetHost> {
  @override
  TripSearchCatalog get searchCatalog => fakeCatalog();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        TextButton(
          onPressed: pickSearchPassengers,
          child: Text('Khách: $searchPassengers'),
        ),
        TextButton(
          onPressed: () => pickSearchLocation(isOrigin: true),
          child: const Text('Điểm đi'),
        ),
        TextButton(onPressed: pickSearchOperator, child: const Text('Nhà xe')),
      ],
    ),
  );
}

Future<void> _pumpApp(
  WidgetTester tester,
  Widget home, {
  double width = 412,
  double height = 900,
  double bottomInset = 48,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  tester.view.padding = FakeViewPadding(top: 24, bottom: bottomInset);
  tester.view.viewPadding = FakeViewPadding(top: 24, bottom: bottomInset);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetViewPadding);
  await tester.pumpWidget(
    MaterialApp(
      builder: (_, child) => PassengerSystemNavigation(child: child!),
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final bottomInset in [0.0, 24.0, 48.0]) {
    testWidgets('xác nhận số khách nằm trên vùng điều hướng $bottomInset', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        const _SearchSheetHost(),
        bottomInset: bottomInset,
      );
      await tester.tap(find.text('Khách: 1'));
      await tester.pumpAndSettle();
      final confirm = find.widgetWithText(FilledButton, 'Xác nhận');
      expect(
        tester.getBottomRight(confirm).dy,
        lessThanOrEqualTo(900 - bottomInset),
      );
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(find.text('Khách: 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('điểm đi, nhà xe và tuyến cuối danh sách vẫn chọn được', (
    tester,
  ) async {
    await _pumpApp(tester, const _SearchSheetHost());
    await tester.tap(find.text('Điểm đi'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(lamDong.name));
    expect(
      tester.getBottomRight(find.text(lamDong.name)).dy,
      lessThanOrEqualTo(852),
    );
    await tester.tap(find.text(lamDong.name));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nhà xe'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('operator-option-op-pt')));
    await tester.pumpAndSettle();
    final lastRoute = find.byKey(const ValueKey('operator-route-option-1'));
    await tester.ensureVisible(lastRoute);
    expect(tester.getBottomRight(lastRoute).dy, lessThanOrEqualTo(852));
    await tester.tap(lastRoute);
    await tester.pumpAndSettle();
    expect(find.text('Chọn tuyến · Phương Trang'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('xác nhận điểm đón không bị điều hướng hệ thống che', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showTripStopPicker(
              context,
              pickup: true,
              stops: sampleTripDetail().stops
                  .where((stop) => stop.allowPickup)
                  .toList(),
              selectedSequence: 1,
            ),
            child: const Text('Điểm đón'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Điểm đón'));
    await tester.pumpAndSettle();
    final confirm = find.byKey(const Key('confirm-stop'));
    expect(tester.getBottomRight(confirm).dy, lessThanOrEqualTo(852));
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pickup-sheet')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'lọc thời gian trên màn thấp cuộn được và không che nút áp dụng',
    (tester) async {
      await _pumpApp(
        tester,
        PointHistoryScreen(
          loadHistory: (query) async => figmaPointHistorySample(query),
          onBack: () {},
        ),
        width: 320,
        height: 568,
      );
      await tester.tap(find.byKey(const Key('point-date-filter')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final confirm = find.byKey(const Key('point-date-filter-apply'));
      expect(tester.getBottomRight(confirm).dy, lessThanOrEqualTo(520));
      final lastOption = find.byKey(const Key('point-date-custom'));
      await tester.ensureVisible(lastOption);
      await tester.tap(lastOption);
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('point-date-filter-sheet')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
