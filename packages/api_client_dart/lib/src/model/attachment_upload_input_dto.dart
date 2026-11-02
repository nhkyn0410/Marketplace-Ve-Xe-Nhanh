//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attachment_upload_input_dto.g.dart';

/// AttachmentUploadInputDto
///
/// Properties:
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class AttachmentUploadInputDto implements Built<AttachmentUploadInputDto, AttachmentUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  AttachmentUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  application/pdf,  image/jpeg,  image/png,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  AttachmentUploadInputDto._();

  factory AttachmentUploadInputDto([void updates(AttachmentUploadInputDtoBuilder b)]) = _$AttachmentUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttachmentUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttachmentUploadInputDto> get serializer => _$AttachmentUploadInputDtoSerializer();
}

class _$AttachmentUploadInputDtoSerializer implements PrimitiveSerializer<AttachmentUploadInputDto> {
  @override
  final Iterable<Type> types = const [AttachmentUploadInputDto, _$AttachmentUploadInputDto];

  @override
  final String wireName = r'AttachmentUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttachmentUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(AttachmentUploadInputDtoContentTypeEnum),
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
    AttachmentUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttachmentUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AttachmentUploadInputDtoContentTypeEnum),
          ) as AttachmentUploadInputDtoContentTypeEnum;
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
  AttachmentUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttachmentUploadInputDtoBuilder();
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


class AttachmentUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'application/pdf')
  static const AttachmentUploadInputDtoContentTypeEnum applicationSlashPdf = _$attachmentUploadInputDtoContentTypeEnum_applicationSlashPdf;
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const AttachmentUploadInputDtoContentTypeEnum imageSlashJpeg = _$attachmentUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const AttachmentUploadInputDtoContentTypeEnum imageSlashPng = _$attachmentUploadInputDtoContentTypeEnum_imageSlashPng;

  static Serializer<AttachmentUploadInputDtoContentTypeEnum> get serializer => _$attachmentUploadInputDtoContentTypeEnumSerializer;

  const AttachmentUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<AttachmentUploadInputDtoContentTypeEnum> get values => _$attachmentUploadInputDtoContentTypeEnumValues;
  static AttachmentUploadInputDtoContentTypeEnum valueOf(String name) => _$attachmentUploadInputDtoContentTypeEnumValueOf(name);
}

