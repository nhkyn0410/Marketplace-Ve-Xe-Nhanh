//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/ticket_verify_result_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_in_result_dto_output.g.dart';

/// CheckInResultDtoOutput
///
/// Properties:
/// * [ticket] 
/// * [checkedInCount] 
/// * [ticketCount] 
@BuiltValue()
abstract class CheckInResultDtoOutput implements Built<CheckInResultDtoOutput, CheckInResultDtoOutputBuilder> {
  @BuiltValueField(wireName: r'ticket')
  TicketVerifyResultDtoOutputTicket? get ticket;

  @BuiltValueField(wireName: r'checkedInCount')
  int get checkedInCount;

  @BuiltValueField(wireName: r'ticketCount')
  int get ticketCount;

  CheckInResultDtoOutput._();

  factory CheckInResultDtoOutput([void updates(CheckInResultDtoOutputBuilder b)]) = _$CheckInResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckInResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckInResultDtoOutput> get serializer => _$CheckInResultDtoOutputSerializer();
}

class _$CheckInResultDtoOutputSerializer implements PrimitiveSerializer<CheckInResultDtoOutput> {
  @override
  final Iterable<Type> types = const [CheckInResultDtoOutput, _$CheckInResultDtoOutput];

  @override
  final String wireName = r'CheckInResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckInResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticket';
    yield object.ticket == null ? null : serializers.serialize(
      object.ticket,
      specifiedType: const FullType.nullable(TicketVerifyResultDtoOutputTicket),
    );
    yield r'checkedInCount';
    yield serializers.serialize(
      object.checkedInCount,
      specifiedType: const FullType(int),
    );
    yield r'ticketCount';
    yield serializers.serialize(
      object.ticketCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckInResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckInResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TicketVerifyResultDtoOutputTicket),
          ) as TicketVerifyResultDtoOutputTicket?;
          if (valueDes == null) continue;
          result.ticket.replace(valueDes);
          break;
        case r'checkedInCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.checkedInCount = valueDes;
          break;
        case r'ticketCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckInResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckInResultDtoOutputBuilder();
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


