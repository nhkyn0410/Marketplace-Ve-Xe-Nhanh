//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail_dto_output_decision_refund.g.dart';

/// DisputeDetailDtoOutputDecisionRefund
///
/// Properties:
/// * [refundId] 
/// * [refundCode] 
/// * [status] 
@BuiltValue()
abstract class DisputeDetailDtoOutputDecisionRefund implements Built<DisputeDetailDtoOutputDecisionRefund, DisputeDetailDtoOutputDecisionRefundBuilder> {
  @BuiltValueField(wireName: r'refundId')
  String get refundId;

  @BuiltValueField(wireName: r'refundCode')
  String get refundCode;

  @BuiltValueField(wireName: r'status')
  DisputeDetailDtoOutputDecisionRefundStatusEnum get status;
  // enum statusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  DisputeDetailDtoOutputDecisionRefund._();

  factory DisputeDetailDtoOutputDecisionRefund([void updates(DisputeDetailDtoOutputDecisionRefundBuilder b)]) = _$DisputeDetailDtoOutputDecisionRefund;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailDtoOutputDecisionRefundBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetailDtoOutputDecisionRefund> get serializer => _$DisputeDetailDtoOutputDecisionRefundSerializer();
}

class _$DisputeDetailDtoOutputDecisionRefundSerializer implements PrimitiveSerializer<DisputeDetailDtoOutputDecisionRefund> {
  @override
  final Iterable<Type> types = const [DisputeDetailDtoOutputDecisionRefund, _$DisputeDetailDtoOutputDecisionRefund];

  @override
  final String wireName = r'DisputeDetailDtoOutputDecisionRefund';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetailDtoOutputDecisionRefund object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refundId';
    yield serializers.serialize(
      object.refundId,
      specifiedType: const FullType(String),
    );
    yield r'refundCode';
    yield serializers.serialize(
      object.refundCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DisputeDetailDtoOutputDecisionRefundStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetailDtoOutputDecisionRefund object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailDtoOutputDecisionRefundBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refundId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundId = valueDes;
          break;
        case r'refundCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailDtoOutputDecisionRefundStatusEnum),
          ) as DisputeDetailDtoOutputDecisionRefundStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetailDtoOutputDecisionRefund deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailDtoOutputDecisionRefundBuilder();
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


class DisputeDetailDtoOutputDecisionRefundStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const DisputeDetailDtoOutputDecisionRefundStatusEnum REQUESTED = _$disputeDetailDtoOutputDecisionRefundStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const DisputeDetailDtoOutputDecisionRefundStatusEnum APPROVED = _$disputeDetailDtoOutputDecisionRefundStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const DisputeDetailDtoOutputDecisionRefundStatusEnum PROCESSING = _$disputeDetailDtoOutputDecisionRefundStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const DisputeDetailDtoOutputDecisionRefundStatusEnum SUCCESS = _$disputeDetailDtoOutputDecisionRefundStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const DisputeDetailDtoOutputDecisionRefundStatusEnum FAILED = _$disputeDetailDtoOutputDecisionRefundStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const DisputeDetailDtoOutputDecisionRefundStatusEnum REJECTED = _$disputeDetailDtoOutputDecisionRefundStatusEnum_REJECTED;

  static Serializer<DisputeDetailDtoOutputDecisionRefundStatusEnum> get serializer => _$disputeDetailDtoOutputDecisionRefundStatusEnumSerializer;

  const DisputeDetailDtoOutputDecisionRefundStatusEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputDecisionRefundStatusEnum> get values => _$disputeDetailDtoOutputDecisionRefundStatusEnumValues;
  static DisputeDetailDtoOutputDecisionRefundStatusEnum valueOf(String name) => _$disputeDetailDtoOutputDecisionRefundStatusEnumValueOf(name);
}

