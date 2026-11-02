//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'seat_hold_response_dto_output_seats_inner.g.dart';

/// SeatHoldResponseDtoOutputSeatsInner
///
/// Properties:
/// * [code] 
/// * [type] 
/// * [price] 
@BuiltValue()
abstract class SeatHoldResponseDtoOutputSeatsInner implements Built<SeatHoldResponseDtoOutputSeatsInner, SeatHoldResponseDtoOutputSeatsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'type')
  SeatHoldResponseDtoOutputSeatsInnerTypeEnum get type;
  // enum typeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'price')
  int get price;

  SeatHoldResponseDtoOutputSeatsInner._();

  factory SeatHoldResponseDtoOutputSeatsInner([void updates(SeatHoldResponseDtoOutputSeatsInnerBuilder b)]) = _$SeatHoldResponseDtoOutputSeatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SeatHoldResponseDtoOutputSeatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SeatHoldResponseDtoOutputSeatsInner> get serializer => _$SeatHoldResponseDtoOutputSeatsInnerSerializer();
}

class _$SeatHoldResponseDtoOutputSeatsInnerSerializer implements PrimitiveSerializer<SeatHoldResponseDtoOutputSeatsInner> {
  @override
  final Iterable<Type> types = const [SeatHoldResponseDtoOutputSeatsInner, _$SeatHoldResponseDtoOutputSeatsInner];

  @override
  final String wireName = r'SeatHoldResponseDtoOutputSeatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SeatHoldResponseDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SeatHoldResponseDtoOutputSeatsInnerTypeEnum),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SeatHoldResponseDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SeatHoldResponseDtoOutputSeatsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SeatHoldResponseDtoOutputSeatsInnerTypeEnum),
          ) as SeatHoldResponseDtoOutputSeatsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.price = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SeatHoldResponseDtoOutputSeatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SeatHoldResponseDtoOutputSeatsInnerBuilder();
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


class SeatHoldResponseDtoOutputSeatsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const SeatHoldResponseDtoOutputSeatsInnerTypeEnum SEAT = _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const SeatHoldResponseDtoOutputSeatsInnerTypeEnum BED = _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const SeatHoldResponseDtoOutputSeatsInnerTypeEnum BED_DOUBLE = _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const SeatHoldResponseDtoOutputSeatsInnerTypeEnum CABIN = _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const SeatHoldResponseDtoOutputSeatsInnerTypeEnum CABIN_DOUBLE = _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE;

  static Serializer<SeatHoldResponseDtoOutputSeatsInnerTypeEnum> get serializer => _$seatHoldResponseDtoOutputSeatsInnerTypeEnumSerializer;

  const SeatHoldResponseDtoOutputSeatsInnerTypeEnum._(String name): super(name);

  static BuiltSet<SeatHoldResponseDtoOutputSeatsInnerTypeEnum> get values => _$seatHoldResponseDtoOutputSeatsInnerTypeEnumValues;
  static SeatHoldResponseDtoOutputSeatsInnerTypeEnum valueOf(String name) => _$seatHoldResponseDtoOutputSeatsInnerTypeEnumValueOf(name);
}

