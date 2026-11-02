import 'dart:async';

import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/operation_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _swipe(WidgetTester tester, String label) async {
  final handle = find.byKey(ValueKey('swipe-$label'));
  await tester.ensureVisible(handle);
  await tester.drag(handle, const Offset(1000, 0));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });

  testWidgets(
    'live trip completes only after each API confirmation and can retry',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final requested = <String>[];
      final trip = DemoTrip(
        id: 'Chuyến thật',
        serverId: 'live-trip',
        origin: 'TP.HCM',
        destination: 'Đà Lạt',
        departure: '10:00',
        operatingNote: '',
        passengers: [],
      );
      var confirmation = Completer<void>();
      trip.updateOperation = (status) {
        requested.add(status);
        return confirmation.future;
      };
      await tester.pumpWidget(MaterialApp(home: OperationsScreen(trip: trip)));
      final handle = find.byKey(const ValueKey('swipe-Xác nhận Đón khách'));
      await tester.ensureVisible(handle);
      await tester.drag(handle, const Offset(1000, 0));
      await tester.pump(const Duration(milliseconds: 300));
      expect(requested, ['BOARDING']);
      expect(trip.status, 'Sắp khởi hành');
      confirmation.completeError(StateError('Mất kết nối'));
      await tester.pumpAndSettle();
      expect(trip.status, 'Sắp khởi hành');
      expect(trip.operationHistory, isEmpty);
      confirmation = Completer<void>();
      await tester.drag(
        find.byKey(const ValueKey('swipe-Thử cập nhật lại')),
        const Offset(1000, 0),
      );
      await tester.pump(const Duration(milliseconds: 300));
      confirmation.complete();
      await tester.pumpAndSettle();
      expect(trip.status, 'Đón khách');
      for (final step in [
        ('Xác nhận khởi hành', 'DEPARTED', 'Khởi hành'),
        ('Chuyển sang Đang chạy', 'IN_PROGRESS', 'Đang chạy'),
        ('Xác nhận hoàn thành', 'COMPLETED', 'Hoàn thành'),
      ]) {
        confirmation = Completer<void>();
        await tester.drag(
          find.byKey(ValueKey('swipe-${step.$1}')),
          const Offset(1000, 0),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(requested.last, step.$2);
        expect(trip.status, isNot(step.$3));
        confirmation.complete();
        await tester.pumpAndSettle();
        expect(trip.status, step.$3);
      }
      expect(trip.operationHistory, hasLength(4));
      expect(find.textContaining('chưa gửi máy chủ'), findsNothing);
    },
  );

  testWidgets(
    'Journal validates delay and keeps detail when Operations reopens',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final trip = createDemoTrips().first;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Inter'),
          home: OperationsScreen(trip: trip),
        ),
      );
      await _swipe(tester, 'Ghi nhật trình');
      await tester.ensureVisible(find.byType(TextFormField).first);
      await tester.enterText(find.byType(TextFormField).first, '-1');
      await _swipe(tester, 'Lưu nhật trình');
      expect(trip.journal, isEmpty);
      await tester.ensureVisible(find.byType(TextFormField).first);
      expect(find.text('Nhập phút ≥ 0'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).first, '5');
      await tester.ensureVisible(find.byType(TextFormField).last);
      await tester.enterText(
        find.byType(TextFormField).last,
        'Ghi chú kiểm thử',
      );
      await _swipe(tester, 'Lưu nhật trình');
      expect(trip.journal.single.delay, 5);
      expect(trip.journal.single.note, 'Ghi chú kiểm thử');
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Inter'),
          home: OperationsScreen(trip: trip),
        ),
      );
      await tester.tap(find.text('Điểm dừng'));
      await tester.pumpAndSettle();
      expect(find.text('Chi tiết nhật trình'), findsOneWidget);
      await tester.ensureVisible(find.text('Ghi chú kiểm thử'));
      expect(find.text('Ghi chú kiểm thử'), findsOneWidget);
    },
  );

  testWidgets(
    'Incident requires description and only reports a demo submission',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Inter'),
          home: IncidentScreen(trip: createDemoTrips().first),
        ),
      );
      await _swipe(tester, 'Gửi báo cáo');
      await tester.ensureVisible(find.byType(TextFormField));
      expect(find.text('Vui lòng nhập mô tả sự cố.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField),
        'Sự cố minh họa để kiểm tra biểu mẫu.',
      );
      await _swipe(tester, 'Gửi báo cáo');
      expect(
        find.textContaining('chỉ xem thử, chưa gửi máy chủ.'),
        findsOneWidget,
      );
    },
  );
}
