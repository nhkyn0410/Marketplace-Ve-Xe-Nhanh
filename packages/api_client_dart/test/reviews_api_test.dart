import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for ReviewsApi
void main() {
  final instance = ApiClientDart().getReviewsApi();

  group(ReviewsApi, () {
    //Future<ReviewDtoOutput> customerReviewControllerCreate(String bookingId, ReviewInputDto reviewInputDto) async
    test('test customerReviewControllerCreate', () async {
      // TODO
    });

    //Future<CustomerReviewDtoOutput> customerReviewControllerGet(String bookingId) async
    test('test customerReviewControllerGet', () async {
      // TODO
    });

  });
}
