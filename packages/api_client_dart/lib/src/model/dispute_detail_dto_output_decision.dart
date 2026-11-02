//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/dispute_detail_dto_output_decision_refund.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail_dto_output_decision.g.dart';

/// DisputeDetailDtoOutputDecision
///
/// Properties:
/// * [decision] 
/// * [amount] 
/// * [reason] 
/// * [decidedAt] 
/// * [refund] 
@BuiltValue()
abstract class DisputeDetailDtoOutputDecision implements Built<DisputeDetailDtoOutputDecision, DisputeDetailDtoOutputDecisionBuilder> {
  @BuiltValueField(wireName: r'decision')
  DisputeDetailDtoOutputDecisionDecisionEnum get decision;
  // enum decisionEnum {  REFUND,  NO_REFUND,  OTHER,  };

  @BuiltValueField(wireName: r'amount')
  int? get amount;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'decidedAt')
  DateTime get decidedAt;

  @BuiltValueField(wireName: r'refund')
  DisputeDetailDtoOutputDecisionRefund? get refund;

  DisputeDetailDtoOutputDecision._();

  factory DisputeDetailDtoOutputDecision([void updates(DisputeDetailDtoOutputDecisionBuilder b)]) = _$DisputeDetailDtoOutputDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailDtoOutputDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetailDtoOutputDecision> get serializer => _$DisputeDetailDtoOutputDecisionSerializer();
}

class _$DisputeDetailDtoOutputDecisionSerializer implements PrimitiveSerializer<DisputeDetailDtoOutputDecision> {
  @override
  final Iterable<Type> types = const [DisputeDetailDtoOutputDecision, _$DisputeDetailDtoOutputDecision];

  @override
  final String wireName = r'DisputeDetailDtoOutputDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetailDtoOutputDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(DisputeDetailDtoOutputDecisionDecisionEnum),
    );
    yield r'amount';
    yield object.amount == null ? null : serializers.serialize(
      object.amount,
      specifiedType: const FullType.nullable(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'decidedAt';
    yield serializers.serialize(
      object.decidedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'refund';
    yield object.refund == null ? null : serializers.serialize(
      object.refund,
      specifiedType: const FullType.nullable(DisputeDetailDtoOutputDecisionRefund),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetailDtoOutputDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailDtoOutputDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailDtoOutputDecisionDecisionEnum),
          ) as DisputeDetailDtoOutputDecisionDecisionEnum;
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
        case r'decidedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.decidedAt = valueDes;
          break;
        case r'refund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDetailDtoOutputDecisionRefund),
          ) as DisputeDetailDtoOutputDecisionRefund?;
          if (valueDes == null) continue;
          result.refund.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetailDtoOutputDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailDtoOutputDecisionBuilder();
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


class DisputeDetailDtoOutputDecisionDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REFUND')
  static const DisputeDetailDtoOutputDecisionDecisionEnum REFUND = _$disputeDetailDtoOutputDecisionDecisionEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_REFUND')
  static const DisputeDetailDtoOutputDecisionDecisionEnum NO_REFUND = _$disputeDetailDtoOutputDecisionDecisionEnum_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const DisputeDetailDtoOutputDecisionDecisionEnum OTHER = _$disputeDetailDtoOutputDecisionDecisionEnum_OTHER;

  static Serializer<DisputeDetailDtoOutputDecisionDecisionEnum> get serializer => _$disputeDetailDtoOutputDecisionDecisionEnumSerializer;

  const DisputeDetailDtoOutputDecisionDecisionEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputDecisionDecisionEnum> get values => _$disputeDetailDtoOutputDecisionDecisionEnumValues;
  static DisputeDetailDtoOutputDecisionDecisionEnum valueOf(String name) => _$disputeDetailDtoOutputDecisionDecisionEnumValueOf(name);
}

