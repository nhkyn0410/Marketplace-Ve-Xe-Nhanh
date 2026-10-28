//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_commission_settlement_input_dto.g.dart';

/// CounterCommissionSettlementInputDto
///
/// Properties:
/// * [operatorId] 
/// * [idempotencyKey] 
/// * [amount] 
/// * [reference] 
/// * [reason] 
@BuiltValue()
abstract class CounterCommissionSettlementInputDto implements Built<CounterCommissionSettlementInputDto, CounterCommissionSettlementInputDtoBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'idempotencyKey')
  String get idempotencyKey;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  CounterCommissionSettlementInputDto._();

  factory CounterCommissionSettlementInputDto([void updates(CounterCommissionSettlementInputDtoBuilder b)]) = _$CounterCommissionSettlementInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterCommissionSettlementInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterCommissionSettlementInputDto> get serializer => _$CounterCommissionSettlementInputDtoSerializer();
}

class _$CounterCommissionSettlementInputDtoSerializer implements PrimitiveSerializer<CounterCommissionSettlementInputDto> {
  @override
  final Iterable<Type> types = const [CounterCommissionSettlementInputDto, _$CounterCommissionSettlementInputDto];

  @override
  final String wireName = r'CounterCommissionSettlementInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterCommissionSettlementInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'idempotencyKey';
    yield serializers.serialize(
      object.idempotencyKey,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterCommissionSettlementInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterCommissionSettlementInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'idempotencyKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idempotencyKey = valueDes;
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
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterCommissionSettlementInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterCommissionSettlementInputDtoBuilder();
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


