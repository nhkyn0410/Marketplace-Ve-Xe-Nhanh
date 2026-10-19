import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorReportsApi
void main() {
  final instance = ApiClientDart().getOperatorReportsApi();

  group(OperatorReportsApi, () {
    //Future<String> operatorReportingControllerExport(Date from, Date to, { String routeId, String vehicleId, String status }) async
    test('test operatorReportingControllerExport', () async {
      // TODO
    });

    //Future<OperatorOverviewDtoOutput> operatorReportingControllerOverview() async
    test('test operatorReportingControllerOverview', () async {
      // TODO
    });

    //Future<OperatorReportDtoOutput> operatorReportingControllerSummary(Date from, Date to, { String routeId, String vehicleId, String status }) async
    test('test operatorReportingControllerSummary', () async {
      // TODO
    });

  });
}
