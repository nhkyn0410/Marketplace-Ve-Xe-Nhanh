//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reauth_dto.g.dart';

/// ReauthDto
///
/// Properties:
/// * [password]
/// * [otp]
@BuiltValue()
abstract class ReauthDto implements Built<ReauthDto, ReauthDtoBuilder> {
  @BuiltValueField(wireName: r'password')
  String? get password;

  @BuiltValueField(wireName: r'otp')
  String? get otp;

  ReauthDto._();

  factory ReauthDto([void updates(ReauthDtoBuilder b)]) = _$ReauthDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReauthDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReauthDto> get serializer => _$ReauthDtoSerializer();
}

class _$ReauthDtoSerializer implements PrimitiveSerializer<ReauthDto> {
  @override
  final Iterable<Type> types = const [ReauthDto, _$ReauthDto];

  @override
  final String wireName = r'ReauthDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReauthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
    if (object.otp != null) {
      yield r'otp';
      yield serializers.serialize(
        object.otp,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReauthDto object, {
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
    required ReauthDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.password = valueDes;
          break;
        case r'otp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReauthDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReauthDtoBuilder();
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
