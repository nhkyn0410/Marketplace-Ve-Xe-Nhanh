//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_trip_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_trip_list_dto_output.g.dart';

/// CounterTripListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class CounterTripListDtoOutput implements Built<CounterTripListDtoOutput, CounterTripListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CounterTripListDtoOutputItemsInner> get items;

  CounterTripListDtoOutput._();

  factory CounterTripListDtoOutput([void updates(CounterTripListDtoOutputBuilder b)]) = _$CounterTripListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterTripListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterTripListDtoOutput> get serializer => _$CounterTripListDtoOutputSerializer();
}

class _$CounterTripListDtoOutputSerializer implements PrimitiveSerializer<CounterTripListDtoOutput> {
  @override
  final Iterable<Type> types = const [CounterTripListDtoOutput, _$CounterTripListDtoOutput];

  @override
  final String wireName = r'CounterTripListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterTripListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CounterTripListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterTripListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterTripListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterTripListDtoOutputItemsInner)]),
          ) as BuiltList<CounterTripListDtoOutputItemsInner>;
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
  CounterTripListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterTripListDtoOutputBuilder();
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


