//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_page_dto_output_items_inner_trip.g.dart';

/// OperatorBookingPageDtoOutputItemsInnerTrip
///
/// Properties:
/// * [tripId] 
/// * [departureAt] 
/// * [routeName] 
/// * [vehiclePlateNumber] 
@BuiltValue()
abstract class OperatorBookingPageDtoOutputItemsInnerTrip implements Built<OperatorBookingPageDtoOutputItemsInnerTrip, OperatorBookingPageDtoOutputItemsInnerTripBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  OperatorBookingPageDtoOutputItemsInnerTrip._();

  factory OperatorBookingPageDtoOutputItemsInnerTrip([void updates(OperatorBookingPageDtoOutputItemsInnerTripBuilder b)]) = _$OperatorBookingPageDtoOutputItemsInnerTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingPageDtoOutputItemsInnerTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingPageDtoOutputItemsInnerTrip> get serializer => _$OperatorBookingPageDtoOutputItemsInnerTripSerializer();
}

class _$OperatorBookingPageDtoOutputItemsInnerTripSerializer implements PrimitiveSerializer<OperatorBookingPageDtoOutputItemsInnerTrip> {
  @override
  final Iterable<Type> types = const [OperatorBookingPageDtoOutputItemsInnerTrip, _$OperatorBookingPageDtoOutputItemsInnerTrip];

  @override
  final String wireName = r'OperatorBookingPageDtoOutputItemsInnerTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingPageDtoOutputItemsInnerTrip object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorBookingPageDtoOutputItemsInnerTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingPageDtoOutputItemsInnerTripBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorBookingPageDtoOutputItemsInnerTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingPageDtoOutputItemsInnerTripBuilder();
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


