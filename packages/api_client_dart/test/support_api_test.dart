import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for SupportApi
void main() {
  final instance = ApiClientDart().getSupportApi();

  group(SupportApi, () {
    //Future<TicketDetailDtoOutput> customerSupportControllerCreate(String bookingId, CustomerTicketInputDto customerTicketInputDto, { String xBookingToken }) async
    test('test customerSupportControllerCreate', () async {
      // TODO
    });

    //Future<DownloadUrlResponseDtoOutput> customerSupportControllerDownload(String bookingId, String attachmentId, { String xBookingToken }) async
    test('test customerSupportControllerDownload', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> customerSupportControllerGet(String bookingId, String ticketId, { String xBookingToken }) async
    test('test customerSupportControllerGet', () async {
      // TODO
    });

    //Future<CustomerTicketListDtoOutput> customerSupportControllerList(String bookingId, { String xBookingToken }) async
    test('test customerSupportControllerList', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> customerSupportControllerReply(String bookingId, String ticketId, MessageInputDto messageInputDto, { String xBookingToken }) async
    test('test customerSupportControllerReply', () async {
      // TODO
    });

    //Future<AttachmentUploadResponseDtoOutput> customerSupportControllerUpload(String bookingId, AttachmentUploadInputDto attachmentUploadInputDto, { String xBookingToken }) async
    test('test customerSupportControllerUpload', () async {
      // TODO
    });

  });
}
