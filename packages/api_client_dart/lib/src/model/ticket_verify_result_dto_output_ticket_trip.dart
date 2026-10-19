//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_verify_result_dto_output_ticket_trip.g.dart';

/// TicketVerifyResultDtoOutputTicketTrip
///
/// Properties:
/// * [routeName] 
/// * [departureAt] 
@BuiltValue()
abstract class TicketVerifyResultDtoOutputTicketTrip implements Built<TicketVerifyResultDtoOutputTicketTrip, TicketVerifyResultDtoOutputTicketTripBuilder> {
  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  TicketVerifyResultDtoOutputTicketTrip._();

  factory TicketVerifyResultDtoOutputTicketTrip([void updates(TicketVerifyResultDtoOutputTicketTripBuilder b)]) = _$TicketVerifyResultDtoOutputTicketTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketVerifyResultDtoOutputTicketTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketVerifyResultDtoOutputTicketTrip> get serializer => _$TicketVerifyResultDtoOutputTicketTripSerializer();
}

class _$TicketVerifyResultDtoOutputTicketTripSerializer implements PrimitiveSerializer<TicketVerifyResultDtoOutputTicketTrip> {
  @override
  final Iterable<Type> types = const [TicketVerifyResultDtoOutputTicketTrip, _$TicketVerifyResultDtoOutputTicketTrip];

  @override
  final String wireName = r'TicketVerifyResultDtoOutputTicketTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketVerifyResultDtoOutputTicketTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketVerifyResultDtoOutputTicketTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketVerifyResultDtoOutputTicketTripBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketVerifyResultDtoOutputTicketTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketVerifyResultDtoOutputTicketTripBuilder();
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


