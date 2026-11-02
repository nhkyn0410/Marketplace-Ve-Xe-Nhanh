//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_trip_list_dto_output_items_inner_stops_inner.g.dart';

/// CounterTripListDtoOutputItemsInnerStopsInner
///
/// Properties:
/// * [sequence] 
/// * [name] 
/// * [plannedAt] 
/// * [allowPickup] 
/// * [allowDropoff] 
@BuiltValue()
abstract class CounterTripListDtoOutputItemsInnerStopsInner implements Built<CounterTripListDtoOutputItemsInnerStopsInner, CounterTripListDtoOutputItemsInnerStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'plannedAt')
  DateTime get plannedAt;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  CounterTripListDtoOutputItemsInnerStopsInner._();

  factory CounterTripListDtoOutputItemsInnerStopsInner([void updates(CounterTripListDtoOutputItemsInnerStopsInnerBuilder b)]) = _$CounterTripListDtoOutputItemsInnerStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterTripListDtoOutputItemsInnerStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterTripListDtoOutputItemsInnerStopsInner> get serializer => _$CounterTripListDtoOutputItemsInnerStopsInnerSerializer();
}

class _$CounterTripListDtoOutputItemsInnerStopsInnerSerializer implements PrimitiveSerializer<CounterTripListDtoOutputItemsInnerStopsInner> {
  @override
  final Iterable<Type> types = const [CounterTripListDtoOutputItemsInnerStopsInner, _$CounterTripListDtoOutputItemsInnerStopsInner];

  @override
  final String wireName = r'CounterTripListDtoOutputItemsInnerStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterTripListDtoOutputItemsInnerStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'plannedAt';
    yield serializers.serialize(
      object.plannedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'allowPickup';
    yield serializers.serialize(
      object.allowPickup,
      specifiedType: const FullType(bool),
    );
    yield r'allowDropoff';
    yield serializers.serialize(
      object.allowDropoff,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterTripListDtoOutputItemsInnerStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterTripListDtoOutputItemsInnerStopsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'plannedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.plannedAt = valueDes;
          break;
        case r'allowPickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowPickup = valueDes;
          break;
        case r'allowDropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowDropoff = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterTripListDtoOutputItemsInnerStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterTripListDtoOutputItemsInnerStopsInnerBuilder();
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


