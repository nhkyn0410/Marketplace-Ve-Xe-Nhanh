import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorOfficesApi
void main() {
  final instance = ApiClientDart().getOperatorOfficesApi();

  group(OperatorOfficesApi, () {
    //Future<SalesOfficeAssignmentsDtoOutput> salesOfficeControllerAssignments(String officeId) async
    test('test salesOfficeControllerAssignments', () async {
      // TODO
    });

    //Future<SalesOfficeDtoOutput> salesOfficeControllerCreate(SalesOfficeInputDto salesOfficeInputDto) async
    test('test salesOfficeControllerCreate', () async {
      // TODO
    });

    //Future<SalesOfficeDtoOutput> salesOfficeControllerGet(String officeId) async
    test('test salesOfficeControllerGet', () async {
      // TODO
    });

    //Future<SalesOfficeListDtoOutput> salesOfficeControllerList() async
    test('test salesOfficeControllerList', () async {
      // TODO
    });

    //Future<SalesOfficeDtoOutput> salesOfficeControllerReplaceAssignments(String officeId, SalesOfficeAssignmentsInputDto salesOfficeAssignmentsInputDto) async
    test('test salesOfficeControllerReplaceAssignments', () async {
      // TODO
    });

    //Future<SalesOfficeDtoOutput> salesOfficeControllerUpdate(String officeId, SalesOfficeUpdateDto salesOfficeUpdateDto) async
    test('test salesOfficeControllerUpdate', () async {
      // TODO
    });

  });
}
