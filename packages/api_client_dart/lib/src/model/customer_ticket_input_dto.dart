//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/customer_ticket_input_dto_attachments_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_ticket_input_dto.g.dart';

/// CustomerTicketInputDto
///
/// Properties:
/// * [category] 
/// * [priority] 
/// * [subject] 
/// * [body] 
/// * [attachments] 
@BuiltValue()
abstract class CustomerTicketInputDto implements Built<CustomerTicketInputDto, CustomerTicketInputDtoBuilder> {
  @BuiltValueField(wireName: r'category')
  CustomerTicketInputDtoCategoryEnum get category;
  // enum categoryEnum {  PAYMENT_REFUND,  SCHEDULE,  SERVICE_QUALITY,  TICKET_CHANGE,  OTHER,  };

  @BuiltValueField(wireName: r'priority')
  CustomerTicketInputDtoPriorityEnum? get priority;
  // enum priorityEnum {  LOW,  MEDIUM,  HIGH,  URGENT,  };

  @BuiltValueField(wireName: r'subject')
  String get subject;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<CustomerTicketInputDtoAttachmentsInner>? get attachments;

  CustomerTicketInputDto._();

  factory CustomerTicketInputDto([void updates(CustomerTicketInputDtoBuilder b)]) = _$CustomerTicketInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerTicketInputDtoBuilder b) => b
      ..priority = CustomerTicketInputDtoPriorityEnum.valueOf('MEDIUM')
      ..attachments = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerTicketInputDto> get serializer => _$CustomerTicketInputDtoSerializer();
}

class _$CustomerTicketInputDtoSerializer implements PrimitiveSerializer<CustomerTicketInputDto> {
  @override
  final Iterable<Type> types = const [CustomerTicketInputDto, _$CustomerTicketInputDto];

  @override
  final String wireName = r'CustomerTicketInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerTicketInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(CustomerTicketInputDtoCategoryEnum),
    );
    if (object.priority != null) {
      yield r'priority';
      yield serializers.serialize(
        object.priority,
        specifiedType: const FullType(CustomerTicketInputDtoPriorityEnum),
      );
    }
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    if (object.attachments != null) {
      yield r'attachments';
      yield serializers.serialize(
        object.attachments,
        specifiedType: const FullType(BuiltList, [FullType(CustomerTicketInputDtoAttachmentsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerTicketInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerTicketInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerTicketInputDtoCategoryEnum),
          ) as CustomerTicketInputDtoCategoryEnum;
          result.category = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomerTicketInputDtoPriorityEnum),
          ) as CustomerTicketInputDtoPriorityEnum?;
          if (valueDes == null) continue;
          result.priority = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'attachments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CustomerTicketInputDtoAttachmentsInner)]),
          ) as BuiltList<CustomerTicketInputDtoAttachmentsInner>?;
          if (valueDes == null) continue;
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
  CustomerTicketInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerTicketInputDtoBuilder();
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


class CustomerTicketInputDtoCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAYMENT_REFUND')
  static const CustomerTicketInputDtoCategoryEnum PAYMENT_REFUND = _$customerTicketInputDtoCategoryEnum_PAYMENT_REFUND;
  @BuiltValueEnumConst(wireName: r'SCHEDULE')
  static const CustomerTicketInputDtoCategoryEnum SCHEDULE = _$customerTicketInputDtoCategoryEnum_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'SERVICE_QUALITY')
  static const CustomerTicketInputDtoCategoryEnum SERVICE_QUALITY = _$customerTicketInputDtoCategoryEnum_SERVICE_QUALITY;
  @BuiltValueEnumConst(wireName: r'TICKET_CHANGE')
  static const CustomerTicketInputDtoCategoryEnum TICKET_CHANGE = _$customerTicketInputDtoCategoryEnum_TICKET_CHANGE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const CustomerTicketInputDtoCategoryEnum OTHER = _$customerTicketInputDtoCategoryEnum_OTHER;

  static Serializer<CustomerTicketInputDtoCategoryEnum> get serializer => _$customerTicketInputDtoCategoryEnumSerializer;

  const CustomerTicketInputDtoCategoryEnum._(String name): super(name);

  static BuiltSet<CustomerTicketInputDtoCategoryEnum> get values => _$customerTicketInputDtoCategoryEnumValues;
  static CustomerTicketInputDtoCategoryEnum valueOf(String name) => _$customerTicketInputDtoCategoryEnumValueOf(name);
}

class CustomerTicketInputDtoPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOW')
  static const CustomerTicketInputDtoPriorityEnum LOW = _$customerTicketInputDtoPriorityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const CustomerTicketInputDtoPriorityEnum MEDIUM = _$customerTicketInputDtoPriorityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const CustomerTicketInputDtoPriorityEnum HIGH = _$customerTicketInputDtoPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'URGENT')
  static const CustomerTicketInputDtoPriorityEnum URGENT = _$customerTicketInputDtoPriorityEnum_URGENT;

  static Serializer<CustomerTicketInputDtoPriorityEnum> get serializer => _$customerTicketInputDtoPriorityEnumSerializer;

  const CustomerTicketInputDtoPriorityEnum._(String name): super(name);

  static BuiltSet<CustomerTicketInputDtoPriorityEnum> get values => _$customerTicketInputDtoPriorityEnumValues;
  static CustomerTicketInputDtoPriorityEnum valueOf(String name) => _$customerTicketInputDtoPriorityEnumValueOf(name);
}

