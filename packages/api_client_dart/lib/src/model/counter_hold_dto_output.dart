//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/counter_hold_dto_output_seats_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_hold_dto_output_pickup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_hold_dto_output.g.dart';

/// CounterHoldDtoOutput
///
/// Properties:
/// * [holdId] 
/// * [officeId] 
/// * [tripId] 
/// * [pickup] 
/// * [dropoff] 
/// * [seats] 
/// * [subtotal] 
/// * [expiresAt] 
@BuiltValue()
abstract class CounterHoldDtoOutput implements Built<CounterHoldDtoOutput, CounterHoldDtoOutputBuilder> {
  @BuiltValueField(wireName: r'holdId')
  String get holdId;

  @BuiltValueField(wireName: r'officeId')
  String get officeId;

  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'pickup')
  CounterHoldDtoOutputPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  CounterHoldDtoOutputPickup get dropoff;

  @BuiltValueField(wireName: r'seats')
  BuiltList<CounterHoldDtoOutputSeatsInner> get seats;

  @BuiltValueField(wireName: r'subtotal')
  String get subtotal;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  CounterHoldDtoOutput._();

  factory CounterHoldDtoOutput([void updates(CounterHoldDtoOutputBuilder b)]) = _$CounterHoldDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterHoldDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterHoldDtoOutput> get serializer => _$CounterHoldDtoOutputSerializer();
}

class _$CounterHoldDtoOutputSerializer implements PrimitiveSerializer<CounterHoldDtoOutput> {
  @override
  final Iterable<Type> types = const [CounterHoldDtoOutput, _$CounterHoldDtoOutput];

  @override
  final String wireName = r'CounterHoldDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterHoldDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'holdId';
    yield serializers.serialize(
      object.holdId,
      specifiedType: const FullType(String),
    );
    yield r'officeId';
    yield serializers.serialize(
      object.officeId,
      specifiedType: const FullType(String),
    );
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(CounterHoldDtoOutputPickup),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(CounterHoldDtoOutputPickup),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(BuiltList, [FullType(CounterHoldDtoOutputSeatsInner)]),
    );
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterHoldDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterHoldDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'holdId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.holdId = valueDes;
          break;
        case r'officeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.officeId = valueDes;
          break;
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterHoldDtoOutputPickup),
          ) as CounterHoldDtoOutputPickup;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterHoldDtoOutputPickup),
          ) as CounterHoldDtoOutputPickup;
          result.dropoff.replace(valueDes);
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterHoldDtoOutputSeatsInner)]),
          ) as BuiltList<CounterHoldDtoOutputSeatsInner>;
          result.seats.replace(valueDes);
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subtotal = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterHoldDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterHoldDtoOutputBuilder();
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


