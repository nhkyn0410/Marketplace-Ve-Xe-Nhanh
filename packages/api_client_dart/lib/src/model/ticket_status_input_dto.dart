//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_status_input_dto.g.dart';

/// TicketStatusInputDto
///
/// Properties:
/// * [status] 
/// * [note] 
@BuiltValue()
abstract class TicketStatusInputDto implements Built<TicketStatusInputDto, TicketStatusInputDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  TicketStatusInputDtoStatusEnum get status;
  // enum statusEnum {  RESOLVED,  CLOSED,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  TicketStatusInputDto._();

  factory TicketStatusInputDto([void updates(TicketStatusInputDtoBuilder b)]) = _$TicketStatusInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketStatusInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketStatusInputDto> get serializer => _$TicketStatusInputDtoSerializer();
}

class _$TicketStatusInputDtoSerializer implements PrimitiveSerializer<TicketStatusInputDto> {
  @override
  final Iterable<Type> types = const [TicketStatusInputDto, _$TicketStatusInputDto];

  @override
  final String wireName = r'TicketStatusInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TicketStatusInputDtoStatusEnum),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketStatusInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketStatusInputDtoStatusEnum),
          ) as TicketStatusInputDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketStatusInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketStatusInputDtoBuilder();
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


class TicketStatusInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const TicketStatusInputDtoStatusEnum RESOLVED = _$ticketStatusInputDtoStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const TicketStatusInputDtoStatusEnum CLOSED = _$ticketStatusInputDtoStatusEnum_CLOSED;

  static Serializer<TicketStatusInputDtoStatusEnum> get serializer => _$ticketStatusInputDtoStatusEnumSerializer;

  const TicketStatusInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<TicketStatusInputDtoStatusEnum> get values => _$ticketStatusInputDtoStatusEnumValues;
  static TicketStatusInputDtoStatusEnum valueOf(String name) => _$ticketStatusInputDtoStatusEnumValueOf(name);
}

