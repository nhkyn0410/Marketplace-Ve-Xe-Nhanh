import 'package:api_client_dart/api_client_dart.dart' as generated;
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/journey_activity/journey_activity_service.dart';
import 'package:passenger_mobile/features/journey_activity/journey_activity_snapshot.dart';

/// Client sinh từ Zod/OpenAPI, dùng cùng bearer refresh của ứng dụng.
class JourneyDemoApi implements JourneyDemoGateway {
  JourneyDemoApi(this._client);

  final generated.ApiClientDart _client;

  @override
  Future<JourneyActivitySnapshot> start(String bookingId, String deviceId) =>
      _call(() async {
        final response = await _client
            .getJourneyDemoApi()
            .journeyDemoControllerStart(
              journeyDemoStartDto: generated.JourneyDemoStartDto(
                (b) => b
                  ..bookingId = bookingId
                  ..deviceId = deviceId,
              ),
            );
        return _snapshot(response.data!);
      });

  @override
  Future<JourneyActivitySnapshot?> current(String deviceId) => _call(() async {
    final response = await _client
        .getJourneyDemoApi()
        .journeyDemoControllerCurrent(deviceId: deviceId);
    final data = response.data;
    return data == null ? null : _snapshot(data);
  });

  @override
  Future<void> stop(String sessionId) => _call(() async {
    await _client.getJourneyDemoApi().journeyDemoControllerStop(
      sessionId: sessionId,
    );
  });

  JourneyActivitySnapshot _snapshot(Object data) {
    final serialized = switch (data) {
      generated.JourneyDemoSnapshotDtoOutput value =>
        _client.serializers.serializeWith(
          generated.JourneyDemoSnapshotDtoOutput.serializer,
          value,
        ),
      generated.JourneyDemoCurrentDtoOutput value =>
        _client.serializers.serializeWith(
          generated.JourneyDemoCurrentDtoOutput.serializer,
          value,
        ),
      _ => throw const FormatException('Invalid journey demo response'),
    };
    final json = Map<String, dynamic>.from(serialized as Map);
    return JourneyActivitySnapshot.fromJson(json);
  }

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw toApiFailure(error, _client.serializers);
    }
  }
}
