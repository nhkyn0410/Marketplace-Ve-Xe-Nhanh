//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_decision_input_dto.g.dart';

/// DisputeDecisionInputDto
///
/// Properties:
/// * [decision] 
/// * [amount] 
/// * [reason] 
@BuiltValue()
abstract class DisputeDecisionInputDto implements Built<DisputeDecisionInputDto, DisputeDecisionInputDtoBuilder> {
  @BuiltValueField(wireName: r'decision')
  DisputeDecisionInputDtoDecisionEnum get decision;
  // enum decisionEnum {  REFUND,  NO_REFUND,  OTHER,  };

  @BuiltValueField(wireName: r'amount')
  int? get amount;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  DisputeDecisionInputDto._();

  factory DisputeDecisionInputDto([void updates(DisputeDecisionInputDtoBuilder b)]) = _$DisputeDecisionInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDecisionInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDecisionInputDto> get serializer => _$DisputeDecisionInputDtoSerializer();
}

class _$DisputeDecisionInputDtoSerializer implements PrimitiveSerializer<DisputeDecisionInputDto> {
  @override
  final Iterable<Type> types = const [DisputeDecisionInputDto, _$DisputeDecisionInputDto];

  @override
  final String wireName = r'DisputeDecisionInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDecisionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(DisputeDecisionInputDtoDecisionEnum),
    );
    if (object.amount != null) {
      yield r'amount';
      yield serializers.serialize(
        object.amount,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDecisionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDecisionInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDecisionInputDtoDecisionEnum),
          ) as DisputeDecisionInputDtoDecisionEnum;
          result.decision = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amount = valueDes;
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
  DisputeDecisionInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDecisionInputDtoBuilder();
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


class DisputeDecisionInputDtoDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REFUND')
  static const DisputeDecisionInputDtoDecisionEnum REFUND = _$disputeDecisionInputDtoDecisionEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_REFUND')
  static const DisputeDecisionInputDtoDecisionEnum NO_REFUND = _$disputeDecisionInputDtoDecisionEnum_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const DisputeDecisionInputDtoDecisionEnum OTHER = _$disputeDecisionInputDtoDecisionEnum_OTHER;

  static Serializer<DisputeDecisionInputDtoDecisionEnum> get serializer => _$disputeDecisionInputDtoDecisionEnumSerializer;

  const DisputeDecisionInputDtoDecisionEnum._(String name): super(name);

  static BuiltSet<DisputeDecisionInputDtoDecisionEnum> get values => _$disputeDecisionInputDtoDecisionEnumValues;
  static DisputeDecisionInputDtoDecisionEnum valueOf(String name) => _$disputeDecisionInputDtoDecisionEnumValueOf(name);
}

