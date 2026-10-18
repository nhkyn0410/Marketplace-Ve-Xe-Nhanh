//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_amenities_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_vehicle_type.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_pickup.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_operator.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_items_inner.g.dart';

/// TripSearchResponseDtoOutputItemsInner
///
/// Properties:
/// * [tripId] 
/// * [operator_] 
/// * [routeName] 
/// * [vehicleType] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [pickup] 
/// * [dropoff] 
/// * [durationMinutes] 
/// * [availableSeats] 
/// * [minPrice] 
/// * [vehicleCoverImageUrl] 
/// * [amenities] 
/// * [onlineSaleClosesAt] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputItemsInner implements Built<TripSearchResponseDtoOutputItemsInner, TripSearchResponseDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'operator')
  TripSearchResponseDtoOutputItemsInnerOperator get operator_;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'vehicleType')
  TripSearchResponseDtoOutputItemsInnerVehicleType get vehicleType;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'pickup')
  TripSearchResponseDtoOutputItemsInnerPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripSearchResponseDtoOutputItemsInnerPickup get dropoff;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'availableSeats')
  int get availableSeats;

  @BuiltValueField(wireName: r'minPrice')
  int get minPrice;

  @BuiltValueField(wireName: r'vehicleCoverImageUrl')
  String? get vehicleCoverImageUrl;

  @BuiltValueField(wireName: r'amenities')
  BuiltList<TripSearchResponseDtoOutputItemsInnerAmenitiesInner> get amenities;

  @BuiltValueField(wireName: r'onlineSaleClosesAt')
  DateTime get onlineSaleClosesAt;

  TripSearchResponseDtoOutputItemsInner._();

  factory TripSearchResponseDtoOutputItemsInner([void updates(TripSearchResponseDtoOutputItemsInnerBuilder b)]) = _$TripSearchResponseDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputItemsInner> get serializer => _$TripSearchResponseDtoOutputItemsInnerSerializer();
}

class _$TripSearchResponseDtoOutputItemsInnerSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputItemsInner, _$TripSearchResponseDtoOutputItemsInner];

  @override
  final String wireName = r'TripSearchResponseDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'operator';
    yield serializers.serialize(
      object.operator_,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerOperator),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'vehicleType';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleType),
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
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
    );
    yield r'durationMinutes';
    yield serializers.serialize(
      object.durationMinutes,
      specifiedType: const FullType(int),
    );
    yield r'availableSeats';
    yield serializers.serialize(
      object.availableSeats,
      specifiedType: const FullType(int),
    );
    yield r'minPrice';
    yield serializers.serialize(
      object.minPrice,
      specifiedType: const FullType(int),
    );
    yield r'vehicleCoverImageUrl';
    yield object.vehicleCoverImageUrl == null ? null : serializers.serialize(
      object.vehicleCoverImageUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'amenities';
    yield serializers.serialize(
      object.amenities,
      specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputItemsInnerAmenitiesInner)]),
    );
    yield r'onlineSaleClosesAt';
    yield serializers.serialize(
      object.onlineSaleClosesAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputItemsInnerBuilder result,
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
        case r'operator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerOperator),
          ) as TripSearchResponseDtoOutputItemsInnerOperator;
          result.operator_.replace(valueDes);
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'vehicleType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleType),
          ) as TripSearchResponseDtoOutputItemsInnerVehicleType;
          result.vehicleType.replace(valueDes);
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
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
          ) as TripSearchResponseDtoOutputItemsInnerPickup;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
          ) as TripSearchResponseDtoOutputItemsInnerPickup;
          result.dropoff.replace(valueDes);
          break;
        case r'durationMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationMinutes = valueDes;
          break;
        case r'availableSeats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.availableSeats = valueDes;
          break;
        case r'minPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minPrice = valueDes;
          break;
        case r'vehicleCoverImageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleCoverImageUrl = valueDes;
          break;
        case r'amenities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputItemsInnerAmenitiesInner)]),
          ) as BuiltList<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>;
          result.amenities.replace(valueDes);
          break;
        case r'onlineSaleClosesAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.onlineSaleClosesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputItemsInnerBuilder();
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


