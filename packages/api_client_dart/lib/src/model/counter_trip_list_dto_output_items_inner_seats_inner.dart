//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_trip_list_dto_output_items_inner_seats_inner.g.dart';

/// CounterTripListDtoOutputItemsInnerSeatsInner
///
/// Properties:
/// * [code] 
/// * [type] 
/// * [status] 
/// * [price] 
@BuiltValue()
abstract class CounterTripListDtoOutputItemsInnerSeatsInner implements Built<CounterTripListDtoOutputItemsInnerSeatsInner, CounterTripListDtoOutputItemsInnerSeatsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'type')
  CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum get type;
  // enum typeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'price')
  String? get price;

  CounterTripListDtoOutputItemsInnerSeatsInner._();

  factory CounterTripListDtoOutputItemsInnerSeatsInner([void updates(CounterTripListDtoOutputItemsInnerSeatsInnerBuilder b)]) = _$CounterTripListDtoOutputItemsInnerSeatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterTripListDtoOutputItemsInnerSeatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterTripListDtoOutputItemsInnerSeatsInner> get serializer => _$CounterTripListDtoOutputItemsInnerSeatsInnerSerializer();
}

class _$CounterTripListDtoOutputItemsInnerSeatsInnerSerializer implements PrimitiveSerializer<CounterTripListDtoOutputItemsInnerSeatsInner> {
  @override
  final Iterable<Type> types = const [CounterTripListDtoOutputItemsInnerSeatsInner, _$CounterTripListDtoOutputItemsInnerSeatsInner];

  @override
  final String wireName = r'CounterTripListDtoOutputItemsInnerSeatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterTripListDtoOutputItemsInnerSeatsInner object, {
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
      specifiedType: const FullType(CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'price';
    yield object.price == null ? null : serializers.serialize(
      object.price,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterTripListDtoOutputItemsInnerSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterTripListDtoOutputItemsInnerSeatsInnerBuilder result,
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
            specifiedType: const FullType(CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum),
          ) as CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  CounterTripListDtoOutputItemsInnerSeatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterTripListDtoOutputItemsInnerSeatsInnerBuilder();
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


class CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum SEAT = _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum BED = _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum BED_DOUBLE = _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum CABIN = _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum CABIN_DOUBLE = _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN_DOUBLE;

  static Serializer<CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum> get serializer => _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnumSerializer;

  const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum._(String name): super(name);

  static BuiltSet<CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum> get values => _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnumValues;
  static CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum valueOf(String name) => _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnumValueOf(name);
}

