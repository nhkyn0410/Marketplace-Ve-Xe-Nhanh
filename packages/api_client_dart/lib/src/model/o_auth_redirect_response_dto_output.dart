//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'o_auth_redirect_response_dto_output.g.dart';

/// OAuthRedirectResponseDtoOutput
///
/// Properties:
/// * [redirectUrl] 
@BuiltValue()
abstract class OAuthRedirectResponseDtoOutput implements Built<OAuthRedirectResponseDtoOutput, OAuthRedirectResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'redirectUrl')
  String get redirectUrl;

  OAuthRedirectResponseDtoOutput._();

  factory OAuthRedirectResponseDtoOutput([void updates(OAuthRedirectResponseDtoOutputBuilder b)]) = _$OAuthRedirectResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OAuthRedirectResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OAuthRedirectResponseDtoOutput> get serializer => _$OAuthRedirectResponseDtoOutputSerializer();
}

class _$OAuthRedirectResponseDtoOutputSerializer implements PrimitiveSerializer<OAuthRedirectResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [OAuthRedirectResponseDtoOutput, _$OAuthRedirectResponseDtoOutput];

  @override
  final String wireName = r'OAuthRedirectResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OAuthRedirectResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'redirectUrl';
    yield serializers.serialize(
      object.redirectUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OAuthRedirectResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OAuthRedirectResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'redirectUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.redirectUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OAuthRedirectResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OAuthRedirectResponseDtoOutputBuilder();
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


