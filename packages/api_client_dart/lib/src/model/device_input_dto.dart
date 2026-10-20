//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_input_dto.g.dart';

/// DeviceInputDto
///
/// Properties:
/// * [provider]
/// * [token]
@BuiltValue()
abstract class DeviceInputDto
    implements Built<DeviceInputDto, DeviceInputDtoBuilder> {
  @BuiltValueField(wireName: r'provider')
  DeviceInputDtoProviderEnum get provider;
  // enum providerEnum {  FCM,  APNS,  };

  @BuiltValueField(wireName: r'token')
  String get token;

  DeviceInputDto._();

  factory DeviceInputDto([void updates(DeviceInputDtoBuilder b)]) =
      _$DeviceInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceInputDto> get serializer =>
      _$DeviceInputDtoSerializer();
}

class _$DeviceInputDtoSerializer
    implements PrimitiveSerializer<DeviceInputDto> {
  @override
  final Iterable<Type> types = const [DeviceInputDto, _$DeviceInputDto];

  @override
  final String wireName = r'DeviceInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(DeviceInputDtoProviderEnum),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeviceInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeviceInputDtoProviderEnum),
          ) as DeviceInputDtoProviderEnum;
          result.provider = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceInputDtoBuilder();
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

class DeviceInputDtoProviderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FCM')
  static const DeviceInputDtoProviderEnum FCM =
      _$deviceInputDtoProviderEnum_FCM;
  @BuiltValueEnumConst(wireName: r'APNS')
  static const DeviceInputDtoProviderEnum APNS =
      _$deviceInputDtoProviderEnum_APNS;

  static Serializer<DeviceInputDtoProviderEnum> get serializer =>
      _$deviceInputDtoProviderEnumSerializer;

  const DeviceInputDtoProviderEnum._(String name) : super(name);

  static BuiltSet<DeviceInputDtoProviderEnum> get values =>
      _$deviceInputDtoProviderEnumValues;
  static DeviceInputDtoProviderEnum valueOf(String name) =>
      _$deviceInputDtoProviderEnumValueOf(name);
}
