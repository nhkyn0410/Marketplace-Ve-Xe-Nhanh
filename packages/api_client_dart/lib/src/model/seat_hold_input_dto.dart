//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'seat_hold_input_dto.g.dart';

/// SeatHoldInputDto
///
/// Properties:
/// * [tripId] 
/// * [seatCodes] 
/// * [pickupSequence] 
/// * [dropoffSequence] 
@BuiltValue()
abstract class SeatHoldInputDto implements Built<SeatHoldInputDto, SeatHoldInputDtoBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'seatCodes')
  BuiltList<String> get seatCodes;

  @BuiltValueField(wireName: r'pickupSequence')
  int get pickupSequence;

  @BuiltValueField(wireName: r'dropoffSequence')
  int get dropoffSequence;

  SeatHoldInputDto._();

  factory SeatHoldInputDto([void updates(SeatHoldInputDtoBuilder b)]) = _$SeatHoldInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SeatHoldInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SeatHoldInputDto> get serializer => _$SeatHoldInputDtoSerializer();
}

class _$SeatHoldInputDtoSerializer implements PrimitiveSerializer<SeatHoldInputDto> {
  @override
  final Iterable<Type> types = const [SeatHoldInputDto, _$SeatHoldInputDto];

  @override
  final String wireName = r'SeatHoldInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SeatHoldInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'seatCodes';
    yield serializers.serialize(
      object.seatCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'pickupSequence';
    yield serializers.serialize(
      object.pickupSequence,
      specifiedType: const FullType(int),
    );
    yield r'dropoffSequence';
    yield serializers.serialize(
      object.dropoffSequence,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SeatHoldInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SeatHoldInputDtoBuilder result,
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
        case r'seatCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.seatCodes.replace(valueDes);
          break;
        case r'pickupSequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pickupSequence = valueDes;
          break;
        case r'dropoffSequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dropoffSequence = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SeatHoldInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SeatHoldInputDtoBuilder();
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


