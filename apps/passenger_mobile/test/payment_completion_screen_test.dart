import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/payment_completion_screen.dart';

const _seats = ['A01', 'A04', 'A12'];
const _passengerNames = ['Nguyễn Văn Minh', 'Trần Thị Lan', 'Lê Hoàng Nam'];

Future<void> _pumpScreen(
  WidgetTester tester, {
  double width = 412,
  double height = 900,
  bool disableAnimations = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E8ABE)),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: disableAnimations),
          child: child!,
        );
      },
      home: PaymentCompletionScreen(
        selectedSeats: _seats,
        passengerNames: _passengerNames,
      ),
    ),
  );
  await tester.pump();
}

double _revealProgress(WidgetTester tester) {
  final reveal = tester.widget<Align>(
    find.byKey(const Key('printed-ticket-reveal')),
  );
  return reveal.heightFactor!;
}

String _textAt(WidgetTester tester, String key) {
  return tester.widget<Text>(find.byKey(Key(key))).data!;
}

void main() {
  testWidgets('hiển thị đủ dữ liệu vé mô phỏng của hành khách đầu tiên', (
    tester,
  ) async {
    await _pumpScreen(tester);

    expect(find.byKey(const Key('payment-completion-screen')), findsOneWidget);
    expect(find.text('Vé của bạn'), findsOneWidget);
    expect(find.text('TP.HCM → Đà Lạt'), findsWidgets);
    expect(find.text('3 vé trong đơn đặt chỗ'), findsOneWidget);
    expect(find.text('Tất cả vé (3)'), findsOneWidget);
    expect(find.text('Vé 1/3'), findsOneWidget);
    expect(find.text('Chỗ A01'), findsOneWidget);
    expect(_textAt(tester, 'selected-passenger-name'), 'Nguyễn Văn Minh');
    expect(_textAt(tester, 'ticket-passenger-name'), 'Nguyễn Văn Minh');
    expect(_textAt(tester, 'ticket-seat'), 'A01');
    expect(_textAt(tester, 'ticket-code'), 'Mã vé: VXN7268103865');
    expect(find.byKey(const Key('ticket-printer')), findsOneWidget);
    expect(find.byKey(const Key('printed-ticket')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bill được máy in mở dần từ 0 đến trạng thái hoàn chỉnh', (
    tester,
  ) async {
    await _pumpScreen(tester);

    expect(_revealProgress(tester), 0);

    await tester.pump(const Duration(milliseconds: 260));
    expect(_revealProgress(tester), inExclusiveRange(0, 1));

    await tester.pump(const Duration(milliseconds: 600));
    expect(_revealProgress(tester), closeTo(1, 0.0001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('vé sau đổi đúng hành khách, ghế, mã và khởi động lại máy in', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await tester.pump(const Duration(milliseconds: 800));
    expect(_revealProgress(tester), closeTo(1, 0.0001));

    await tester.tap(find.byKey(const Key('ticket-next')));
    await tester.pump();

    expect(_textAt(tester, 'selected-passenger-name'), 'Trần Thị Lan');
    expect(_textAt(tester, 'ticket-passenger-name'), 'Trần Thị Lan');
    expect(_textAt(tester, 'ticket-seat'), 'A04');
    expect(_textAt(tester, 'ticket-code'), 'Mã vé: VXN7268103866');
    expect(find.text('Vé 2/3'), findsOneWidget);
    expect(_revealProgress(tester), 0);

    await tester.pump(const Duration(milliseconds: 240));
    expect(_revealProgress(tester), inExclusiveRange(0, 1));
    await tester.pump(const Duration(milliseconds: 600));
    expect(_revealProgress(tester), closeTo(1, 0.0001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet tất cả vé tìm và chọn đúng hành khách', (tester) async {
    await _pumpScreen(tester);

    await tester.tap(find.byKey(const Key('all-tickets')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('passenger-ticket-sheet')), findsOneWidget);
    expect(find.text('Chọn vé hành khách'), findsOneWidget);
    expect(find.text('3 vé trong đơn đặt chỗ'), findsWidgets);

    await tester.enterText(find.byKey(const Key('ticket-search')), 'Lê Hoàng');
    await tester.pump();
    expect(find.byKey(const Key('ticket-option-0')), findsNothing);
    expect(find.byKey(const Key('ticket-option-1')), findsNothing);
    expect(find.byKey(const Key('ticket-option-2')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ticket-option-2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('passenger-ticket-sheet')), findsNothing);
    expect(_textAt(tester, 'selected-passenger-name'), 'Lê Hoàng Nam');
    expect(_textAt(tester, 'ticket-passenger-name'), 'Lê Hoàng Nam');
    expect(_textAt(tester, 'ticket-seat'), 'A12');
    expect(_textAt(tester, 'ticket-code'), 'Mã vé: VXN7268103867');
    expect(find.text('Vé 3/3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('viewport 320x568 cuộn hết nội dung mà không bottom overflow', (
    tester,
  ) async {
    await _pumpScreen(tester, width: 320, height: 568);
    await tester.pump(const Duration(milliseconds: 800));
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.byKey(const Key('download-ticket')),
      420,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(find.byKey(const Key('download-ticket')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion hiển thị bill hoàn chỉnh ngay lập tức', (
    tester,
  ) async {
    await _pumpScreen(tester, disableAnimations: true);

    expect(_revealProgress(tester), 1);
    expect(_textAt(tester, 'ticket-passenger-name'), 'Nguyễn Văn Minh');
    expect(_textAt(tester, 'ticket-seat'), 'A01');
    expect(tester.takeException(), isNull);
  });
}
