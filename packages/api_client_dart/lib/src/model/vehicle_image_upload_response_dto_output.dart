//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_image_upload_response_dto_output.g.dart';

/// VehicleImageUploadResponseDtoOutput
///
/// Properties:
/// * [uploadUrl] 
/// * [objectKey] 
/// * [expiresAt] 
@BuiltValue()
abstract class VehicleImageUploadResponseDtoOutput implements Built<VehicleImageUploadResponseDtoOutput, VehicleImageUploadResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  VehicleImageUploadResponseDtoOutput._();

  factory VehicleImageUploadResponseDtoOutput([void updates(VehicleImageUploadResponseDtoOutputBuilder b)]) = _$VehicleImageUploadResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleImageUploadResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleImageUploadResponseDtoOutput> get serializer => _$VehicleImageUploadResponseDtoOutputSerializer();
}

class _$VehicleImageUploadResponseDtoOutputSerializer implements PrimitiveSerializer<VehicleImageUploadResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [VehicleImageUploadResponseDtoOutput, _$VehicleImageUploadResponseDtoOutput];

  @override
  final String wireName = r'VehicleImageUploadResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleImageUploadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadUrl';
    yield serializers.serialize(
      object.uploadUrl,
      specifiedType: const FullType(String),
    );
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleImageUploadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleImageUploadResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadUrl = valueDes;
          break;
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VehicleImageUploadResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleImageUploadResponseDtoOutputBuilder();
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


