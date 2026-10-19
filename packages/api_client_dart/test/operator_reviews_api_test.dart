import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorReviewsApi
void main() {
  final instance = ApiClientDart().getOperatorReviewsApi();

  group(OperatorReviewsApi, () {
    //Future<ReviewPageDtoOutput> operatorReviewControllerList({ String routeId, num rating, String replied, String cursor, num limit }) async
    test('test operatorReviewControllerList', () async {
      // TODO
    });

    //Future<ReviewDtoOutput> operatorReviewControllerReply(String reviewId, ReplyInputDto replyInputDto) async
    test('test operatorReviewControllerReply', () async {
      // TODO
    });

    //Future<ReviewDtoOutput> operatorReviewControllerReport(String reviewId, ReportInputDto reportInputDto) async
    test('test operatorReviewControllerReport', () async {
      // TODO
    });

  });
}
