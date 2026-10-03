import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for HealthApi
void main() {
  final instance = ApiClientDart().getHealthApi();

  group(HealthApi, () {
    //Future<HealthResponseDtoOutput> appControllerHealth() async
    test('test appControllerHealth', () async {
      // TODO
    });

    //Future<MongoHealthResponseDtoOutput> appControllerMongo() async
    test('test appControllerMongo', () async {
      // TODO
    });

    //Future<PostgresHealthResponseDtoOutput> appControllerPostgres() async
    test('test appControllerPostgres', () async {
      // TODO
    });

    //Future<QueueHealthResponseDtoOutput> appControllerQueues() async
    test('test appControllerQueues', () async {
      // TODO
    });

    //Future<RedisHealthResponseDtoOutput> appControllerRedis() async
    test('test appControllerRedis', () async {
      // TODO
    });

  });
}
