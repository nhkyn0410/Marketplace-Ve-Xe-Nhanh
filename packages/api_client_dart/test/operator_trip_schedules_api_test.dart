import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for OperatorTripSchedulesApi
void main() {
  final instance = ApiClientDart().getOperatorTripSchedulesApi();

  group(OperatorTripSchedulesApi, () {
    //Future<TripScheduleResponseDtoOutput> tripScheduleControllerCreate(TripScheduleInputDto tripScheduleInputDto) async
    test('test tripScheduleControllerCreate', () async {
      // TODO
    });

    //Future<TripScheduleGenerateResponseDtoOutput> tripScheduleControllerGenerate(String scheduleId, TripScheduleGenerateInputDto tripScheduleGenerateInputDto) async
    test('test tripScheduleControllerGenerate', () async {
      // TODO
    });

    //Future<TripScheduleResponseDtoOutput> tripScheduleControllerGet(String scheduleId) async
    test('test tripScheduleControllerGet', () async {
      // TODO
    });

    //Future<TripScheduleListResponseDtoOutput> tripScheduleControllerList() async
    test('test tripScheduleControllerList', () async {
      // TODO
    });

    //Future<TripScheduleResponseDtoOutput> tripScheduleControllerUpdate(String scheduleId, TripScheduleInputDto tripScheduleInputDto) async
    test('test tripScheduleControllerUpdate', () async {
      // TODO
    });

  });
}
