//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_otp_response_dto_output.g.dart';

/// TicketLookupOtpResponseDtoOutput
///
/// Properties:
/// * [maskedEmail] 
/// * [expiresInSeconds] 
/// * [resendAfterSeconds] 
/// * [maxAttempts] 
@BuiltValue()
abstract class TicketLookupOtpResponseDtoOutput implements Built<TicketLookupOtpResponseDtoOutput, TicketLookupOtpResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'maskedEmail')
  String get maskedEmail;

  @BuiltValueField(wireName: r'expiresInSeconds')
  int get expiresInSeconds;

  @BuiltValueField(wireName: r'resendAfterSeconds')
  int get resendAfterSeconds;

  @BuiltValueField(wireName: r'maxAttempts')
  int get maxAttempts;

  TicketLookupOtpResponseDtoOutput._();

  factory TicketLookupOtpResponseDtoOutput([void updates(TicketLookupOtpResponseDtoOutputBuilder b)]) = _$TicketLookupOtpResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupOtpResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupOtpResponseDtoOutput> get serializer => _$TicketLookupOtpResponseDtoOutputSerializer();
}

class _$TicketLookupOtpResponseDtoOutputSerializer implements PrimitiveSerializer<TicketLookupOtpResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketLookupOtpResponseDtoOutput, _$TicketLookupOtpResponseDtoOutput];

  @override
  final String wireName = r'TicketLookupOtpResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupOtpResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'maskedEmail';
    yield serializers.serialize(
      object.maskedEmail,
      specifiedType: const FullType(String),
    );
    yield r'expiresInSeconds';
    yield serializers.serialize(
      object.expiresInSeconds,
      specifiedType: const FullType(int),
    );
    yield r'resendAfterSeconds';
    yield serializers.serialize(
      object.resendAfterSeconds,
      specifiedType: const FullType(int),
    );
    yield r'maxAttempts';
    yield serializers.serialize(
      object.maxAttempts,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupOtpResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupOtpResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maskedEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maskedEmail = valueDes;
          break;
        case r'expiresInSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresInSeconds = valueDes;
          break;
        case r'resendAfterSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.resendAfterSeconds = valueDes;
          break;
        case r'maxAttempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxAttempts = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketLookupOtpResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupOtpResponseDtoOutputBuilder();
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


