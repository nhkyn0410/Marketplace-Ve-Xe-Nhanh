//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_ticket_input_dto_attachments_inner.g.dart';

/// CustomerTicketInputDtoAttachmentsInner
///
/// Properties:
/// * [objectKey] 
/// * [fileName] 
@BuiltValue()
abstract class CustomerTicketInputDtoAttachmentsInner implements Built<CustomerTicketInputDtoAttachmentsInner, CustomerTicketInputDtoAttachmentsInnerBuilder> {
  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  CustomerTicketInputDtoAttachmentsInner._();

  factory CustomerTicketInputDtoAttachmentsInner([void updates(CustomerTicketInputDtoAttachmentsInnerBuilder b)]) = _$CustomerTicketInputDtoAttachmentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerTicketInputDtoAttachmentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerTicketInputDtoAttachmentsInner> get serializer => _$CustomerTicketInputDtoAttachmentsInnerSerializer();
}

class _$CustomerTicketInputDtoAttachmentsInnerSerializer implements PrimitiveSerializer<CustomerTicketInputDtoAttachmentsInner> {
  @override
  final Iterable<Type> types = const [CustomerTicketInputDtoAttachmentsInner, _$CustomerTicketInputDtoAttachmentsInner];

  @override
  final String wireName = r'CustomerTicketInputDtoAttachmentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerTicketInputDtoAttachmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerTicketInputDtoAttachmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerTicketInputDtoAttachmentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'fileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerTicketInputDtoAttachmentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerTicketInputDtoAttachmentsInnerBuilder();
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


