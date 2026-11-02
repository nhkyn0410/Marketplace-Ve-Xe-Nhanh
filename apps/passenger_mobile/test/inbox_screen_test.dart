import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/notification/inbox_screen.dart';
import 'package:passenger_mobile/features/notification/notification_center_api.dart';

InboxMessage _message(
  String id, {
  String kind = 'SERVICE_NOTICE',
  String? linkType,
  String? linkTarget,
  DateTime? readAt,
  String? body,
}) => InboxMessage(
  id: id,
  kind: kind,
  title: 'Tiêu đề $id',
  body: body ?? 'Nội dung $id',
  createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  linkType: linkType,
  linkTarget: linkTarget,
  readAt: readAt,
);

class _Harness {
  final read = <String>[];
  final actions = <InboxMessage>[];
  final unread = <int>[];
  int markAllCalls = 0;
  bool wentBack = false;
  Future<void> Function()? markAllRead;

  InboxScreen screen(InboxPageLoader loadPage) => InboxScreen(
    loadPage: loadPage,
    markRead: (id) async => read.add(id),
    markAllRead: () async {
      markAllCalls++;
      await markAllRead?.call();
    },
    onBack: () => wentBack = true,
    onAction: actions.add,
    onUnreadChanged: unread.add,
  );
}

Future<void> _pump(WidgetTester tester, Widget screen) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
      home: screen,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('nhãn giờ: gần đây tương đối, cũ hơn một tuần ghi ngày', () {
    final now = DateTime(2026, 11, 2, 12);
    expect(
      inboxTimeLabel(now.subtract(const Duration(seconds: 20)), now),
      'Vừa xong',
    );
    expect(
      inboxTimeLabel(now.add(const Duration(minutes: 3)), now),
      'Vừa xong',
    );
    expect(
      inboxTimeLabel(now.subtract(const Duration(minutes: 5)), now),
      '5 phút trước',
    );
    expect(
      inboxTimeLabel(now.subtract(const Duration(hours: 3)), now),
      '3 giờ trước',
    );
    expect(
      inboxTimeLabel(now.subtract(const Duration(days: 2)), now),
      '2 ngày trước',
    );
    expect(inboxTimeLabel(DateTime(2026, 10, 1, 8), now), '01/10/2026');
  });

  test('hành động theo liên kết của tin', () {
    expect(_message('a').action, isNull);
    expect(
      _message('a', linkType: 'BOOKING', linkTarget: 'b1').action,
      InboxAction.journey,
    );
    expect(
      _message('a', linkType: 'ARTICLE', linkTarget: 'slug').action,
      InboxAction.article,
    );
    expect(
      _message('a', linkType: 'PROMOTION', linkTarget: 'CODE').action,
      InboxAction.voucher,
    );
    expect(_message('a', linkType: 'ARTICLE').action, isNull);
  });

  testWidgets('chạm tin: đánh dấu đã đọc, xem toàn văn, chọn hành động', (
    tester,
  ) async {
    final harness = _Harness();
    final longBody = List.filled(60, 'nội dung dài').join(' ');
    await _pump(
      tester,
      harness.screen(
        ({cursor}) async => InboxPage(
          items: [
            _message(
              'a',
              linkType: 'ARTICLE',
              linkTarget: 'bai-moi',
              body: longBody,
            ),
            _message('b', readAt: DateTime(2026, 11, 1)),
          ],
          nextCursor: null,
          unreadCount: 1,
        ),
      ),
    );

    expect(find.text('1 tin chưa đọc'), findsOneWidget);
    expect(find.byKey(const Key('inbox-unread-dot-a')), findsOneWidget);
    expect(find.byKey(const Key('inbox-unread-dot-b')), findsNothing);
    expect(harness.unread, [1]);

    await tester.tap(find.byKey(const Key('inbox-item-a')));
    await tester.pumpAndSettle();

    expect(harness.read, ['a']);
    expect(harness.unread, [1, 0]);
    expect(find.byKey(const Key('inbox-unread-dot-a')), findsNothing);
    expect(find.byKey(const Key('inbox-unread-count')), findsNothing);
    expect(find.byKey(const Key('inbox-message-sheet')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('inbox-message-sheet')),
        matching: find.text(longBody),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('inbox-message-action')));
    await tester.pumpAndSettle();
    expect(harness.actions.single.linkTarget, 'bai-moi');
  });

  testWidgets('tin không có liên kết chỉ để đọc; tin đã đọc không gửi lại', (
    tester,
  ) async {
    final harness = _Harness();
    await _pump(
      tester,
      harness.screen(
        ({cursor}) async => InboxPage(
          items: [_message('a', readAt: DateTime(2026, 11, 1))],
          nextCursor: null,
          unreadCount: 0,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('inbox-item-a')));
    await tester.pumpAndSettle();

    expect(harness.read, isEmpty);
    expect(find.byKey(const Key('inbox-message-action')), findsNothing);
    await tester.tap(find.byKey(const Key('inbox-message-close')));
    await tester.pumpAndSettle();
    expect(harness.actions, isEmpty);
  });

  testWidgets('đọc tất cả gửi lỗi thì báo và tải lại để đúng với máy chủ', (
    tester,
  ) async {
    final failing = _Harness()
      ..markAllRead = () async => throw StateError('mạng');
    await _pump(
      tester,
      failing.screen(
        ({cursor}) async =>
            InboxPage(items: [_message('c')], nextCursor: null, unreadCount: 1),
      ),
    );

    await tester.tap(find.byKey(const Key('inbox-mark-all-read')));
    await tester.pumpAndSettle();

    expect(find.text('Chưa đánh dấu được. Vui lòng thử lại.'), findsOneWidget);
    expect(find.byKey(const Key('inbox-unread-dot-c')), findsOneWidget);
    expect(failing.unread.last, 1);
  });

  testWidgets('đọc tất cả cập nhật danh sách và chuông', (tester) async {
    final harness = _Harness();
    await _pump(
      tester,
      harness.screen(
        ({cursor}) async => InboxPage(
          items: [_message('a'), _message('b')],
          nextCursor: null,
          unreadCount: 2,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('inbox-mark-all-read')));
    await tester.pumpAndSettle();
    expect(harness.markAllCalls, 1);
    expect(harness.unread.last, 0);
    expect(find.byKey(const Key('inbox-unread-dot-a')), findsNothing);
    expect(find.byKey(const Key('inbox-mark-all-read')), findsNothing);
  });

  testWidgets('cuộn gần cuối tải trang tiếp; lỗi thì cho thử lại', (
    tester,
  ) async {
    final harness = _Harness();
    final cursors = <String?>[];
    var failNext = true;
    await _pump(
      tester,
      harness.screen(({cursor}) async {
        cursors.add(cursor);
        if (cursor == null) {
          return InboxPage(
            items: [
              for (var i = 0; i < 20; i++)
                _message('a$i', readAt: DateTime(2026, 11, 1)),
            ],
            nextCursor: 'c1',
            unreadCount: 0,
          );
        }
        if (failNext) {
          failNext = false;
          throw StateError('mạng');
        }
        return InboxPage(
          items: [_message('z', readAt: DateTime(2026, 11, 1))],
          nextCursor: null,
          unreadCount: 0,
        );
      }),
    );

    await tester.drag(
      find.byKey(const Key('inbox-list')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('inbox-list')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    expect(cursors, [null, 'c1']);
    expect(find.byKey(const Key('inbox-load-more-retry')), findsOneWidget);

    await tester.tap(find.byKey(const Key('inbox-load-more-retry')));
    await tester.pumpAndSettle();
    expect(cursors, [null, 'c1', 'c1']);
    expect(find.byKey(const Key('inbox-load-more-retry')), findsNothing);
    await tester.drag(
      find.byKey(const Key('inbox-list')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tiêu đề z'), findsOneWidget);
  });

  testWidgets('tải lỗi có nút thử lại; hộp thư trống có lời giải thích', (
    tester,
  ) async {
    final harness = _Harness();
    var attempts = 0;
    await _pump(
      tester,
      harness.screen(({cursor}) async {
        attempts++;
        if (attempts == 1) throw StateError('mạng');
        return const InboxPage(items: [], nextCursor: null, unreadCount: 0);
      }),
    );
    expect(find.byKey(const Key('inbox-error')), findsOneWidget);

    await tester.tap(find.byKey(const Key('inbox-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inbox-empty')), findsOneWidget);
    expect(find.text('Chưa có thông báo'), findsOneWidget);

    await tester.tap(find.byKey(const Key('account-settings-back')));
    expect(harness.wentBack, isTrue);
  });

  testWidgets('có tin mới khi đang mở màn thì reload hiện tin đó', (
    tester,
  ) async {
    final harness = _Harness();
    final key = GlobalKey<InboxScreenState>();
    var items = [_message('a', readAt: DateTime(2026, 11, 1))];
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
        home: InboxScreen(
          key: key,
          loadPage: ({cursor}) async =>
              InboxPage(items: items, nextCursor: null, unreadCount: 0),
          markRead: (_) async {},
          markAllRead: () async {},
          onBack: () {},
          onAction: harness.actions.add,
          onUnreadChanged: harness.unread.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tiêu đề b'), findsNothing);

    items = [_message('b'), ...items];
    await key.currentState!.reload();
    await tester.pumpAndSettle();
    expect(find.text('Tiêu đề b'), findsOneWidget);
  });
}
