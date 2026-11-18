import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Chuyến thật có sơ đồ ghế từ máy chủ: 2 tầng, có ghế chưa bán và một ô trống.
DemoTrip _liveTrip({bool withLayout = true}) {
  final trip = DemoTrip(
    id: 'TP. Hồ Chí Minh – Vũng Tàu',
    serverId: '11111111-1111-4111-8111-111111111111',
    origin: 'TP.HCM',
    destination: 'Vũng Tàu',
    departure: '14:30',
    operatingNote: '',
    passengers: [
      DemoPassenger('Phạm Văn Tuấn', 'A01', 'VXN1-01', '0*** *** 789')
        ..boarded = true,
      DemoPassenger('Phạm Thị Ngọc', 'B02', 'VXN1-02', '0*** *** 790'),
    ],
    seats: withLayout
        ? ['A01', 'A02', 'A03', 'B01', 'B02', 'B03']
        : ['A01', 'B02'],
  );
  if (withLayout) {
    trip.seatLayout.addAll([
      (code: 'A01', deck: 1, row: 1, column: 1),
      (code: 'A02', deck: 1, row: 1, column: 2),
      (code: 'A03', deck: 1, row: 2, column: 1),
      (code: 'B01', deck: 2, row: 1, column: 1),
      (code: 'B02', deck: 2, row: 1, column: 2),
      (code: 'B03', deck: 2, row: 2, column: 2),
    ]);
  }
  return trip;
}

Future<void> _pumpNarrow(WidgetTester tester, Widget home) async {
  tester.view.physicalSize = const Size(384, 854);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(theme: employeeTheme(Brightness.light), home: home),
  );
  await tester.pumpAndSettle();
}

Finder _seatLabel(String label) => find.byWidgetPredicate(
  (widget) => widget is Semantics && widget.properties.label == label,
);

Rect _rect(WidgetTester tester, String code) =>
    tester.getRect(find.byKey(ValueKey('seat-$code')));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });

  testWidgets(
    'Sơ đồ ghế chuyến thật vẽ đủ ghế theo tầng, ghế chưa bán là Trống',
    (tester) async {
      await _pumpNarrow(tester, SeatMapScreen(trip: _liveTrip()));
      expect(tester.takeException(), isNull);
      for (final code in ['A01', 'A02', 'A03', 'B01', 'B02', 'B03']) {
        expect(find.byKey(ValueKey('seat-$code')), findsOneWidget);
      }
      expect(find.text('6 ghế'), findsOneWidget);
      expect(find.text('Tầng dưới'), findsOneWidget);
      expect(find.text('Tầng trên'), findsOneWidget);
      expect(_seatLabel('Ghế A01, Đã lên'), findsOneWidget);
      expect(_seatLabel('Ghế B02, Chưa lên'), findsOneWidget);
      expect(_seatLabel('Ghế A02, Trống'), findsOneWidget);
      // Đúng hàng / cột của máy chủ: A03 ngay dưới A01; B03 dưới B02, ô hàng 2 cột 1 tầng trên để trống.
      expect(
        _rect(tester, 'A03').left,
        closeTo(_rect(tester, 'A01').left, 0.5),
      );
      expect(
        _rect(tester, 'A03').top,
        greaterThan(_rect(tester, 'A01').bottom),
      );
      expect(
        _rect(tester, 'B03').left,
        closeTo(_rect(tester, 'B02').left, 0.5),
      );
      expect(
        _rect(tester, 'B01').top,
        greaterThan(_rect(tester, 'A03').bottom),
      );
    },
  );

  testWidgets(
    'API cũ chưa trả sơ đồ: chỉ các ghế có vé, không có chú thích Trống',
    (tester) async {
      await _pumpNarrow(
        tester,
        SeatMapScreen(trip: _liveTrip(withLayout: false)),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('2 ghế có vé'), findsOneWidget);
      expect(find.text('Trống'), findsNothing);
      expect(find.text('Tầng dưới'), findsNothing);
    },
  );
}
