import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorProfileApi
void main() {
  final instance = ApiClientDart().getOperatorProfileApi();

  group(OperatorProfileApi, () {
    //Future<KycDownloadResponseDtoOutput> operatorProfileControllerCreateDownloadUrl(String type) async
    test('test operatorProfileControllerCreateDownloadUrl', () async {
      // TODO
    });

    //Future<KycUploadResponseDtoOutput> operatorProfileControllerCreateUploadUrl(KycUploadInputDto kycUploadInputDto) async
    test('test operatorProfileControllerCreateUploadUrl', () async {
      // TODO
    });

    //Future<OperatorProfileResponseDtoOutput> operatorProfileControllerGet() async
    test('test operatorProfileControllerGet', () async {
      // TODO
    });

    //Future<OperatorProfileResponseDtoOutput> operatorProfileControllerReplaceDocument(String type, KycReplaceInputDto kycReplaceInputDto) async
    test('test operatorProfileControllerReplaceDocument', () async {
      // TODO
    });

    //Future<OperatorProfileResponseDtoOutput> operatorProfileControllerRequestBankChange(BankChangeInputDto bankChangeInputDto) async
    test('test operatorProfileControllerRequestBankChange', () async {
      // TODO
    });

    //Future<OperatorProfileResponseDtoOutput> operatorProfileControllerUpdate(OperatorProfileUpdateDto operatorProfileUpdateDto) async
    test('test operatorProfileControllerUpdate', () async {
      // TODO
    });

  });
}
