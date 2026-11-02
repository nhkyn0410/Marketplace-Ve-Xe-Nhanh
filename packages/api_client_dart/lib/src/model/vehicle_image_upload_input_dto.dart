//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_image_upload_input_dto.g.dart';

/// VehicleImageUploadInputDto
///
/// Properties:
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class VehicleImageUploadInputDto implements Built<VehicleImageUploadInputDto, VehicleImageUploadInputDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  VehicleImageUploadInputDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  VehicleImageUploadInputDto._();

  factory VehicleImageUploadInputDto([void updates(VehicleImageUploadInputDtoBuilder b)]) = _$VehicleImageUploadInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleImageUploadInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleImageUploadInputDto> get serializer => _$VehicleImageUploadInputDtoSerializer();
}

class _$VehicleImageUploadInputDtoSerializer implements PrimitiveSerializer<VehicleImageUploadInputDto> {
  @override
  final Iterable<Type> types = const [VehicleImageUploadInputDto, _$VehicleImageUploadInputDto];

  @override
  final String wireName = r'VehicleImageUploadInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleImageUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(VehicleImageUploadInputDtoContentTypeEnum),
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
    VehicleImageUploadInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleImageUploadInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VehicleImageUploadInputDtoContentTypeEnum),
          ) as VehicleImageUploadInputDtoContentTypeEnum;
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
  VehicleImageUploadInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleImageUploadInputDtoBuilder();
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


class VehicleImageUploadInputDtoContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const VehicleImageUploadInputDtoContentTypeEnum imageSlashJpeg = _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const VehicleImageUploadInputDtoContentTypeEnum imageSlashPng = _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const VehicleImageUploadInputDtoContentTypeEnum imageSlashWebp = _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashWebp;

  static Serializer<VehicleImageUploadInputDtoContentTypeEnum> get serializer => _$vehicleImageUploadInputDtoContentTypeEnumSerializer;

  const VehicleImageUploadInputDtoContentTypeEnum._(String name): super(name);

  static BuiltSet<VehicleImageUploadInputDtoContentTypeEnum> get values => _$vehicleImageUploadInputDtoContentTypeEnumValues;
  static VehicleImageUploadInputDtoContentTypeEnum valueOf(String name) => _$vehicleImageUploadInputDtoContentTypeEnumValueOf(name);
}

