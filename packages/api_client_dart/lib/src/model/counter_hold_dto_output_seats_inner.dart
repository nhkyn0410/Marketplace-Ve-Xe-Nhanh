//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_hold_dto_output_seats_inner.g.dart';

/// CounterHoldDtoOutputSeatsInner
///
/// Properties:
/// * [code] 
/// * [type] 
/// * [price] 
@BuiltValue()
abstract class CounterHoldDtoOutputSeatsInner implements Built<CounterHoldDtoOutputSeatsInner, CounterHoldDtoOutputSeatsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'type')
  CounterHoldDtoOutputSeatsInnerTypeEnum get type;
  // enum typeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'price')
  String get price;

  CounterHoldDtoOutputSeatsInner._();

  factory CounterHoldDtoOutputSeatsInner([void updates(CounterHoldDtoOutputSeatsInnerBuilder b)]) = _$CounterHoldDtoOutputSeatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterHoldDtoOutputSeatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterHoldDtoOutputSeatsInner> get serializer => _$CounterHoldDtoOutputSeatsInnerSerializer();
}

class _$CounterHoldDtoOutputSeatsInnerSerializer implements PrimitiveSerializer<CounterHoldDtoOutputSeatsInner> {
  @override
  final Iterable<Type> types = const [CounterHoldDtoOutputSeatsInner, _$CounterHoldDtoOutputSeatsInner];

  @override
  final String wireName = r'CounterHoldDtoOutputSeatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterHoldDtoOutputSeatsInner object, {
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
      specifiedType: const FullType(CounterHoldDtoOutputSeatsInnerTypeEnum),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterHoldDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterHoldDtoOutputSeatsInnerBuilder result,
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
            specifiedType: const FullType(CounterHoldDtoOutputSeatsInnerTypeEnum),
          ) as CounterHoldDtoOutputSeatsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  CounterHoldDtoOutputSeatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterHoldDtoOutputSeatsInnerBuilder();
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


class CounterHoldDtoOutputSeatsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const CounterHoldDtoOutputSeatsInnerTypeEnum SEAT = _$counterHoldDtoOutputSeatsInnerTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const CounterHoldDtoOutputSeatsInnerTypeEnum BED = _$counterHoldDtoOutputSeatsInnerTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const CounterHoldDtoOutputSeatsInnerTypeEnum BED_DOUBLE = _$counterHoldDtoOutputSeatsInnerTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const CounterHoldDtoOutputSeatsInnerTypeEnum CABIN = _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const CounterHoldDtoOutputSeatsInnerTypeEnum CABIN_DOUBLE = _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE;

  static Serializer<CounterHoldDtoOutputSeatsInnerTypeEnum> get serializer => _$counterHoldDtoOutputSeatsInnerTypeEnumSerializer;

  const CounterHoldDtoOutputSeatsInnerTypeEnum._(String name): super(name);

  static BuiltSet<CounterHoldDtoOutputSeatsInnerTypeEnum> get values => _$counterHoldDtoOutputSeatsInnerTypeEnumValues;
  static CounterHoldDtoOutputSeatsInnerTypeEnum valueOf(String name) => _$counterHoldDtoOutputSeatsInnerTypeEnumValueOf(name);
}

