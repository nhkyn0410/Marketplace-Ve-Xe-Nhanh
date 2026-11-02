import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/account/account_settings_header.dart';
import 'package:passenger_mobile/features/notification/notification_center_api.dart';

typedef InboxPageLoader = Future<InboxPage> Function({String? cursor});

const _primary = Color(0xFF1389DD);

/// Giờ hiển thị của một tin: gần đây ghi tương đối, cũ hơn một tuần ghi ngày.
String inboxTimeLabel(DateTime at, DateTime now) {
  final local = at.toLocal();
  final elapsed = now.difference(local);
  if (elapsed.inMinutes < 1) return 'Vừa xong';
  if (elapsed.inHours < 1) return '${elapsed.inMinutes} phút trước';
  if (elapsed.inDays < 1) return '${elapsed.inHours} giờ trước';
  if (elapsed.inDays < 7) return '${elapsed.inDays} ngày trước';
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year}';
}

/// Biểu tượng theo loại tin, cùng bộ với màn Cài đặt thông báo.
(String, Color) _kindVisual(String kind) => switch (kind) {
  'TRIP_CHANGED' || 'TRIP_CANCELLED' => ('bus.svg', const Color(0xFFE5F8F1)),
  'CASE_UPDATED' => ('chat.svg', const Color(0xFFFFF3E0)),
  'LOYALTY_UPDATED' => ('star.svg', const Color(0xFFFFF4DF)),
  'PROMOTION' => ('gift.svg', const Color(0xFFFFF0F1)),
  'SERVICE_NOTICE' => ('shield.svg', const Color(0xFFEDF7FF)),
  'NEWS' || 'OPERATIONS_ALERT' => ('megaphone.svg', const Color(0xFFFFF3DF)),
  _ => ('ticket.svg', const Color(0xFFFFF0F1)),
};

String? _actionLabel(InboxMessage message) => switch (message.action) {
  InboxAction.journey => 'Xem hành trình',
  InboxAction.article => 'Đọc bài viết',
  InboxAction.voucher => 'Lưu mã ${message.linkTarget} vào ví',
  null => null,
};

/// Hộp thư thông báo (TASK-NSR-003): tin mới nhất trước; chạm để đọc đầy đủ rồi đi tiếp
/// tới hành trình, bài viết hoặc mã ưu đãi.
class InboxScreen extends StatefulWidget {
  const InboxScreen({
    required this.loadPage,
    required this.markRead,
    required this.markAllRead,
    required this.onBack,
    required this.onAction,
    required this.onUnreadChanged,
    super.key,
  });

  final InboxPageLoader loadPage;
  final Future<void> Function(String messageId) markRead;
  final Future<void> Function() markAllRead;
  final VoidCallback onBack;
  final ValueChanged<InboxMessage> onAction;

  /// Báo số tin chưa đọc mới để chuông ở Trang chủ cập nhật theo.
  final ValueChanged<int> onUnreadChanged;

  @override
  State<InboxScreen> createState() => InboxScreenState();
}

/// Công khai để có tin mới trong lúc đang mở màn thì gọi [reload].
class InboxScreenState extends State<InboxScreen> {
  final _scroll = ScrollController();
  List<InboxMessage> _items = const [];
  String? _nextCursor;
  int _unread = 0;
  bool _loading = true;
  bool _failed = false;
  bool _loadingMore = false;
  bool _moreFailed = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_loadMoreNearEnd);
    unawaited(reload());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Tải lại từ đầu; đang có danh sách mà lỗi thì giữ nguyên và báo ngắn.
  Future<void> reload() async {
    try {
      final page = await widget.loadPage();
      if (!mounted) return;
      setState(() {
        _items = page.items;
        _nextCursor = page.nextCursor;
        _unread = page.unreadCount;
        _loading = false;
        _failed = false;
        _moreFailed = false;
      });
      widget.onUnreadChanged(page.unreadCount);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
      if (_items.isNotEmpty) {
        _notify('Chưa tải được tin mới. Vui lòng thử lại.');
      }
    }
  }

  void _retry() {
    setState(() {
      _loading = true;
      _failed = false;
    });
    unawaited(reload());
  }

  void _loadMoreNearEnd() {
    if (_scroll.position.extentAfter < 240) unawaited(_loadMore());
  }

  Future<void> _loadMore() async {
    final cursor = _nextCursor;
    if (cursor == null || _loadingMore || _moreFailed) return;
    setState(() => _loadingMore = true);
    try {
      final page = await widget.loadPage(cursor: cursor);
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...page.items];
        _nextCursor = page.nextCursor;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingMore = false;
        _moreFailed = true;
      });
    }
  }

  void _setUnread(int count) {
    _unread = math.max(0, count);
    widget.onUnreadChanged(_unread);
  }

  /// Đánh dấu ngay trên màn hình; gửi lỗi thì lần tải sau tự đúng lại, không làm phiền khách.
  void _markRead(InboxMessage message) {
    final now = DateTime.now();
    setState(() {
      _items = [
        for (final item in _items)
          item.id == message.id ? item.asRead(now) : item,
      ];
      _setUnread(_unread - 1);
    });
    unawaited(widget.markRead(message.id).catchError((Object _) {}));
  }

  Future<void> _markAllRead() async {
    final now = DateTime.now();
    setState(() {
      _items = [
        for (final item in _items) item.isUnread ? item.asRead(now) : item,
      ];
      _setUnread(0);
    });
    try {
      await widget.markAllRead();
    } catch (_) {
      if (!mounted) return;
      _notify('Chưa đánh dấu được. Vui lòng thử lại.');
      await reload();
    }
  }

  Future<void> _open(InboxMessage message) async {
    if (message.isUnread) _markRead(message);
    final proceed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InboxMessageSheet(message: message),
    );
    if (proceed == true && mounted) widget.onAction(message);
  }

  void _notify(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: accountSettingsOverlayStyle,
      child: Scaffold(
        key: const Key('inbox-screen'),
        backgroundColor: accountSettingsBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccountSettingsHeader(title: 'Thông báo', onBack: widget.onBack),
              if (_unread > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 12, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$_unread tin chưa đọc',
                          key: const Key('inbox-unread-count'),
                          style: const TextStyle(
                            color: accountSettingsMuted,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                      TextButton(
                        key: const Key('inbox-mark-all-read'),
                        onPressed: _markAllRead,
                        child: const Text(
                          'Đọc tất cả',
                          style: TextStyle(
                            color: _primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(
        key: Key('inbox-loading'),
        child: CircularProgressIndicator(color: _primary),
      );
    }
    if (_items.isEmpty) {
      return _failed
          ? _InboxState(
              key: const Key('inbox-error'),
              title: 'Không tải được thông báo',
              description: 'Vui lòng kiểm tra kết nối và thử lại.',
              action: OutlinedButton(
                key: const Key('inbox-retry'),
                onPressed: _retry,
                child: const Text('Thử lại'),
              ),
            )
          : RefreshIndicator(
              color: _primary,
              onRefresh: reload,
              child: const _InboxEmpty(),
            );
    }
    return RefreshIndicator(
      color: _primary,
      onRefresh: reload,
      child: ListView.separated(
        key: const Key('inbox-list'),
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          20,
          6,
          20,
          24 + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: _items.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == _items.length) return _footer();
          final message = _items[index];
          return _InboxTile(
            key: Key('inbox-item-${message.id}'),
            message: message,
            onTap: () => _open(message),
          );
        },
      ),
    );
  }

  Widget _footer() {
    if (_loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: _primary),
          ),
        ),
      );
    }
    if (_moreFailed) {
      return Center(
        child: TextButton(
          key: const Key('inbox-load-more-retry'),
          onPressed: () {
            setState(() => _moreFailed = false);
            unawaited(_loadMore());
          },
          child: const Text('Chưa tải thêm được. Thử lại'),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _InboxEmpty extends StatelessWidget {
  const _InboxEmpty();

  @override
  Widget build(BuildContext context) {
    // Vẫn cuộn được để kéo xuống tải lại.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: const _InboxState(
            key: Key('inbox-empty'),
            title: 'Chưa có thông báo',
            description: 'Vé, chuyến đi và ưu đãi dành cho bạn sẽ hiện ở đây.',
          ),
        ),
      ),
    );
  }
}

class _InboxState extends StatelessWidget {
  const _InboxState({
    required this.title,
    required this.description,
    this.action,
    super.key,
  });

  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: accountSettingsInk,
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: accountSettingsMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

class _InboxTile extends StatelessWidget {
  const _InboxTile({required this.message, required this.onTap, super.key});

  final InboxMessage message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = message.isUnread;
    final (icon, iconBackground) = _kindVisual(message.kind);
    return Semantics(
      button: true,
      label: unread ? 'Chưa đọc' : null,
      child: Material(
        color: unread ? const Color(0xFFF2F8FF) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: unread ? const Color(0xFFD6E8FB) : const Color(0xFFECF1F8),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    '$accountSettingsAssetRoot/$icon',
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: accountSettingsInk,
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: unread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: accountSettingsMuted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        inboxTimeLabel(message.createdAt, DateTime.now()),
                        style: const TextStyle(
                          color: accountSettingsMuted,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unread) ...[
                  const SizedBox(width: 8),
                  Container(
                    key: Key('inbox-unread-dot-${message.id}'),
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4B5B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Toàn văn một tin; trả `true` khi khách chọn đi tiếp.
class _InboxMessageSheet extends StatelessWidget {
  const _InboxMessageSheet({required this.message});

  final InboxMessage message;

  @override
  Widget build(BuildContext context) {
    final actionLabel = _actionLabel(message);
    return Container(
      key: const Key('inbox-message-sheet'),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .8,
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFAAB9CC),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  message.title,
                  style: const TextStyle(
                    color: accountSettingsInk,
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                key: const Key('inbox-message-close'),
                tooltip: 'Đóng',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close_rounded,
                  color: accountSettingsMuted,
                ),
              ),
            ],
          ),
          Text(
            inboxTimeLabel(message.createdAt, DateTime.now()),
            style: const TextStyle(
              color: accountSettingsMuted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                message.body,
                style: const TextStyle(
                  color: accountSettingsInk,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              child: FilledButton(
                key: const Key('inbox-message-action'),
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
