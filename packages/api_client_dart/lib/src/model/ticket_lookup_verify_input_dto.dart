//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_verify_input_dto.g.dart';

/// TicketLookupVerifyInputDto
///
/// Properties:
/// * [bookingCode] 
/// * [email] 
/// * [otp] 
@BuiltValue()
abstract class TicketLookupVerifyInputDto implements Built<TicketLookupVerifyInputDto, TicketLookupVerifyInputDtoBuilder> {
  @BuiltValueField(wireName: r'bookingCode')
  String? get bookingCode;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'otp')
  String get otp;

  TicketLookupVerifyInputDto._();

  factory TicketLookupVerifyInputDto([void updates(TicketLookupVerifyInputDtoBuilder b)]) = _$TicketLookupVerifyInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupVerifyInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupVerifyInputDto> get serializer => _$TicketLookupVerifyInputDtoSerializer();
}

class _$TicketLookupVerifyInputDtoSerializer implements PrimitiveSerializer<TicketLookupVerifyInputDto> {
  @override
  final Iterable<Type> types = const [TicketLookupVerifyInputDto, _$TicketLookupVerifyInputDto];

  @override
  final String wireName = r'TicketLookupVerifyInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupVerifyInputDto object, {
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
    yield r'otp';
    yield serializers.serialize(
      object.otp,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupVerifyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupVerifyInputDtoBuilder result,
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
        case r'otp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  TicketLookupVerifyInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupVerifyInputDtoBuilder();
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


