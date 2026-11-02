//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_departure_dto_output.g.dart';

/// TripDepartureDtoOutput
///
/// Properties:
/// * [tripId] 
/// * [departedAt] 
@BuiltValue()
abstract class TripDepartureDtoOutput implements Built<TripDepartureDtoOutput, TripDepartureDtoOutputBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'departedAt')
  DateTime get departedAt;

  TripDepartureDtoOutput._();

  factory TripDepartureDtoOutput([void updates(TripDepartureDtoOutputBuilder b)]) = _$TripDepartureDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripDepartureDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripDepartureDtoOutput> get serializer => _$TripDepartureDtoOutputSerializer();
}

class _$TripDepartureDtoOutputSerializer implements PrimitiveSerializer<TripDepartureDtoOutput> {
  @override
  final Iterable<Type> types = const [TripDepartureDtoOutput, _$TripDepartureDtoOutput];

  @override
  final String wireName = r'TripDepartureDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripDepartureDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'departedAt';
    yield serializers.serialize(
      object.departedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripDepartureDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripDepartureDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'departedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripDepartureDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripDepartureDtoOutputBuilder();
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


