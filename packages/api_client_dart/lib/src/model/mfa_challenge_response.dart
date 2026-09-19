//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_challenge_response.g.dart';

/// MfaChallengeResponse
///
/// Properties:
/// * [mfaRequired] 
/// * [challengeToken] 
/// * [enrollmentRequired] 
/// * [challengeExpiresIn] 
/// * [otpAuthUri] 
@BuiltValue()
abstract class MfaChallengeResponse implements Built<MfaChallengeResponse, MfaChallengeResponseBuilder> {
  @BuiltValueField(wireName: r'mfaRequired')
  MfaChallengeResponseMfaRequiredEnum get mfaRequired;
  // enum mfaRequiredEnum {  true,  };

  @BuiltValueField(wireName: r'challengeToken')
  String get challengeToken;

  @BuiltValueField(wireName: r'enrollmentRequired')
  bool get enrollmentRequired;

  @BuiltValueField(wireName: r'challengeExpiresIn')
  int get challengeExpiresIn;

  @BuiltValueField(wireName: r'otpAuthUri')
  String? get otpAuthUri;

  MfaChallengeResponse._();

  factory MfaChallengeResponse([void updates(MfaChallengeResponseBuilder b)]) = _$MfaChallengeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaChallengeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaChallengeResponse> get serializer => _$MfaChallengeResponseSerializer();
}

class _$MfaChallengeResponseSerializer implements PrimitiveSerializer<MfaChallengeResponse> {
  @override
  final Iterable<Type> types = const [MfaChallengeResponse, _$MfaChallengeResponse];

  @override
  final String wireName = r'MfaChallengeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaChallengeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mfaRequired';
    yield serializers.serialize(
      object.mfaRequired,
      specifiedType: const FullType(MfaChallengeResponseMfaRequiredEnum),
    );
    yield r'challengeToken';
    yield serializers.serialize(
      object.challengeToken,
      specifiedType: const FullType(String),
    );
    yield r'enrollmentRequired';
    yield serializers.serialize(
      object.enrollmentRequired,
      specifiedType: const FullType(bool),
    );
    yield r'challengeExpiresIn';
    yield serializers.serialize(
      object.challengeExpiresIn,
      specifiedType: const FullType(int),
    );
    if (object.otpAuthUri != null) {
      yield r'otpAuthUri';
      yield serializers.serialize(
        object.otpAuthUri,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaChallengeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaChallengeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mfaRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MfaChallengeResponseMfaRequiredEnum),
          ) as MfaChallengeResponseMfaRequiredEnum;
          result.mfaRequired = valueDes;
          break;
        case r'challengeToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeToken = valueDes;
          break;
        case r'enrollmentRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enrollmentRequired = valueDes;
          break;
        case r'challengeExpiresIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.challengeExpiresIn = valueDes;
          break;
        case r'otpAuthUri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otpAuthUri = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaChallengeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaChallengeResponseBuilder();
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


class MfaChallengeResponseMfaRequiredEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const MfaChallengeResponseMfaRequiredEnum true_ = _$mfaChallengeResponseMfaRequiredEnum_true_;

  static Serializer<MfaChallengeResponseMfaRequiredEnum> get serializer => _$mfaChallengeResponseMfaRequiredEnumSerializer;

  const MfaChallengeResponseMfaRequiredEnum._(String name): super(name);

  static BuiltSet<MfaChallengeResponseMfaRequiredEnum> get values => _$mfaChallengeResponseMfaRequiredEnumValues;
  static MfaChallengeResponseMfaRequiredEnum valueOf(String name) => _$mfaChallengeResponseMfaRequiredEnumValueOf(name);
}

