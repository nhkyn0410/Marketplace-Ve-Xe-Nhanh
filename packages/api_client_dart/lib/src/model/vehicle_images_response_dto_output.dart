//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/vehicle_list_response_dto_output_items_inner_images_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_images_response_dto_output.g.dart';

/// VehicleImagesResponseDtoOutput
///
/// Properties:
/// * [images] 
@BuiltValue()
abstract class VehicleImagesResponseDtoOutput implements Built<VehicleImagesResponseDtoOutput, VehicleImagesResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'images')
  BuiltList<VehicleListResponseDtoOutputItemsInnerImagesInner> get images;

  VehicleImagesResponseDtoOutput._();

  factory VehicleImagesResponseDtoOutput([void updates(VehicleImagesResponseDtoOutputBuilder b)]) = _$VehicleImagesResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleImagesResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleImagesResponseDtoOutput> get serializer => _$VehicleImagesResponseDtoOutputSerializer();
}

class _$VehicleImagesResponseDtoOutputSerializer implements PrimitiveSerializer<VehicleImagesResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [VehicleImagesResponseDtoOutput, _$VehicleImagesResponseDtoOutput];

  @override
  final String wireName = r'VehicleImagesResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleImagesResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(BuiltList, [FullType(VehicleListResponseDtoOutputItemsInnerImagesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleImagesResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleImagesResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VehicleListResponseDtoOutputItemsInnerImagesInner)]),
          ) as BuiltList<VehicleListResponseDtoOutputItemsInnerImagesInner>;
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
  VehicleImagesResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleImagesResponseDtoOutputBuilder();
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


