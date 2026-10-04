//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_list_response_dto_output_items_inner_seat_map.g.dart';

/// VehicleListResponseDtoOutputItemsInnerSeatMap
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [seatCount] 
/// * [passengerCapacity] 
/// * [deckCount] 
/// * [inUse] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class VehicleListResponseDtoOutputItemsInnerSeatMap implements Built<VehicleListResponseDtoOutputItemsInnerSeatMap, VehicleListResponseDtoOutputItemsInnerSeatMapBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'seatCount')
  int get seatCount;

  @BuiltValueField(wireName: r'passengerCapacity')
  int get passengerCapacity;

  @BuiltValueField(wireName: r'deckCount')
  int get deckCount;

  @BuiltValueField(wireName: r'inUse')
  bool get inUse;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  VehicleListResponseDtoOutputItemsInnerSeatMap._();

  factory VehicleListResponseDtoOutputItemsInnerSeatMap([void updates(VehicleListResponseDtoOutputItemsInnerSeatMapBuilder b)]) = _$VehicleListResponseDtoOutputItemsInnerSeatMap;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleListResponseDtoOutputItemsInnerSeatMapBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleListResponseDtoOutputItemsInnerSeatMap> get serializer => _$VehicleListResponseDtoOutputItemsInnerSeatMapSerializer();
}

class _$VehicleListResponseDtoOutputItemsInnerSeatMapSerializer implements PrimitiveSerializer<VehicleListResponseDtoOutputItemsInnerSeatMap> {
  @override
  final Iterable<Type> types = const [VehicleListResponseDtoOutputItemsInnerSeatMap, _$VehicleListResponseDtoOutputItemsInnerSeatMap];

  @override
  final String wireName = r'VehicleListResponseDtoOutputItemsInnerSeatMap';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleListResponseDtoOutputItemsInnerSeatMap object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'seatCount';
    yield serializers.serialize(
      object.seatCount,
      specifiedType: const FullType(int),
    );
    yield r'passengerCapacity';
    yield serializers.serialize(
      object.passengerCapacity,
      specifiedType: const FullType(int),
    );
    yield r'deckCount';
    yield serializers.serialize(
      object.deckCount,
      specifiedType: const FullType(int),
    );
    yield r'inUse';
    yield serializers.serialize(
      object.inUse,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleListResponseDtoOutputItemsInnerSeatMap object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleListResponseDtoOutputItemsInnerSeatMapBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'seatCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seatCount = valueDes;
          break;
        case r'passengerCapacity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.passengerCapacity = valueDes;
          break;
        case r'deckCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deckCount = valueDes;
          break;
        case r'inUse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inUse = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VehicleListResponseDtoOutputItemsInnerSeatMap deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleListResponseDtoOutputItemsInnerSeatMapBuilder();
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


