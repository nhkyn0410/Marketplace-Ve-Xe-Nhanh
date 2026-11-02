//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/customer_ticket_input_dto_attachments_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_message_input_dto.g.dart';

/// AdminMessageInputDto
///
/// Properties:
/// * [body] 
/// * [attachments] 
/// * [requestInfo] 
@BuiltValue()
abstract class AdminMessageInputDto implements Built<AdminMessageInputDto, AdminMessageInputDtoBuilder> {
  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<CustomerTicketInputDtoAttachmentsInner>? get attachments;

  @BuiltValueField(wireName: r'requestInfo')
  bool? get requestInfo;

  AdminMessageInputDto._();

  factory AdminMessageInputDto([void updates(AdminMessageInputDtoBuilder b)]) = _$AdminMessageInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMessageInputDtoBuilder b) => b
      ..attachments = ListBuilder()
      ..requestInfo = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMessageInputDto> get serializer => _$AdminMessageInputDtoSerializer();
}

class _$AdminMessageInputDtoSerializer implements PrimitiveSerializer<AdminMessageInputDto> {
  @override
  final Iterable<Type> types = const [AdminMessageInputDto, _$AdminMessageInputDto];

  @override
  final String wireName = r'AdminMessageInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMessageInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.requestInfo != null) {
      yield r'requestInfo';
      yield serializers.serialize(
        object.requestInfo,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMessageInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminMessageInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'requestInfo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.requestInfo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMessageInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMessageInputDtoBuilder();
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


