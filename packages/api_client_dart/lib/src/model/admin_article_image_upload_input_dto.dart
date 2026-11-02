//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_image_upload_input_dto.g.dart';

/// AdminArticleImageUploadInputDto
///
/// Properties:
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class AdminArticleImageUploadInputDto implements Built<AdminArticleImageUploadInputDto, AdminArticleImageUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  AdminArticleImageUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  AdminArticleImageUploadInputDto._();

  factory AdminArticleImageUploadInputDto([void updates(AdminArticleImageUploadInputDtoBuilder b)]) = _$AdminArticleImageUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleImageUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleImageUploadInputDto> get serializer => _$AdminArticleImageUploadInputDtoSerializer();
}

class _$AdminArticleImageUploadInputDtoSerializer implements PrimitiveSerializer<AdminArticleImageUploadInputDto> {
  @override
  final Iterable<Type> types = const [AdminArticleImageUploadInputDto, _$AdminArticleImageUploadInputDto];

  @override
  final String wireName = r'AdminArticleImageUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleImageUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(AdminArticleImageUploadInputDtoContentTypeEnum),
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
    AdminArticleImageUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleImageUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminArticleImageUploadInputDtoContentTypeEnum),
          ) as AdminArticleImageUploadInputDtoContentTypeEnum;
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
  AdminArticleImageUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleImageUploadInputDtoBuilder();
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


class AdminArticleImageUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const AdminArticleImageUploadInputDtoContentTypeEnum imageSlashJpeg = _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const AdminArticleImageUploadInputDtoContentTypeEnum imageSlashPng = _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const AdminArticleImageUploadInputDtoContentTypeEnum imageSlashWebp = _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashWebp;

  static Serializer<AdminArticleImageUploadInputDtoContentTypeEnum> get serializer => _$adminArticleImageUploadInputDtoContentTypeEnumSerializer;

  const AdminArticleImageUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<AdminArticleImageUploadInputDtoContentTypeEnum> get values => _$adminArticleImageUploadInputDtoContentTypeEnumValues;
  static AdminArticleImageUploadInputDtoContentTypeEnum valueOf(String name) => _$adminArticleImageUploadInputDtoContentTypeEnumValueOf(name);
}

