//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credential_token_response.g.dart';

/// CredentialTokenResponse
///
/// Properties:
/// * [accessToken] 
/// * [tokenType] 
/// * [expiresIn] 
/// * [scope] 
/// * [role] 
/// * [refreshToken] 
/// * [refreshExpiresIn] 
/// * [mfaRequired] 
@BuiltValue()
abstract class CredentialTokenResponse implements Built<CredentialTokenResponse, CredentialTokenResponseBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'tokenType')
  CredentialTokenResponseTokenTypeEnum get tokenType;
  // enum tokenTypeEnum {  Bearer,  };

  @BuiltValueField(wireName: r'expiresIn')
  int get expiresIn;

  @BuiltValueField(wireName: r'scope')
  CredentialTokenResponseScopeEnum get scope;
  // enum scopeEnum {  passenger,  operator,  platform,  };

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'refreshExpiresIn')
  int get refreshExpiresIn;

  @BuiltValueField(wireName: r'mfaRequired')
  CredentialTokenResponseMfaRequiredEnum get mfaRequired;
  // enum mfaRequiredEnum {  false,  };

  CredentialTokenResponse._();

  factory CredentialTokenResponse([void updates(CredentialTokenResponseBuilder b)]) = _$CredentialTokenResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CredentialTokenResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CredentialTokenResponse> get serializer => _$CredentialTokenResponseSerializer();
}

class _$CredentialTokenResponseSerializer implements PrimitiveSerializer<CredentialTokenResponse> {
  @override
  final Iterable<Type> types = const [CredentialTokenResponse, _$CredentialTokenResponse];

  @override
  final String wireName = r'CredentialTokenResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CredentialTokenResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'tokenType';
    yield serializers.serialize(
      object.tokenType,
      specifiedType: const FullType(CredentialTokenResponseTokenTypeEnum),
    );
    yield r'expiresIn';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(CredentialTokenResponseScopeEnum),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'refreshExpiresIn';
    yield serializers.serialize(
      object.refreshExpiresIn,
      specifiedType: const FullType(int),
    );
    yield r'mfaRequired';
    yield serializers.serialize(
      object.mfaRequired,
      specifiedType: const FullType(CredentialTokenResponseMfaRequiredEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CredentialTokenResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CredentialTokenResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'tokenType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CredentialTokenResponseTokenTypeEnum),
          ) as CredentialTokenResponseTokenTypeEnum;
          result.tokenType = valueDes;
          break;
        case r'expiresIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CredentialTokenResponseScopeEnum),
          ) as CredentialTokenResponseScopeEnum;
          result.scope = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'refreshExpiresIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refreshExpiresIn = valueDes;
          break;
        case r'mfaRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CredentialTokenResponseMfaRequiredEnum),
          ) as CredentialTokenResponseMfaRequiredEnum;
          result.mfaRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CredentialTokenResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CredentialTokenResponseBuilder();
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


class CredentialTokenResponseTokenTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Bearer')
  static const CredentialTokenResponseTokenTypeEnum bearer = _$credentialTokenResponseTokenTypeEnum_bearer;

  static Serializer<CredentialTokenResponseTokenTypeEnum> get serializer => _$credentialTokenResponseTokenTypeEnumSerializer;

  const CredentialTokenResponseTokenTypeEnum._(String name): super(name);

  static BuiltSet<CredentialTokenResponseTokenTypeEnum> get values => _$credentialTokenResponseTokenTypeEnumValues;
  static CredentialTokenResponseTokenTypeEnum valueOf(String name) => _$credentialTokenResponseTokenTypeEnumValueOf(name);
}

class CredentialTokenResponseScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'passenger')
  static const CredentialTokenResponseScopeEnum passenger = _$credentialTokenResponseScopeEnum_passenger;
  @BuiltValueEnumConst(wireName: r'operator')
  static const CredentialTokenResponseScopeEnum operator_ = _$credentialTokenResponseScopeEnum_operator_;
  @BuiltValueEnumConst(wireName: r'platform')
  static const CredentialTokenResponseScopeEnum platform = _$credentialTokenResponseScopeEnum_platform;

  static Serializer<CredentialTokenResponseScopeEnum> get serializer => _$credentialTokenResponseScopeEnumSerializer;

  const CredentialTokenResponseScopeEnum._(String name): super(name);

  static BuiltSet<CredentialTokenResponseScopeEnum> get values => _$credentialTokenResponseScopeEnumValues;
  static CredentialTokenResponseScopeEnum valueOf(String name) => _$credentialTokenResponseScopeEnumValueOf(name);
}

class CredentialTokenResponseMfaRequiredEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'false')
  static const CredentialTokenResponseMfaRequiredEnum false_ = _$credentialTokenResponseMfaRequiredEnum_false_;

  static Serializer<CredentialTokenResponseMfaRequiredEnum> get serializer => _$credentialTokenResponseMfaRequiredEnumSerializer;

  const CredentialTokenResponseMfaRequiredEnum._(String name): super(name);

  static BuiltSet<CredentialTokenResponseMfaRequiredEnum> get values => _$credentialTokenResponseMfaRequiredEnumValues;
  static CredentialTokenResponseMfaRequiredEnum valueOf(String name) => _$credentialTokenResponseMfaRequiredEnumValueOf(name);
}

