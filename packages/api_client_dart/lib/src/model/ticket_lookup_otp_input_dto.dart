//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_otp_input_dto.g.dart';

/// TicketLookupOtpInputDto
///
/// Properties:
/// * [bookingCode] 
/// * [email] 
@BuiltValue()
abstract class TicketLookupOtpInputDto implements Built<TicketLookupOtpInputDto, TicketLookupOtpInputDtoBuilder> {
  @BuiltValueField(wireName: r'bookingCode')
  String? get bookingCode;

  @BuiltValueField(wireName: r'email')
  String get email;

  TicketLookupOtpInputDto._();

  factory TicketLookupOtpInputDto([void updates(TicketLookupOtpInputDtoBuilder b)]) = _$TicketLookupOtpInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupOtpInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupOtpInputDto> get serializer => _$TicketLookupOtpInputDtoSerializer();
}

class _$TicketLookupOtpInputDtoSerializer implements PrimitiveSerializer<TicketLookupOtpInputDto> {
  @override
  final Iterable<Type> types = const [TicketLookupOtpInputDto, _$TicketLookupOtpInputDto];

  @override
  final String wireName = r'TicketLookupOtpInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupOtpInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bookingCode != null) {
      yield r'bookingCode';
      yield serializers.serialize(
        object.bookingCode,
        specifiedType: const FullType(String),
      );
    }
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupOtpInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupOtpInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bookingCode = valueDes;
          break;
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
  TicketLookupOtpInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupOtpInputDtoBuilder();
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


