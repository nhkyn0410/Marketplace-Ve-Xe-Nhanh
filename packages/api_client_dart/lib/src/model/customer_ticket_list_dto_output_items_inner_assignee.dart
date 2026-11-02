//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_ticket_list_dto_output_items_inner_assignee.g.dart';

/// CustomerTicketListDtoOutputItemsInnerAssignee
///
/// Properties:
/// * [id] 
/// * [username] 
@BuiltValue()
abstract class CustomerTicketListDtoOutputItemsInnerAssignee implements Built<CustomerTicketListDtoOutputItemsInnerAssignee, CustomerTicketListDtoOutputItemsInnerAssigneeBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  CustomerTicketListDtoOutputItemsInnerAssignee._();

  factory CustomerTicketListDtoOutputItemsInnerAssignee([void updates(CustomerTicketListDtoOutputItemsInnerAssigneeBuilder b)]) = _$CustomerTicketListDtoOutputItemsInnerAssignee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerTicketListDtoOutputItemsInnerAssigneeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerTicketListDtoOutputItemsInnerAssignee> get serializer => _$CustomerTicketListDtoOutputItemsInnerAssigneeSerializer();
}

class _$CustomerTicketListDtoOutputItemsInnerAssigneeSerializer implements PrimitiveSerializer<CustomerTicketListDtoOutputItemsInnerAssignee> {
  @override
  final Iterable<Type> types = const [CustomerTicketListDtoOutputItemsInnerAssignee, _$CustomerTicketListDtoOutputItemsInnerAssignee];

  @override
  final String wireName = r'CustomerTicketListDtoOutputItemsInnerAssignee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerTicketListDtoOutputItemsInnerAssignee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerTicketListDtoOutputItemsInnerAssignee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerTicketListDtoOutputItemsInnerAssigneeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerTicketListDtoOutputItemsInnerAssignee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerTicketListDtoOutputItemsInnerAssigneeBuilder();
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


