/// Khiếu nại và hỗ trợ của hành khách đăng nhập (SCR-PSG-30/31): dữ liệu màn hình, độc lập client API.
library;

/// Danh mục khiếu nại, cùng bộ nhãn với web.
enum SupportCategory {
  paymentRefund('PAYMENT_REFUND', 'Thanh toán / hoàn tiền'),
  schedule('SCHEDULE', 'Lịch trình'),
  serviceQuality('SERVICE_QUALITY', 'Chất lượng dịch vụ'),
  ticketChange('TICKET_CHANGE', 'Đổi vé'),
  other('OTHER', 'Khác');

  const SupportCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static SupportCategory fromApi(String value) =>
      values.firstWhere((item) => item.apiValue == value, orElse: () => other);
}

/// Mức độ khách chọn chỉ là gợi ý; CSKH phân loại lại.
enum SupportPriority {
  low('LOW', 'Thấp'),
  medium('MEDIUM', 'Trung bình'),
  high('HIGH', 'Cao'),
  urgent('URGENT', 'Khẩn cấp');

  const SupportPriority(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static SupportPriority fromApi(String value) =>
      values.firstWhere((item) => item.apiValue == value, orElse: () => medium);
}

/// Nhãn trạng thái như web (`support-mappers.ts`).
String supportStatusLabel(String status) => switch (status) {
  'NEW' => 'Mới tiếp nhận',
  'IN_PROGRESS' => 'Đang xử lý',
  'WAITING_OPERATOR' => 'Chờ nhà xe',
  'WAITING_CUSTOMER' => 'Chờ bạn bổ sung',
  'ESCALATED' => 'Đã chuyển cấp',
  'RESOLVED' => 'Đã giải quyết',
  'CLOSED' => 'Đã đóng',
  _ => status,
};

/// Tab "Đang xử lý"; đã giải quyết / đã đóng nằm ở tab "Đã đóng" như web.
bool isSupportTicketActive(String status) =>
    status != 'RESOLVED' && status != 'CLOSED';

/// Một dòng trong danh sách khiếu nại (`GET /me/support-tickets`).
class SupportTicketSummary {
  const SupportTicketSummary({
    required this.ticketId,
    required this.ticketCode,
    required this.bookingId,
    required this.bookingCode,
    required this.subject,
    required this.status,
    required this.updatedAt,
  });

  final String ticketId;
  final String ticketCode;
  final String bookingId;
  final String bookingCode;
  final String subject;

  /// Mã trạng thái API (`NEW`, `WAITING_CUSTOMER`, `CLOSED`, …).
  final String status;
  final DateTime updatedAt;
}

/// Một lượt trao đổi.
class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.party,
    required this.authorName,
    required this.body,
    required this.createdAt,
    this.attachmentNames = const [],
  });

  final String id;

  /// `PASSENGER` / `GUEST` / `OPERATOR` / `PLATFORM` / `SYSTEM`.
  final String party;
  final String authorName;
  final String body;
  final DateTime createdAt;

  /// Tên tệp đính kèm; xem tệp trên web (đính kèm trên app làm đợt sau).
  final List<String> attachmentNames;

  bool get fromPassenger => party == 'PASSENGER' || party == 'GUEST';

  /// Vai trò người gửi phía sàn; `null` với tin của khách.
  String? get roleLabel => switch (party) {
    'OPERATOR' => 'Nhà xe',
    'PLATFORM' => 'CSKH',
    'SYSTEM' => 'Hệ thống',
    _ => null,
  };
}

/// Chi tiết khiếu nại kèm trao đổi.
class SupportTicketDetail {
  const SupportTicketDetail({
    required this.ticketId,
    required this.ticketCode,
    required this.subject,
    required this.bookingId,
    required this.bookingCode,
    required this.routeName,
    required this.operatorName,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.messages,
  });

  final String ticketId;
  final String ticketCode;
  final String subject;
  final String bookingId;
  final String bookingCode;
  final String routeName;
  final String operatorName;
  final SupportCategory category;
  final SupportPriority priority;
  final String status;
  final DateTime createdAt;
  final List<SupportMessage> messages;

  /// Đã đóng thì không phản hồi thêm (API trả 409); đã giải quyết vẫn phản hồi được và mở lại yêu cầu.
  bool get closed => status == 'CLOSED';
}

/// Nội dung khiếu nại mới (SCR-PSG-31).
class SupportTicketDraft {
  const SupportTicketDraft({
    required this.category,
    required this.priority,
    required this.subject,
    required this.body,
  });

  final SupportCategory category;
  final SupportPriority priority;
  final String subject;
  final String body;
}

/// Đơn vé gắn với khiếu nại.
class SupportBookingRef {
  const SupportBookingRef({
    required this.bookingId,
    required this.bookingCode,
    required this.routeName,
    this.departureAt,
  });

  final String bookingId;
  final String bookingCode;
  final String routeName;
  final DateTime? departureAt;
}

/// Lời gọi khiếu nại mà màn hình cần; app dùng `SupportTicketApi`, test dùng bản giả.
abstract interface class SupportTicketService {
  Future<List<SupportTicketSummary>> listMine();

  Future<SupportTicketDetail> load(String bookingId, String ticketId);

  Future<SupportTicketDetail> create(
    String bookingId,
    SupportTicketDraft draft,
  );

  Future<SupportTicketDetail> reply(
    String bookingId,
    String ticketId,
    String body,
  );
}

/// Giờ Việt Nam `HH:mm · dd/MM/yyyy`.
String formatSupportMoment(DateTime value) {
  final vn = value.toUtc().add(const Duration(hours: 7));
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(vn.hour)}:${two(vn.minute)} · '
      '${two(vn.day)}/${two(vn.month)}/${vn.year}';
}
