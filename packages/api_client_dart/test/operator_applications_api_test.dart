import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorApplicationsApi
void main() {
  final instance = ApiClientDart().getOperatorApplicationsApi();

  group(OperatorApplicationsApi, () {
    //Future operatorApplicationControllerCreate(ApplicationCreateInputDto applicationCreateInputDto) async
    test('test operatorApplicationControllerCreate', () async {
      // TODO
    });

    //Future<DocumentDownloadResponseDtoOutput> operatorApplicationControllerCreateDocumentDownload(String type, String xApplicationToken) async
    test('test operatorApplicationControllerCreateDocumentDownload', () async {
      // TODO
    });

    //Future<DocumentUploadResponseDtoOutput> operatorApplicationControllerCreateDocumentUpload(String xApplicationToken, DocumentUploadInputDto documentUploadInputDto) async
    test('test operatorApplicationControllerCreateDocumentUpload', () async {
      // TODO
    });

    //Future<ApplicationResponseDtoOutput> operatorApplicationControllerGet(String xApplicationToken) async
    test('test operatorApplicationControllerGet', () async {
      // TODO
    });

    //Future operatorApplicationControllerRequestAccessLink(ApplicationAccessLinkInputDto applicationAccessLinkInputDto) async
    test('test operatorApplicationControllerRequestAccessLink', () async {
      // TODO
    });

    //Future<ApplicationResponseDtoOutput> operatorApplicationControllerSubmit(String xApplicationToken) async
    test('test operatorApplicationControllerSubmit', () async {
      // TODO
    });

    //Future<ApplicationResponseDtoOutput> operatorApplicationControllerUpdate(String xApplicationToken, ApplicationUpdateInputDto applicationUpdateInputDto) async
    test('test operatorApplicationControllerUpdate', () async {
      // TODO
    });

  });
}
