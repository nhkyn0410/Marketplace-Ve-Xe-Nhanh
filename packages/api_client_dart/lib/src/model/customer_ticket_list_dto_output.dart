//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/customer_ticket_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_ticket_list_dto_output.g.dart';

/// CustomerTicketListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class CustomerTicketListDtoOutput implements Built<CustomerTicketListDtoOutput, CustomerTicketListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CustomerTicketListDtoOutputItemsInner> get items;

  CustomerTicketListDtoOutput._();

  factory CustomerTicketListDtoOutput([void updates(CustomerTicketListDtoOutputBuilder b)]) = _$CustomerTicketListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerTicketListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerTicketListDtoOutput> get serializer => _$CustomerTicketListDtoOutputSerializer();
}

class _$CustomerTicketListDtoOutputSerializer implements PrimitiveSerializer<CustomerTicketListDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerTicketListDtoOutput, _$CustomerTicketListDtoOutput];

  @override
  final String wireName = r'CustomerTicketListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerTicketListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CustomerTicketListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerTicketListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerTicketListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CustomerTicketListDtoOutputItemsInner)]),
          ) as BuiltList<CustomerTicketListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerTicketListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerTicketListDtoOutputBuilder();
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


