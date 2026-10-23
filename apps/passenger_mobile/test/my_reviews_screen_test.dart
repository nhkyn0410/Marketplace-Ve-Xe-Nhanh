import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/my_reviews_screen.dart';

const _empty = MyReviewsData(pending: [], reviewed: []);

Future<void> _pumpReviews(
  WidgetTester tester, {
  required MyReviewsLoader loader,
  ReviewSubmitter? submitter,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 860);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: MyReviewsScreen(
        loadReviews: loader,
        submitReview: submitter ?? (_, _) async => true,
        onBack: () {},
      ),
    ),
  );
}

void main() {
  testWidgets(
    'hiển thị trạng thái rỗng cho cả hai tab khi API chưa có dữ liệu',
    (tester) async {
      await _pumpReviews(tester, loader: () async => _empty);
      await tester.pumpAndSettle();

      expect(find.text('Chưa có chuyến chờ đánh giá'), findsOneWidget);
      expect(find.text('Chờ đánh giá (0)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('completed-review-tab')));
      await tester.pump();

      expect(find.text('Chưa có đánh giá'), findsOneWidget);
      expect(find.text('Đã đánh giá (0)'), findsOneWidget);
    },
  );

  testWidgets('dùng card mẫu và gửi đánh giá từ bottom sheet', (tester) async {
    final pending = ReviewTripItem(
      bookingId: 'booking-pending',
      routeName: 'TP. Hồ Chí Minh → Đà Lạt',
      operatorName: 'Phương Nam Travel',
      departureAt: DateTime(2026, 10, 16),
      vehicleType: 'Limousine 34 giường',
      imageAsset: reviewSampleTripAssets.first,
    );
    final reviewed = ReviewTripItem(
      bookingId: 'booking-reviewed',
      routeName: 'Hà Nội → Thanh Hóa',
      operatorName: 'Hoàng Long',
      departureAt: DateTime(2026, 10, 10),
      imageAsset: reviewSampleTripAssets[1],
      rating: 5,
      comment: 'Chuyến đi rất tốt, xe chạy êm và đúng giờ.',
      reviewedAt: DateTime(2026, 10, 11),
    );
    final data = MyReviewsData(pending: [pending], reviewed: [reviewed]);
    ReviewSubmission? submitted;
    String? submittedBookingId;

    await _pumpReviews(
      tester,
      loader: () async => data,
      submitter: (bookingId, input) async {
        submittedBookingId = bookingId;
        submitted = input;
        return true;
      },
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('pending-review-booking-pending')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('write-review-booking-pending')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('review-form-sheet')), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('submit-review')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const Key('review-rating-4')));
    await tester.enterText(
      find.byKey(const Key('review-comment-input')),
      'Xe sạch sẽ và đúng giờ.',
    );
    await tester.tap(find.byKey(const Key('submit-review')));
    await tester.pumpAndSettle();

    expect(submittedBookingId, 'booking-pending');
    expect(submitted?.rating, 4);
    expect(submitted?.comment, 'Xe sạch sẽ và đúng giờ.');
    expect(
      find.byKey(const Key('completed-review-booking-reviewed')),
      findsOneWidget,
    );
    expect(find.text('5/5'), findsOneWidget);
  });
}
