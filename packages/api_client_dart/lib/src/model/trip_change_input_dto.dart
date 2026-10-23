//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_change_input_dto_stops_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_change_input_dto.g.dart';

/// TripChangeInputDto
///
/// Properties:
/// * [departureAt] 
/// * [arrivalAt] 
/// * [stopTimes] 
/// * [vehicleId] 
/// * [stops] 
/// * [reason] 
@BuiltValue()
abstract class TripChangeInputDto implements Built<TripChangeInputDto, TripChangeInputDtoBuilder> {
  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'stopTimes')
  BuiltList<DateTime>? get stopTimes;

  @BuiltValueField(wireName: r'vehicleId')
  String get vehicleId;

  @BuiltValueField(wireName: r'stops')
  BuiltList<TripChangeInputDtoStopsInner> get stops;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  TripChangeInputDto._();

  factory TripChangeInputDto([void updates(TripChangeInputDtoBuilder b)]) = _$TripChangeInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripChangeInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripChangeInputDto> get serializer => _$TripChangeInputDtoSerializer();
}

class _$TripChangeInputDtoSerializer implements PrimitiveSerializer<TripChangeInputDto> {
  @override
  final Iterable<Type> types = const [TripChangeInputDto, _$TripChangeInputDto];

  @override
  final String wireName = r'TripChangeInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripChangeInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'arrivalAt';
    yield serializers.serialize(
      object.arrivalAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'stopTimes';
    yield object.stopTimes == null ? null : serializers.serialize(
      object.stopTimes,
      specifiedType: const FullType.nullable(BuiltList, [FullType(DateTime)]),
    );
    yield r'vehicleId';
    yield serializers.serialize(
      object.vehicleId,
      specifiedType: const FullType(String),
    );
    yield r'stops';
    yield serializers.serialize(
      object.stops,
      specifiedType: const FullType(BuiltList, [FullType(TripChangeInputDtoStopsInner)]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripChangeInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripChangeInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'arrivalAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.arrivalAt = valueDes;
          break;
        case r'stopTimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DateTime)]),
          ) as BuiltList<DateTime>?;
          if (valueDes == null) continue;
          result.stopTimes.replace(valueDes);
          break;
        case r'vehicleId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleId = valueDes;
          break;
        case r'stops':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripChangeInputDtoStopsInner)]),
          ) as BuiltList<TripChangeInputDtoStopsInner>;
          result.stops.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripChangeInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripChangeInputDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


