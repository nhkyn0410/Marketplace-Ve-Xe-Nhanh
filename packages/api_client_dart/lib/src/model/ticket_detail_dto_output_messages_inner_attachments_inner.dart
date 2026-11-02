//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_detail_dto_output_messages_inner_attachments_inner.g.dart';

/// TicketDetailDtoOutputMessagesInnerAttachmentsInner
///
/// Properties:
/// * [attachmentId] 
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class TicketDetailDtoOutputMessagesInnerAttachmentsInner implements Built<TicketDetailDtoOutputMessagesInnerAttachmentsInner, TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder> {
  @BuiltValueField(wireName: r'attachmentId')
  String get attachmentId;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'contentType')
  String get contentType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  TicketDetailDtoOutputMessagesInnerAttachmentsInner._();

  factory TicketDetailDtoOutputMessagesInnerAttachmentsInner([void updates(TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder b)]) = _$TicketDetailDtoOutputMessagesInnerAttachmentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketDetailDtoOutputMessagesInnerAttachmentsInner> get serializer => _$TicketDetailDtoOutputMessagesInnerAttachmentsInnerSerializer();
}

class _$TicketDetailDtoOutputMessagesInnerAttachmentsInnerSerializer implements PrimitiveSerializer<TicketDetailDtoOutputMessagesInnerAttachmentsInner> {
  @override
  final Iterable<Type> types = const [TicketDetailDtoOutputMessagesInnerAttachmentsInner, _$TicketDetailDtoOutputMessagesInnerAttachmentsInner];

  @override
  final String wireName = r'TicketDetailDtoOutputMessagesInnerAttachmentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketDetailDtoOutputMessagesInnerAttachmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'attachmentId';
    yield serializers.serialize(
      object.attachmentId,
      specifiedType: const FullType(String),
    );
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketDetailDtoOutputMessagesInnerAttachmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'attachmentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.attachmentId = valueDes;
          break;
        case r'fileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileName = valueDes;
          break;
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketDetailDtoOutputMessagesInnerAttachmentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder();
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


