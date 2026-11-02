import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminSupportApi
void main() {
  final instance = ApiClientDart().getAdminSupportApi();

  group(AdminSupportApi, () {
    //Future<AssigneeListDtoOutput> adminSupportControllerAssignees() async
    test('test adminSupportControllerAssignees', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> adminSupportControllerClassify(String ticketId, ClassifyInputDto classifyInputDto) async
    test('test adminSupportControllerClassify', () async {
      // TODO
    });

    //Future<DownloadUrlResponseDtoOutput> adminSupportControllerDownload(String attachmentId) async
    test('test adminSupportControllerDownload', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> adminSupportControllerGet(String ticketId) async
    test('test adminSupportControllerGet', () async {
      // TODO
    });

    //Future<TicketPageDtoOutput> adminSupportControllerList({ String status, String category, String operatorId, AdminSupportControllerListAssigneeIdParameter assigneeId, String q, String cursor, num limit }) async
    test('test adminSupportControllerList', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> adminSupportControllerReply(String ticketId, AdminMessageInputDto adminMessageInputDto) async
    test('test adminSupportControllerReply', () async {
      // TODO
    });

    //Future<TicketDetailDtoOutput> adminSupportControllerSetStatus(String ticketId, TicketStatusInputDto ticketStatusInputDto) async
    test('test adminSupportControllerSetStatus', () async {
      // TODO
    });

    //Future<AttachmentUploadResponseDtoOutput> adminSupportControllerUpload(String ticketId, AttachmentUploadInputDto attachmentUploadInputDto) async
    test('test adminSupportControllerUpload', () async {
      // TODO
    });

  });
}
