//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_input_dto.g.dart';

/// TicketLookupInputDto
///
/// Properties:
/// * [lookupToken] 
/// * [bookingId] 
@BuiltValue()
abstract class TicketLookupInputDto implements Built<TicketLookupInputDto, TicketLookupInputDtoBuilder> {
  @BuiltValueField(wireName: r'lookupToken')
  String get lookupToken;

  @BuiltValueField(wireName: r'bookingId')
  String? get bookingId;

  TicketLookupInputDto._();

  factory TicketLookupInputDto([void updates(TicketLookupInputDtoBuilder b)]) = _$TicketLookupInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupInputDto> get serializer => _$TicketLookupInputDtoSerializer();
}

class _$TicketLookupInputDtoSerializer implements PrimitiveSerializer<TicketLookupInputDto> {
  @override
  final Iterable<Type> types = const [TicketLookupInputDto, _$TicketLookupInputDto];

  @override
  final String wireName = r'TicketLookupInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lookupToken';
    yield serializers.serialize(
      object.lookupToken,
      specifiedType: const FullType(String),
    );
    if (object.bookingId != null) {
      yield r'bookingId';
      yield serializers.serialize(
        object.bookingId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupInputDtoBuilder result,
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
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bookingId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketLookupInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupInputDtoBuilder();
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


