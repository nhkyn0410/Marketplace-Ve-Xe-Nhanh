//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_dto_output_trip.g.dart';

/// CounterBookingDtoOutputTrip
///
/// Properties:
/// * [routeName] 
/// * [departureAt] 
/// * [arrivalAt] 
@BuiltValue()
abstract class CounterBookingDtoOutputTrip implements Built<CounterBookingDtoOutputTrip, CounterBookingDtoOutputTripBuilder> {
  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  CounterBookingDtoOutputTrip._();

  factory CounterBookingDtoOutputTrip([void updates(CounterBookingDtoOutputTripBuilder b)]) = _$CounterBookingDtoOutputTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingDtoOutputTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingDtoOutputTrip> get serializer => _$CounterBookingDtoOutputTripSerializer();
}

class _$CounterBookingDtoOutputTripSerializer implements PrimitiveSerializer<CounterBookingDtoOutputTrip> {
  @override
  final Iterable<Type> types = const [CounterBookingDtoOutputTrip, _$CounterBookingDtoOutputTrip];

  @override
  final String wireName = r'CounterBookingDtoOutputTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingDtoOutputTrip object, {
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
    yield r'arrivalAt';
    yield serializers.serialize(
      object.arrivalAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingDtoOutputTripBuilder result,
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
        case r'arrivalAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.arrivalAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingDtoOutputTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingDtoOutputTripBuilder();
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


