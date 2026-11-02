import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';

/// Việc khách có thể làm tiếp từ một tin trong hộp thư.
enum InboxAction { journey, article, voucher }

/// Một tin trong hộp thư thông báo (TASK-NSR-003).
class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.linkType,
    this.linkTarget,
    this.readAt,
  });

  final String id;
  final String kind;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? linkType;

  /// Mã đơn, slug bài viết hoặc mã khuyến mãi tùy [linkType].
  final String? linkTarget;
  final DateTime? readAt;

  bool get isUnread => readAt == null;

  InboxAction? get action => switch (linkType) {
    'BOOKING' => InboxAction.journey,
    'ARTICLE' when linkTarget != null => InboxAction.article,
    'PROMOTION' when linkTarget != null => InboxAction.voucher,
    _ => null,
  };

  /// Bản sao đã đọc, để cập nhật danh sách ngay khi khách chạm tin.
  InboxMessage asRead(DateTime at) => InboxMessage(
    id: id,
    kind: kind,
    title: title,
    body: body,
    createdAt: createdAt,
    linkType: linkType,
    linkTarget: linkTarget,
    readAt: at,
  );
}

/// Một trang hộp thư; [nextCursor] `null` là đã hết tin.
class InboxPage {
  const InboxPage({
    required this.items,
    required this.nextCursor,
    required this.unreadCount,
  });

  final List<InboxMessage> items;
  final String? nextCursor;
  final int unreadCount;
}

/// Lời gọi API của hộp thư và cài đặt thông báo. Lỗi API ném ra dạng [ApiFailure].
class NotificationCenterApi {
  NotificationCenterApi(this._client);

  final ApiClientDart _client;

  /// Tin mới nhất trước; truyền [cursor] để tải tiếp.
  Future<InboxPage> loadInbox({String? cursor}) async {
    final response = await _call(
      () => _client.getNotificationApi().inboxControllerList(cursor: cursor),
    );
    final data = response.data!;
    return InboxPage(
      items: [
        for (final item in data.items)
          InboxMessage(
            id: item.id,
            kind: item.kind.name,
            title: item.title,
            body: item.body,
            createdAt: item.createdAt,
            linkType: item.linkType?.name,
            linkTarget: item.linkTarget,
            readAt: item.readAt,
          ),
      ],
      nextCursor: data.nextCursor,
      unreadCount: data.unreadCount,
    );
  }

  /// Số tin chưa đọc cho chuông ở Trang chủ.
  Future<int> unreadCount() async {
    final response = await _call(
      () => _client.getNotificationApi().inboxControllerUnreadCount(),
    );
    return response.data!.unreadCount;
  }

  Future<void> markRead(String messageId) => _call(
    () => _client.getNotificationApi().inboxControllerMarkRead(
      messageId: messageId,
    ),
  );

  Future<void> markAllRead() =>
      _call(() => _client.getNotificationApi().inboxControllerMarkAllRead());

  /// Trạng thái bật / tắt của các loại khách được tự chọn (BR-52); loại bắt buộc không có ở đây.
  Future<Map<String, bool>> loadPreferences() async {
    final response = await _call(
      () => _client.getNotificationApi().preferenceControllerPreferences(),
    );
    return {
      for (final item in response.data!.items)
        if (!item.mandatory) item.kind.name: item.email || item.push,
    };
  }

  /// Bật thì nhận cả push; máy chưa đăng ký push (vd từ chối quyền) vẫn bật được để nhận trong hộp thư.
  Future<void> savePreference(String kind, {required bool enabled}) async {
    if (!enabled) return _save(kind, email: false, push: false);
    try {
      await _save(kind, email: true, push: true);
    } on ApiFailure catch (failure) {
      if (failure.code != 'PUSH_DEVICE_REQUIRED') rethrow;
      await _save(kind, email: true, push: false);
    }
  }

  Future<void> _save(String kind, {required bool email, required bool push}) =>
      _call(
        () => _client.getNotificationApi().preferenceControllerSave(
          preferenceInputDto: PreferenceInputDto(
            (builder) => builder
              ..kind = PreferenceInputDtoKindEnum.valueOf(kind)
              ..email = email
              ..push = push,
          ),
        ),
      );

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw toApiFailure(error, _client.serializers);
    }
  }
}
