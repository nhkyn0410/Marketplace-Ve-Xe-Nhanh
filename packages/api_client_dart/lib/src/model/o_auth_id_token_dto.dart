//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'o_auth_id_token_dto.g.dart';

/// OAuthIdTokenDto
///
/// Properties:
/// * [idToken] 
@BuiltValue()
abstract class OAuthIdTokenDto implements Built<OAuthIdTokenDto, OAuthIdTokenDtoBuilder> {
  @BuiltValueField(wireName: r'idToken')
  String get idToken;

  OAuthIdTokenDto._();

  factory OAuthIdTokenDto([void updates(OAuthIdTokenDtoBuilder b)]) = _$OAuthIdTokenDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OAuthIdTokenDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OAuthIdTokenDto> get serializer => _$OAuthIdTokenDtoSerializer();
}

class _$OAuthIdTokenDtoSerializer implements PrimitiveSerializer<OAuthIdTokenDto> {
  @override
  final Iterable<Type> types = const [OAuthIdTokenDto, _$OAuthIdTokenDto];

  @override
  final String wireName = r'OAuthIdTokenDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OAuthIdTokenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'idToken';
    yield serializers.serialize(
      object.idToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OAuthIdTokenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OAuthIdTokenDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OAuthIdTokenDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OAuthIdTokenDtoBuilder();
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


