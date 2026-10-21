//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_vehicle_images_inner.g.dart';

/// PublicTripDtoOutputVehicleImagesInner
///
/// Properties:
/// * [url] 
/// * [caption] 
@BuiltValue()
abstract class PublicTripDtoOutputVehicleImagesInner implements Built<PublicTripDtoOutputVehicleImagesInner, PublicTripDtoOutputVehicleImagesInnerBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'caption')
  String? get caption;

  PublicTripDtoOutputVehicleImagesInner._();

  factory PublicTripDtoOutputVehicleImagesInner([void updates(PublicTripDtoOutputVehicleImagesInnerBuilder b)]) = _$PublicTripDtoOutputVehicleImagesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputVehicleImagesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputVehicleImagesInner> get serializer => _$PublicTripDtoOutputVehicleImagesInnerSerializer();
}

class _$PublicTripDtoOutputVehicleImagesInnerSerializer implements PrimitiveSerializer<PublicTripDtoOutputVehicleImagesInner> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputVehicleImagesInner, _$PublicTripDtoOutputVehicleImagesInner];

  @override
  final String wireName = r'PublicTripDtoOutputVehicleImagesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputVehicleImagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
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
    PublicTripDtoOutputVehicleImagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputVehicleImagesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
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
  PublicTripDtoOutputVehicleImagesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputVehicleImagesInnerBuilder();
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


