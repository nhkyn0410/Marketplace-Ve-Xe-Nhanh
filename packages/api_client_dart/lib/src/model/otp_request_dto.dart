//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'otp_request_dto.g.dart';

/// OtpRequestDto
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class OtpRequestDto implements Built<OtpRequestDto, OtpRequestDtoBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  OtpRequestDto._();

  factory OtpRequestDto([void updates(OtpRequestDtoBuilder b)]) = _$OtpRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OtpRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OtpRequestDto> get serializer => _$OtpRequestDtoSerializer();
}

class _$OtpRequestDtoSerializer implements PrimitiveSerializer<OtpRequestDto> {
  @override
  final Iterable<Type> types = const [OtpRequestDto, _$OtpRequestDto];

  @override
  final String wireName = r'OtpRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OtpRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OtpRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OtpRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OtpRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtpRequestDtoBuilder();
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


