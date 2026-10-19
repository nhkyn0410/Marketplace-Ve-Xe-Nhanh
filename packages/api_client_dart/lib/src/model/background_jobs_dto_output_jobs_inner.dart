//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/background_jobs_dto_output_jobs_inner_last_run.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'background_jobs_dto_output_jobs_inner.g.dart';

/// BackgroundJobsDtoOutputJobsInner
///
/// Properties:
/// * [queue] 
/// * [name] 
/// * [label] 
/// * [schedule] 
/// * [nextRunAt] 
/// * [lastRun] 
/// * [failedCount] 
@BuiltValue()
abstract class BackgroundJobsDtoOutputJobsInner implements Built<BackgroundJobsDtoOutputJobsInner, BackgroundJobsDtoOutputJobsInnerBuilder> {
  @BuiltValueField(wireName: r'queue')
  String get queue;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'schedule')
  String? get schedule;

  @BuiltValueField(wireName: r'nextRunAt')
  DateTime? get nextRunAt;

  @BuiltValueField(wireName: r'lastRun')
  BackgroundJobsDtoOutputJobsInnerLastRun? get lastRun;

  @BuiltValueField(wireName: r'failedCount')
  int get failedCount;

  BackgroundJobsDtoOutputJobsInner._();

  factory BackgroundJobsDtoOutputJobsInner([void updates(BackgroundJobsDtoOutputJobsInnerBuilder b)]) = _$BackgroundJobsDtoOutputJobsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackgroundJobsDtoOutputJobsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackgroundJobsDtoOutputJobsInner> get serializer => _$BackgroundJobsDtoOutputJobsInnerSerializer();
}

class _$BackgroundJobsDtoOutputJobsInnerSerializer implements PrimitiveSerializer<BackgroundJobsDtoOutputJobsInner> {
  @override
  final Iterable<Type> types = const [BackgroundJobsDtoOutputJobsInner, _$BackgroundJobsDtoOutputJobsInner];

  @override
  final String wireName = r'BackgroundJobsDtoOutputJobsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackgroundJobsDtoOutputJobsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'queue';
    yield serializers.serialize(
      object.queue,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'schedule';
    yield object.schedule == null ? null : serializers.serialize(
      object.schedule,
      specifiedType: const FullType.nullable(String),
    );
    yield r'nextRunAt';
    yield object.nextRunAt == null ? null : serializers.serialize(
      object.nextRunAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'lastRun';
    yield object.lastRun == null ? null : serializers.serialize(
      object.lastRun,
      specifiedType: const FullType.nullable(BackgroundJobsDtoOutputJobsInnerLastRun),
    );
    yield r'failedCount';
    yield serializers.serialize(
      object.failedCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackgroundJobsDtoOutputJobsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackgroundJobsDtoOutputJobsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'queue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.queue = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.schedule = valueDes;
          break;
        case r'nextRunAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.nextRunAt = valueDes;
          break;
        case r'lastRun':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BackgroundJobsDtoOutputJobsInnerLastRun),
          ) as BackgroundJobsDtoOutputJobsInnerLastRun?;
          if (valueDes == null) continue;
          result.lastRun.replace(valueDes);
          break;
        case r'failedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.failedCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackgroundJobsDtoOutputJobsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackgroundJobsDtoOutputJobsInnerBuilder();
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


