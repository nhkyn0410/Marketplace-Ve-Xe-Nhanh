import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/support/support_models.dart';

/// Khiếu nại của hành khách đăng nhập: danh sách `GET /me/support-tickets`; chi tiết, gửi, trao đổi qua
/// `/bookings/{bookingId}/support-tickets`. Lỗi API ném ra dạng [ApiFailure].
class SupportTicketApi implements SupportTicketService {
  /// [uploader] gửi tệp lên URL ký sẵn của kho — Dio riêng, không mang token đăng nhập của API.
  SupportTicketApi(this._client, {Dio? uploader})
    : _uploader = uploader ?? Dio();

  final ApiClientDart _client;
  final Dio _uploader;

  @override
  Future<List<SupportTicketSummary>> listMine() async {
    final items = <SupportTicketSummary>[];
    String? cursor;
    do {
      final response = await _call(
        () => _client
            .getPassengerProfileApi()
            .passengerProfileControllerSupportTickets(
              cursor: cursor,
              limit: 100,
            ),
      );
      final page = response.data!;
      items.addAll(
        page.items.map(
          (item) => SupportTicketSummary(
            ticketId: item.ticketId,
            ticketCode: item.ticketCode,
            bookingId: item.bookingId,
            bookingCode: item.bookingCode,
            subject: item.subject,
            status: item.status,
            updatedAt: item.updatedAt,
          ),
        ),
      );
      final next = page.nextCursor;
      if (next == cursor) break;
      cursor = next;
    } while (cursor != null);
    return items;
  }

  @override
  Future<SupportTicketDetail> load(String bookingId, String ticketId) async {
    final response = await _call(
      () => _client.getSupportApi().customerSupportControllerGet(
        bookingId: bookingId,
        ticketId: ticketId,
      ),
    );
    return _detail(response.data!);
  }

  @override
  Future<SupportTicketDetail> create(
    String bookingId,
    SupportTicketDraft draft,
  ) async {
    final response = await _call(
      () => _client.getSupportApi().customerSupportControllerCreate(
        bookingId: bookingId,
        customerTicketInputDto: CustomerTicketInputDto(
          (b) => b
            ..category = CustomerTicketInputDtoCategoryEnum.valueOf(
              draft.category.apiValue,
            )
            ..priority = CustomerTicketInputDtoPriorityEnum.valueOf(
              draft.priority.apiValue,
            )
            ..subject = draft.subject.trim()
            ..body = draft.body.trim()
            ..attachments.replace(_attachments(draft.attachments)),
        ),
      ),
    );
    return _detail(response.data!);
  }

  @override
  Future<SupportTicketDetail> reply(
    String bookingId,
    String ticketId,
    String body, {
    List<SupportUpload> attachments = const [],
  }) async {
    final response = await _call(
      () => _client.getSupportApi().customerSupportControllerReply(
        bookingId: bookingId,
        ticketId: ticketId,
        messageInputDto: MessageInputDto(
          (b) => b
            ..body = body.trim()
            ..attachments.replace(_attachments(attachments)),
        ),
      ),
    );
    return _detail(response.data!);
  }

  @override
  Future<SupportUpload> upload(String bookingId, SupportPickedFile file) async {
    final response = await _call(
      () => _client.getSupportApi().customerSupportControllerUpload(
        bookingId: bookingId,
        attachmentUploadInputDto: AttachmentUploadInputDto(
          (b) => b
            ..contentType = switch (file.contentType) {
              'application/pdf' =>
                AttachmentUploadInputDtoContentTypeEnum.applicationSlashPdf,
              'image/png' =>
                AttachmentUploadInputDtoContentTypeEnum.imageSlashPng,
              _ => AttachmentUploadInputDtoContentTypeEnum.imageSlashJpeg,
            }
            ..sizeBytes = file.bytes.length,
        ),
      ),
    );
    final target = response.data!;
    try {
      await _uploader.put<void>(
        target.uploadUrl,
        data: Stream.fromIterable([file.bytes]),
        options: Options(
          headers: {
            Headers.contentTypeHeader: file.contentType,
            Headers.contentLengthHeader: file.bytes.length,
          },
        ),
      );
    } on DioException {
      throw SupportAttachmentError(
        'Chưa tải được tệp "${file.name}". Vui lòng thử lại.',
      );
    }
    return SupportUpload(objectKey: target.objectKey, fileName: file.name);
  }

  @override
  Future<Uri> attachmentUrl(String bookingId, String attachmentId) async {
    final response = await _call(
      () => _client.getSupportApi().customerSupportControllerDownload(
        bookingId: bookingId,
        attachmentId: attachmentId,
      ),
    );
    return Uri.parse(response.data!.url);
  }

  Iterable<CustomerTicketInputDtoAttachmentsInner> _attachments(
    List<SupportUpload> uploads,
  ) => [
    for (final upload in uploads)
      CustomerTicketInputDtoAttachmentsInner(
        (b) => b
          ..objectKey = upload.objectKey
          ..fileName = upload.fileName,
      ),
  ];

  SupportTicketDetail _detail(TicketDetailDtoOutput data) =>
      SupportTicketDetail(
        ticketId: data.ticketId,
        ticketCode: data.ticketCode,
        subject: data.subject,
        bookingId: data.bookingId,
        bookingCode: data.bookingCode,
        routeName: data.trip.routeName,
        operatorName: data.operatorName,
        category: SupportCategory.fromApi(data.category.name),
        priority: SupportPriority.fromApi(data.priority.name),
        status: data.status.name,
        createdAt: data.createdAt,
        messages: [
          for (final message in data.messages)
            SupportMessage(
              id: message.messageId,
              party: message.party.name,
              authorName: message.authorName,
              body: message.body,
              createdAt: message.createdAt,
              attachments: [
                for (final file in message.attachments)
                  SupportAttachment(
                    id: file.attachmentId,
                    fileName: file.fileName,
                    sizeBytes: file.sizeBytes,
                  ),
              ],
            ),
        ],
      );

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw toApiFailure(error, _client.serializers);
    }
  }
}

/// Câu tiếng Việt cho lỗi khiếu nại.
String describeSupportFailure(Object error) {
  if (error is SupportAttachmentError) return error.message;
  if (error is! ApiFailure) return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  if (error.isNetworkError) {
    return 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
  }
  return switch (error.code) {
    'SUPPORT_TICKET_NOT_FOUND' =>
      'Không tìm thấy khiếu nại hoặc đơn vé trong tài khoản của bạn.',
    'SUPPORT_STATE_INVALID' => 'Khiếu nại đã đóng, không thể phản hồi thêm.',
    _ => error.detail,
  };
}
