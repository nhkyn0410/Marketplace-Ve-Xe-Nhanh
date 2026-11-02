//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/ticket_detail_dto_output_dispute.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/ticket_detail_dto_output_payments_inner.dart';
import 'package:api_client_dart/src/model/operator_booking_page_dto_output_items_inner_trip.dart';
import 'package:api_client_dart/src/model/ticket_detail_dto_output_messages_inner.dart';
import 'package:api_client_dart/src/model/customer_ticket_list_dto_output_items_inner_assignee.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_detail_dto_output.g.dart';

/// TicketDetailDtoOutput
///
/// Properties:
/// * [ticketId] 
/// * [ticketCode] 
/// * [subject] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [operatorId] 
/// * [operatorName] 
/// * [reporterParty] 
/// * [reporterName] 
/// * [category] 
/// * [priority] 
/// * [handler] 
/// * [status] 
/// * [assignee] 
/// * [disputeId] 
/// * [createdAt] 
/// * [lastMessageAt] 
/// * [requestedPriority] 
/// * [contactEmailMasked] 
/// * [trip] 
/// * [messages] 
/// * [payments] 
/// * [validTickets] 
/// * [dispute] 
@BuiltValue()
abstract class TicketDetailDtoOutput implements Built<TicketDetailDtoOutput, TicketDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'subject')
  String get subject;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'reporterParty')
  TicketDetailDtoOutputReporterPartyEnum get reporterParty;
  // enum reporterPartyEnum {  PASSENGER,  GUEST,  OPERATOR,  PLATFORM,  SYSTEM,  };

  @BuiltValueField(wireName: r'reporterName')
  String get reporterName;

  @BuiltValueField(wireName: r'category')
  TicketDetailDtoOutputCategoryEnum get category;
  // enum categoryEnum {  PAYMENT_REFUND,  SCHEDULE,  SERVICE_QUALITY,  TICKET_CHANGE,  OTHER,  };

  @BuiltValueField(wireName: r'priority')
  TicketDetailDtoOutputPriorityEnum get priority;
  // enum priorityEnum {  LOW,  MEDIUM,  HIGH,  URGENT,  };

  @BuiltValueField(wireName: r'handler')
  TicketDetailDtoOutputHandlerEnum get handler;
  // enum handlerEnum {  PLATFORM,  OPERATOR,  };

  @BuiltValueField(wireName: r'status')
  TicketDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  NEW,  IN_PROGRESS,  WAITING_OPERATOR,  WAITING_CUSTOMER,  ESCALATED,  RESOLVED,  CLOSED,  };

  @BuiltValueField(wireName: r'assignee')
  CustomerTicketListDtoOutputItemsInnerAssignee? get assignee;

  @BuiltValueField(wireName: r'disputeId')
  String? get disputeId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lastMessageAt')
  DateTime get lastMessageAt;

  @BuiltValueField(wireName: r'requestedPriority')
  TicketDetailDtoOutputRequestedPriorityEnum get requestedPriority;
  // enum requestedPriorityEnum {  LOW,  MEDIUM,  HIGH,  URGENT,  };

  @BuiltValueField(wireName: r'contactEmailMasked')
  String? get contactEmailMasked;

  @BuiltValueField(wireName: r'trip')
  OperatorBookingPageDtoOutputItemsInnerTrip get trip;

  @BuiltValueField(wireName: r'messages')
  BuiltList<TicketDetailDtoOutputMessagesInner> get messages;

  @BuiltValueField(wireName: r'payments')
  BuiltList<TicketDetailDtoOutputPaymentsInner> get payments;

  @BuiltValueField(wireName: r'validTickets')
  int get validTickets;

  @BuiltValueField(wireName: r'dispute')
  TicketDetailDtoOutputDispute? get dispute;

  TicketDetailDtoOutput._();

  factory TicketDetailDtoOutput([void updates(TicketDetailDtoOutputBuilder b)]) = _$TicketDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketDetailDtoOutput> get serializer => _$TicketDetailDtoOutputSerializer();
}

class _$TicketDetailDtoOutputSerializer implements PrimitiveSerializer<TicketDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketDetailDtoOutput, _$TicketDetailDtoOutput];

  @override
  final String wireName = r'TicketDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
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
    yield r'reporterParty';
    yield serializers.serialize(
      object.reporterParty,
      specifiedType: const FullType(TicketDetailDtoOutputReporterPartyEnum),
    );
    yield r'reporterName';
    yield serializers.serialize(
      object.reporterName,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(TicketDetailDtoOutputCategoryEnum),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(TicketDetailDtoOutputPriorityEnum),
    );
    yield r'handler';
    yield serializers.serialize(
      object.handler,
      specifiedType: const FullType(TicketDetailDtoOutputHandlerEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TicketDetailDtoOutputStatusEnum),
    );
    yield r'assignee';
    yield object.assignee == null ? null : serializers.serialize(
      object.assignee,
      specifiedType: const FullType.nullable(CustomerTicketListDtoOutputItemsInnerAssignee),
    );
    yield r'disputeId';
    yield object.disputeId == null ? null : serializers.serialize(
      object.disputeId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastMessageAt';
    yield serializers.serialize(
      object.lastMessageAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'requestedPriority';
    yield serializers.serialize(
      object.requestedPriority,
      specifiedType: const FullType(TicketDetailDtoOutputRequestedPriorityEnum),
    );
    yield r'contactEmailMasked';
    yield object.contactEmailMasked == null ? null : serializers.serialize(
      object.contactEmailMasked,
      specifiedType: const FullType.nullable(String),
    );
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerTrip),
    );
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputMessagesInner)]),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputPaymentsInner)]),
    );
    yield r'validTickets';
    yield serializers.serialize(
      object.validTickets,
      specifiedType: const FullType(int),
    );
    yield r'dispute';
    yield object.dispute == null ? null : serializers.serialize(
      object.dispute,
      specifiedType: const FullType.nullable(TicketDetailDtoOutputDispute),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketDetailDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketId = valueDes;
          break;
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
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
        case r'reporterParty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputReporterPartyEnum),
          ) as TicketDetailDtoOutputReporterPartyEnum;
          result.reporterParty = valueDes;
          break;
        case r'reporterName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reporterName = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputCategoryEnum),
          ) as TicketDetailDtoOutputCategoryEnum;
          result.category = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputPriorityEnum),
          ) as TicketDetailDtoOutputPriorityEnum;
          result.priority = valueDes;
          break;
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputHandlerEnum),
          ) as TicketDetailDtoOutputHandlerEnum;
          result.handler = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputStatusEnum),
          ) as TicketDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'assignee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomerTicketListDtoOutputItemsInnerAssignee),
          ) as CustomerTicketListDtoOutputItemsInnerAssignee?;
          if (valueDes == null) continue;
          result.assignee.replace(valueDes);
          break;
        case r'disputeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.disputeId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'lastMessageAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastMessageAt = valueDes;
          break;
        case r'requestedPriority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputRequestedPriorityEnum),
          ) as TicketDetailDtoOutputRequestedPriorityEnum;
          result.requestedPriority = valueDes;
          break;
        case r'contactEmailMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactEmailMasked = valueDes;
          break;
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerTrip),
          ) as OperatorBookingPageDtoOutputItemsInnerTrip;
          result.trip.replace(valueDes);
          break;
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputMessagesInner)]),
          ) as BuiltList<TicketDetailDtoOutputMessagesInner>;
          result.messages.replace(valueDes);
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputPaymentsInner)]),
          ) as BuiltList<TicketDetailDtoOutputPaymentsInner>;
          result.payments.replace(valueDes);
          break;
        case r'validTickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.validTickets = valueDes;
          break;
        case r'dispute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TicketDetailDtoOutputDispute),
          ) as TicketDetailDtoOutputDispute?;
          if (valueDes == null) continue;
          result.dispute.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketDetailDtoOutputBuilder();
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


class TicketDetailDtoOutputReporterPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const TicketDetailDtoOutputReporterPartyEnum PASSENGER = _$ticketDetailDtoOutputReporterPartyEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'GUEST')
  static const TicketDetailDtoOutputReporterPartyEnum GUEST = _$ticketDetailDtoOutputReporterPartyEnum_GUEST;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const TicketDetailDtoOutputReporterPartyEnum OPERATOR = _$ticketDetailDtoOutputReporterPartyEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const TicketDetailDtoOutputReporterPartyEnum PLATFORM = _$ticketDetailDtoOutputReporterPartyEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const TicketDetailDtoOutputReporterPartyEnum SYSTEM = _$ticketDetailDtoOutputReporterPartyEnum_SYSTEM;

  static Serializer<TicketDetailDtoOutputReporterPartyEnum> get serializer => _$ticketDetailDtoOutputReporterPartyEnumSerializer;

  const TicketDetailDtoOutputReporterPartyEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputReporterPartyEnum> get values => _$ticketDetailDtoOutputReporterPartyEnumValues;
  static TicketDetailDtoOutputReporterPartyEnum valueOf(String name) => _$ticketDetailDtoOutputReporterPartyEnumValueOf(name);
}

class TicketDetailDtoOutputCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAYMENT_REFUND')
  static const TicketDetailDtoOutputCategoryEnum PAYMENT_REFUND = _$ticketDetailDtoOutputCategoryEnum_PAYMENT_REFUND;
  @BuiltValueEnumConst(wireName: r'SCHEDULE')
  static const TicketDetailDtoOutputCategoryEnum SCHEDULE = _$ticketDetailDtoOutputCategoryEnum_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'SERVICE_QUALITY')
  static const TicketDetailDtoOutputCategoryEnum SERVICE_QUALITY = _$ticketDetailDtoOutputCategoryEnum_SERVICE_QUALITY;
  @BuiltValueEnumConst(wireName: r'TICKET_CHANGE')
  static const TicketDetailDtoOutputCategoryEnum TICKET_CHANGE = _$ticketDetailDtoOutputCategoryEnum_TICKET_CHANGE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const TicketDetailDtoOutputCategoryEnum OTHER = _$ticketDetailDtoOutputCategoryEnum_OTHER;

  static Serializer<TicketDetailDtoOutputCategoryEnum> get serializer => _$ticketDetailDtoOutputCategoryEnumSerializer;

  const TicketDetailDtoOutputCategoryEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputCategoryEnum> get values => _$ticketDetailDtoOutputCategoryEnumValues;
  static TicketDetailDtoOutputCategoryEnum valueOf(String name) => _$ticketDetailDtoOutputCategoryEnumValueOf(name);
}

class TicketDetailDtoOutputPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOW')
  static const TicketDetailDtoOutputPriorityEnum LOW = _$ticketDetailDtoOutputPriorityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const TicketDetailDtoOutputPriorityEnum MEDIUM = _$ticketDetailDtoOutputPriorityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const TicketDetailDtoOutputPriorityEnum HIGH = _$ticketDetailDtoOutputPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'URGENT')
  static const TicketDetailDtoOutputPriorityEnum URGENT = _$ticketDetailDtoOutputPriorityEnum_URGENT;

  static Serializer<TicketDetailDtoOutputPriorityEnum> get serializer => _$ticketDetailDtoOutputPriorityEnumSerializer;

  const TicketDetailDtoOutputPriorityEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputPriorityEnum> get values => _$ticketDetailDtoOutputPriorityEnumValues;
  static TicketDetailDtoOutputPriorityEnum valueOf(String name) => _$ticketDetailDtoOutputPriorityEnumValueOf(name);
}

class TicketDetailDtoOutputHandlerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const TicketDetailDtoOutputHandlerEnum PLATFORM = _$ticketDetailDtoOutputHandlerEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const TicketDetailDtoOutputHandlerEnum OPERATOR = _$ticketDetailDtoOutputHandlerEnum_OPERATOR;

  static Serializer<TicketDetailDtoOutputHandlerEnum> get serializer => _$ticketDetailDtoOutputHandlerEnumSerializer;

  const TicketDetailDtoOutputHandlerEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputHandlerEnum> get values => _$ticketDetailDtoOutputHandlerEnumValues;
  static TicketDetailDtoOutputHandlerEnum valueOf(String name) => _$ticketDetailDtoOutputHandlerEnumValueOf(name);
}

class TicketDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NEW')
  static const TicketDetailDtoOutputStatusEnum NEW = _$ticketDetailDtoOutputStatusEnum_NEW;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const TicketDetailDtoOutputStatusEnum IN_PROGRESS = _$ticketDetailDtoOutputStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR')
  static const TicketDetailDtoOutputStatusEnum WAITING_OPERATOR = _$ticketDetailDtoOutputStatusEnum_WAITING_OPERATOR;
  @BuiltValueEnumConst(wireName: r'WAITING_CUSTOMER')
  static const TicketDetailDtoOutputStatusEnum WAITING_CUSTOMER = _$ticketDetailDtoOutputStatusEnum_WAITING_CUSTOMER;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const TicketDetailDtoOutputStatusEnum ESCALATED = _$ticketDetailDtoOutputStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const TicketDetailDtoOutputStatusEnum RESOLVED = _$ticketDetailDtoOutputStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const TicketDetailDtoOutputStatusEnum CLOSED = _$ticketDetailDtoOutputStatusEnum_CLOSED;

  static Serializer<TicketDetailDtoOutputStatusEnum> get serializer => _$ticketDetailDtoOutputStatusEnumSerializer;

  const TicketDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputStatusEnum> get values => _$ticketDetailDtoOutputStatusEnumValues;
  static TicketDetailDtoOutputStatusEnum valueOf(String name) => _$ticketDetailDtoOutputStatusEnumValueOf(name);
}

class TicketDetailDtoOutputRequestedPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOW')
  static const TicketDetailDtoOutputRequestedPriorityEnum LOW = _$ticketDetailDtoOutputRequestedPriorityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const TicketDetailDtoOutputRequestedPriorityEnum MEDIUM = _$ticketDetailDtoOutputRequestedPriorityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const TicketDetailDtoOutputRequestedPriorityEnum HIGH = _$ticketDetailDtoOutputRequestedPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'URGENT')
  static const TicketDetailDtoOutputRequestedPriorityEnum URGENT = _$ticketDetailDtoOutputRequestedPriorityEnum_URGENT;

  static Serializer<TicketDetailDtoOutputRequestedPriorityEnum> get serializer => _$ticketDetailDtoOutputRequestedPriorityEnumSerializer;

  const TicketDetailDtoOutputRequestedPriorityEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputRequestedPriorityEnum> get values => _$ticketDetailDtoOutputRequestedPriorityEnumValues;
  static TicketDetailDtoOutputRequestedPriorityEnum valueOf(String name) => _$ticketDetailDtoOutputRequestedPriorityEnumValueOf(name);
}

