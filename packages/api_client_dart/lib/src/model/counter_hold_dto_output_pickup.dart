//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_hold_dto_output_pickup.g.dart';

/// CounterHoldDtoOutputPickup
///
/// Properties:
/// * [sequence] 
/// * [name] 
/// * [plannedAt] 
@BuiltValue()
abstract class CounterHoldDtoOutputPickup implements Built<CounterHoldDtoOutputPickup, CounterHoldDtoOutputPickupBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'plannedAt')
  DateTime get plannedAt;

  CounterHoldDtoOutputPickup._();

  factory CounterHoldDtoOutputPickup([void updates(CounterHoldDtoOutputPickupBuilder b)]) = _$CounterHoldDtoOutputPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterHoldDtoOutputPickupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterHoldDtoOutputPickup> get serializer => _$CounterHoldDtoOutputPickupSerializer();
}

class _$CounterHoldDtoOutputPickupSerializer implements PrimitiveSerializer<CounterHoldDtoOutputPickup> {
  @override
  final Iterable<Type> types = const [CounterHoldDtoOutputPickup, _$CounterHoldDtoOutputPickup];

  @override
  final String wireName = r'CounterHoldDtoOutputPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterHoldDtoOutputPickup object, {
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
    CounterHoldDtoOutputPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterHoldDtoOutputPickupBuilder result,
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
  CounterHoldDtoOutputPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterHoldDtoOutputPickupBuilder();
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


