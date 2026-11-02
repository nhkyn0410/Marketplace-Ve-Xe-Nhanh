import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/payment_completion_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';
import 'package:passenger_mobile/system_navigation_bar.dart';

import 'support/fake_booking_api.dart';

class _BookingReturnHost extends StatefulWidget {
  const _BookingReturnHost({required this.isSignedIn});

  final bool isSignedIn;

  @override
  State<_BookingReturnHost> createState() => _BookingReturnHostState();
}

class _BookingReturnHostState extends State<_BookingReturnHost> {
  var _finished = false;
  final api = FakeBookingApi()..confirmAfterPayment = true;

  void _finishBooking() {
    setState(() => _finished = true);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: _finished
          ? Text(widget.isSignedIn ? 'Hành trình' : 'Trang chủ')
          : TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TripDetailScreen(
                    api: api,
                    tripId: api.trip.tripId,
                    isSignedIn: widget.isSignedIn,
                    onBookingFinished: _finishBooking,
                  ),
                ),
              ),
              child: const Text('Bắt đầu đặt vé'),
            ),
    ),
  );
}

Future<void> _pumpApp(
  WidgetTester tester,
  Widget home, {
  double width = 412,
  double height = 900,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  tester.view.padding = const FakeViewPadding(top: 24, bottom: 48);
  tester.view.viewPadding = const FakeViewPadding(top: 24, bottom: 48);
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

Future<void> _completeBookingFlow(WidgetTester tester) async {
  await tester.tap(find.text('Bắt đầu đặt vé'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('trip-detail-cta')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('seat-A01')));
  await tester.pump();
  await tester.tap(find.byKey(const Key('seat-selection-continue')));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('contact-name-field')),
    'Khách kiểm thử',
  );
  await tester.enterText(
    find.byKey(const Key('contact-email-field')),
    'test@example.com',
  );
  await tester.enterText(
    find.byKey(const Key('contact-phone-field')),
    '0901234567',
  );
  await tester.pump();
  await tester.tap(find.byKey(const Key('passenger-information-continue')));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.byKey(const Key('booking-terms-checkbox')),
    300,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('booking-confirmation-scroll')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.tap(find.byKey(const Key('booking-terms-checkbox')));
  await tester.pump();
  await tester.tap(find.byKey(const Key('booking-continue-payment')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('payment-submit')));
  await tester.pumpAndSettle();
}

void main() {
  for (final signedIn in [false, true]) {
    final label = signedIn ? 'Xem chuyến hành trình' : 'Khám phá thêm';
    final destination = signedIn ? 'Hành trình' : 'Trang chủ';

    testWidgets(
      '$label đi qua toàn bộ luồng đặt vé và đóng các màn thanh toán',
      (tester) async {
        await _pumpApp(tester, _BookingReturnHost(isSignedIn: signedIn));
        await _completeBookingFlow(tester);
        expect(find.text(label), findsOneWidget);
        expect(find.byKey(const Key('completion-back')), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const Key('payment-completion-return')));
        await tester.pumpAndSettle();

        expect(find.text(destination), findsOneWidget);
        expect(find.byKey(const Key('payment-screen')), findsNothing);
        expect(
          find.byKey(const Key('payment-completion-screen')),
          findsNothing,
        );
        expect(find.byKey(const Key('trip-detail-screen')), findsNothing);
        expect(
          Navigator.of(tester.element(find.text(destination))).canPop(),
          isFalse,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('Back hệ thống về $destination, không mở lại thanh toán', (
      tester,
    ) async {
      await _pumpApp(tester, _BookingReturnHost(isSignedIn: signedIn));
      await _completeBookingFlow(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text(destination), findsOneWidget);
      expect(find.byKey(const Key('payment-screen')), findsNothing);
      expect(find.byKey(const Key('payment-completion-screen')), findsNothing);
      expect(
        Navigator.of(tester.element(find.text(destination))).canPop(),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      '$label luôn hiện trên thanh điều hướng khi cuộn vé ở màn nhỏ',
      (tester) async {
        var returns = 0;
        await _pumpApp(
          tester,
          PaymentCompletionScreen(
            selectedSeats: const ['A01'],
            passengerNames: const ['Khách kiểm thử'],
            isSignedIn: signedIn,
            onBookingFinished: () => returns++,
          ),
          width: 320,
          height: 568,
        );
        final button = find.byKey(const Key('payment-completion-return'));
        final initialRect = tester.getRect(button);
        expect(find.text(label), findsOneWidget);
        expect(initialRect.bottom, lessThanOrEqualTo(520));
        await tester.drag(
          find.byKey(const Key('payment-completion-scroll')),
          const Offset(0, -900),
        );
        await tester.pumpAndSettle();
        expect(tester.getRect(button), initialRect);
        await tester.tap(button);
        await tester.pump();
        expect(returns, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
