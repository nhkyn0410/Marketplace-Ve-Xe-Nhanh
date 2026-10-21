//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'seat_hold_response_dto_output_pickup.g.dart';

/// SeatHoldResponseDtoOutputPickup
///
/// Properties:
/// * [sequence] 
/// * [name] 
/// * [plannedAt] 
@BuiltValue()
abstract class SeatHoldResponseDtoOutputPickup implements Built<SeatHoldResponseDtoOutputPickup, SeatHoldResponseDtoOutputPickupBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'plannedAt')
  DateTime get plannedAt;

  SeatHoldResponseDtoOutputPickup._();

  factory SeatHoldResponseDtoOutputPickup([void updates(SeatHoldResponseDtoOutputPickupBuilder b)]) = _$SeatHoldResponseDtoOutputPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SeatHoldResponseDtoOutputPickupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SeatHoldResponseDtoOutputPickup> get serializer => _$SeatHoldResponseDtoOutputPickupSerializer();
}

class _$SeatHoldResponseDtoOutputPickupSerializer implements PrimitiveSerializer<SeatHoldResponseDtoOutputPickup> {
  @override
  final Iterable<Type> types = const [SeatHoldResponseDtoOutputPickup, _$SeatHoldResponseDtoOutputPickup];

  @override
  final String wireName = r'SeatHoldResponseDtoOutputPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SeatHoldResponseDtoOutputPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'plannedAt';
    yield serializers.serialize(
      object.plannedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SeatHoldResponseDtoOutputPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SeatHoldResponseDtoOutputPickupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'plannedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.plannedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SeatHoldResponseDtoOutputPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SeatHoldResponseDtoOutputPickupBuilder();
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


