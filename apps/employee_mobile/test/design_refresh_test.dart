import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/operation_screens.dart';
import 'package:employee_mobile/profile_screens.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:employee_mobile/trip_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:async';

Future<void> _open(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(412, 915),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: employeeTheme(Brightness.light),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => openDriverPage(context, screen),
            child: const Text('Mở màn'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Mở màn'));
  await tester.pumpAndSettle();
}

Future<void> _swipe(WidgetTester tester, String label) async {
  final handle = find.byKey(ValueKey('swipe-$label'));
  await tester.ensureVisible(handle);
  await tester.drag(handle, const Offset(1000, 0));
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });

  for (final (code, title) in [
    ('VX10200X', 'Không tìm thấy vé'),
    ('VX103001', 'Vé thuộc chuyến khác'),
    ('VX102CANCEL', 'Vé đã hủy'),
    ('VX102REFUND', 'Vé đã hoàn tiền'),
  ]) {
    testWidgets(
      'Ticket result $code blocks boarding without exposing passenger data',
      (tester) async {
        final trip = createDemoTrips().first;
        await _open(tester, ManualTicketScreen(trip: trip));
        await tester.enterText(find.byType(TextField), code);
        await _swipe(tester, 'Kiểm tra vé');
        expect(find.text(title), findsOneWidget);
        expect(find.text('Nguyễn Văn An'), findsNothing);
        expect(
          find.byKey(const ValueKey('swipe-Xác nhận lên xe')),
          findsNothing,
        );
        expect(trip.boardedCount, 0);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Absent state is only selectable after boarding starts and keeps the note',
    (tester) async {
      final trip = createDemoTrips().first;
      final passenger = trip.passengers.first;
      await _open(
        tester,
        PassengerStatusScreen(trip: trip, passenger: passenger),
      );
      await tester.tap(find.text('Vắng mặt'));
      await _swipe(tester, 'Lưu trạng thái');
      expect(passenger.absent, false);
      trip.status = 'Đón khách';
      await tester.tap(find.text('Mở màn'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vắng mặt'));
      await tester.enterText(
        find.byType(TextField),
        'Chưa có mặt tại điểm đón.',
      );
      await _swipe(tester, 'Lưu trạng thái');
      expect(passenger.absent, true);
      expect(passenger.boarded, false);
      expect(passenger.note, 'Chưa có mặt tại điểm đón.');
    },
  );

  testWidgets(
    'Operation failure keeps current status and retry creates one persistent event',
    (tester) async {
      final trip = createDemoTrips().first
        ..status = 'Khởi hành'
        ..demoOperationFailure = true;
      await _open(tester, OperationsScreen(trip: trip));
      await _swipe(tester, 'Chuyển sang Đang chạy');
      expect(trip.status, 'Khởi hành');
      expect(trip.operationHistory, isEmpty);
      expect(find.text('Chưa cập nhật trạng thái.'), findsOneWidget);
      await _swipe(tester, 'Thử cập nhật lại');
      expect(trip.status, 'Đang chạy');
      expect(trip.operationHistory.length, 1);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mở màn'));
      await tester.pumpAndSettle();
      expect(find.text('1 mốc'), findsOneWidget);
      await _swipe(tester, 'Xác nhận hoàn thành');
      expect(trip.status, 'Hoàn thành');
      expect(find.text('Chuyến đã kết thúc'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('swipe-Xác nhận hoàn thành')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Vehicle check failure preserves input and retry saves once without delay',
    (tester) async {
      final trip = createDemoTrips().first..demoJournalFailure = true;
      await _open(
        tester,
        JournalScreen(trip: trip, initialCategory: 'Kiểm tra xe'),
      );
      expect(find.text('Độ trễ'), findsNothing);
      await tester.enterText(
        find.byType(TextFormField),
        'Phanh và đèn hoạt động bình thường.',
      );
      await _swipe(tester, 'Lưu nhật trình');
      expect(find.text('Chưa lưu được nhật trình'), findsOneWidget);
      expect(trip.journal, isEmpty);
      expect(find.text('Phanh và đèn hoạt động bình thường.'), findsOneWidget);
      await _swipe(tester, 'Lưu lại');
      expect(trip.journal.length, 1);
      expect(trip.journal.first.title, 'Kiểm tra xe');
      expect(trip.journal.first.delay, 0);
      expect(trip.journal.first.location, trip.pickup);
    },
  );

  testWidgets(
    'Device confirmation can cancel and only removes the selected local session',
    (tester) async {
      final sessions = DemoDeviceSessions();
      await _open(tester, DevicesScreen(sessions: sessions));
      await _swipe(tester, 'Thu hồi phiên này');
      expect(find.text('Thu hồi phiên này?'), findsOneWidget);
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();
      expect(sessions.hasOther, true);
      await _swipe(tester, 'Thu hồi phiên này');
      await _swipe(tester, 'Thu hồi phiên');
      expect(sessions.hasOther, false);
      expect(find.text('1 phiên đang hoạt động'), findsOneWidget);
      expect(find.text('Chỉ còn thiết bị này'), findsOneWidget);
      expect(find.text('Samsung Galaxy A54'), findsNothing);
    },
  );

  testWidgets('Unassigned trip blocks passenger and operation information', (
    tester,
  ) async {
    final trip = createDemoTrips().first..assigned = false;
    await _open(
      tester,
      TripDetailScreen(trip: trip, onTabSelected: (_) {}),
      size: const Size(320, 640),
    );
    expect(find.text('Chưa được phân công'), findsOneWidget);
    expect(find.text('32 hành khách'), findsNothing);
    expect(find.byKey(const ValueKey('swipe-Bắt đầu đón khách')), findsNothing);
  });

  testWidgets(
    'Journal detail retries once while pending and recovers the stored record',
    (tester) async {
      final trip = createDemoTrips().first;
      final load = Completer<void>();
      var attempts = 0;
      await _open(
        tester,
        JournalDetailScreen(
          trip: trip,
          initiallyFailed: true,
          onRetry: () {
            attempts++;
            return load.future;
          },
        ),
      );
      expect(find.text('Chưa tải được nhật trình'), findsOneWidget);
      await tester.drag(
        find.byKey(const ValueKey('swipe-Thử lại')),
        const Offset(1000, 0),
      );
      await tester.pump();
      expect(find.text('Đang tải nhật trình…'), findsOneWidget);
      await tester.drag(
        find.byKey(const ValueKey('swipe-Đang tải…')),
        const Offset(1000, 0),
      );
      expect(attempts, 1);
      trip.journal.add((
        title: 'Kiểm tra xe',
        time: '09:55',
        note: 'Đèn hoạt động bình thường.',
        occurredAt: DateTime(2026, 10, 14, 9, 55),
        location: trip.pickup,
        vehicle: 'Bình thường',
        delay: 0,
      ));
      load.complete();
      await tester.pumpAndSettle();
      expect(find.text('Đèn hoạt động bình thường.'), findsOneWidget);
      expect(find.text('Chưa tải được nhật trình'), findsNothing);
      expect(find.text('Độ trễ'), findsNothing);
    },
  );

  testWidgets(
    'Journal detail retry failure stays recoverable without inventing records',
    (tester) async {
      final trip = createDemoTrips().first;
      var attempts = 0;
      await _open(
        tester,
        JournalDetailScreen(
          trip: trip,
          onRetry: () async {
            attempts++;
            throw StateError('demo fetch failed');
          },
        ),
        size: const Size(320, 640),
      );
      await _swipe(tester, 'Thử lại');
      expect(attempts, 1);
      expect(trip.journal, isEmpty);
      expect(find.text('Chưa tải được nhật trình'), findsOneWidget);
      expect(find.byKey(const ValueKey('swipe-Thử lại')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
