//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_dto_output_tickets_inner.g.dart';

/// CounterBookingDtoOutputTicketsInner
///
/// Properties:
/// * [ticketId] 
/// * [ticketCode] 
/// * [seatCode] 
/// * [passengerName] 
/// * [status] 
/// * [qrToken] 
@BuiltValue()
abstract class CounterBookingDtoOutputTicketsInner implements Built<CounterBookingDtoOutputTicketsInner, CounterBookingDtoOutputTicketsInnerBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'qrToken')
  String get qrToken;

  CounterBookingDtoOutputTicketsInner._();

  factory CounterBookingDtoOutputTicketsInner([void updates(CounterBookingDtoOutputTicketsInnerBuilder b)]) = _$CounterBookingDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingDtoOutputTicketsInner> get serializer => _$CounterBookingDtoOutputTicketsInnerSerializer();
}

class _$CounterBookingDtoOutputTicketsInnerSerializer implements PrimitiveSerializer<CounterBookingDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [CounterBookingDtoOutputTicketsInner, _$CounterBookingDtoOutputTicketsInner];

  @override
  final String wireName = r'CounterBookingDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'passengerName';
    yield serializers.serialize(
      object.passengerName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'qrToken';
    yield serializers.serialize(
      object.qrToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingDtoOutputTicketsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketId = valueDes;
          break;
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'passengerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passengerName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'qrToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qrToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingDtoOutputTicketsInnerBuilder();
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


