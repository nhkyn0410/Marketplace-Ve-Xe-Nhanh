//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_list_response_dto_output_items_inner_images_inner.g.dart';

/// VehicleListResponseDtoOutputItemsInnerImagesInner
///
/// Properties:
/// * [id] 
/// * [objectKey] 
/// * [url] 
/// * [position] 
/// * [caption] 
@BuiltValue()
abstract class VehicleListResponseDtoOutputItemsInnerImagesInner implements Built<VehicleListResponseDtoOutputItemsInnerImagesInner, VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'caption')
  String? get caption;

  VehicleListResponseDtoOutputItemsInnerImagesInner._();

  factory VehicleListResponseDtoOutputItemsInnerImagesInner([void updates(VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder b)]) = _$VehicleListResponseDtoOutputItemsInnerImagesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleListResponseDtoOutputItemsInnerImagesInner> get serializer => _$VehicleListResponseDtoOutputItemsInnerImagesInnerSerializer();
}

class _$VehicleListResponseDtoOutputItemsInnerImagesInnerSerializer implements PrimitiveSerializer<VehicleListResponseDtoOutputItemsInnerImagesInner> {
  @override
  final Iterable<Type> types = const [VehicleListResponseDtoOutputItemsInnerImagesInner, _$VehicleListResponseDtoOutputItemsInnerImagesInner];

  @override
  final String wireName = r'VehicleListResponseDtoOutputItemsInnerImagesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleListResponseDtoOutputItemsInnerImagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
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
    VehicleListResponseDtoOutputItemsInnerImagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.position = valueDes;
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
  VehicleListResponseDtoOutputItemsInnerImagesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder();
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


