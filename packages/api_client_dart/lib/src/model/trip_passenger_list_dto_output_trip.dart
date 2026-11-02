//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_passenger_list_dto_output_trip.g.dart';

/// TripPassengerListDtoOutputTrip
///
/// Properties:
/// * [tripId] 
/// * [departureAt] 
/// * [routeName] 
/// * [vehiclePlateNumber] 
/// * [seatCount] 
@BuiltValue()
abstract class TripPassengerListDtoOutputTrip implements Built<TripPassengerListDtoOutputTrip, TripPassengerListDtoOutputTripBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'seatCount')
  int get seatCount;

  TripPassengerListDtoOutputTrip._();

  factory TripPassengerListDtoOutputTrip([void updates(TripPassengerListDtoOutputTripBuilder b)]) = _$TripPassengerListDtoOutputTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripPassengerListDtoOutputTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripPassengerListDtoOutputTrip> get serializer => _$TripPassengerListDtoOutputTripSerializer();
}

class _$TripPassengerListDtoOutputTripSerializer implements PrimitiveSerializer<TripPassengerListDtoOutputTrip> {
  @override
  final Iterable<Type> types = const [TripPassengerListDtoOutputTrip, _$TripPassengerListDtoOutputTrip];

  @override
  final String wireName = r'TripPassengerListDtoOutputTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripPassengerListDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'seatCount';
    yield serializers.serialize(
      object.seatCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripPassengerListDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripPassengerListDtoOutputTripBuilder result,
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
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'vehiclePlateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlateNumber = valueDes;
          break;
        case r'seatCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seatCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripPassengerListDtoOutputTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripPassengerListDtoOutputTripBuilder();
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


