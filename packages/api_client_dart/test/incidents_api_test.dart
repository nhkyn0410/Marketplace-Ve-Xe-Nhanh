import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for IncidentsApi
void main() {
  final instance = ApiClientDart().getIncidentsApi();

  group(IncidentsApi, () {
    //Future<DownloadUrlResponseDtoOutput> adminIncidentControllerDownload(String incidentId, num index) async
    test('test adminIncidentControllerDownload', () async {
      // TODO
    });

    //Future<IncidentPageDtoOutput> adminIncidentControllerList({ String tripId, String cursor, int limit }) async
    test('test adminIncidentControllerList', () async {
      // TODO
    });

    //Future<IncidentDtoOutput> employeeIncidentControllerCreate(IncidentInputDto incidentInputDto) async
    test('test employeeIncidentControllerCreate', () async {
      // TODO
    });

    //Future<IncidentPageDtoOutput> employeeIncidentControllerList({ String tripId, String cursor, int limit }) async
    test('test employeeIncidentControllerList', () async {
      // TODO
    });

    //Future<AttachmentUploadResponseDtoOutput> employeeIncidentControllerUpload(String tripId, AttachmentUploadInputDto attachmentUploadInputDto) async
    test('test employeeIncidentControllerUpload', () async {
      // TODO
    });

    //Future<DownloadUrlResponseDtoOutput> operatorIncidentControllerDownload(String incidentId, num index) async
    test('test operatorIncidentControllerDownload', () async {
      // TODO
    });

    //Future<IncidentPageDtoOutput> operatorIncidentControllerList({ String tripId, String cursor, int limit }) async
    test('test operatorIncidentControllerList', () async {
      // TODO
    });

    //Future<IncidentDtoOutput> operatorIncidentControllerResolve(String incidentId, IncidentResolutionDto incidentResolutionDto) async
    test('test operatorIncidentControllerResolve', () async {
      // TODO
    });

  });
}
