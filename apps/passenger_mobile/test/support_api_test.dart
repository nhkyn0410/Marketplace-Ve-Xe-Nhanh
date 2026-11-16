import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/support/support_api.dart';
import 'package:passenger_mobile/features/support/support_models.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.responseFor);

  final Object Function(RequestOptions) responseFor;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(responseFor(options)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(SupportTicketApi, _Adapter) _api(Object Function(RequestOptions) responseFor) {
  final adapter = _Adapter(responseFor);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  return (SupportTicketApi(ApiClientDart(dio: dio)), adapter);
}

Map<String, Object?> _summary(String id) => {
  'ticketId': id,
  'ticketCode': 'KN-$id',
  'bookingId': 'b1',
  'bookingCode': 'VXN1',
  'subject': 'Khiếu nại $id',
  'status': 'WAITING_CUSTOMER',
  'updatedAt': '2026-11-15T03:30:00.000Z',
};

Map<String, Object?> _detail() => {
  'ticketId': 't1',
  'ticketCode': 'KN-t1',
  'subject': 'Xe đến trễ',
  'bookingId': 'b1',
  'bookingCode': 'VXN1',
  'operatorId': 'op1',
  'operatorName': 'Nhà xe An Bình',
  'reporterParty': 'PASSENGER',
  'reporterName': 'Nguyễn An',
  'category': 'SCHEDULE',
  'priority': 'HIGH',
  'handler': 'PLATFORM',
  'status': 'NEW',
  'assignee': null,
  'disputeId': null,
  'createdAt': '2026-11-15T03:30:00.000Z',
  'lastMessageAt': '2026-11-15T03:30:00.000Z',
  'requestedPriority': 'HIGH',
  'contactEmailMasked': null,
  'trip': {
    'tripId': 'trip1',
    'departureAt': '2026-11-20T01:00:00.000Z',
    'routeName': 'Hà Nội → Hải Phòng',
    'vehiclePlateNumber': null,
  },
  'messages': [
    {
      'messageId': 'm1',
      'party': 'PASSENGER',
      'authorName': 'Nguyễn An',
      'body': 'Xe xuất bến trễ.',
      'createdAt': '2026-11-15T03:30:00.000Z',
      'attachments': [
        {
          'attachmentId': 'a1',
          'fileName': 've.png',
          'contentType': 'image/png',
          'sizeBytes': 2048,
        },
      ],
    },
  ],
  'payments': <Object>[],
  'validTickets': 1,
  'dispute': null,
};

void main() {
  test('danh sách đi hết các trang theo cursor', () async {
    final (api, adapter) = _api(
      (options) => options.queryParameters['cursor'] == 'c1'
          ? {
              'items': [_summary('t2')],
              'nextCursor': null,
            }
          : {
              'items': [_summary('t1')],
              'nextCursor': 'c1',
            },
    );

    final tickets = await api.listMine();

    expect(tickets.map((ticket) => ticket.ticketId), ['t1', 't2']);
    expect(tickets.first.status, 'WAITING_CUSTOMER');
    expect(adapter.requests, hasLength(2));
    expect(adapter.requests.first.path, '/v1/me/support-tickets');
    expect(adapter.requests.first.queryParameters['limit'], 100);
  });

  test(
    'gửi khiếu nại đúng đơn, đúng danh mục và mức độ; đọc lại chi tiết',
    () async {
      final (api, adapter) = _api((_) => _detail());

      final detail = await api.create(
        'b1',
        const SupportTicketDraft(
          category: SupportCategory.schedule,
          priority: SupportPriority.high,
          subject: '  Xe đến trễ  ',
          body: ' Xe xuất bến trễ. ',
        ),
      );

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/v1/bookings/b1/support-tickets');
      expect(jsonDecode(jsonEncode(request.data)), {
        'category': 'SCHEDULE',
        'priority': 'HIGH',
        'subject': 'Xe đến trễ',
        'body': 'Xe xuất bến trễ.',
        // Client sinh luôn gửi danh sách tệp (rỗng); API mặc định [] nên tương đương.
        'attachments': <Object>[],
      });
      expect(detail.category, SupportCategory.schedule);
      expect(detail.priority, SupportPriority.high);
      expect(detail.routeName, 'Hà Nội → Hải Phòng');
      expect(detail.messages.single.fromPassenger, isTrue);
      expect(detail.messages.single.attachmentNames, ['ve.png']);
    },
  );

  test('phản hồi gửi vào đúng khiếu nại', () async {
    final (api, adapter) = _api((_) => _detail());

    await api.reply('b1', 't1', '  Đã gửi ảnh.  ');

    final request = adapter.requests.single;
    expect(request.path, '/v1/bookings/b1/support-tickets/t1/messages');
    expect(jsonDecode(jsonEncode(request.data)), {
      'body': 'Đã gửi ảnh.',
      'attachments': <Object>[],
    });
  });

  test('câu báo lỗi tiếng Việt theo mã lỗi', () {
    expect(
      describeSupportFailure(
        const ApiFailure(
          status: 409,
          code: 'SUPPORT_STATE_INVALID',
          detail: 'x',
        ),
      ),
      'Khiếu nại đã đóng, không thể phản hồi thêm.',
    );
    expect(
      describeSupportFailure(
        const ApiFailure(status: 422, code: 'OTHER', detail: 'Chi tiết'),
      ),
      'Chi tiết',
    );
    expect(supportStatusLabel('WAITING_OPERATOR'), 'Chờ nhà xe');
    expect(isSupportTicketActive('RESOLVED'), isFalse);
  });
}
