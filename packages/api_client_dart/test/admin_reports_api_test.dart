import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminReportsApi
void main() {
  final instance = ApiClientDart().getAdminReportsApi();

  group(AdminReportsApi, () {
    //Future<String> adminReportingControllerExport(Date from, Date to, { String operatorId, String provider }) async
    test('test adminReportingControllerExport', () async {
      // TODO
    });

    //Future<AdminOverviewDtoOutput> adminReportingControllerOverview(Date from, Date to, { String operatorId, String provider }) async
    test('test adminReportingControllerOverview', () async {
      // TODO
    });

    //Future<AdminReportDtoOutput> adminReportingControllerSummary(Date from, Date to, { String operatorId, String provider }) async
    test('test adminReportingControllerSummary', () async {
      // TODO
    });

  });
}
