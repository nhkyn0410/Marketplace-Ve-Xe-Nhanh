import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/account/my_reviews_screen.dart';

const _empty = MyReviewsData(pending: [], reviewed: []);

/// Mục đơn giản cho các test phân trang: [id] là mã đơn, tên tuyến theo mã.
ReviewTripItem _trip(String id, {int? rating}) => ReviewTripItem(
  bookingId: id,
  routeName: 'Tuyến $id',
  operatorName: 'Nhà xe',
  departureAt: DateTime(2026, 10, 16),
  rating: rating,
);

Future<void> _pumpReviews(
  WidgetTester tester, {
  Future<MyReviewsData> Function()? loader,
  MyReviewsLoader? pagedLoader,
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
        loadReviews:
            pagedLoader ?? ({pendingCursor, reviewedCursor}) => loader!(),
        submitReview: submitter ?? (_, _) async => true,
        onBack: () {},
      ),
    ),
  );
}

void main() {
  test('ảnh hàng sao tô đúng số sao theo tên file', () {
    for (final rating in [3, 4, 5]) {
      final svg = File(
        'assets/account/reviews/rating_$rating.svg',
      ).readAsStringSync();
      expect(
        RegExp('fill="#FFB62E"').allMatches(svg).length,
        rating,
        reason: 'rating_$rating.svg',
      );
    }
  });

  testWidgets('hiển thị fixture Figma với 3 chuyến chờ và 5 đánh giá', (
    tester,
  ) async {
    await _pumpReviews(tester, loader: () async => figmaMyReviewsSample);
    await tester.pumpAndSettle();

    expect(find.text('Chờ đánh giá (3)'), findsOneWidget);
    expect(find.text('TP. Hồ Chí Minh → Đà Lạt'), findsOneWidget);
    expect(find.text('Phương Nam Travel'), findsOneWidget);
    expect(
      tester.getSize(find.byType(PendingReviewCard).first),
      const Size(388, 200),
    );

    await tester.tap(find.byKey(const Key('completed-review-tab')));
    await tester.pump();

    expect(find.text('Đã đánh giá (5)'), findsOneWidget);
    expect(find.text('4/5'), findsOneWidget);
    expect(find.text('5/5'), findsAtLeastNWidgets(1));
    expect(find.text('3/5'), findsOneWidget);
    expect(
      tester.getSize(find.byType(CompletedReviewCard).first),
      const Size(388, 208),
    );
  });

  testWidgets('fixture Figma mở form với nội dung mẫu 4 sao', (tester) async {
    await _pumpReviews(tester, loader: () async => figmaMyReviewsSample);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('write-review-figma-pending-1')));
    await tester.pumpAndSettle();

    expect(find.text('4/5 - Khá hài lòng'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('review-form-sheet'))),
      const Size(412, 626),
    );
    expect(
      find.textContaining('Xe sạch sẽ, nhân viên hỗ trợ nhiệt tình.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('submit-review')))
          .onPressed,
      isNotNull,
    );
  });

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

  testWidgets(
    'tab đếm theo tổng máy chủ; "Xem thêm" chỉ nối trang kế của tab đang mở',
    (tester) async {
      final calls = <(String?, String?)>[];
      await _pumpReviews(
        tester,
        pagedLoader: ({pendingCursor, reviewedCursor}) async {
          calls.add((pendingCursor, reviewedCursor));
          return MyReviewsData(
            pending: [_trip(pendingCursor == 'p1' ? 'p2' : 'p1')],
            pendingTotal: 2,
            pendingNextCursor: pendingCursor == 'p1' ? null : 'p1',
            reviewed: [_trip(reviewedCursor == 'r1' ? 'r2' : 'r1', rating: 5)],
            reviewedTotal: 2,
            reviewedNextCursor: reviewedCursor == 'r1' ? null : 'r1',
          );
        },
      );
      await tester.pumpAndSettle();

      expect(find.text('Chờ đánh giá (2)'), findsOneWidget);
      expect(find.text('Đã đánh giá (2)'), findsOneWidget);
      expect(find.byType(PendingReviewCard), findsOneWidget);

      await tester.tap(find.byKey(const Key('my-reviews-more')));
      await tester.pumpAndSettle();

      expect(calls.last, ('p1', null));
      expect(find.byKey(const Key('pending-review-p1')), findsOneWidget);
      expect(find.byKey(const Key('pending-review-p2')), findsOneWidget);
      expect(find.byKey(const Key('my-reviews-more')), findsNothing);

      // Tab kia chưa bị nối thêm, vẫn còn nút của riêng nó.
      await tester.tap(find.byKey(const Key('completed-review-tab')));
      await tester.pump();
      expect(find.byType(CompletedReviewCard), findsOneWidget);

      await tester.tap(find.byKey(const Key('my-reviews-more')));
      await tester.pumpAndSettle();

      expect(calls.last, (null, 'r1'));
      expect(find.byType(CompletedReviewCard), findsNWidgets(2));
      expect(find.byKey(const Key('my-reviews-more')), findsNothing);

      await tester.tap(find.byKey(const Key('pending-review-tab')));
      await tester.pump();
      expect(find.byType(PendingReviewCard), findsNWidgets(2));
      expect(calls, hasLength(3));
    },
  );

  testWidgets('tải thêm lỗi thì giữ danh sách, bấm lại được', (tester) async {
    var failNext = true;
    await _pumpReviews(
      tester,
      pagedLoader: ({pendingCursor, reviewedCursor}) async {
        if (pendingCursor == null) {
          return MyReviewsData(
            pending: [_trip('p1')],
            pendingNextCursor: 'p1',
            reviewed: const [],
          );
        }
        if (failNext) {
          failNext = false;
          throw StateError('mất mạng');
        }
        return MyReviewsData(pending: [_trip('p2')], reviewed: const []);
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('my-reviews-more')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('pending-review-p1')), findsOneWidget);
    expect(
      find.text('Chưa tải được thêm đánh giá. Vui lòng thử lại.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('my-reviews-more')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pending-review-p2')), findsOneWidget);
  });

  testWidgets(
    'gửi xong tải lại từ đầu, mở tab Đã đánh giá, bỏ các trang đã nối',
    (tester) async {
      var submitted = false;
      var loads = 0;
      await _pumpReviews(
        tester,
        pagedLoader: ({pendingCursor, reviewedCursor}) async {
          loads += 1;
          if (submitted) {
            return MyReviewsData(
              pending: const [],
              reviewed: [_trip('p1', rating: 4)],
            );
          }
          return MyReviewsData(pending: [_trip('p1')], reviewed: const []);
        },
        submitter: (_, _) async {
          submitted = true;
          return true;
        },
      );
      await tester.pumpAndSettle();
      expect(loads, 1);

      await tester.tap(find.byKey(const Key('write-review-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('review-rating-4')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit-review')));
      await tester.pumpAndSettle();

      expect(loads, 2);
      expect(find.text('Đã đánh giá (1)'), findsOneWidget);
      expect(find.text('Chờ đánh giá (0)'), findsOneWidget);
      expect(find.byKey(const Key('completed-review-p1')), findsOneWidget);
    },
  );

  testWidgets(
    'gửi lỗi vì đơn đã có đánh giá: đóng form thì danh sách tự đúng lại',
    (tester) async {
      var alreadyReviewed = false;
      var loads = 0;
      await _pumpReviews(
        tester,
        pagedLoader: ({pendingCursor, reviewedCursor}) async {
          loads += 1;
          return alreadyReviewed
              ? MyReviewsData(
                  pending: const [],
                  reviewed: [_trip('p1', rating: 4)],
                )
              : MyReviewsData(pending: [_trip('p1')], reviewed: const []);
        },
        submitter: (_, _) async {
          alreadyReviewed = true;
          return false;
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('write-review-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('review-rating-4')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit-review')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('review-submit-error')), findsOneWidget);
      expect(loads, 1);

      await tester.tap(find.byKey(const Key('close-review-form')));
      await tester.pumpAndSettle();

      expect(loads, 2);
      expect(find.text('Chờ đánh giá (0)'), findsOneWidget);
      expect(find.text('Đã đánh giá (1)'), findsOneWidget);
    },
  );

  testWidgets('đóng form không gửi thì không tải lại', (tester) async {
    var loads = 0;
    await _pumpReviews(
      tester,
      pagedLoader: ({pendingCursor, reviewedCursor}) async {
        loads += 1;
        return MyReviewsData(pending: [_trip('p1')], reviewed: const []);
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('write-review-p1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('close-review-form')));
    await tester.pumpAndSettle();

    expect(loads, 1);
  });

  testWidgets(
    'tải lỗi hiện nút thử lại, thử lại thành công không ném lỗi ra ngoài',
    (tester) async {
      var attempts = 0;
      await _pumpReviews(
        tester,
        pagedLoader: ({pendingCursor, reviewedCursor}) async {
          attempts += 1;
          if (attempts <= 2) throw StateError('API lỗi');
          return MyReviewsData(pending: [_trip('p1')], reviewed: const []);
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('Chưa thể tải đánh giá'), findsOneWidget);

      // Lần thử lại đầu vẫn lỗi: giữ màn lỗi, không có lỗi chưa xử lý.
      await tester.tap(find.byKey(const Key('my-reviews-retry')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Chưa thể tải đánh giá'), findsOneWidget);

      await tester.tap(find.byKey(const Key('my-reviews-retry')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('pending-review-p1')), findsOneWidget);
    },
  );

  testWidgets(
    'đánh giá đang giữ chờ / đã ẩn hiện dòng trạng thái thay cho ngày gửi',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      await _pumpReviews(
        tester,
        loader: () async => MyReviewsData(
          pending: const [],
          reviewed: [
            ReviewTripItem(
              bookingId: 'held',
              routeName: 'Tuyến giữ',
              operatorName: 'Nhà xe',
              departureAt: DateTime(2026, 10, 16),
              rating: 2,
              reviewedAt: DateTime(2026, 10, 17),
              visibility: ReviewVisibility.held,
            ),
            ReviewTripItem(
              bookingId: 'hidden',
              routeName: 'Tuyến ẩn',
              operatorName: 'Nhà xe',
              departureAt: DateTime(2026, 10, 16),
              rating: 1,
              reviewedAt: DateTime(2026, 10, 17),
              visibility: ReviewVisibility.hidden,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('completed-review-tab')));
      await tester.pump();

      expect(find.text('Đánh giá đang chờ duyệt'), findsOneWidget);
      expect(find.text('Đánh giá hiện không được hiển thị'), findsOneWidget);
      expect(find.textContaining('Đánh giá ngày'), findsNothing);
    },
  );

  testWidgets('ngày trên thẻ theo giờ máy, không theo UTC API trả về', (
    tester,
  ) async {
    final departure = DateTime.utc(2026, 10, 15, 23, 30);
    final local = departure.toLocal();
    await _pumpReviews(
      tester,
      loader: () async => MyReviewsData(
        pending: [
          ReviewTripItem(
            bookingId: 'early',
            routeName: 'Chuyến sáng sớm',
            operatorName: 'Nhà xe',
            departureAt: departure,
          ),
        ],
        reviewed: const [],
      ),
    );
    await tester.pumpAndSettle();

    final expected =
        '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
    expect(find.text(expected), findsOneWidget);
  });
}
