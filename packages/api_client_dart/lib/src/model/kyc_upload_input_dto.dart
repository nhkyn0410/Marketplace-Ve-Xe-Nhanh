//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_upload_input_dto.g.dart';

/// KycUploadInputDto
///
/// Properties:
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class KycUploadInputDto implements Built<KycUploadInputDto, KycUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  KycUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  application/pdf,  image/jpeg,  image/png,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  KycUploadInputDto._();

  factory KycUploadInputDto([void updates(KycUploadInputDtoBuilder b)]) = _$KycUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycUploadInputDto> get serializer => _$KycUploadInputDtoSerializer();
}

class _$KycUploadInputDtoSerializer implements PrimitiveSerializer<KycUploadInputDto> {
  @override
  final Iterable<Type> types = const [KycUploadInputDto, _$KycUploadInputDto];

  @override
  final String wireName = r'KycUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(KycUploadInputDtoContentTypeEnum),
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
    KycUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycUploadInputDtoContentTypeEnum),
          ) as KycUploadInputDtoContentTypeEnum;
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
  KycUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycUploadInputDtoBuilder();
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


class KycUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'application/pdf')
  static const KycUploadInputDtoContentTypeEnum applicationSlashPdf = _$kycUploadInputDtoContentTypeEnum_applicationSlashPdf;
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const KycUploadInputDtoContentTypeEnum imageSlashJpeg = _$kycUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const KycUploadInputDtoContentTypeEnum imageSlashPng = _$kycUploadInputDtoContentTypeEnum_imageSlashPng;

  static Serializer<KycUploadInputDtoContentTypeEnum> get serializer => _$kycUploadInputDtoContentTypeEnumSerializer;

  const KycUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<KycUploadInputDtoContentTypeEnum> get values => _$kycUploadInputDtoContentTypeEnumValues;
  static KycUploadInputDtoContentTypeEnum valueOf(String name) => _$kycUploadInputDtoContentTypeEnumValueOf(name);
}

