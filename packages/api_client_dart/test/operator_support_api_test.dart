import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorSupportApi
void main() {
  final instance = ApiClientDart().getOperatorSupportApi();

  group(OperatorSupportApi, () {
    //Future<DownloadUrlResponseDtoOutput> operatorSupportControllerDownload(String attachmentId) async
    test('test operatorSupportControllerDownload', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> operatorSupportControllerGet(String ticketId) async
    test('test operatorSupportControllerGet', () async {
      // TODO
    });

    //Future<TicketPageDtoOutput> operatorSupportControllerList({ String status, String cursor, num limit }) async
    test('test operatorSupportControllerList', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> operatorSupportControllerReply(String ticketId, MessageInputDto messageInputDto) async
    test('test operatorSupportControllerReply', () async {
      // TODO
    });

    //Future<AttachmentUploadResponseDtoOutput> operatorSupportControllerUpload(AttachmentUploadInputDto attachmentUploadInputDto) async
    test('test operatorSupportControllerUpload', () async {
      // TODO
    });

  });
}
