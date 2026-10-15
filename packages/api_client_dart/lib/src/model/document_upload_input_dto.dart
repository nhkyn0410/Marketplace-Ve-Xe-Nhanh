//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'document_upload_input_dto.g.dart';

/// DocumentUploadInputDto
///
/// Properties:
/// * [type] 
/// * [contentType] 
/// * [sizeBytes] 
/// * [fileName] 
@BuiltValue()
abstract class DocumentUploadInputDto implements Built<DocumentUploadInputDto, DocumentUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  DocumentUploadInputDtoTypeEnum get type;
  // enum typeEnum {  BUSINESS_REGISTRATION,  TRANSPORT_LICENSE,  REPRESENTATIVE_AUTHORIZATION,  };

  @BuiltValueField(wireName: r'contentType')
  DocumentUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  application/pdf,  image/jpeg,  image/png,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  DocumentUploadInputDto._();

  factory DocumentUploadInputDto([void updates(DocumentUploadInputDtoBuilder b)]) = _$DocumentUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentUploadInputDto> get serializer => _$DocumentUploadInputDtoSerializer();
}

class _$DocumentUploadInputDtoSerializer implements PrimitiveSerializer<DocumentUploadInputDto> {
  @override
  final Iterable<Type> types = const [DocumentUploadInputDto, _$DocumentUploadInputDto];

  @override
  final String wireName = r'DocumentUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(DocumentUploadInputDtoTypeEnum),
    );
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(DocumentUploadInputDtoContentTypeEnum),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
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
    DocumentUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DocumentUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentUploadInputDtoTypeEnum),
          ) as DocumentUploadInputDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentUploadInputDtoContentTypeEnum),
          ) as DocumentUploadInputDtoContentTypeEnum;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
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
  DocumentUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentUploadInputDtoBuilder();
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


class DocumentUploadInputDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUSINESS_REGISTRATION')
  static const DocumentUploadInputDtoTypeEnum BUSINESS_REGISTRATION = _$documentUploadInputDtoTypeEnum_BUSINESS_REGISTRATION;
  @BuiltValueEnumConst(wireName: r'TRANSPORT_LICENSE')
  static const DocumentUploadInputDtoTypeEnum TRANSPORT_LICENSE = _$documentUploadInputDtoTypeEnum_TRANSPORT_LICENSE;
  @BuiltValueEnumConst(wireName: r'REPRESENTATIVE_AUTHORIZATION')
  static const DocumentUploadInputDtoTypeEnum REPRESENTATIVE_AUTHORIZATION = _$documentUploadInputDtoTypeEnum_REPRESENTATIVE_AUTHORIZATION;

  static Serializer<DocumentUploadInputDtoTypeEnum> get serializer => _$documentUploadInputDtoTypeEnumSerializer;

  const DocumentUploadInputDtoTypeEnum._(String name): super(name);

  static BuiltSet<DocumentUploadInputDtoTypeEnum> get values => _$documentUploadInputDtoTypeEnumValues;
  static DocumentUploadInputDtoTypeEnum valueOf(String name) => _$documentUploadInputDtoTypeEnumValueOf(name);
}

class DocumentUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'application/pdf')
  static const DocumentUploadInputDtoContentTypeEnum applicationSlashPdf = _$documentUploadInputDtoContentTypeEnum_applicationSlashPdf;
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const DocumentUploadInputDtoContentTypeEnum imageSlashJpeg = _$documentUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const DocumentUploadInputDtoContentTypeEnum imageSlashPng = _$documentUploadInputDtoContentTypeEnum_imageSlashPng;

  static Serializer<DocumentUploadInputDtoContentTypeEnum> get serializer => _$documentUploadInputDtoContentTypeEnumSerializer;

  const DocumentUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<DocumentUploadInputDtoContentTypeEnum> get values => _$documentUploadInputDtoContentTypeEnumValues;
  static DocumentUploadInputDtoContentTypeEnum valueOf(String name) => _$documentUploadInputDtoContentTypeEnumValueOf(name);
}

