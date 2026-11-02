import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AdminReviewsApi
void main() {
  final instance = ApiClientDart().getAdminReviewsApi();

  group(AdminReviewsApi, () {
    //Future<ReviewPageDtoOutput> adminReviewControllerList({ String status, String operatorId, num rating, String q, String cursor, num limit }) async
    test('test adminReviewControllerList', () async {
      // TODO
    });

    //Future<ReviewDtoOutput> adminReviewControllerModerate(String reviewId, ModerationInputDto moderationInputDto) async
    test('test adminReviewControllerModerate', () async {
      // TODO
    });

  });
}
