//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_booking_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_list_dto_output.g.dart';

/// CounterBookingListDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class CounterBookingListDtoOutput implements Built<CounterBookingListDtoOutput, CounterBookingListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CounterBookingListDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  CounterBookingListDtoOutput._();

  factory CounterBookingListDtoOutput([void updates(CounterBookingListDtoOutputBuilder b)]) = _$CounterBookingListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingListDtoOutput> get serializer => _$CounterBookingListDtoOutputSerializer();
}

class _$CounterBookingListDtoOutputSerializer implements PrimitiveSerializer<CounterBookingListDtoOutput> {
  @override
  final Iterable<Type> types = const [CounterBookingListDtoOutput, _$CounterBookingListDtoOutput];

  @override
  final String wireName = r'CounterBookingListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CounterBookingListDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterBookingListDtoOutputItemsInner)]),
          ) as BuiltList<CounterBookingListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingListDtoOutputBuilder();
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


