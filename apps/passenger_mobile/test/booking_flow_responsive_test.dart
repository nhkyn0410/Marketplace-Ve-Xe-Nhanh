import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/booking_confirmation_screen.dart';
import 'package:passenger_mobile/features/ticket/booking_flow_chrome.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
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

const _draft = BookingDraft(
  contact: BookingContact(
    fullName: 'Lê Văn An',
    phone: '0901234567',
    email: 'an@vidu.com',
  ),
  passengers: [
    BookingPassenger(seatCode: 'A01', fullName: 'Lê Văn An'),
    BookingPassenger(seatCode: 'A03', fullName: 'Trần Thị Bình'),
  ],
);

void main() {
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
          build: () {
            final api = FakeBookingApi();
            return PassengerInformationScreen(
              api: api,
              trip: api.trip,
              hold: sampleHold(),
            );
          },
          header: const Key('passenger-information-header'),
          progress: const Key('passenger-information-progress'),
          scroll: const Key('passenger-information-scroll'),
          bottomAction: const Key('passenger-information-continue'),
        ),
        (
          build: () {
            final api = FakeBookingApi();
            return BookingConfirmationScreen(
              api: api,
              trip: api.trip,
              hold: sampleHold(),
              draft: _draft,
            );
          },
          header: const Key('booking-confirmation-header'),
          progress: const Key('booking-confirmation-progress'),
          scroll: const Key('booking-confirmation-scroll'),
          bottomAction: const Key('booking-continue-payment'),
        ),
        (
          build: () =>
              PaymentScreen(api: FakeBookingApi(), booking: sampleBooking()),
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
            expect(find.text('Thông tin'), findsWidgets);
            expect(find.text('Thông tin\nhành khách'), findsNothing);
            expect(find.textContaining('Giữ ghế trong'), findsNothing);
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
      PassengerInformationScreen(api: api, trip: api.trip, hold: sampleHold()),
      width: 360,
      textScale: 1.5,
    );
    expect(find.byKey(const Key('passenger-hold-countdown')), findsOneWidget);
    expect(find.byKey(const Key('passenger-hold-banner')), findsNothing);
    expect(find.text('Thông tin'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('đồng hồ có phụ đề vẫn gọn và giữ trạng thái, nhãn trợ năng', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    const timerKey = Key('compact-header-countdown');

    try {
      for (final state in [
        (time: '09:19', expired: false, urgent: false),
        (time: '00:45', expired: false, urgent: true),
        (time: '00:00', expired: true, urgent: false),
      ]) {
        await _pumpScreen(
          tester,
          Scaffold(
            body: BookingFlowHeader(
              title: 'Thanh toán',
              subtitle: 'TP. Hồ Chí Minh → Đà Nẵng',
              timerLabel: state.time,
              expired: state.expired,
              urgent: state.urgent,
              onBack: () {},
              backKey: const Key('compact-header-back'),
              timerKey: timerKey,
            ),
          ),
          width: 360,
          textScale: 1.5,
        );

        expect(find.textContaining('Giữ ghế trong'), findsNothing);
        expect(
          find.text(state.expired ? 'Đã hết hạn' : state.time),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel(
            state.expired
                ? 'Đã hết hạn giữ chỗ'
                : 'Thời gian giữ chỗ còn lại ${state.time}',
          ),
          findsOneWidget,
        );
        expect(tester.getSize(find.byKey(timerKey)).height, lessThan(36));
        expect(
          tester
              .widget<Icon>(find.byIcon(Icons.access_time_filled_rounded))
              .color,
          state.expired || state.urgent
              ? const Color(0xFFD84A4A)
              : const Color(0xFFF59B31),
        );
        expect(tester.takeException(), isNull);
      }
    } finally {
      semantics.dispose();
    }
  });
}
