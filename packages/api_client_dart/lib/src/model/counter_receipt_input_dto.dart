//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_receipt_input_dto.g.dart';

/// CounterReceiptInputDto
///
/// Properties:
/// * [idempotencyKey] 
/// * [method] 
/// * [amount] 
/// * [reference] 
@BuiltValue()
abstract class CounterReceiptInputDto implements Built<CounterReceiptInputDto, CounterReceiptInputDtoBuilder> {
  @BuiltValueField(wireName: r'idempotencyKey')
  String get idempotencyKey;

  @BuiltValueField(wireName: r'method')
  CounterReceiptInputDtoMethodEnum get method;
  // enum methodEnum {  CASH,  BANK_TRANSFER,  };

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reference')
  String? get reference;

  CounterReceiptInputDto._();

  factory CounterReceiptInputDto([void updates(CounterReceiptInputDtoBuilder b)]) = _$CounterReceiptInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterReceiptInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterReceiptInputDto> get serializer => _$CounterReceiptInputDtoSerializer();
}

class _$CounterReceiptInputDtoSerializer implements PrimitiveSerializer<CounterReceiptInputDto> {
  @override
  final Iterable<Type> types = const [CounterReceiptInputDto, _$CounterReceiptInputDto];

  @override
  final String wireName = r'CounterReceiptInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterReceiptInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'idempotencyKey';
    yield serializers.serialize(
      object.idempotencyKey,
      specifiedType: const FullType(String),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(CounterReceiptInputDtoMethodEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield object.reference == null ? null : serializers.serialize(
      object.reference,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterReceiptInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterReceiptInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idempotencyKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idempotencyKey = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterReceiptInputDtoMethodEnum),
          ) as CounterReceiptInputDtoMethodEnum;
          result.method = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterReceiptInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterReceiptInputDtoBuilder();
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


class CounterReceiptInputDtoMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CASH')
  static const CounterReceiptInputDtoMethodEnum CASH = _$counterReceiptInputDtoMethodEnum_CASH;
  @BuiltValueEnumConst(wireName: r'BANK_TRANSFER')
  static const CounterReceiptInputDtoMethodEnum BANK_TRANSFER = _$counterReceiptInputDtoMethodEnum_BANK_TRANSFER;

  static Serializer<CounterReceiptInputDtoMethodEnum> get serializer => _$counterReceiptInputDtoMethodEnumSerializer;

  const CounterReceiptInputDtoMethodEnum._(String name): super(name);

  static BuiltSet<CounterReceiptInputDtoMethodEnum> get values => _$counterReceiptInputDtoMethodEnumValues;
  static CounterReceiptInputDtoMethodEnum valueOf(String name) => _$counterReceiptInputDtoMethodEnumValueOf(name);
}

