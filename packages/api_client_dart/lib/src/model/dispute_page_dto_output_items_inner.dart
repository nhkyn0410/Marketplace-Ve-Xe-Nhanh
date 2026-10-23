//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/customer_ticket_list_dto_output_items_inner_assignee.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_page_dto_output_items_inner.g.dart';

/// DisputePageDtoOutputItemsInner
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
@BuiltValue()
abstract class DisputePageDtoOutputItemsInner implements Built<DisputePageDtoOutputItemsInner, DisputePageDtoOutputItemsInnerBuilder> {
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
  DisputePageDtoOutputItemsInnerStatusEnum get status;
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

  DisputePageDtoOutputItemsInner._();

  factory DisputePageDtoOutputItemsInner([void updates(DisputePageDtoOutputItemsInnerBuilder b)]) = _$DisputePageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputePageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputePageDtoOutputItemsInner> get serializer => _$DisputePageDtoOutputItemsInnerSerializer();
}

class _$DisputePageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<DisputePageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [DisputePageDtoOutputItemsInner, _$DisputePageDtoOutputItemsInner];

  @override
  final String wireName = r'DisputePageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputePageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(DisputePageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputePageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(DisputePageDtoOutputItemsInnerStatusEnum),
          ) as DisputePageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputePageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputePageDtoOutputItemsInnerBuilder();
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


class DisputePageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputePageDtoOutputItemsInnerStatusEnum OPEN = _$disputePageDtoOutputItemsInnerStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'WAITING_USER_EVIDENCE')
  static const DisputePageDtoOutputItemsInnerStatusEnum WAITING_USER_EVIDENCE = _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_USER_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'WAITING_OPERATOR_RESPONSE')
  static const DisputePageDtoOutputItemsInnerStatusEnum WAITING_OPERATOR_RESPONSE = _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_OPERATOR_RESPONSE;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const DisputePageDtoOutputItemsInnerStatusEnum UNDER_REVIEW = _$disputePageDtoOutputItemsInnerStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const DisputePageDtoOutputItemsInnerStatusEnum ESCALATED = _$disputePageDtoOutputItemsInnerStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'RESOLVED_REFUND')
  static const DisputePageDtoOutputItemsInnerStatusEnum RESOLVED_REFUND = _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_REFUND;
  @BuiltValueEnumConst(wireName: r'RESOLVED_NO_REFUND')
  static const DisputePageDtoOutputItemsInnerStatusEnum RESOLVED_NO_REFUND = _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_NO_REFUND;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const DisputePageDtoOutputItemsInnerStatusEnum CLOSED = _$disputePageDtoOutputItemsInnerStatusEnum_CLOSED;

  static Serializer<DisputePageDtoOutputItemsInnerStatusEnum> get serializer => _$disputePageDtoOutputItemsInnerStatusEnumSerializer;

  const DisputePageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<DisputePageDtoOutputItemsInnerStatusEnum> get values => _$disputePageDtoOutputItemsInnerStatusEnumValues;
  static DisputePageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$disputePageDtoOutputItemsInnerStatusEnumValueOf(name);
}

