//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner_before_stops_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_sales_dto_output_changes_inner_before.g.dart';

/// TripSalesDtoOutputChangesInnerBefore
///
/// Properties:
/// * [departureAt] 
/// * [arrivalAt] 
/// * [vehiclePlateNumber] 
/// * [stops] 
@BuiltValue()
abstract class TripSalesDtoOutputChangesInnerBefore implements Built<TripSalesDtoOutputChangesInnerBefore, TripSalesDtoOutputChangesInnerBeforeBuilder> {
  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'stops')
  BuiltList<TripSalesDtoOutputChangesInnerBeforeStopsInner> get stops;

  TripSalesDtoOutputChangesInnerBefore._();

  factory TripSalesDtoOutputChangesInnerBefore([void updates(TripSalesDtoOutputChangesInnerBeforeBuilder b)]) = _$TripSalesDtoOutputChangesInnerBefore;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSalesDtoOutputChangesInnerBeforeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSalesDtoOutputChangesInnerBefore> get serializer => _$TripSalesDtoOutputChangesInnerBeforeSerializer();
}

class _$TripSalesDtoOutputChangesInnerBeforeSerializer implements PrimitiveSerializer<TripSalesDtoOutputChangesInnerBefore> {
  @override
  final Iterable<Type> types = const [TripSalesDtoOutputChangesInnerBefore, _$TripSalesDtoOutputChangesInnerBefore];

  @override
  final String wireName = r'TripSalesDtoOutputChangesInnerBefore';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSalesDtoOutputChangesInnerBefore object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stops';
    yield serializers.serialize(
      object.stops,
      specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSalesDtoOutputChangesInnerBefore object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSalesDtoOutputChangesInnerBeforeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner)]),
          ) as BuiltList<TripSalesDtoOutputChangesInnerBeforeStopsInner>;
          result.stops.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSalesDtoOutputChangesInnerBefore deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSalesDtoOutputChangesInnerBeforeBuilder();
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


