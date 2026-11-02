//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_detail_dto_output_dispute.g.dart';

/// TicketDetailDtoOutputDispute
///
/// Properties:
/// * [disputeId] 
/// * [disputeCode] 
/// * [status] 
@BuiltValue()
abstract class TicketDetailDtoOutputDispute implements Built<TicketDetailDtoOutputDispute, TicketDetailDtoOutputDisputeBuilder> {
  @BuiltValueField(wireName: r'disputeId')
  String get disputeId;

  @BuiltValueField(wireName: r'disputeCode')
  String get disputeCode;

  @BuiltValueField(wireName: r'status')
  TicketDetailDtoOutputDisputeStatusEnum get status;
  // enum statusEnum {  OPEN,  WAITING_USER_EVIDENCE,  WAITING_OPERATOR_RESPONSE,  UNDER_REVIEW,  ESCALATED,  RESOLVED_REFUND,  RESOLVED_NO_REFUND,  CLOSED,  };

  TicketDetailDtoOutputDispute._();

  factory TicketDetailDtoOutputDispute([void updates(TicketDetailDtoOutputDisputeBuilder b)]) = _$TicketDetailDtoOutputDispute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketDetailDtoOutputDisputeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketDetailDtoOutputDispute> get serializer => _$TicketDetailDtoOutputDisputeSerializer();
}

class _$TicketDetailDtoOutputDisputeSerializer implements PrimitiveSerializer<TicketDetailDtoOutputDispute> {
  @override
  final Iterable<Type> types = const [TicketDetailDtoOutputDispute, _$TicketDetailDtoOutputDispute];

  @override
  final String wireName = r'TicketDetailDtoOutputDispute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketDetailDtoOutputDispute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'disputeId';
    yield serializers.serialize(
      object.disputeId,
      specifiedType: const FullType(String),
    );
    yield r'disputeCode';
    yield serializers.serialize(
      object.disputeCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TicketDetailDtoOutputDisputeStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketDetailDtoOutputDispute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketDetailDtoOutputDisputeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'disputeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.disputeId = valueDes;
          break;
        case r'disputeCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.disputeCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputDisputeStatusEnum),
          ) as TicketDetailDtoOutputDisputeStatusEnum;
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
  TicketDetailDtoOutputDispute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketDetailDtoOutputDisputeBuilder();
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


class TicketDetailDtoOutputDisputeStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const TicketDetailDtoOutputDisputeStatusEnum OPEN = _$ticketDetailDtoOutputDisputeStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'WAITING_USER_EVIDENCE')
  static const TicketDetailDtoOutputDisputeStatusEnum WAITING_USER_EVIDENCE = _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_USER_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR_RESPONSE')
  static const TicketDetailDtoOutputDisputeStatusEnum WAITING_OPERATOR_RESPONSE = _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_OPERATOR_RESPONSE;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const TicketDetailDtoOutputDisputeStatusEnum UNDER_REVIEW = _$ticketDetailDtoOutputDisputeStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const TicketDetailDtoOutputDisputeStatusEnum ESCALATED = _$ticketDetailDtoOutputDisputeStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED_REFUND')
  static const TicketDetailDtoOutputDisputeStatusEnum RESOLVED_REFUND = _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_REFUND;
  @BuiltValueEnumConst(wireName: r'RESOLVED_NO_REFUND')
  static const TicketDetailDtoOutputDisputeStatusEnum RESOLVED_NO_REFUND = _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const TicketDetailDtoOutputDisputeStatusEnum CLOSED = _$ticketDetailDtoOutputDisputeStatusEnum_CLOSED;

  static Serializer<TicketDetailDtoOutputDisputeStatusEnum> get serializer => _$ticketDetailDtoOutputDisputeStatusEnumSerializer;

  const TicketDetailDtoOutputDisputeStatusEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputDisputeStatusEnum> get values => _$ticketDetailDtoOutputDisputeStatusEnumValues;
  static TicketDetailDtoOutputDisputeStatusEnum valueOf(String name) => _$ticketDetailDtoOutputDisputeStatusEnumValueOf(name);
}

