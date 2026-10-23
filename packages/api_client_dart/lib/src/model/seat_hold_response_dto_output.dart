//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/seat_hold_response_dto_output_seats_inner.dart';
import 'package:api_client_dart/src/model/seat_hold_response_dto_output_pickup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'seat_hold_response_dto_output.g.dart';

/// SeatHoldResponseDtoOutput
///
/// Properties:
/// * [holdId] 
/// * [tripId] 
/// * [pickup] 
/// * [dropoff] 
/// * [seats] 
/// * [subtotal] 
/// * [expiresAt] 
@BuiltValue()
abstract class SeatHoldResponseDtoOutput implements Built<SeatHoldResponseDtoOutput, SeatHoldResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'holdId')
  String get holdId;

  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'pickup')
  SeatHoldResponseDtoOutputPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  SeatHoldResponseDtoOutputPickup get dropoff;

  @BuiltValueField(wireName: r'seats')
  BuiltList<SeatHoldResponseDtoOutputSeatsInner> get seats;

  @BuiltValueField(wireName: r'subtotal')
  int get subtotal;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  SeatHoldResponseDtoOutput._();

  factory SeatHoldResponseDtoOutput([void updates(SeatHoldResponseDtoOutputBuilder b)]) = _$SeatHoldResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SeatHoldResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SeatHoldResponseDtoOutput> get serializer => _$SeatHoldResponseDtoOutputSerializer();
}

class _$SeatHoldResponseDtoOutputSerializer implements PrimitiveSerializer<SeatHoldResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [SeatHoldResponseDtoOutput, _$SeatHoldResponseDtoOutput];

  @override
  final String wireName = r'SeatHoldResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SeatHoldResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'holdId';
    yield serializers.serialize(
      object.holdId,
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
      specifiedType: const FullType(SeatHoldResponseDtoOutputPickup),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(SeatHoldResponseDtoOutputPickup),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(BuiltList, [FullType(SeatHoldResponseDtoOutputSeatsInner)]),
    );
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(int),
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
    SeatHoldResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SeatHoldResponseDtoOutputBuilder result,
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
            specifiedType: const FullType(SeatHoldResponseDtoOutputPickup),
          ) as SeatHoldResponseDtoOutputPickup;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SeatHoldResponseDtoOutputPickup),
          ) as SeatHoldResponseDtoOutputPickup;
          result.dropoff.replace(valueDes);
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SeatHoldResponseDtoOutputSeatsInner)]),
          ) as BuiltList<SeatHoldResponseDtoOutputSeatsInner>;
          result.seats.replace(valueDes);
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  SeatHoldResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SeatHoldResponseDtoOutputBuilder();
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


