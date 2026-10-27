import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/booking_confirmation_screen.dart';
import 'package:passenger_mobile/features/ticket/passenger_information_screen.dart';
import 'package:passenger_mobile/features/ticket/payment_screen.dart';
import 'package:passenger_mobile/features/ticket/seat_selection_screen.dart';

import 'support/fake_booking_api.dart';

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required double width,
  required double textScale,
  double height = 800,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E8ABE)),
      ),
      home: screen,
    ),
  );
  await tester.pump();
}

void main() {
  final now = DateTime(2026, 10, 26, 10);

  final screens =
      <
        ({
          Widget Function() build,
          Key header,
          Key progress,
          Key scroll,
          Key bottomAction,
        })
      >[
        (
          build: () {
            final api = FakeBookingApi();
            return SeatSelectionScreen(
              api: api,
              trip: api.trip,
              pickupSequence: 1,
              dropoffSequence: 5,
            );
          },
          header: const Key('seat-selection-header'),
          progress: const Key('seat-selection-progress'),
          scroll: const Key('seat-selection-scroll'),
          bottomAction: const Key('seat-selection-continue'),
        ),
        (
          build: () => PassengerInformationScreen(
            selectedSeats: const ['A01', 'A02'],
            holdExpiresAt: now.add(const Duration(minutes: 10)),
            now: () => now,
          ),
          header: const Key('passenger-information-header'),
          progress: const Key('passenger-information-progress'),
          scroll: const Key('passenger-information-scroll'),
          bottomAction: const Key('passenger-information-continue'),
        ),
        (
          build: () => BookingConfirmationScreen(
            selectedSeats: const ['A01', 'A02'],
            passengerNames: const ['Nguyễn Văn Minh', 'Trần Thị Lan'],
            holdExpiresAt: now.add(const Duration(minutes: 10)),
            now: () => now,
          ),
          header: const Key('booking-confirmation-header'),
          progress: const Key('booking-confirmation-progress'),
          scroll: const Key('booking-confirmation-scroll'),
          bottomAction: const Key('booking-continue-payment'),
        ),
        (
          build: () => PaymentScreen(
            selectedSeats: const ['A01', 'A02'],
            passengerNames: const ['Nguyễn Văn Minh', 'Trần Thị Lan'],
            holdExpiresAt: now.add(const Duration(minutes: 10)),
            now: () => now,
          ),
          header: const Key('payment-header'),
          progress: const Key('payment-progress'),
          scroll: const Key('payment-scroll'),
          bottomAction: const Key('payment-submit'),
        ),
      ];

  for (final width in [360.0, 430.0]) {
    for (final textScale in [1.0, 1.3, 1.5]) {
      testWidgets(
        'workflow không overflow tại ${width.toInt()}dp, text scale $textScale',
        (tester) async {
          for (final screen in screens) {
            final widget = screen.build();
            await _pumpScreen(
              tester,
              widget,
              width: width,
              textScale: textScale,
            );
            expect(
              tester.takeException(),
              isNull,
              reason: widget.runtimeType.toString(),
            );

            final headerTop = tester.getTopLeft(find.byKey(screen.header)).dy;
            final progressTop = tester
                .getTopLeft(find.byKey(screen.progress))
                .dy;

            for (var drag = 0; drag < 6; drag++) {
              await tester.drag(
                find.byKey(screen.scroll),
                const Offset(0, -420),
              );
              await tester.pump();
              expect(
                tester.takeException(),
                isNull,
                reason: '${widget.runtimeType} overflow after drag $drag',
              );
            }

            expect(
              tester.getTopLeft(find.byKey(screen.header)).dy,
              closeTo(headerTop, 0.1),
            );
            expect(
              tester.getTopLeft(find.byKey(screen.progress)).dy,
              closeTo(progressTop, 0.1),
            );
            expect(find.byKey(screen.bottomAction), findsOneWidget);
          }
        },
      );
    }
  }

  testWidgets('badge timer thống nhất và không còn banner cam trong nội dung', (
    tester,
  ) async {
    final api = FakeBookingApi();
    await _pumpScreen(
      tester,
      SeatSelectionScreen(
        api: api,
        trip: api.trip,
        pickupSequence: 1,
        dropoffSequence: 5,
      ),
      width: 360,
      textScale: 1.5,
    );
    // Bước 1 chưa giữ chỗ nên chưa có đồng hồ.
    expect(find.byKey(const Key('seat-hold-countdown')), findsNothing);
    expect(find.byKey(const Key('seat-hold-banner')), findsNothing);

    await _pumpScreen(
      tester,
      PassengerInformationScreen(
        selectedSeats: const ['A01'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
      width: 360,
      textScale: 1.5,
    );
    expect(find.byKey(const Key('passenger-hold-countdown')), findsOneWidget);
    expect(find.byKey(const Key('passenger-hold-banner')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom sheet ngân hàng không overflow khi mở bàn phím', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      PaymentScreen(
        selectedSeats: const ['A01'],
        passengerNames: const ['Nguyễn Văn Minh'],
        holdExpiresAt: now.add(const Duration(minutes: 10)),
        now: () => now,
      ),
      width: 360,
      textScale: 1.5,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('payment-bank-selector')),
      250,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('payment-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find.byKey(const Key('payment-scroll')),
      const Offset(0, -240),
    );
    await tester.pump();
    final bankSelector = tester.widget<InkWell>(
      find.descendant(
        of: find.byKey(const Key('payment-bank-selector')),
        matching: find.byType(InkWell),
      ),
    );
    bankSelector.onTap!();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bank-picker-sheet')), findsOneWidget);
    expect(find.byKey(const Key('bank-grid')), findsOneWidget);

    await tester.tap(find.byKey(const Key('bank-search')));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.enterText(find.byKey(const Key('bank-search')), 'ngân hàng');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bank-confirm')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final sheetTitle = find.text('Chọn ngân hàng').last;
    final titleTop = tester.getTopLeft(sheetTitle).dy;
    final confirmTop = tester
        .getTopLeft(find.byKey(const Key('bank-confirm')))
        .dy;
    await tester.drag(
      find.byKey(const Key('bank-grid')),
      const Offset(0, -400),
    );
    await tester.pump();
    expect(tester.getTopLeft(sheetTitle).dy, closeTo(titleTop, 0.1));
    expect(
      tester.getTopLeft(find.byKey(const Key('bank-confirm'))).dy,
      closeTo(confirmTop, 0.1),
    );
    expect(tester.takeException(), isNull);
  });
}
