//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_schedule_generate_response_dto_output_skipped_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_schedule_generate_response_dto_output_created_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_schedule_generate_response_dto_output.g.dart';

/// TripScheduleGenerateResponseDtoOutput
///
/// Properties:
/// * [created] 
/// * [skipped] 
@BuiltValue()
abstract class TripScheduleGenerateResponseDtoOutput implements Built<TripScheduleGenerateResponseDtoOutput, TripScheduleGenerateResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'created')
  BuiltList<TripScheduleGenerateResponseDtoOutputCreatedInner> get created;

  @BuiltValueField(wireName: r'skipped')
  BuiltList<TripScheduleGenerateResponseDtoOutputSkippedInner> get skipped;

  TripScheduleGenerateResponseDtoOutput._();

  factory TripScheduleGenerateResponseDtoOutput([void updates(TripScheduleGenerateResponseDtoOutputBuilder b)]) = _$TripScheduleGenerateResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripScheduleGenerateResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripScheduleGenerateResponseDtoOutput> get serializer => _$TripScheduleGenerateResponseDtoOutputSerializer();
}

class _$TripScheduleGenerateResponseDtoOutputSerializer implements PrimitiveSerializer<TripScheduleGenerateResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [TripScheduleGenerateResponseDtoOutput, _$TripScheduleGenerateResponseDtoOutput];

  @override
  final String wireName = r'TripScheduleGenerateResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripScheduleGenerateResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created';
    yield serializers.serialize(
      object.created,
      specifiedType: const FullType(BuiltList, [FullType(TripScheduleGenerateResponseDtoOutputCreatedInner)]),
    );
    yield r'skipped';
    yield serializers.serialize(
      object.skipped,
      specifiedType: const FullType(BuiltList, [FullType(TripScheduleGenerateResponseDtoOutputSkippedInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripScheduleGenerateResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripScheduleGenerateResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripScheduleGenerateResponseDtoOutputCreatedInner)]),
          ) as BuiltList<TripScheduleGenerateResponseDtoOutputCreatedInner>;
          result.created.replace(valueDes);
          break;
        case r'skipped':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripScheduleGenerateResponseDtoOutputSkippedInner)]),
          ) as BuiltList<TripScheduleGenerateResponseDtoOutputSkippedInner>;
          result.skipped.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripScheduleGenerateResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripScheduleGenerateResponseDtoOutputBuilder();
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


