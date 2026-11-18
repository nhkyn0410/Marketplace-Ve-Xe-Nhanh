import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/support/support_models.dart';
import 'package:passenger_mobile/features/support/support_screens.dart';

SupportTicketSummary _summary(
  String id,
  String status, {
  String bookingId = 'b1',
  String bookingCode = 'VXN1',
}) => SupportTicketSummary(
  ticketId: id,
  ticketCode: 'KN-$id',
  bookingId: bookingId,
  bookingCode: bookingCode,
  subject: 'Khiếu nại $id',
  status: status,
  updatedAt: DateTime.utc(2026, 11, 15, 3, 30),
);

SupportMessage _message(String id, String party, String body) => SupportMessage(
  id: id,
  party: party,
  authorName: party == 'PASSENGER' ? 'Nguyễn An' : 'Trần Bình',
  body: body,
  createdAt: DateTime.utc(2026, 11, 15, 3, 30),
);

SupportTicketDetail _detail(
  String id, {
  String status = 'NEW',
  String bookingId = 'b1',
  String subject = 'Chưa nhận được tiền hoàn',
  List<SupportMessage>? messages,
}) => SupportTicketDetail(
  ticketId: id,
  ticketCode: 'KN-$id',
  subject: subject,
  bookingId: bookingId,
  bookingCode: 'VXN1',
  routeName: 'Hà Nội → Hải Phòng',
  operatorName: 'Nhà xe An Bình',
  category: SupportCategory.paymentRefund,
  priority: SupportPriority.medium,
  status: status,
  createdAt: DateTime.utc(2026, 11, 15, 3, 30),
  messages:
      messages ??
      [
        _message('m1', 'PASSENGER', 'Tôi đã hủy vé nhưng chưa nhận tiền.'),
        _message('m2', 'OPERATOR', 'Nhà xe đang kiểm tra giao dịch.'),
      ],
);

class _FakeSupportService implements SupportTicketService {
  _FakeSupportService({
    List<SupportTicketSummary> tickets = const [],
    Map<String, SupportTicketDetail>? details,
  }) : tickets = [...tickets],
       details = {...?details};

  List<SupportTicketSummary> tickets;
  final Map<String, SupportTicketDetail> details;
  Object? listError;
  Object? replyError;
  final created = <(String, SupportTicketDraft)>[];
  final replies = <(String, String, String)>[];
  final replyAttachments = <List<SupportUpload>>[];
  final uploaded = <(String, String)>[];
  final opened = <String>[];

  @override
  Future<SupportUpload> upload(String bookingId, SupportPickedFile file) async {
    uploaded.add((bookingId, file.name));
    return SupportUpload(objectKey: 'key/${file.name}', fileName: file.name);
  }

  @override
  Future<Uri> attachmentUrl(String bookingId, String attachmentId) async {
    opened.add(attachmentId);
    return Uri.parse('https://files.test/$attachmentId');
  }

  @override
  Future<List<SupportTicketSummary>> listMine() async {
    final error = listError;
    if (error != null) throw error;
    return tickets;
  }

  @override
  Future<SupportTicketDetail> load(String bookingId, String ticketId) async =>
      details[ticketId]!;

  @override
  Future<SupportTicketDetail> create(
    String bookingId,
    SupportTicketDraft draft,
  ) async {
    created.add((bookingId, draft));
    final detail = _detail(
      'new',
      bookingId: bookingId,
      subject: draft.subject,
      messages: [_message('m-new', 'PASSENGER', draft.body)],
    );
    details['new'] = detail;
    tickets = [...tickets, _summary('new', 'NEW', bookingId: bookingId)];
    return detail;
  }

  @override
  Future<SupportTicketDetail> reply(
    String bookingId,
    String ticketId,
    String body, {
    List<SupportUpload> attachments = const [],
  }) async {
    final error = replyError;
    if (error != null) throw error;
    replies.add((bookingId, ticketId, body));
    replyAttachments.add(attachments);
    final current = details[ticketId]!;
    final updated = _detail(
      ticketId,
      status: 'IN_PROGRESS',
      bookingId: bookingId,
      messages: [
        ...current.messages,
        _message('m-${replies.length}', 'PASSENGER', body),
      ],
    );
    details[ticketId] = updated;
    return updated;
  }
}

/// Màn cao như điện thoại dài: form + thanh phản hồi có thêm dòng đính kèm, ListView chỉ dựng phần đang thấy.
void _tallView(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(420, 1600);
  addTearDown(tester.view.reset);
}

Future<void> _pumpList(
  WidgetTester tester,
  _FakeSupportService service, {
  SupportBookingRef? booking,
  Future<List<SupportBookingRef>> Function()? loadBookings,
}) async {
  _tallView(tester);
  await tester.pumpWidget(
    MaterialApp(
      home: SupportTicketsScreen(
        service: service,
        booking: booking,
        loadBookings: loadBookings,
        onBack: () {},
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Cuộn danh sách có [scrollKey] tới khi thấy [target] (ListView chỉ dựng phần đang nhìn).
Future<void> _reveal(
  WidgetTester tester,
  Finder target,
  String scrollKey,
) async {
  await tester.scrollUntilVisible(
    target,
    120,
    scrollable: find
        .descendant(
          of: find.byKey(Key(scrollKey)),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  // ensureVisible nhảy vị trí cuộn; cần dựng lại khung để tap() lấy đúng toạ độ mới.
  await tester.pumpAndSettle();
}

const _booking = SupportBookingRef(
  bookingId: 'b1',
  bookingCode: 'VXN1',
  routeName: 'Hà Nội → Hải Phòng',
);

void main() {
  attachmentTests();

  testWidgets('chia tab Đang xử lý / Đã đóng như web, mặc định Đang xử lý', (
    tester,
  ) async {
    final service = _FakeSupportService(
      tickets: [
        _summary('t1', 'NEW'),
        _summary('t2', 'WAITING_CUSTOMER'),
        _summary('t3', 'RESOLVED'),
        _summary('t4', 'CLOSED'),
      ],
    );
    await _pumpList(tester, service);

    expect(find.text('Đang xử lý (2)'), findsOneWidget);
    expect(find.text('Đã đóng (2)'), findsOneWidget);
    expect(find.byKey(const Key('support-ticket-t1')), findsOneWidget);
    expect(find.text('Chờ bạn bổ sung'), findsOneWidget);
    expect(find.byKey(const Key('support-ticket-t3')), findsNothing);

    await tester.tap(find.byKey(const Key('support-tab-closed')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-ticket-t1')), findsNothing);
    expect(find.text('Đã giải quyết'), findsOneWidget);
    expect(find.text('Đã đóng'), findsOneWidget);
  });

  testWidgets('mở từ chi tiết vé chỉ hiện khiếu nại của đơn đó', (
    tester,
  ) async {
    final service = _FakeSupportService(
      tickets: [
        _summary('t1', 'NEW'),
        _summary('t2', 'NEW', bookingId: 'b2', bookingCode: 'VXN2'),
      ],
    );
    await _pumpList(tester, service, booking: _booking);

    expect(find.text('Đơn VXN1 · Hà Nội → Hải Phòng'), findsOneWidget);
    expect(find.byKey(const Key('support-ticket-t1')), findsOneWidget);
    expect(find.byKey(const Key('support-ticket-t2')), findsNothing);
  });

  testWidgets('chưa có khiếu nại thì báo trống, vẫn gửi được', (tester) async {
    await _pumpList(tester, _FakeSupportService());

    expect(find.byKey(const Key('support-empty')), findsOneWidget);
    expect(find.byKey(const Key('support-new')), findsOneWidget);
  });

  testWidgets('lỗi tải danh sách thì thử lại được', (tester) async {
    final service = _FakeSupportService(tickets: [_summary('t1', 'NEW')])
      ..listError = const ApiFailure(
        status: 0,
        code: 'NETWORK_ERROR',
        detail: 'offline',
      );
    await _pumpList(tester, service);

    expect(
      find.text(
        'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.',
      ),
      findsOneWidget,
    );
    service.listError = null;
    await tester.tap(find.byKey(const Key('support-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-ticket-t1')), findsOneWidget);
  });

  testWidgets('gửi khiếu nại cho đúng đơn rồi mở chi tiết vừa tạo', (
    tester,
  ) async {
    final service = _FakeSupportService();
    await _pumpList(tester, service, booking: _booking);

    await tester.tap(find.byKey(const Key('support-new')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-form-screen')), findsOneWidget);
    expect(find.text('VXN1 · Hà Nội → Hải Phòng'), findsOneWidget);
    await _reveal(tester, find.text('0/2000'), 'support-form-scroll');
    expect(find.text('0/200'), findsOneWidget);

    await tester.tap(find.byKey(const Key('support-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Tiêu đề cần từ 3 đến 200 ký tự.'), findsOneWidget);
    expect(service.created, isEmpty);

    final category = find.byKey(const Key('support-category-schedule'));
    await _reveal(tester, category, 'support-form-scroll');
    await tester.tap(category);
    await tester.tap(find.byKey(const Key('support-priority-high')));
    await _reveal(
      tester,
      find.byKey(const Key('support-subject')),
      'support-form-scroll',
    );
    await tester.enterText(
      find.byKey(const Key('support-subject')),
      '  Xe đến trễ 2 tiếng  ',
    );
    await _reveal(
      tester,
      find.byKey(const Key('support-body')),
      'support-form-scroll',
    );
    await tester.enterText(
      find.byKey(const Key('support-body')),
      'Xe xuất bến trễ, không ai báo trước.',
    );
    await tester.tap(find.byKey(const Key('support-submit')));
    await tester.pumpAndSettle();

    final (bookingId, draft) = service.created.single;
    expect(bookingId, 'b1');
    expect(draft.category, SupportCategory.schedule);
    expect(draft.priority, SupportPriority.high);
    expect(draft.subject, 'Xe đến trễ 2 tiếng');
    expect(draft.body, 'Xe xuất bến trễ, không ai báo trước.');
    expect(find.byKey(const Key('support-detail-screen')), findsOneWidget);
    expect(find.text('Xe đến trễ 2 tiếng'), findsOneWidget);

    await tester.tap(find.byKey(const Key('support-detail-back')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-ticket-new')), findsOneWidget);
  });

  testWidgets('mở từ Tài khoản thì chọn đơn trước khi gửi', (tester) async {
    await _pumpList(
      tester,
      _FakeSupportService(),
      loadBookings: () async => const [
        _booking,
        SupportBookingRef(
          bookingId: 'b2',
          bookingCode: 'VXN2',
          routeName: 'Đà Nẵng → Huế',
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('support-new')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn đơn vé cần hỗ trợ'), findsOneWidget);
    await tester.tap(find.byKey(const Key('support-booking-b2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('support-form-screen')), findsOneWidget);
    expect(find.text('VXN2 · Đà Nẵng → Huế'), findsOneWidget);
  });

  testWidgets('chi tiết chờ bổ sung có nhắc, phản hồi được nối vào trao đổi', (
    tester,
  ) async {
    final service = _FakeSupportService(
      details: {'t1': _detail('t1', status: 'WAITING_CUSTOMER')},
    );
    await tester.pumpWidget(
      MaterialApp(
        home: SupportTicketDetailScreen(
          service: service,
          bookingId: 'b1',
          ticketId: 't1',
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('support-waiting-notice')), findsOneWidget);
    expect(find.text('Thanh toán / hoàn tiền'), findsOneWidget);
    await _reveal(
      tester,
      find.text('Trần Bình · Nhà xe'),
      'support-detail-scroll',
    );

    await tester.enterText(
      find.byKey(const Key('support-reply-input')),
      'Tôi đã gửi ảnh chụp giao dịch.',
    );
    await tester.tap(find.byKey(const Key('support-reply-send')));
    await tester.pumpAndSettle();

    expect(service.replies.single, (
      'b1',
      't1',
      'Tôi đã gửi ảnh chụp giao dịch.',
    ));
    await _reveal(
      tester,
      find.text('Tôi đã gửi ảnh chụp giao dịch.'),
      'support-detail-scroll',
    );
    await tester.drag(
      find.byKey(const Key('support-detail-scroll')),
      const Offset(0, 2000),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-waiting-notice')), findsNothing);
    expect(find.text('Đang xử lý'), findsOneWidget);
    final input = tester.widget<TextField>(
      find.byKey(const Key('support-reply-input')),
    );
    expect(input.controller!.text, isEmpty);
  });

  testWidgets('đã đóng thì khóa phản hồi; phản hồi lỗi thì báo lỗi', (
    tester,
  ) async {
    final service =
        _FakeSupportService(
            details: {
              'closed': _detail('closed', status: 'CLOSED'),
              'open': _detail('open'),
            },
          )
          ..replyError = const ApiFailure(
            status: 409,
            code: 'SUPPORT_STATE_INVALID',
            detail: 'closed',
          );
    Future<void> pumpDetail(String id) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SupportTicketDetailScreen(
            key: ValueKey(id),
            service: service,
            bookingId: 'b1',
            ticketId: id,
            onBack: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpDetail('closed');
    expect(find.byKey(const Key('support-reply-locked')), findsOneWidget);
    expect(find.byKey(const Key('support-reply-input')), findsNothing);

    await pumpDetail('open');
    await tester.enterText(
      find.byKey(const Key('support-reply-input')),
      'Còn ai xử lý không?',
    );
    await tester.tap(find.byKey(const Key('support-reply-send')));
    await tester.pumpAndSettle();
    expect(
      find.text('Khiếu nại đã đóng, không thể phản hồi thêm.'),
      findsOneWidget,
    );
    expect(service.replies, isEmpty);
  });
}

// PASSENGER-PARITY A24 đợt 2: đính kèm ảnh / PDF và mở tệp đã gửi.
SupportPickedFile _picked(String name, {int size = 1024}) => SupportPickedFile(
  name: name,
  contentType: supportContentType(name)!,
  bytes: List.filled(size, 0),
);

void attachmentTests() {
  testWidgets('gửi khiếu nại kèm tệp: tải lên rồi gửi khóa tệp cùng nội dung', (
    tester,
  ) async {
    _tallView(tester);
    final service = _FakeSupportService();
    await tester.pumpWidget(
      MaterialApp(
        home: SupportTicketFormScreen(
          booking: _booking,
          submit: (draft) => service.create('b1', draft),
          upload: (file) => service.upload('b1', file),
          pickFiles: () async => [_picked('ve.png'), _picked('hoa-don.pdf')],
          onCreated: (_) {},
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final attach = find.byKey(const Key('support-form-attach'));
    await tester.ensureVisible(attach);
    await tester.pumpAndSettle();
    await tester.tap(attach);
    await tester.pumpAndSettle();
    expect(service.uploaded, [('b1', 've.png'), ('b1', 'hoa-don.pdf')]);
    expect(find.byKey(const Key('support-form-file-ve.png')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('support-subject')),
      'Thiếu tiền hoàn',
    );
    await tester.enterText(find.byKey(const Key('support-body')), 'Xem ảnh.');
    await tester.tap(find.byKey(const Key('support-submit')));
    await tester.pumpAndSettle();
    expect(
      service.created.single.$2.attachments.map((file) => file.objectKey),
      ['key/ve.png', 'key/hoa-don.pdf'],
    );
  });

  testWidgets('tệp quá 10 MB hoặc quá 5 tệp thì báo lỗi, không tải lên', (
    tester,
  ) async {
    _tallView(tester);
    final service = _FakeSupportService();
    var files = [_picked('lon.pdf', size: supportMaxFileBytes + 1)];
    await tester.pumpWidget(
      MaterialApp(
        home: SupportTicketFormScreen(
          booking: _booking,
          submit: (draft) => service.create('b1', draft),
          upload: (file) => service.upload('b1', file),
          pickFiles: () async => files,
          onCreated: (_) {},
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final attach = find.byKey(const Key('support-form-attach'));
    await tester.ensureVisible(attach);
    await tester.pumpAndSettle();
    await tester.tap(attach);
    await tester.pumpAndSettle();
    expect(find.text('Tệp "lon.pdf" lớn hơn 10 MB.'), findsOneWidget);

    files = [for (var i = 0; i < 6; i++) _picked('anh$i.jpg')];
    await tester.tap(attach);
    await tester.pumpAndSettle();
    expect(find.text('Mỗi lần gửi tối đa 5 tệp.'), findsOneWidget);
    expect(service.uploaded, isEmpty);
  });

  testWidgets('phản hồi kèm tệp; bấm tệp đã gửi thì mở URL có hạn', (
    tester,
  ) async {
    final service = _FakeSupportService(
      details: {
        't1': _detail(
          't1',
          messages: [
            SupportMessage(
              id: 'm1',
              party: 'OPERATOR',
              authorName: 'Trần Bình',
              body: 'Gửi bạn biên nhận.',
              createdAt: DateTime.utc(2026, 11, 15),
              attachments: const [
                SupportAttachment(
                  id: 'a1',
                  fileName: 'bien-nhan.pdf',
                  sizeBytes: 4096,
                ),
              ],
            ),
          ],
        ),
      },
    );
    final openedUrls = <Uri>[];
    _tallView(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: SupportTicketDetailScreen(
          service: service,
          bookingId: 'b1',
          ticketId: 't1',
          pickFiles: () async => [_picked('anh.jpg')],
          openUrl: (url) async {
            openedUrls.add(url);
            return true;
          },
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('support-attachment-a1')));
    await tester.pumpAndSettle();
    expect(openedUrls, [Uri.parse('https://files.test/a1')]);

    await tester.tap(find.byKey(const Key('support-reply-attach')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('support-reply-file-anh.jpg')), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('support-reply-input')),
      'Ảnh vé đây.',
    );
    await tester.tap(find.byKey(const Key('support-reply-send')));
    await tester.pumpAndSettle();
    expect(service.replyAttachments.single.single.objectKey, 'key/anh.jpg');
    expect(find.byKey(const Key('support-reply-file-anh.jpg')), findsNothing);
  });
}
