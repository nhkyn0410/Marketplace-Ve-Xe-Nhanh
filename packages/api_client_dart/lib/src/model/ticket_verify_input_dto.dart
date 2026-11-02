//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_verify_input_dto.g.dart';

/// TicketVerifyInputDto
///
/// Properties:
/// * [tripId] 
/// * [code] 
@BuiltValue()
abstract class TicketVerifyInputDto implements Built<TicketVerifyInputDto, TicketVerifyInputDtoBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'code')
  String get code;

  TicketVerifyInputDto._();

  factory TicketVerifyInputDto([void updates(TicketVerifyInputDtoBuilder b)]) = _$TicketVerifyInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketVerifyInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketVerifyInputDto> get serializer => _$TicketVerifyInputDtoSerializer();
}

class _$TicketVerifyInputDtoSerializer implements PrimitiveSerializer<TicketVerifyInputDto> {
  @override
  final Iterable<Type> types = const [TicketVerifyInputDto, _$TicketVerifyInputDto];

  @override
  final String wireName = r'TicketVerifyInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketVerifyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketVerifyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketVerifyInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketVerifyInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketVerifyInputDtoBuilder();
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


