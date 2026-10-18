//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_booking_page_dto_output_items_inner_trip.g.dart';

/// FinanceBookingPageDtoOutputItemsInnerTrip
///
/// Properties:
/// * [tripId] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [routeName] 
@BuiltValue()
abstract class FinanceBookingPageDtoOutputItemsInnerTrip implements Built<FinanceBookingPageDtoOutputItemsInnerTrip, FinanceBookingPageDtoOutputItemsInnerTripBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  FinanceBookingPageDtoOutputItemsInnerTrip._();

  factory FinanceBookingPageDtoOutputItemsInnerTrip([void updates(FinanceBookingPageDtoOutputItemsInnerTripBuilder b)]) = _$FinanceBookingPageDtoOutputItemsInnerTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceBookingPageDtoOutputItemsInnerTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceBookingPageDtoOutputItemsInnerTrip> get serializer => _$FinanceBookingPageDtoOutputItemsInnerTripSerializer();
}

class _$FinanceBookingPageDtoOutputItemsInnerTripSerializer implements PrimitiveSerializer<FinanceBookingPageDtoOutputItemsInnerTrip> {
  @override
  final Iterable<Type> types = const [FinanceBookingPageDtoOutputItemsInnerTrip, _$FinanceBookingPageDtoOutputItemsInnerTrip];

  @override
  final String wireName = r'FinanceBookingPageDtoOutputItemsInnerTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceBookingPageDtoOutputItemsInnerTrip object, {
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
    yield r'arrivalAt';
    yield serializers.serialize(
      object.arrivalAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceBookingPageDtoOutputItemsInnerTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceBookingPageDtoOutputItemsInnerTripBuilder result,
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
        case r'arrivalAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.arrivalAt = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceBookingPageDtoOutputItemsInnerTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceBookingPageDtoOutputItemsInnerTripBuilder();
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


