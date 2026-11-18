//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_email_response_dto_output.g.dart';

/// TicketEmailResponseDtoOutput
///
/// Properties:
/// * [sentTo] 
/// * [resendAfterSeconds] 
@BuiltValue()
abstract class TicketEmailResponseDtoOutput implements Built<TicketEmailResponseDtoOutput, TicketEmailResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'sentTo')
  String get sentTo;

  @BuiltValueField(wireName: r'resendAfterSeconds')
  int get resendAfterSeconds;

  TicketEmailResponseDtoOutput._();

  factory TicketEmailResponseDtoOutput([void updates(TicketEmailResponseDtoOutputBuilder b)]) = _$TicketEmailResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketEmailResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketEmailResponseDtoOutput> get serializer => _$TicketEmailResponseDtoOutputSerializer();
}

class _$TicketEmailResponseDtoOutputSerializer implements PrimitiveSerializer<TicketEmailResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketEmailResponseDtoOutput, _$TicketEmailResponseDtoOutput];

  @override
  final String wireName = r'TicketEmailResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketEmailResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sentTo';
    yield serializers.serialize(
      object.sentTo,
      specifiedType: const FullType(String),
    );
    yield r'resendAfterSeconds';
    yield serializers.serialize(
      object.resendAfterSeconds,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketEmailResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketEmailResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sentTo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sentTo = valueDes;
          break;
        case r'resendAfterSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.resendAfterSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketEmailResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketEmailResponseDtoOutputBuilder();
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


