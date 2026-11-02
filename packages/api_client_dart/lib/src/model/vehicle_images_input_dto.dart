//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/vehicle_images_input_dto_images_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_images_input_dto.g.dart';

/// VehicleImagesInputDto
///
/// Properties:
/// * [images] 
@BuiltValue()
abstract class VehicleImagesInputDto implements Built<VehicleImagesInputDto, VehicleImagesInputDtoBuilder> {
  @BuiltValueField(wireName: r'images')
  BuiltList<VehicleImagesInputDtoImagesInner> get images;

  VehicleImagesInputDto._();

  factory VehicleImagesInputDto([void updates(VehicleImagesInputDtoBuilder b)]) = _$VehicleImagesInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleImagesInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleImagesInputDto> get serializer => _$VehicleImagesInputDtoSerializer();
}

class _$VehicleImagesInputDtoSerializer implements PrimitiveSerializer<VehicleImagesInputDto> {
  @override
  final Iterable<Type> types = const [VehicleImagesInputDto, _$VehicleImagesInputDto];

  @override
  final String wireName = r'VehicleImagesInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleImagesInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(BuiltList, [FullType(VehicleImagesInputDtoImagesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleImagesInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleImagesInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VehicleImagesInputDtoImagesInner)]),
          ) as BuiltList<VehicleImagesInputDtoImagesInner>;
          result.images.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VehicleImagesInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleImagesInputDtoBuilder();
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


