//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_access_dto_output.g.dart';

/// TicketLookupAccessDtoOutput
///
/// Properties:
/// * [bookingId] 
/// * [accessToken] 
/// * [expiresAt] 
@BuiltValue()
abstract class TicketLookupAccessDtoOutput implements Built<TicketLookupAccessDtoOutput, TicketLookupAccessDtoOutputBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  TicketLookupAccessDtoOutput._();

  factory TicketLookupAccessDtoOutput([void updates(TicketLookupAccessDtoOutputBuilder b)]) = _$TicketLookupAccessDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupAccessDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupAccessDtoOutput> get serializer => _$TicketLookupAccessDtoOutputSerializer();
}

class _$TicketLookupAccessDtoOutputSerializer implements PrimitiveSerializer<TicketLookupAccessDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketLookupAccessDtoOutput, _$TicketLookupAccessDtoOutput];

  @override
  final String wireName = r'TicketLookupAccessDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupAccessDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
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
    TicketLookupAccessDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupAccessDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
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
  TicketLookupAccessDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupAccessDtoOutputBuilder();
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


