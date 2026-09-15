//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credential_login_dto.g.dart';

/// CredentialLoginDto
///
/// Properties:
/// * [identifier] 
/// * [password] 
@BuiltValue()
abstract class CredentialLoginDto implements Built<CredentialLoginDto, CredentialLoginDtoBuilder> {
  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  @BuiltValueField(wireName: r'password')
  String get password;

  CredentialLoginDto._();

  factory CredentialLoginDto([void updates(CredentialLoginDtoBuilder b)]) = _$CredentialLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CredentialLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CredentialLoginDto> get serializer => _$CredentialLoginDtoSerializer();
}

class _$CredentialLoginDtoSerializer implements PrimitiveSerializer<CredentialLoginDto> {
  @override
  final Iterable<Type> types = const [CredentialLoginDto, _$CredentialLoginDto];

  @override
  final String wireName = r'CredentialLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CredentialLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'identifier';
    yield serializers.serialize(
      object.identifier,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CredentialLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CredentialLoginDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identifier = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CredentialLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CredentialLoginDtoBuilder();
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


