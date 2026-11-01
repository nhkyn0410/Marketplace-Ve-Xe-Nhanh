import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/operator/operator_profile_models.dart';
import 'package:passenger_mobile/features/operator/operator_profile_screen.dart';

OperatorReview _review(String id, {String? reply}) => OperatorReview(
  id: id,
  authorName: 'Phạm Ngọc Á***',
  rating: 4,
  createdAt: DateTime.utc(2026, 4, 18, 10),
  comment: 'Xe sạch, chạy đúng giờ ($id).',
  operatorReply: reply,
);

OperatorProfile _profile({
  String? description = 'Nhà xe chuyên tuyến TP.HCM – Đà Lạt.',
  String? hotline = '1900 8678',
  String? email = 'hotro@saomai.vn',
  String? address = 'Số 2 Nguyễn Tri Phương, Khánh Hòa',
  OperatorScorecard scorecard = const OperatorScorecard(
    reviewCount: 1200,
    averageRating: 4.7,
    operatorCancellationRate: .012,
    refundBookingRate: .05,
    disputeBookingRate: 0,
    checkInRate: .965,
    noShowRate: .035,
  ),
  List<OperatorRoute> routes = const [
    OperatorRoute(id: 'r1', name: 'TP.HCM → Đà Lạt'),
    OperatorRoute(id: 'r2', name: 'TP.HCM → Nha Trang'),
  ],
  List<OperatorReview>? reviews,
  OperatorServiceTerms? terms,
  String? nextCursor,
}) => OperatorProfile(
  operatorId: 'op-1',
  displayName: 'Nhà xe Sao Mai',
  description: description,
  hotline: hotline,
  publicEmail: email,
  address: address,
  scorecard: scorecard,
  routes: routes,
  reviews: reviews ?? [_review('a', reply: 'Cảm ơn quý khách.')],
  serviceTerms: terms,
  nextReviewCursor: nextCursor,
);

Future<void> _pumpScreen(
  WidgetTester tester, {
  required OperatorProfileLoader loader,
  void Function(OperatorProfile)? onViewTrips,
  ExternalUriOpener? openExternalUri,
  double width = 412,
  double height = 900,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: OperatorProfileScreen(
        operatorId: 'op-1',
        loadProfile: loader,
        onViewTrips: onViewTrips,
        openExternalUri: openExternalUri,
      ),
    ),
  );
}

Future<void> _scrollTo(WidgetTester tester, Finder target) =>
    tester.scrollUntilVisible(
      target,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('operator-profile-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

void main() {
  testWidgets('hiện thông tin công khai, chỉ số, tuyến, đánh giá và phản hồi', (
    tester,
  ) async {
    String? requested;
    await _pumpScreen(
      tester,
      loader: (id, {reviewCursor}) async {
        requested = id;
        return _profile();
      },
    );
    expect(find.byKey(const Key('operator-profile-loading')), findsOneWidget);
    await tester.pumpAndSettle();

    expect(requested, 'op-1');
    expect(find.text('Nhà xe Sao Mai'), findsOneWidget);
    expect(find.text('(1.200 đánh giá)'), findsOneWidget);
    expect(find.text('1900 8678'), findsOneWidget);
    expect(find.text('hotro@saomai.vn'), findsOneWidget);
    expect(find.text('Số 2 Nguyễn Tri Phương, Khánh Hòa'), findsOneWidget);

    expect(find.text('4.7'), findsNWidgets(2));
    expect(find.text('1,2%'), findsOneWidget);
    expect(find.text('5,0% / 0,0%'), findsOneWidget);
    await _scrollTo(tester, find.text('96,5%'));
    expect(find.text('Không đến: 3,5%'), findsOneWidget);

    await _scrollTo(tester, find.text('TP.HCM → Nha Trang'));
    await _scrollTo(tester, find.text('Cảm ơn quý khách.'));
    expect(find.text('18/04/2026'), findsOneWidget);
    expect(find.text('Phản hồi từ nhà xe'), findsOneWidget);

    await _scrollTo(tester, find.byKey(const Key('operator-terms-empty')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('thiếu dữ liệu: ghi rõ chưa có, không tràn, ẩn liên hệ trống', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      width: 320,
      height: 640,
      loader: (_, {reviewCursor}) async => _profile(
        description: null,
        hotline: null,
        email: ' ',
        address: null,
        scorecard: const OperatorScorecard(reviewCount: 0),
        routes: const [],
        reviews: const [],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có đánh giá'), findsOneWidget);
    expect(find.text('Chưa có dữ liệu'), findsNWidgets(4));
    expect(find.byKey(const Key('operator-contact-hotline')), findsNothing);
    expect(find.byKey(const Key('operator-contact-email')), findsNothing);
    expect(find.byKey(const Key('operator-profile-call')), findsNothing);
    await _scrollTo(tester, find.byKey(const Key('operator-routes-empty')));
    await _scrollTo(tester, find.byKey(const Key('operator-reviews-empty')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('điều khoản nhà xe công bố thì hiện nội dung', (tester) async {
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async => _profile(
        terms: const OperatorServiceTerms(
          title: 'Quy định gửi hành lý',
          contentMarkdown: 'Mỗi khách được **20 kg**.',
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byKey(const Key('operator-terms')));
    expect(find.text('Quy định gửi hành lý'), findsOneWidget);
    expect(find.byKey(const Key('operator-terms-empty')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('xem thêm đánh giá dùng con trỏ, hết trang thì ẩn nút', (
    tester,
  ) async {
    final cursors = <String?>[];
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async {
        cursors.add(reviewCursor);
        return reviewCursor == null
            ? _profile(nextCursor: 'cursor-2')
            : _profile(reviews: [_review('b')]);
      },
    );
    await tester.pumpAndSettle();

    final more = find.byKey(const Key('operator-reviews-more'));
    await _scrollTo(tester, more);
    await tester.tap(more);
    await tester.pumpAndSettle();

    expect(cursors, [null, 'cursor-2']);
    expect(find.byKey(const Key('operator-review-a')), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('operator-review-b')));
    expect(more, findsNothing);
  });

  testWidgets('tải thêm đánh giá lỗi: giữ danh sách, bấm lại được', (
    tester,
  ) async {
    var failNext = true;
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async {
        if (reviewCursor == null) return _profile(nextCursor: 'cursor-2');
        if (failNext) {
          failNext = false;
          throw const ApiFailure(status: 0, code: 'NETWORK', detail: 'x');
        }
        return _profile(reviews: [_review('b')]);
      },
    );
    await tester.pumpAndSettle();

    final more = find.byKey(const Key('operator-reviews-more'));
    await _scrollTo(tester, more);
    await tester.tap(more);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('operator-review-a')), findsOneWidget);
    expect(more, findsOneWidget);

    await tester.tap(more);
    await tester.pumpAndSettle();
    expect(more, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lỗi mạng có nút thử lại; nhà xe không còn hoạt động thì báo rõ', (
    tester,
  ) async {
    var calls = 0;
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async {
        calls++;
        if (calls == 1) {
          throw const ApiFailure(status: 0, code: 'NETWORK', detail: 'x');
        }
        return _profile();
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('Chưa thể tải thông tin nhà xe'), findsOneWidget);
    await tester.tap(find.byKey(const Key('operator-profile-retry')));
    await tester.pumpAndSettle();
    expect(find.text('Nhà xe Sao Mai'), findsOneWidget);

    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async => throw const ApiFailure(
        status: 404,
        code: 'OPERATOR_NOT_FOUND',
        detail: 'Không tìm thấy nhà xe.',
      ),
    );
    await tester.pumpWidget(const SizedBox());
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async => throw const ApiFailure(
        status: 404,
        code: 'OPERATOR_NOT_FOUND',
        detail: 'Không tìm thấy nhà xe.',
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Nhà xe không tồn tại hoặc đang tạm ngừng hoạt động.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('operator-profile-retry')), findsNothing);
  });

  testWidgets('gọi, gửi email và xem chuyến dùng đúng thông tin nhà xe', (
    tester,
  ) async {
    final opened = <Uri>[];
    OperatorProfile? viewed;
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async => _profile(),
      onViewTrips: (profile) => viewed = profile,
      openExternalUri: (uri) async {
        opened.add(uri);
        return true;
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('operator-profile-call')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('operator-contact-email')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('operator-profile-view-trips')));
    await tester.pump();

    expect(opened[0].toString(), 'tel:19008678');
    expect(opened[1].toString(), 'mailto:hotro@saomai.vn');
    expect(viewed?.operatorId, 'op-1');
  });

  testWidgets('không mở được ứng dụng gọi điện thì báo, màn vẫn dùng được', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async => _profile(),
      openExternalUri: (_) async => false,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operator-profile-call')));
    await tester.pump();
    expect(
      find.text('Không thể mở ứng dụng gọi điện trên thiết bị này.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('giới thiệu dài rút gọn và mở rộng được', (tester) async {
    await _pumpScreen(
      tester,
      loader: (_, {reviewCursor}) async =>
          _profile(description: 'Nhà xe uy tín nhiều năm. ' * 30),
    );
    await tester.pumpAndSettle();
    final toggle = find.byKey(const Key('operator-description-toggle'));
    expect(find.text('Xem thêm'), findsOneWidget);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Thu gọn'), findsOneWidget);
  });
}
