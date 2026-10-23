//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_schedule_list_response_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_schedule_list_response_dto_output.g.dart';

/// TripScheduleListResponseDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class TripScheduleListResponseDtoOutput implements Built<TripScheduleListResponseDtoOutput, TripScheduleListResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<TripScheduleListResponseDtoOutputItemsInner> get items;

  TripScheduleListResponseDtoOutput._();

  factory TripScheduleListResponseDtoOutput([void updates(TripScheduleListResponseDtoOutputBuilder b)]) = _$TripScheduleListResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripScheduleListResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripScheduleListResponseDtoOutput> get serializer => _$TripScheduleListResponseDtoOutputSerializer();
}

class _$TripScheduleListResponseDtoOutputSerializer implements PrimitiveSerializer<TripScheduleListResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [TripScheduleListResponseDtoOutput, _$TripScheduleListResponseDtoOutput];

  @override
  final String wireName = r'TripScheduleListResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripScheduleListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(TripScheduleListResponseDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripScheduleListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripScheduleListResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripScheduleListResponseDtoOutputItemsInner)]),
          ) as BuiltList<TripScheduleListResponseDtoOutputItemsInner>;
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
  TripScheduleListResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripScheduleListResponseDtoOutputBuilder();
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


