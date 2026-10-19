//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/customer_ticket_list_dto_output_items_inner_assignee.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_ticket_list_dto_output_items_inner.g.dart';

/// CustomerTicketListDtoOutputItemsInner
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
@BuiltValue()
abstract class CustomerTicketListDtoOutputItemsInner implements Built<CustomerTicketListDtoOutputItemsInner, CustomerTicketListDtoOutputItemsInnerBuilder> {
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
  CustomerTicketListDtoOutputItemsInnerReporterPartyEnum get reporterParty;
  // enum reporterPartyEnum {  PASSENGER,  GUEST,  OPERATOR,  PLATFORM,  SYSTEM,  };

  @BuiltValueField(wireName: r'reporterName')
  String get reporterName;

  @BuiltValueField(wireName: r'category')
  CustomerTicketListDtoOutputItemsInnerCategoryEnum get category;
  // enum categoryEnum {  PAYMENT_REFUND,  SCHEDULE,  SERVICE_QUALITY,  TICKET_CHANGE,  OTHER,  };

  @BuiltValueField(wireName: r'priority')
  CustomerTicketListDtoOutputItemsInnerPriorityEnum get priority;
  // enum priorityEnum {  LOW,  MEDIUM,  HIGH,  URGENT,  };

  @BuiltValueField(wireName: r'handler')
  CustomerTicketListDtoOutputItemsInnerHandlerEnum get handler;
  // enum handlerEnum {  PLATFORM,  OPERATOR,  };

  @BuiltValueField(wireName: r'status')
  CustomerTicketListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  NEW,  IN_PROGRESS,  WAITING_OPERATOR,  WAITING_CUSTOMER,  ESCALATED,  RESOLVED,  CLOSED,  };

  @BuiltValueField(wireName: r'assignee')
  CustomerTicketListDtoOutputItemsInnerAssignee? get assignee;

  @BuiltValueField(wireName: r'disputeId')
  String? get disputeId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lastMessageAt')
  DateTime get lastMessageAt;

  CustomerTicketListDtoOutputItemsInner._();

  factory CustomerTicketListDtoOutputItemsInner([void updates(CustomerTicketListDtoOutputItemsInnerBuilder b)]) = _$CustomerTicketListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerTicketListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerTicketListDtoOutputItemsInner> get serializer => _$CustomerTicketListDtoOutputItemsInnerSerializer();
}

class _$CustomerTicketListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<CustomerTicketListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [CustomerTicketListDtoOutputItemsInner, _$CustomerTicketListDtoOutputItemsInner];

  @override
  final String wireName = r'CustomerTicketListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerTicketListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerReporterPartyEnum),
    );
    yield r'reporterName';
    yield serializers.serialize(
      object.reporterName,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerCategoryEnum),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerPriorityEnum),
    );
    yield r'handler';
    yield serializers.serialize(
      object.handler,
      specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerHandlerEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerTicketListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerTicketListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerReporterPartyEnum),
          ) as CustomerTicketListDtoOutputItemsInnerReporterPartyEnum;
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
            specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerCategoryEnum),
          ) as CustomerTicketListDtoOutputItemsInnerCategoryEnum;
          result.category = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerPriorityEnum),
          ) as CustomerTicketListDtoOutputItemsInnerPriorityEnum;
          result.priority = valueDes;
          break;
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerHandlerEnum),
          ) as CustomerTicketListDtoOutputItemsInnerHandlerEnum;
          result.handler = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerTicketListDtoOutputItemsInnerStatusEnum),
          ) as CustomerTicketListDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerTicketListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerTicketListDtoOutputItemsInnerBuilder();
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


class CustomerTicketListDtoOutputItemsInnerReporterPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const CustomerTicketListDtoOutputItemsInnerReporterPartyEnum PASSENGER = _$customerTicketListDtoOutputItemsInnerReporterPartyEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'GUEST')
  static const CustomerTicketListDtoOutputItemsInnerReporterPartyEnum GUEST = _$customerTicketListDtoOutputItemsInnerReporterPartyEnum_GUEST;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const CustomerTicketListDtoOutputItemsInnerReporterPartyEnum OPERATOR = _$customerTicketListDtoOutputItemsInnerReporterPartyEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const CustomerTicketListDtoOutputItemsInnerReporterPartyEnum PLATFORM = _$customerTicketListDtoOutputItemsInnerReporterPartyEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const CustomerTicketListDtoOutputItemsInnerReporterPartyEnum SYSTEM = _$customerTicketListDtoOutputItemsInnerReporterPartyEnum_SYSTEM;

  static Serializer<CustomerTicketListDtoOutputItemsInnerReporterPartyEnum> get serializer => _$customerTicketListDtoOutputItemsInnerReporterPartyEnumSerializer;

  const CustomerTicketListDtoOutputItemsInnerReporterPartyEnum._(String name): super(name);

  static BuiltSet<CustomerTicketListDtoOutputItemsInnerReporterPartyEnum> get values => _$customerTicketListDtoOutputItemsInnerReporterPartyEnumValues;
  static CustomerTicketListDtoOutputItemsInnerReporterPartyEnum valueOf(String name) => _$customerTicketListDtoOutputItemsInnerReporterPartyEnumValueOf(name);
}

class CustomerTicketListDtoOutputItemsInnerCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAYMENT_REFUND')
  static const CustomerTicketListDtoOutputItemsInnerCategoryEnum PAYMENT_REFUND = _$customerTicketListDtoOutputItemsInnerCategoryEnum_PAYMENT_REFUND;
  @BuiltValueEnumConst(wireName: r'SCHEDULE')
  static const CustomerTicketListDtoOutputItemsInnerCategoryEnum SCHEDULE = _$customerTicketListDtoOutputItemsInnerCategoryEnum_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'SERVICE_QUALITY')
  static const CustomerTicketListDtoOutputItemsInnerCategoryEnum SERVICE_QUALITY = _$customerTicketListDtoOutputItemsInnerCategoryEnum_SERVICE_QUALITY;
  @BuiltValueEnumConst(wireName: r'TICKET_CHANGE')
  static const CustomerTicketListDtoOutputItemsInnerCategoryEnum TICKET_CHANGE = _$customerTicketListDtoOutputItemsInnerCategoryEnum_TICKET_CHANGE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const CustomerTicketListDtoOutputItemsInnerCategoryEnum OTHER = _$customerTicketListDtoOutputItemsInnerCategoryEnum_OTHER;

  static Serializer<CustomerTicketListDtoOutputItemsInnerCategoryEnum> get serializer => _$customerTicketListDtoOutputItemsInnerCategoryEnumSerializer;

  const CustomerTicketListDtoOutputItemsInnerCategoryEnum._(String name): super(name);

  static BuiltSet<CustomerTicketListDtoOutputItemsInnerCategoryEnum> get values => _$customerTicketListDtoOutputItemsInnerCategoryEnumValues;
  static CustomerTicketListDtoOutputItemsInnerCategoryEnum valueOf(String name) => _$customerTicketListDtoOutputItemsInnerCategoryEnumValueOf(name);
}

class CustomerTicketListDtoOutputItemsInnerPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOW')
  static const CustomerTicketListDtoOutputItemsInnerPriorityEnum LOW = _$customerTicketListDtoOutputItemsInnerPriorityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const CustomerTicketListDtoOutputItemsInnerPriorityEnum MEDIUM = _$customerTicketListDtoOutputItemsInnerPriorityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const CustomerTicketListDtoOutputItemsInnerPriorityEnum HIGH = _$customerTicketListDtoOutputItemsInnerPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'URGENT')
  static const CustomerTicketListDtoOutputItemsInnerPriorityEnum URGENT = _$customerTicketListDtoOutputItemsInnerPriorityEnum_URGENT;

  static Serializer<CustomerTicketListDtoOutputItemsInnerPriorityEnum> get serializer => _$customerTicketListDtoOutputItemsInnerPriorityEnumSerializer;

  const CustomerTicketListDtoOutputItemsInnerPriorityEnum._(String name): super(name);

  static BuiltSet<CustomerTicketListDtoOutputItemsInnerPriorityEnum> get values => _$customerTicketListDtoOutputItemsInnerPriorityEnumValues;
  static CustomerTicketListDtoOutputItemsInnerPriorityEnum valueOf(String name) => _$customerTicketListDtoOutputItemsInnerPriorityEnumValueOf(name);
}

class CustomerTicketListDtoOutputItemsInnerHandlerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const CustomerTicketListDtoOutputItemsInnerHandlerEnum PLATFORM = _$customerTicketListDtoOutputItemsInnerHandlerEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const CustomerTicketListDtoOutputItemsInnerHandlerEnum OPERATOR = _$customerTicketListDtoOutputItemsInnerHandlerEnum_OPERATOR;

  static Serializer<CustomerTicketListDtoOutputItemsInnerHandlerEnum> get serializer => _$customerTicketListDtoOutputItemsInnerHandlerEnumSerializer;

  const CustomerTicketListDtoOutputItemsInnerHandlerEnum._(String name): super(name);

  static BuiltSet<CustomerTicketListDtoOutputItemsInnerHandlerEnum> get values => _$customerTicketListDtoOutputItemsInnerHandlerEnumValues;
  static CustomerTicketListDtoOutputItemsInnerHandlerEnum valueOf(String name) => _$customerTicketListDtoOutputItemsInnerHandlerEnumValueOf(name);
}

class CustomerTicketListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NEW')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum NEW = _$customerTicketListDtoOutputItemsInnerStatusEnum_NEW;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum IN_PROGRESS = _$customerTicketListDtoOutputItemsInnerStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum WAITING_OPERATOR = _$customerTicketListDtoOutputItemsInnerStatusEnum_WAITING_OPERATOR;
  @BuiltValueEnumConst(wireName: r'WAITING_CUSTOMER')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum WAITING_CUSTOMER = _$customerTicketListDtoOutputItemsInnerStatusEnum_WAITING_CUSTOMER;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum ESCALATED = _$customerTicketListDtoOutputItemsInnerStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum RESOLVED = _$customerTicketListDtoOutputItemsInnerStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const CustomerTicketListDtoOutputItemsInnerStatusEnum CLOSED = _$customerTicketListDtoOutputItemsInnerStatusEnum_CLOSED;

  static Serializer<CustomerTicketListDtoOutputItemsInnerStatusEnum> get serializer => _$customerTicketListDtoOutputItemsInnerStatusEnumSerializer;

  const CustomerTicketListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CustomerTicketListDtoOutputItemsInnerStatusEnum> get values => _$customerTicketListDtoOutputItemsInnerStatusEnumValues;
  static CustomerTicketListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$customerTicketListDtoOutputItemsInnerStatusEnumValueOf(name);
}

