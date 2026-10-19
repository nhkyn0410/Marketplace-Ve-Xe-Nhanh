//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'created_booking_dto_output_passengers_inner.g.dart';

/// CreatedBookingDtoOutputPassengersInner
///
/// Properties:
/// * [seatCode] 
/// * [seatType] 
/// * [fullName] 
/// * [phone] 
/// * [price] 
@BuiltValue()
abstract class CreatedBookingDtoOutputPassengersInner implements Built<CreatedBookingDtoOutputPassengersInner, CreatedBookingDtoOutputPassengersInnerBuilder> {
  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'seatType')
  CreatedBookingDtoOutputPassengersInnerSeatTypeEnum get seatType;
  // enum seatTypeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'price')
  int get price;

  CreatedBookingDtoOutputPassengersInner._();

  factory CreatedBookingDtoOutputPassengersInner([void updates(CreatedBookingDtoOutputPassengersInnerBuilder b)]) = _$CreatedBookingDtoOutputPassengersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputPassengersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutputPassengersInner> get serializer => _$CreatedBookingDtoOutputPassengersInnerSerializer();
}

class _$CreatedBookingDtoOutputPassengersInnerSerializer implements PrimitiveSerializer<CreatedBookingDtoOutputPassengersInner> {
  @override
  final Iterable<Type> types = const [CreatedBookingDtoOutputPassengersInner, _$CreatedBookingDtoOutputPassengersInner];

  @override
  final String wireName = r'CreatedBookingDtoOutputPassengersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'seatType';
    yield serializers.serialize(
      object.seatType,
      specifiedType: const FullType(CreatedBookingDtoOutputPassengersInnerSeatTypeEnum),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
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
    CreatedBookingDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputPassengersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'seatType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatedBookingDtoOutputPassengersInnerSeatTypeEnum),
          ) as CreatedBookingDtoOutputPassengersInnerSeatTypeEnum;
          result.seatType = valueDes;
          break;
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
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
  CreatedBookingDtoOutputPassengersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputPassengersInnerBuilder();
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


class CreatedBookingDtoOutputPassengersInnerSeatTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum SEAT = _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum BED = _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum BED_DOUBLE = _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum CABIN = _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum CABIN_DOUBLE = _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN_DOUBLE;

  static Serializer<CreatedBookingDtoOutputPassengersInnerSeatTypeEnum> get serializer => _$createdBookingDtoOutputPassengersInnerSeatTypeEnumSerializer;

  const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum._(String name): super(name);

  static BuiltSet<CreatedBookingDtoOutputPassengersInnerSeatTypeEnum> get values => _$createdBookingDtoOutputPassengersInnerSeatTypeEnumValues;
  static CreatedBookingDtoOutputPassengersInnerSeatTypeEnum valueOf(String name) => _$createdBookingDtoOutputPassengersInnerSeatTypeEnumValueOf(name);
}

