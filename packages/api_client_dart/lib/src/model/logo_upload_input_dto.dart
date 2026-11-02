//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'logo_upload_input_dto.g.dart';

/// LogoUploadInputDto
///
/// Properties:
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class LogoUploadInputDto implements Built<LogoUploadInputDto, LogoUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  LogoUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  LogoUploadInputDto._();

  factory LogoUploadInputDto([void updates(LogoUploadInputDtoBuilder b)]) = _$LogoUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LogoUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LogoUploadInputDto> get serializer => _$LogoUploadInputDtoSerializer();
}

class _$LogoUploadInputDtoSerializer implements PrimitiveSerializer<LogoUploadInputDto> {
  @override
  final Iterable<Type> types = const [LogoUploadInputDto, _$LogoUploadInputDto];

  @override
  final String wireName = r'LogoUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LogoUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(LogoUploadInputDtoContentTypeEnum),
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
    LogoUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LogoUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LogoUploadInputDtoContentTypeEnum),
          ) as LogoUploadInputDtoContentTypeEnum;
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
  LogoUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LogoUploadInputDtoBuilder();
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


class LogoUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const LogoUploadInputDtoContentTypeEnum imageSlashJpeg = _$logoUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const LogoUploadInputDtoContentTypeEnum imageSlashPng = _$logoUploadInputDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const LogoUploadInputDtoContentTypeEnum imageSlashWebp = _$logoUploadInputDtoContentTypeEnum_imageSlashWebp;

  static Serializer<LogoUploadInputDtoContentTypeEnum> get serializer => _$logoUploadInputDtoContentTypeEnumSerializer;

  const LogoUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<LogoUploadInputDtoContentTypeEnum> get values => _$logoUploadInputDtoContentTypeEnumValues;
  static LogoUploadInputDtoContentTypeEnum valueOf(String name) => _$logoUploadInputDtoContentTypeEnumValueOf(name);
}

