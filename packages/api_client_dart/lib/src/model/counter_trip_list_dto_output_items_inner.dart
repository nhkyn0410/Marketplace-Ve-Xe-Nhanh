//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_trip_list_dto_output_items_inner_stops_inner.dart';
import 'package:api_client_dart/src/model/counter_trip_list_dto_output_items_inner_seats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_trip_list_dto_output_items_inner.g.dart';

/// CounterTripListDtoOutputItemsInner
///
/// Properties:
/// * [tripId] 
/// * [routeName] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [status] 
/// * [vehiclePlateNumber] 
/// * [stops] 
/// * [seats] 
@BuiltValue()
abstract class CounterTripListDtoOutputItemsInner implements Built<CounterTripListDtoOutputItemsInner, CounterTripListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'status')
  CounterTripListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  OPEN_FOR_SALE,  BOARDING,  };

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'stops')
  BuiltList<CounterTripListDtoOutputItemsInnerStopsInner> get stops;

  @BuiltValueField(wireName: r'seats')
  BuiltList<CounterTripListDtoOutputItemsInnerSeatsInner> get seats;

  CounterTripListDtoOutputItemsInner._();

  factory CounterTripListDtoOutputItemsInner([void updates(CounterTripListDtoOutputItemsInnerBuilder b)]) = _$CounterTripListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterTripListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterTripListDtoOutputItemsInner> get serializer => _$CounterTripListDtoOutputItemsInnerSerializer();
}

class _$CounterTripListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<CounterTripListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [CounterTripListDtoOutputItemsInner, _$CounterTripListDtoOutputItemsInner];

  @override
  final String wireName = r'CounterTripListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterTripListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CounterTripListDtoOutputItemsInnerStatusEnum),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stops';
    yield serializers.serialize(
      object.stops,
      specifiedType: const FullType(BuiltList, [FullType(CounterTripListDtoOutputItemsInnerStopsInner)]),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(BuiltList, [FullType(CounterTripListDtoOutputItemsInnerSeatsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterTripListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterTripListDtoOutputItemsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterTripListDtoOutputItemsInnerStatusEnum),
          ) as CounterTripListDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'vehiclePlateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlateNumber = valueDes;
          break;
        case r'stops':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterTripListDtoOutputItemsInnerStopsInner)]),
          ) as BuiltList<CounterTripListDtoOutputItemsInnerStopsInner>;
          result.stops.replace(valueDes);
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterTripListDtoOutputItemsInnerSeatsInner)]),
          ) as BuiltList<CounterTripListDtoOutputItemsInnerSeatsInner>;
          result.seats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterTripListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterTripListDtoOutputItemsInnerBuilder();
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


class CounterTripListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const CounterTripListDtoOutputItemsInnerStatusEnum OPEN_FOR_SALE = _$counterTripListDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const CounterTripListDtoOutputItemsInnerStatusEnum BOARDING = _$counterTripListDtoOutputItemsInnerStatusEnum_BOARDING;

  static Serializer<CounterTripListDtoOutputItemsInnerStatusEnum> get serializer => _$counterTripListDtoOutputItemsInnerStatusEnumSerializer;

  const CounterTripListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CounterTripListDtoOutputItemsInnerStatusEnum> get values => _$counterTripListDtoOutputItemsInnerStatusEnumValues;
  static CounterTripListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$counterTripListDtoOutputItemsInnerStatusEnumValueOf(name);
}

