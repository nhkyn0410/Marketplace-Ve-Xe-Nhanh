//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_passenger_list_dto_output_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_passenger_list_dto_output_items_inner.dart';
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner_before_stops_inner.dart';
import 'package:api_client_dart/src/model/trip_passenger_list_dto_output_trip.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_passenger_list_dto_output.g.dart';

/// TripPassengerListDtoOutput
///
/// Properties:
/// * [trip] 
/// * [summary] 
/// * [pickups] 
/// * [items] 
@BuiltValue()
abstract class TripPassengerListDtoOutput implements Built<TripPassengerListDtoOutput, TripPassengerListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'trip')
  TripPassengerListDtoOutputTrip get trip;

  @BuiltValueField(wireName: r'summary')
  TripPassengerListDtoOutputSummary get summary;

  @BuiltValueField(wireName: r'pickups')
  BuiltList<TripSalesDtoOutputChangesInnerBeforeStopsInner> get pickups;

  @BuiltValueField(wireName: r'items')
  BuiltList<TripPassengerListDtoOutputItemsInner> get items;

  TripPassengerListDtoOutput._();

  factory TripPassengerListDtoOutput([void updates(TripPassengerListDtoOutputBuilder b)]) = _$TripPassengerListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripPassengerListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripPassengerListDtoOutput> get serializer => _$TripPassengerListDtoOutputSerializer();
}

class _$TripPassengerListDtoOutputSerializer implements PrimitiveSerializer<TripPassengerListDtoOutput> {
  @override
  final Iterable<Type> types = const [TripPassengerListDtoOutput, _$TripPassengerListDtoOutput];

  @override
  final String wireName = r'TripPassengerListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripPassengerListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(TripPassengerListDtoOutputTrip),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(TripPassengerListDtoOutputSummary),
    );
    yield r'pickups';
    yield serializers.serialize(
      object.pickups,
      specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner)]),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(TripPassengerListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripPassengerListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripPassengerListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripPassengerListDtoOutputTrip),
          ) as TripPassengerListDtoOutputTrip;
          result.trip.replace(valueDes);
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripPassengerListDtoOutputSummary),
          ) as TripPassengerListDtoOutputSummary;
          result.summary.replace(valueDes);
          break;
        case r'pickups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner)]),
          ) as BuiltList<TripSalesDtoOutputChangesInnerBeforeStopsInner>;
          result.pickups.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripPassengerListDtoOutputItemsInner)]),
          ) as BuiltList<TripPassengerListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripPassengerListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripPassengerListDtoOutputBuilder();
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


