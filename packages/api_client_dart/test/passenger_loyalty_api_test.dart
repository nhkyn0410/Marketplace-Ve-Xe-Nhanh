import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for PassengerLoyaltyApi
void main() {
  final instance = ApiClientDart().getPassengerLoyaltyApi();

  group(PassengerLoyaltyApi, () {
    //Future<PassengerLoyaltyDtoOutput> passengerLoyaltyControllerMember() async
    test('test passengerLoyaltyControllerMember', () async {
      // TODO
    });

    //Future<UserVoucherDtoOutput> passengerLoyaltyControllerRedeem(String idempotencyKey, LoyaltyRedemptionInputDto loyaltyRedemptionInputDto) async
    test('test passengerLoyaltyControllerRedeem', () async {
      // TODO
    });

    //Future<UserVoucherDtoOutput> passengerLoyaltyControllerSave(SaveVoucherInputDto saveVoucherInputDto) async
    test('test passengerLoyaltyControllerSave', () async {
      // TODO
    });

    //Future<PassengerLoyaltyTransactionsDtoOutput> passengerLoyaltyControllerTransactions({ int offset, int limit, String type, DateTime from, DateTime to }) async
    test('test passengerLoyaltyControllerTransactions', () async {
      // TODO
    });

    //Future<UserVoucherPageDtoOutput> passengerLoyaltyControllerVouchers({ String status, int offset, int limit }) async
    test('test passengerLoyaltyControllerVouchers', () async {
      // TODO
    });

  });
}
