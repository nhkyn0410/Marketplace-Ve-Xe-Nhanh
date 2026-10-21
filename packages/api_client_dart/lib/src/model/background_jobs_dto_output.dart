//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/background_jobs_dto_output_queues_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/background_jobs_dto_output_jobs_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'background_jobs_dto_output.g.dart';

/// BackgroundJobsDtoOutput
///
/// Properties:
/// * [checkedAt] 
/// * [available] 
/// * [jobs] 
/// * [queues] 
@BuiltValue()
abstract class BackgroundJobsDtoOutput implements Built<BackgroundJobsDtoOutput, BackgroundJobsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'checkedAt')
  DateTime get checkedAt;

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'jobs')
  BuiltList<BackgroundJobsDtoOutputJobsInner> get jobs;

  @BuiltValueField(wireName: r'queues')
  BuiltList<BackgroundJobsDtoOutputQueuesInner> get queues;

  BackgroundJobsDtoOutput._();

  factory BackgroundJobsDtoOutput([void updates(BackgroundJobsDtoOutputBuilder b)]) = _$BackgroundJobsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackgroundJobsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackgroundJobsDtoOutput> get serializer => _$BackgroundJobsDtoOutputSerializer();
}

class _$BackgroundJobsDtoOutputSerializer implements PrimitiveSerializer<BackgroundJobsDtoOutput> {
  @override
  final Iterable<Type> types = const [BackgroundJobsDtoOutput, _$BackgroundJobsDtoOutput];

  @override
  final String wireName = r'BackgroundJobsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackgroundJobsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checkedAt';
    yield serializers.serialize(
      object.checkedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'jobs';
    yield serializers.serialize(
      object.jobs,
      specifiedType: const FullType(BuiltList, [FullType(BackgroundJobsDtoOutputJobsInner)]),
    );
    yield r'queues';
    yield serializers.serialize(
      object.queues,
      specifiedType: const FullType(BuiltList, [FullType(BackgroundJobsDtoOutputQueuesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackgroundJobsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackgroundJobsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checkedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.checkedAt = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'jobs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BackgroundJobsDtoOutputJobsInner)]),
          ) as BuiltList<BackgroundJobsDtoOutputJobsInner>;
          result.jobs.replace(valueDes);
          break;
        case r'queues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BackgroundJobsDtoOutputQueuesInner)]),
          ) as BuiltList<BackgroundJobsDtoOutputQueuesInner>;
          result.queues.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackgroundJobsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackgroundJobsDtoOutputBuilder();
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


