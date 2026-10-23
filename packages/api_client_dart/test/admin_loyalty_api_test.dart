import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminLoyaltyApi
void main() {
  final instance = ApiClientDart().getAdminLoyaltyApi();

  group(AdminLoyaltyApi, () {
    //Future<LoyaltyMemberDtoOutput> adminLoyaltyControllerAdjust(String userId, PointAdjustInputDto pointAdjustInputDto) async
    test('test adminLoyaltyControllerAdjust', () async {
      // TODO
    });

    //Future<LoyaltyMemberDtoOutput> adminLoyaltyControllerMember(String email) async
    test('test adminLoyaltyControllerMember', () async {
      // TODO
    });

    //Future<LoyaltyReportDtoOutput> adminLoyaltyControllerReport(num year, num quarter, { String tier }) async
    test('test adminLoyaltyControllerReport', () async {
      // TODO
    });

    //Future<LoyaltyTransactionPageDtoOutput> adminLoyaltyControllerTransactions(String userId, { num offset, num limit }) async
    test('test adminLoyaltyControllerTransactions', () async {
      // TODO
    });

  });
}
