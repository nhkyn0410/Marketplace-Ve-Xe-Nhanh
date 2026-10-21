//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/dispute_detail_dto_output_decision.dart';
import 'package:api_client_dart/src/model/dispute_detail_dto_output_trip.dart';
import 'package:api_client_dart/src/model/dispute_detail_dto_output_cancellation_tiers_inner.dart';
import 'package:api_client_dart/src/model/customer_ticket_list_dto_output_items_inner_assignee.dart';
import 'package:api_client_dart/src/model/dispute_detail_dto_output_events_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail_dto_output.g.dart';

/// DisputeDetailDtoOutput
///
/// Properties:
/// * [disputeId] 
/// * [disputeCode] 
/// * [title] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [operatorId] 
/// * [operatorName] 
/// * [paidAmount] 
/// * [status] 
/// * [responseDueAt] 
/// * [overdue] 
/// * [assignee] 
/// * [supportTicketId] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [customerRequest] 
/// * [supportTicketCode] 
/// * [bookingTotal] 
/// * [refundableAmount] 
/// * [customerName] 
/// * [trip] 
/// * [firstCheckInAt] 
/// * [tripChangeNotified] 
/// * [cancellationTiers] 
/// * [events] 
/// * [decision] 
@BuiltValue()
abstract class DisputeDetailDtoOutput implements Built<DisputeDetailDtoOutput, DisputeDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'disputeId')
  String get disputeId;

  @BuiltValueField(wireName: r'disputeCode')
  String get disputeCode;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'paidAmount')
  int get paidAmount;

  @BuiltValueField(wireName: r'status')
  DisputeDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  OPEN,  WAITING_USER_EVIDENCE,  WAITING_OPERATOR_RESPONSE,  UNDER_REVIEW,  ESCALATED,  RESOLVED_REFUND,  RESOLVED_NO_REFUND,  CLOSED,  };

  @BuiltValueField(wireName: r'responseDueAt')
  DateTime? get responseDueAt;

  @BuiltValueField(wireName: r'overdue')
  bool get overdue;

  @BuiltValueField(wireName: r'assignee')
  CustomerTicketListDtoOutputItemsInnerAssignee? get assignee;

  @BuiltValueField(wireName: r'supportTicketId')
  String? get supportTicketId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'customerRequest')
  String? get customerRequest;

  @BuiltValueField(wireName: r'supportTicketCode')
  String? get supportTicketCode;

  @BuiltValueField(wireName: r'bookingTotal')
  int get bookingTotal;

  @BuiltValueField(wireName: r'refundableAmount')
  int get refundableAmount;

  @BuiltValueField(wireName: r'customerName')
  String get customerName;

  @BuiltValueField(wireName: r'trip')
  DisputeDetailDtoOutputTrip get trip;

  @BuiltValueField(wireName: r'firstCheckInAt')
  DateTime? get firstCheckInAt;

  @BuiltValueField(wireName: r'tripChangeNotified')
  bool get tripChangeNotified;

  @BuiltValueField(wireName: r'cancellationTiers')
  BuiltList<DisputeDetailDtoOutputCancellationTiersInner> get cancellationTiers;

  @BuiltValueField(wireName: r'events')
  BuiltList<DisputeDetailDtoOutputEventsInner> get events;

  @BuiltValueField(wireName: r'decision')
  DisputeDetailDtoOutputDecision? get decision;

  DisputeDetailDtoOutput._();

  factory DisputeDetailDtoOutput([void updates(DisputeDetailDtoOutputBuilder b)]) = _$DisputeDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetailDtoOutput> get serializer => _$DisputeDetailDtoOutputSerializer();
}

class _$DisputeDetailDtoOutputSerializer implements PrimitiveSerializer<DisputeDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [DisputeDetailDtoOutput, _$DisputeDetailDtoOutput];

  @override
  final String wireName = r'DisputeDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetailDtoOutput object, {
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
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'bookingCode';
    yield serializers.serialize(
      object.bookingCode,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'paidAmount';
    yield serializers.serialize(
      object.paidAmount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DisputeDetailDtoOutputStatusEnum),
    );
    yield r'responseDueAt';
    yield object.responseDueAt == null ? null : serializers.serialize(
      object.responseDueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'overdue';
    yield serializers.serialize(
      object.overdue,
      specifiedType: const FullType(bool),
    );
    yield r'assignee';
    yield object.assignee == null ? null : serializers.serialize(
      object.assignee,
      specifiedType: const FullType.nullable(CustomerTicketListDtoOutputItemsInnerAssignee),
    );
    yield r'supportTicketId';
    yield object.supportTicketId == null ? null : serializers.serialize(
      object.supportTicketId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'customerRequest';
    yield object.customerRequest == null ? null : serializers.serialize(
      object.customerRequest,
      specifiedType: const FullType.nullable(String),
    );
    yield r'supportTicketCode';
    yield object.supportTicketCode == null ? null : serializers.serialize(
      object.supportTicketCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bookingTotal';
    yield serializers.serialize(
      object.bookingTotal,
      specifiedType: const FullType(int),
    );
    yield r'refundableAmount';
    yield serializers.serialize(
      object.refundableAmount,
      specifiedType: const FullType(int),
    );
    yield r'customerName';
    yield serializers.serialize(
      object.customerName,
      specifiedType: const FullType(String),
    );
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(DisputeDetailDtoOutputTrip),
    );
    yield r'firstCheckInAt';
    yield object.firstCheckInAt == null ? null : serializers.serialize(
      object.firstCheckInAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'tripChangeNotified';
    yield serializers.serialize(
      object.tripChangeNotified,
      specifiedType: const FullType(bool),
    );
    yield r'cancellationTiers';
    yield serializers.serialize(
      object.cancellationTiers,
      specifiedType: const FullType(BuiltList, [FullType(DisputeDetailDtoOutputCancellationTiersInner)]),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(DisputeDetailDtoOutputEventsInner)]),
    );
    yield r'decision';
    yield object.decision == null ? null : serializers.serialize(
      object.decision,
      specifiedType: const FullType.nullable(DisputeDetailDtoOutputDecision),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailDtoOutputBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingCode = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'paidAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paidAmount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailDtoOutputStatusEnum),
          ) as DisputeDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'responseDueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.responseDueAt = valueDes;
          break;
        case r'overdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.overdue = valueDes;
          break;
        case r'assignee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomerTicketListDtoOutputItemsInnerAssignee),
          ) as CustomerTicketListDtoOutputItemsInnerAssignee?;
          if (valueDes == null) continue;
          result.assignee.replace(valueDes);
          break;
        case r'supportTicketId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supportTicketId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'customerRequest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customerRequest = valueDes;
          break;
        case r'supportTicketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supportTicketCode = valueDes;
          break;
        case r'bookingTotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingTotal = valueDes;
          break;
        case r'refundableAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundableAmount = valueDes;
          break;
        case r'customerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.customerName = valueDes;
          break;
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailDtoOutputTrip),
          ) as DisputeDetailDtoOutputTrip;
          result.trip.replace(valueDes);
          break;
        case r'firstCheckInAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.firstCheckInAt = valueDes;
          break;
        case r'tripChangeNotified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.tripChangeNotified = valueDes;
          break;
        case r'cancellationTiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeDetailDtoOutputCancellationTiersInner)]),
          ) as BuiltList<DisputeDetailDtoOutputCancellationTiersInner>;
          result.cancellationTiers.replace(valueDes);
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeDetailDtoOutputEventsInner)]),
          ) as BuiltList<DisputeDetailDtoOutputEventsInner>;
          result.events.replace(valueDes);
          break;
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDetailDtoOutputDecision),
          ) as DisputeDetailDtoOutputDecision?;
          if (valueDes == null) continue;
          result.decision.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailDtoOutputBuilder();
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


class DisputeDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputeDetailDtoOutputStatusEnum OPEN = _$disputeDetailDtoOutputStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'WAITING_USER_EVIDENCE')
  static const DisputeDetailDtoOutputStatusEnum WAITING_USER_EVIDENCE = _$disputeDetailDtoOutputStatusEnum_WAITING_USER_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR_RESPONSE')
  static const DisputeDetailDtoOutputStatusEnum WAITING_OPERATOR_RESPONSE = _$disputeDetailDtoOutputStatusEnum_WAITING_OPERATOR_RESPONSE;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const DisputeDetailDtoOutputStatusEnum UNDER_REVIEW = _$disputeDetailDtoOutputStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const DisputeDetailDtoOutputStatusEnum ESCALATED = _$disputeDetailDtoOutputStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED_REFUND')
  static const DisputeDetailDtoOutputStatusEnum RESOLVED_REFUND = _$disputeDetailDtoOutputStatusEnum_RESOLVED_REFUND;
  @BuiltValueEnumConst(wireName: r'RESOLVED_NO_REFUND')
  static const DisputeDetailDtoOutputStatusEnum RESOLVED_NO_REFUND = _$disputeDetailDtoOutputStatusEnum_RESOLVED_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const DisputeDetailDtoOutputStatusEnum CLOSED = _$disputeDetailDtoOutputStatusEnum_CLOSED;

  static Serializer<DisputeDetailDtoOutputStatusEnum> get serializer => _$disputeDetailDtoOutputStatusEnumSerializer;

  const DisputeDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<DisputeDetailDtoOutputStatusEnum> get values => _$disputeDetailDtoOutputStatusEnumValues;
  static DisputeDetailDtoOutputStatusEnum valueOf(String name) => _$disputeDetailDtoOutputStatusEnumValueOf(name);
}

