//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/public_trip_dto_output_operator.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_amenities_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_vehicle_type.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_cancellation_policy.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_seats_inner.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_stops_inner.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_vehicle_images_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output.g.dart';

/// PublicTripDtoOutput
///
/// Properties:
/// * [tripId] 
/// * [operator_] 
/// * [routeName] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [onlineSaleClosesAt] 
/// * [note] 
/// * [vehicleType] 
/// * [amenities] 
/// * [vehicleImages] 
/// * [stops] 
/// * [seats] 
/// * [cancellationPolicy] 
@BuiltValue()
abstract class PublicTripDtoOutput implements Built<PublicTripDtoOutput, PublicTripDtoOutputBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'operator')
  PublicTripDtoOutputOperator get operator_;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'onlineSaleClosesAt')
  DateTime get onlineSaleClosesAt;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'vehicleType')
  TripSearchResponseDtoOutputItemsInnerVehicleType get vehicleType;

  @BuiltValueField(wireName: r'amenities')
  BuiltList<TripSearchResponseDtoOutputItemsInnerAmenitiesInner> get amenities;

  @BuiltValueField(wireName: r'vehicleImages')
  BuiltList<PublicTripDtoOutputVehicleImagesInner> get vehicleImages;

  @BuiltValueField(wireName: r'stops')
  BuiltList<PublicTripDtoOutputStopsInner> get stops;

  @BuiltValueField(wireName: r'seats')
  BuiltList<PublicTripDtoOutputSeatsInner> get seats;

  @BuiltValueField(wireName: r'cancellationPolicy')
  PublicTripDtoOutputCancellationPolicy get cancellationPolicy;

  PublicTripDtoOutput._();

  factory PublicTripDtoOutput([void updates(PublicTripDtoOutputBuilder b)]) = _$PublicTripDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutput> get serializer => _$PublicTripDtoOutputSerializer();
}

class _$PublicTripDtoOutputSerializer implements PrimitiveSerializer<PublicTripDtoOutput> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutput, _$PublicTripDtoOutput];

  @override
  final String wireName = r'PublicTripDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutput object, {
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
      specifiedType: const FullType(PublicTripDtoOutputOperator),
    );
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
    yield r'onlineSaleClosesAt';
    yield serializers.serialize(
      object.onlineSaleClosesAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vehicleType';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleType),
    );
    yield r'amenities';
    yield serializers.serialize(
      object.amenities,
      specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputItemsInnerAmenitiesInner)]),
    );
    yield r'vehicleImages';
    yield serializers.serialize(
      object.vehicleImages,
      specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputVehicleImagesInner)]),
    );
    yield r'stops';
    yield serializers.serialize(
      object.stops,
      specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputStopsInner)]),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputSeatsInner)]),
    );
    yield r'cancellationPolicy';
    yield serializers.serialize(
      object.cancellationPolicy,
      specifiedType: const FullType(PublicTripDtoOutputCancellationPolicy),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputBuilder result,
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
            specifiedType: const FullType(PublicTripDtoOutputOperator),
          ) as PublicTripDtoOutputOperator;
          result.operator_.replace(valueDes);
          break;
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
        case r'onlineSaleClosesAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.onlineSaleClosesAt = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'vehicleType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleType),
          ) as TripSearchResponseDtoOutputItemsInnerVehicleType;
          result.vehicleType.replace(valueDes);
          break;
        case r'amenities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputItemsInnerAmenitiesInner)]),
          ) as BuiltList<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>;
          result.amenities.replace(valueDes);
          break;
        case r'vehicleImages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputVehicleImagesInner)]),
          ) as BuiltList<PublicTripDtoOutputVehicleImagesInner>;
          result.vehicleImages.replace(valueDes);
          break;
        case r'stops':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputStopsInner)]),
          ) as BuiltList<PublicTripDtoOutputStopsInner>;
          result.stops.replace(valueDes);
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputSeatsInner)]),
          ) as BuiltList<PublicTripDtoOutputSeatsInner>;
          result.seats.replace(valueDes);
          break;
        case r'cancellationPolicy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputCancellationPolicy),
          ) as PublicTripDtoOutputCancellationPolicy;
          result.cancellationPolicy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicTripDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputBuilder();
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


