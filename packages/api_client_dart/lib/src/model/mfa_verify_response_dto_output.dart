//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_verify_response_dto_output.g.dart';

/// MfaVerifyResponseDtoOutput
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
/// * [backupCodes] 
@BuiltValue()
abstract class MfaVerifyResponseDtoOutput implements Built<MfaVerifyResponseDtoOutput, MfaVerifyResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'tokenType')
  MfaVerifyResponseDtoOutputTokenTypeEnum get tokenType;
  // enum tokenTypeEnum {  Bearer,  };

  @BuiltValueField(wireName: r'expiresIn')
  int get expiresIn;

  @BuiltValueField(wireName: r'scope')
  MfaVerifyResponseDtoOutputScopeEnum get scope;
  // enum scopeEnum {  passenger,  operator,  platform,  };

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'refreshExpiresIn')
  int get refreshExpiresIn;

  @BuiltValueField(wireName: r'mfaRequired')
  MfaVerifyResponseDtoOutputMfaRequiredEnum get mfaRequired;
  // enum mfaRequiredEnum {  false,  };

  @BuiltValueField(wireName: r'backupCodes')
  BuiltList<String>? get backupCodes;

  MfaVerifyResponseDtoOutput._();

  factory MfaVerifyResponseDtoOutput([void updates(MfaVerifyResponseDtoOutputBuilder b)]) = _$MfaVerifyResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaVerifyResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaVerifyResponseDtoOutput> get serializer => _$MfaVerifyResponseDtoOutputSerializer();
}

class _$MfaVerifyResponseDtoOutputSerializer implements PrimitiveSerializer<MfaVerifyResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [MfaVerifyResponseDtoOutput, _$MfaVerifyResponseDtoOutput];

  @override
  final String wireName = r'MfaVerifyResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaVerifyResponseDtoOutput object, {
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
      specifiedType: const FullType(MfaVerifyResponseDtoOutputTokenTypeEnum),
    );
    yield r'expiresIn';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(MfaVerifyResponseDtoOutputScopeEnum),
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
      specifiedType: const FullType(MfaVerifyResponseDtoOutputMfaRequiredEnum),
    );
    if (object.backupCodes != null) {
      yield r'backupCodes';
      yield serializers.serialize(
        object.backupCodes,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaVerifyResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaVerifyResponseDtoOutputBuilder result,
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
            specifiedType: const FullType(MfaVerifyResponseDtoOutputTokenTypeEnum),
          ) as MfaVerifyResponseDtoOutputTokenTypeEnum;
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
            specifiedType: const FullType(MfaVerifyResponseDtoOutputScopeEnum),
          ) as MfaVerifyResponseDtoOutputScopeEnum;
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
            specifiedType: const FullType(MfaVerifyResponseDtoOutputMfaRequiredEnum),
          ) as MfaVerifyResponseDtoOutputMfaRequiredEnum;
          result.mfaRequired = valueDes;
          break;
        case r'backupCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.backupCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaVerifyResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaVerifyResponseDtoOutputBuilder();
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


class MfaVerifyResponseDtoOutputTokenTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Bearer')
  static const MfaVerifyResponseDtoOutputTokenTypeEnum bearer = _$mfaVerifyResponseDtoOutputTokenTypeEnum_bearer;

  static Serializer<MfaVerifyResponseDtoOutputTokenTypeEnum> get serializer => _$mfaVerifyResponseDtoOutputTokenTypeEnumSerializer;

  const MfaVerifyResponseDtoOutputTokenTypeEnum._(String name): super(name);

  static BuiltSet<MfaVerifyResponseDtoOutputTokenTypeEnum> get values => _$mfaVerifyResponseDtoOutputTokenTypeEnumValues;
  static MfaVerifyResponseDtoOutputTokenTypeEnum valueOf(String name) => _$mfaVerifyResponseDtoOutputTokenTypeEnumValueOf(name);
}

class MfaVerifyResponseDtoOutputScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'passenger')
  static const MfaVerifyResponseDtoOutputScopeEnum passenger = _$mfaVerifyResponseDtoOutputScopeEnum_passenger;
  @BuiltValueEnumConst(wireName: r'operator')
  static const MfaVerifyResponseDtoOutputScopeEnum operator_ = _$mfaVerifyResponseDtoOutputScopeEnum_operator_;
  @BuiltValueEnumConst(wireName: r'platform')
  static const MfaVerifyResponseDtoOutputScopeEnum platform = _$mfaVerifyResponseDtoOutputScopeEnum_platform;

  static Serializer<MfaVerifyResponseDtoOutputScopeEnum> get serializer => _$mfaVerifyResponseDtoOutputScopeEnumSerializer;

  const MfaVerifyResponseDtoOutputScopeEnum._(String name): super(name);

  static BuiltSet<MfaVerifyResponseDtoOutputScopeEnum> get values => _$mfaVerifyResponseDtoOutputScopeEnumValues;
  static MfaVerifyResponseDtoOutputScopeEnum valueOf(String name) => _$mfaVerifyResponseDtoOutputScopeEnumValueOf(name);
}

class MfaVerifyResponseDtoOutputMfaRequiredEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'false')
  static const MfaVerifyResponseDtoOutputMfaRequiredEnum false_ = _$mfaVerifyResponseDtoOutputMfaRequiredEnum_false_;

  static Serializer<MfaVerifyResponseDtoOutputMfaRequiredEnum> get serializer => _$mfaVerifyResponseDtoOutputMfaRequiredEnumSerializer;

  const MfaVerifyResponseDtoOutputMfaRequiredEnum._(String name): super(name);

  static BuiltSet<MfaVerifyResponseDtoOutputMfaRequiredEnum> get values => _$mfaVerifyResponseDtoOutputMfaRequiredEnumValues;
  static MfaVerifyResponseDtoOutputMfaRequiredEnum valueOf(String name) => _$mfaVerifyResponseDtoOutputMfaRequiredEnumValueOf(name);
}

