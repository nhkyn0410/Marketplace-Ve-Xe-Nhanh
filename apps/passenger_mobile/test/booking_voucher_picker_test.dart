import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/booking_models.dart';
import 'package:passenger_mobile/features/ticket/booking_voucher_picker.dart';

import 'support/fake_booking_api.dart';

BookingVoucher _voucher(String id, {required String minOrder}) =>
    BookingVoucher(
      id: id,
      name: 'Voucher $id',
      status: 'AVAILABLE',
      discountType: 'AMOUNT',
      discountValue: '20000',
      minOrder: minOrder,
      expiresAt: DateTime.now().add(const Duration(days: 3)),
    );

void main() {
  // PASSENGER-PARITY A20 (S59): voucher chưa đủ điều kiện khóa và ghi lý do ngay.
  testWidgets(
    'đơn 290.000đ, voucher tối thiểu 300.000đ: khóa, ghi lý do, không hỏi máy chủ',
    (tester) async {
      final api = FakeBookingApi()
        ..walletVouchers = [
          _voucher('min300', minOrder: '300000'),
          _voucher('free', minOrder: '0'),
        ];
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => FractionallySizedBox(
                  heightFactor: .8,
                  child: BookingVoucherPicker(
                    api: api,
                    tripId: 'trip-1',
                    subtotal: 290000,
                    holdExpiresAt: DateTime.now().add(
                      const Duration(minutes: 5),
                    ),
                  ),
                ),
              ),
              child: const Text('Mở ví'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Mở ví'));
      await tester.pumpAndSettle();

      expect(
        find.text('Chưa đủ điều kiện: đơn tối thiểu 300.000đ'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('booking-voucher-reason-free')),
        findsNothing,
      );
      await tester.tap(find.byKey(const Key('booking-voucher-min300')));
      await tester.pump();
      expect(api.voucherChecks, isEmpty);

      await tester.tap(find.byKey(const Key('booking-voucher-free')));
      await tester.pumpAndSettle();
      expect(api.voucherChecks.single.userVoucherId, 'free');
      expect(tester.takeException(), isNull);
    },
  );
}
