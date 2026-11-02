//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/ticket_detail_dto_output_messages_inner_attachments_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail_dto_output_events_inner.g.dart';

/// DisputeDetailDtoOutputEventsInner
///
/// Properties:
/// * [eventId] 
/// * [kind] 
/// * [party] 
/// * [actorName] 
/// * [fromStatus] 
/// * [toStatus] 
/// * [body] 
/// * [target] 
/// * [dueAt] 
/// * [createdAt] 
/// * [attachments] 
@BuiltValue()
abstract class DisputeDetailDtoOutputEventsInner implements Built<DisputeDetailDtoOutputEventsInner, DisputeDetailDtoOutputEventsInnerBuilder> {
  @BuiltValueField(wireName: r'eventId')
  String get eventId;

  @BuiltValueField(wireName: r'kind')
  DisputeDetailDtoOutputEventsInnerKindEnum get kind;
  // enum kindEnum {  STATUS,  EVIDENCE,  REQUEST,  };

  @BuiltValueField(wireName: r'party')
  DisputeDetailDtoOutputEventsInnerPartyEnum get party;
  // enum partyEnum {  PASSENGER,  GUEST,  OPERATOR,  PLATFORM,  SYSTEM,  };

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  @BuiltValueField(wireName: r'fromStatus')
  DisputeDetailDtoOutputEventsInnerFromStatusEnum? get fromStatus;
  // enum fromStatusEnum {  OPEN,  WAITING_USER_EVIDENCE,  WAITING_OPERATOR_RESPONSE,  UNDER_REVIEW,  ESCALATED,  RESOLVED_REFUND,  RESOLVED_NO_REFUND,  CLOSED,  };

  @BuiltValueField(wireName: r'toStatus')
  DisputeDetailDtoOutputEventsInnerToStatusEnum? get toStatus;
  // enum toStatusEnum {  OPEN,  WAITING_USER_EVIDENCE,  WAITING_OPERATOR_RESPONSE,  UNDER_REVIEW,  ESCALATED,  RESOLVED_REFUND,  RESOLVED_NO_REFUND,  CLOSED,  };

  @BuiltValueField(wireName: r'body')
  String? get body;

  @BuiltValueField(wireName: r'target')
  DisputeDetailDtoOutputEventsInnerTargetEnum? get target;
  // enum targetEnum {  PASSENGER,  GUEST,  OPERATOR,  PLATFORM,  SYSTEM,  };

  @BuiltValueField(wireName: r'dueAt')
  DateTime? get dueAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<TicketDetailDtoOutputMessagesInnerAttachmentsInner> get attachments;

  DisputeDetailDtoOutputEventsInner._();

  factory DisputeDetailDtoOutputEventsInner([void updates(DisputeDetailDtoOutputEventsInnerBuilder b)]) = _$DisputeDetailDtoOutputEventsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailDtoOutputEventsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetailDtoOutputEventsInner> get serializer => _$DisputeDetailDtoOutputEventsInnerSerializer();
}

class _$DisputeDetailDtoOutputEventsInnerSerializer implements PrimitiveSerializer<DisputeDetailDtoOutputEventsInner> {
  @override
  final Iterable<Type> types = const [DisputeDetailDtoOutputEventsInner, _$DisputeDetailDtoOutputEventsInner];

  @override
  final String wireName = r'DisputeDetailDtoOutputEventsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetailDtoOutputEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'eventId';
    yield serializers.serialize(
      object.eventId,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(DisputeDetailDtoOutputEventsInnerKindEnum),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(DisputeDetailDtoOutputEventsInnerPartyEnum),
    );
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'fromStatus';
    yield object.fromStatus == null ? null : serializers.serialize(
      object.fromStatus,
      specifiedType: const FullType.nullable(DisputeDetailDtoOutputEventsInnerFromStatusEnum),
    );
    yield r'toStatus';
    yield object.toStatus == null ? null : serializers.serialize(
      object.toStatus,
      specifiedType: const FullType.nullable(DisputeDetailDtoOutputEventsInnerToStatusEnum),
    );
    yield r'body';
    yield object.body == null ? null : serializers.serialize(
      object.body,
      specifiedType: const FullType.nullable(String),
    );
    yield r'target';
    yield object.target == null ? null : serializers.serialize(
      object.target,
      specifiedType: const FullType.nullable(DisputeDetailDtoOutputEventsInnerTargetEnum),
    );
    yield r'dueAt';
    yield object.dueAt == null ? null : serializers.serialize(
      object.dueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'attachments';
    yield serializers.serialize(
      object.attachments,
      specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputMessagesInnerAttachmentsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetailDtoOutputEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailDtoOutputEventsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eventId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eventId = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailDtoOutputEventsInnerKindEnum),
          ) as DisputeDetailDtoOutputEventsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailDtoOutputEventsInnerPartyEnum),
          ) as DisputeDetailDtoOutputEventsInnerPartyEnum;
          result.party = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDetailDtoOutputEventsInnerFromStatusEnum),
          ) as DisputeDetailDtoOutputEventsInnerFromStatusEnum?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDetailDtoOutputEventsInnerToStatusEnum),
          ) as DisputeDetailDtoOutputEventsInnerToStatusEnum?;
          if (valueDes == null) continue;
          result.toStatus = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.body = valueDes;
          break;
        case r'target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDetailDtoOutputEventsInnerTargetEnum),
          ) as DisputeDetailDtoOutputEventsInnerTargetEnum?;
          if (valueDes == null) continue;
          result.target = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'attachments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputMessagesInnerAttachmentsInner)]),
          ) as BuiltList<TicketDetailDtoOutputMessagesInnerAttachmentsInner>;
          result.attachments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetailDtoOutputEventsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailDtoOutputEventsInnerBuilder();
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


class DisputeDetailDtoOutputEventsInnerKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STATUS')
  static const DisputeDetailDtoOutputEventsInnerKindEnum STATUS = _$disputeDetailDtoOutputEventsInnerKindEnum_STATUS;
  @BuiltValueEnumConst(wireName: r'EVIDENCE')
  static const DisputeDetailDtoOutputEventsInnerKindEnum EVIDENCE = _$disputeDetailDtoOutputEventsInnerKindEnum_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'REQUEST')
  static const DisputeDetailDtoOutputEventsInnerKindEnum REQUEST = _$disputeDetailDtoOutputEventsInnerKindEnum_REQUEST;

  static Serializer<DisputeDetailDtoOutputEventsInnerKindEnum> get serializer => _$disputeDetailDtoOutputEventsInnerKindEnumSerializer;

  const DisputeDetailDtoOutputEventsInnerKindEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputEventsInnerKindEnum> get values => _$disputeDetailDtoOutputEventsInnerKindEnumValues;
  static DisputeDetailDtoOutputEventsInnerKindEnum valueOf(String name) => _$disputeDetailDtoOutputEventsInnerKindEnumValueOf(name);
}

class DisputeDetailDtoOutputEventsInnerPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const DisputeDetailDtoOutputEventsInnerPartyEnum PASSENGER = _$disputeDetailDtoOutputEventsInnerPartyEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'GUEST')
  static const DisputeDetailDtoOutputEventsInnerPartyEnum GUEST = _$disputeDetailDtoOutputEventsInnerPartyEnum_GUEST;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const DisputeDetailDtoOutputEventsInnerPartyEnum OPERATOR = _$disputeDetailDtoOutputEventsInnerPartyEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const DisputeDetailDtoOutputEventsInnerPartyEnum PLATFORM = _$disputeDetailDtoOutputEventsInnerPartyEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const DisputeDetailDtoOutputEventsInnerPartyEnum SYSTEM = _$disputeDetailDtoOutputEventsInnerPartyEnum_SYSTEM;

  static Serializer<DisputeDetailDtoOutputEventsInnerPartyEnum> get serializer => _$disputeDetailDtoOutputEventsInnerPartyEnumSerializer;

  const DisputeDetailDtoOutputEventsInnerPartyEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputEventsInnerPartyEnum> get values => _$disputeDetailDtoOutputEventsInnerPartyEnumValues;
  static DisputeDetailDtoOutputEventsInnerPartyEnum valueOf(String name) => _$disputeDetailDtoOutputEventsInnerPartyEnumValueOf(name);
}

class DisputeDetailDtoOutputEventsInnerFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum OPEN = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'WAITING_USER_EVIDENCE')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum WAITING_USER_EVIDENCE = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_WAITING_USER_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR_RESPONSE')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum WAITING_OPERATOR_RESPONSE = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_WAITING_OPERATOR_RESPONSE;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum UNDER_REVIEW = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum ESCALATED = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED_REFUND')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum RESOLVED_REFUND = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_RESOLVED_REFUND;
  @BuiltValueEnumConst(wireName: r'RESOLVED_NO_REFUND')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum RESOLVED_NO_REFUND = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_RESOLVED_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const DisputeDetailDtoOutputEventsInnerFromStatusEnum CLOSED = _$disputeDetailDtoOutputEventsInnerFromStatusEnum_CLOSED;

  static Serializer<DisputeDetailDtoOutputEventsInnerFromStatusEnum> get serializer => _$disputeDetailDtoOutputEventsInnerFromStatusEnumSerializer;

  const DisputeDetailDtoOutputEventsInnerFromStatusEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputEventsInnerFromStatusEnum> get values => _$disputeDetailDtoOutputEventsInnerFromStatusEnumValues;
  static DisputeDetailDtoOutputEventsInnerFromStatusEnum valueOf(String name) => _$disputeDetailDtoOutputEventsInnerFromStatusEnumValueOf(name);
}

class DisputeDetailDtoOutputEventsInnerToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum OPEN = _$disputeDetailDtoOutputEventsInnerToStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'WAITING_USER_EVIDENCE')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum WAITING_USER_EVIDENCE = _$disputeDetailDtoOutputEventsInnerToStatusEnum_WAITING_USER_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR_RESPONSE')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum WAITING_OPERATOR_RESPONSE = _$disputeDetailDtoOutputEventsInnerToStatusEnum_WAITING_OPERATOR_RESPONSE;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum UNDER_REVIEW = _$disputeDetailDtoOutputEventsInnerToStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum ESCALATED = _$disputeDetailDtoOutputEventsInnerToStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED_REFUND')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum RESOLVED_REFUND = _$disputeDetailDtoOutputEventsInnerToStatusEnum_RESOLVED_REFUND;
  @BuiltValueEnumConst(wireName: r'RESOLVED_NO_REFUND')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum RESOLVED_NO_REFUND = _$disputeDetailDtoOutputEventsInnerToStatusEnum_RESOLVED_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const DisputeDetailDtoOutputEventsInnerToStatusEnum CLOSED = _$disputeDetailDtoOutputEventsInnerToStatusEnum_CLOSED;

  static Serializer<DisputeDetailDtoOutputEventsInnerToStatusEnum> get serializer => _$disputeDetailDtoOutputEventsInnerToStatusEnumSerializer;

  const DisputeDetailDtoOutputEventsInnerToStatusEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputEventsInnerToStatusEnum> get values => _$disputeDetailDtoOutputEventsInnerToStatusEnumValues;
  static DisputeDetailDtoOutputEventsInnerToStatusEnum valueOf(String name) => _$disputeDetailDtoOutputEventsInnerToStatusEnumValueOf(name);
}

class DisputeDetailDtoOutputEventsInnerTargetEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const DisputeDetailDtoOutputEventsInnerTargetEnum PASSENGER = _$disputeDetailDtoOutputEventsInnerTargetEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'GUEST')
  static const DisputeDetailDtoOutputEventsInnerTargetEnum GUEST = _$disputeDetailDtoOutputEventsInnerTargetEnum_GUEST;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const DisputeDetailDtoOutputEventsInnerTargetEnum OPERATOR = _$disputeDetailDtoOutputEventsInnerTargetEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const DisputeDetailDtoOutputEventsInnerTargetEnum PLATFORM = _$disputeDetailDtoOutputEventsInnerTargetEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const DisputeDetailDtoOutputEventsInnerTargetEnum SYSTEM = _$disputeDetailDtoOutputEventsInnerTargetEnum_SYSTEM;

  static Serializer<DisputeDetailDtoOutputEventsInnerTargetEnum> get serializer => _$disputeDetailDtoOutputEventsInnerTargetEnumSerializer;

  const DisputeDetailDtoOutputEventsInnerTargetEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputEventsInnerTargetEnum> get values => _$disputeDetailDtoOutputEventsInnerTargetEnumValues;
  static DisputeDetailDtoOutputEventsInnerTargetEnum valueOf(String name) => _$disputeDetailDtoOutputEventsInnerTargetEnumValueOf(name);
}

