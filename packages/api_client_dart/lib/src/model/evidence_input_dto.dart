//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/customer_ticket_input_dto_attachments_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'evidence_input_dto.g.dart';

/// EvidenceInputDto
///
/// Properties:
/// * [body] 
/// * [attachments] 
@BuiltValue()
abstract class EvidenceInputDto implements Built<EvidenceInputDto, EvidenceInputDtoBuilder> {
  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<CustomerTicketInputDtoAttachmentsInner>? get attachments;

  EvidenceInputDto._();

  factory EvidenceInputDto([void updates(EvidenceInputDtoBuilder b)]) = _$EvidenceInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EvidenceInputDtoBuilder b) => b
      ..attachments = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<EvidenceInputDto> get serializer => _$EvidenceInputDtoSerializer();
}

class _$EvidenceInputDtoSerializer implements PrimitiveSerializer<EvidenceInputDto> {
  @override
  final Iterable<Type> types = const [EvidenceInputDto, _$EvidenceInputDto];

  @override
  final String wireName = r'EvidenceInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EvidenceInputDto object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    EvidenceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EvidenceInputDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EvidenceInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EvidenceInputDtoBuilder();
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


