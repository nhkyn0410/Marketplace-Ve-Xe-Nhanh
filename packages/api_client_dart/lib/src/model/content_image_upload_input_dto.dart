//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_image_upload_input_dto.g.dart';

/// ContentImageUploadInputDto
///
/// Properties:
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class ContentImageUploadInputDto implements Built<ContentImageUploadInputDto, ContentImageUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  ContentImageUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  ContentImageUploadInputDto._();

  factory ContentImageUploadInputDto([void updates(ContentImageUploadInputDtoBuilder b)]) = _$ContentImageUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContentImageUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContentImageUploadInputDto> get serializer => _$ContentImageUploadInputDtoSerializer();
}

class _$ContentImageUploadInputDtoSerializer implements PrimitiveSerializer<ContentImageUploadInputDto> {
  @override
  final Iterable<Type> types = const [ContentImageUploadInputDto, _$ContentImageUploadInputDto];

  @override
  final String wireName = r'ContentImageUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContentImageUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(ContentImageUploadInputDtoContentTypeEnum),
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
    ContentImageUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContentImageUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentImageUploadInputDtoContentTypeEnum),
          ) as ContentImageUploadInputDtoContentTypeEnum;
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
  ContentImageUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContentImageUploadInputDtoBuilder();
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


class ContentImageUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const ContentImageUploadInputDtoContentTypeEnum imageSlashJpeg = _$contentImageUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const ContentImageUploadInputDtoContentTypeEnum imageSlashPng = _$contentImageUploadInputDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const ContentImageUploadInputDtoContentTypeEnum imageSlashWebp = _$contentImageUploadInputDtoContentTypeEnum_imageSlashWebp;

  static Serializer<ContentImageUploadInputDtoContentTypeEnum> get serializer => _$contentImageUploadInputDtoContentTypeEnumSerializer;

  const ContentImageUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<ContentImageUploadInputDtoContentTypeEnum> get values => _$contentImageUploadInputDtoContentTypeEnumValues;
  static ContentImageUploadInputDtoContentTypeEnum valueOf(String name) => _$contentImageUploadInputDtoContentTypeEnumValueOf(name);
}

