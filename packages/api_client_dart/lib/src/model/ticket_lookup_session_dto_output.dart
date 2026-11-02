//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_session_dto_output.g.dart';

/// TicketLookupSessionDtoOutput
///
/// Properties:
/// * [lookupToken] 
/// * [expiresAt] 
@BuiltValue()
abstract class TicketLookupSessionDtoOutput implements Built<TicketLookupSessionDtoOutput, TicketLookupSessionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'lookupToken')
  String get lookupToken;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  TicketLookupSessionDtoOutput._();

  factory TicketLookupSessionDtoOutput([void updates(TicketLookupSessionDtoOutputBuilder b)]) = _$TicketLookupSessionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupSessionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupSessionDtoOutput> get serializer => _$TicketLookupSessionDtoOutputSerializer();
}

class _$TicketLookupSessionDtoOutputSerializer implements PrimitiveSerializer<TicketLookupSessionDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketLookupSessionDtoOutput, _$TicketLookupSessionDtoOutput];

  @override
  final String wireName = r'TicketLookupSessionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lookupToken';
    yield serializers.serialize(
      object.lookupToken,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupSessionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lookupToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lookupToken = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketLookupSessionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupSessionDtoOutputBuilder();
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


