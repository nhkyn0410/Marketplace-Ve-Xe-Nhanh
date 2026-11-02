import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for EmployeeOperationsApi
void main() {
  final instance = ApiClientDart().getEmployeeOperationsApi();

  group(EmployeeOperationsApi, () {
    //Future<EmployeeAssignmentListDtoOutput> employeeOperationsControllerAssignments({ Date from, Date to }) async
    test('test employeeOperationsControllerAssignments', () async {
      // TODO
    });

    //Future<CheckInResultDtoOutput> employeeOperationsControllerCheckIn(CheckInInputDto checkInInputDto) async
    test('test employeeOperationsControllerCheckIn', () async {
      // TODO
    });

    //Future<EmployeeAssignmentDtoOutput> employeeOperationsControllerOperate(String tripId, TripOperationInputDto tripOperationInputDto) async
    test('test employeeOperationsControllerOperate', () async {
      // TODO
    });

    //Future<TripManifestDtoOutput> employeeOperationsControllerPassengers(String tripId) async
    test('test employeeOperationsControllerPassengers', () async {
      // TODO
    });

    //Future<TicketVerifyResultDtoOutput> employeeOperationsControllerVerify(TicketVerifyInputDto ticketVerifyInputDto) async
    test('test employeeOperationsControllerVerify', () async {
      // TODO
    });

  });
}
