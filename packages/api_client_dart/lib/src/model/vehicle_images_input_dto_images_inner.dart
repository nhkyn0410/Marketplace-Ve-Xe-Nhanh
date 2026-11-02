//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_images_input_dto_images_inner.g.dart';

/// VehicleImagesInputDtoImagesInner
///
/// Properties:
/// * [objectKey] 
/// * [caption] 
@BuiltValue()
abstract class VehicleImagesInputDtoImagesInner implements Built<VehicleImagesInputDtoImagesInner, VehicleImagesInputDtoImagesInnerBuilder> {
  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'caption')
  String? get caption;

  VehicleImagesInputDtoImagesInner._();

  factory VehicleImagesInputDtoImagesInner([void updates(VehicleImagesInputDtoImagesInnerBuilder b)]) = _$VehicleImagesInputDtoImagesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleImagesInputDtoImagesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleImagesInputDtoImagesInner> get serializer => _$VehicleImagesInputDtoImagesInnerSerializer();
}

class _$VehicleImagesInputDtoImagesInnerSerializer implements PrimitiveSerializer<VehicleImagesInputDtoImagesInner> {
  @override
  final Iterable<Type> types = const [VehicleImagesInputDtoImagesInner, _$VehicleImagesInputDtoImagesInner];

  @override
  final String wireName = r'VehicleImagesInputDtoImagesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleImagesInputDtoImagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'caption';
    yield object.caption == null ? null : serializers.serialize(
      object.caption,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleImagesInputDtoImagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleImagesInputDtoImagesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.caption = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VehicleImagesInputDtoImagesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleImagesInputDtoImagesInnerBuilder();
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


