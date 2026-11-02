//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/ticket_verify_result_dto_output_ticket_trip.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/ticket_verify_result_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_verify_result_dto_output.g.dart';

/// TicketVerifyResultDtoOutput
///
/// Properties:
/// * [result] 
/// * [ticket] 
/// * [ticketCode] 
/// * [ticketTrip] 
@BuiltValue()
abstract class TicketVerifyResultDtoOutput implements Built<TicketVerifyResultDtoOutput, TicketVerifyResultDtoOutputBuilder> {
  @BuiltValueField(wireName: r'result')
  TicketVerifyResultDtoOutputResultEnum get result;
  // enum resultEnum {  OK,  WRONG_TRIP,  ALREADY_CHECKED_IN,  CANCELLED,  REFUNDED,  NO_SHOW,  USED,  };

  @BuiltValueField(wireName: r'ticket')
  TicketVerifyResultDtoOutputTicket? get ticket;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'ticketTrip')
  TicketVerifyResultDtoOutputTicketTrip? get ticketTrip;

  TicketVerifyResultDtoOutput._();

  factory TicketVerifyResultDtoOutput([void updates(TicketVerifyResultDtoOutputBuilder b)]) = _$TicketVerifyResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketVerifyResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketVerifyResultDtoOutput> get serializer => _$TicketVerifyResultDtoOutputSerializer();
}

class _$TicketVerifyResultDtoOutputSerializer implements PrimitiveSerializer<TicketVerifyResultDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketVerifyResultDtoOutput, _$TicketVerifyResultDtoOutput];

  @override
  final String wireName = r'TicketVerifyResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketVerifyResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(TicketVerifyResultDtoOutputResultEnum),
    );
    yield r'ticket';
    yield object.ticket == null ? null : serializers.serialize(
      object.ticket,
      specifiedType: const FullType.nullable(TicketVerifyResultDtoOutputTicket),
    );
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'ticketTrip';
    yield object.ticketTrip == null ? null : serializers.serialize(
      object.ticketTrip,
      specifiedType: const FullType.nullable(TicketVerifyResultDtoOutputTicketTrip),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketVerifyResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketVerifyResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketVerifyResultDtoOutputResultEnum),
          ) as TicketVerifyResultDtoOutputResultEnum;
          result.result = valueDes;
          break;
        case r'ticket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TicketVerifyResultDtoOutputTicket),
          ) as TicketVerifyResultDtoOutputTicket?;
          if (valueDes == null) continue;
          result.ticket.replace(valueDes);
          break;
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'ticketTrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TicketVerifyResultDtoOutputTicketTrip),
          ) as TicketVerifyResultDtoOutputTicketTrip?;
          if (valueDes == null) continue;
          result.ticketTrip.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketVerifyResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketVerifyResultDtoOutputBuilder();
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


class TicketVerifyResultDtoOutputResultEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const TicketVerifyResultDtoOutputResultEnum OK = _$ticketVerifyResultDtoOutputResultEnum_OK;
  @BuiltValueEnumConst(wireName: r'WRONG_TRIP')
  static const TicketVerifyResultDtoOutputResultEnum WRONG_TRIP = _$ticketVerifyResultDtoOutputResultEnum_WRONG_TRIP;
  @BuiltValueEnumConst(wireName: r'ALREADY_CHECKED_IN')
  static const TicketVerifyResultDtoOutputResultEnum ALREADY_CHECKED_IN = _$ticketVerifyResultDtoOutputResultEnum_ALREADY_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TicketVerifyResultDtoOutputResultEnum CANCELLED = _$ticketVerifyResultDtoOutputResultEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TicketVerifyResultDtoOutputResultEnum REFUNDED = _$ticketVerifyResultDtoOutputResultEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const TicketVerifyResultDtoOutputResultEnum NO_SHOW = _$ticketVerifyResultDtoOutputResultEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const TicketVerifyResultDtoOutputResultEnum USED = _$ticketVerifyResultDtoOutputResultEnum_USED;

  static Serializer<TicketVerifyResultDtoOutputResultEnum> get serializer => _$ticketVerifyResultDtoOutputResultEnumSerializer;

  const TicketVerifyResultDtoOutputResultEnum._(String name): super(name);

  static BuiltSet<TicketVerifyResultDtoOutputResultEnum> get values => _$ticketVerifyResultDtoOutputResultEnumValues;
  static TicketVerifyResultDtoOutputResultEnum valueOf(String name) => _$ticketVerifyResultDtoOutputResultEnumValueOf(name);
}

