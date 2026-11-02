//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_session_input_dto.g.dart';

/// TicketLookupSessionInputDto
///
/// Properties:
/// * [lookupToken] 
@BuiltValue()
abstract class TicketLookupSessionInputDto implements Built<TicketLookupSessionInputDto, TicketLookupSessionInputDtoBuilder> {
  @BuiltValueField(wireName: r'lookupToken')
  String get lookupToken;

  TicketLookupSessionInputDto._();

  factory TicketLookupSessionInputDto([void updates(TicketLookupSessionInputDtoBuilder b)]) = _$TicketLookupSessionInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupSessionInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupSessionInputDto> get serializer => _$TicketLookupSessionInputDtoSerializer();
}

class _$TicketLookupSessionInputDtoSerializer implements PrimitiveSerializer<TicketLookupSessionInputDto> {
  @override
  final Iterable<Type> types = const [TicketLookupSessionInputDto, _$TicketLookupSessionInputDto];

  @override
  final String wireName = r'TicketLookupSessionInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupSessionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lookupToken';
    yield serializers.serialize(
      object.lookupToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupSessionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupSessionInputDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketLookupSessionInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupSessionInputDtoBuilder();
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


