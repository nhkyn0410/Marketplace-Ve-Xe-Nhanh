//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'background_jobs_dto_output_jobs_inner_last_run.g.dart';

/// BackgroundJobsDtoOutputJobsInnerLastRun
///
/// Properties:
/// * [state] 
/// * [at] 
/// * [processed] 
/// * [error] 
/// * [attempts] 
@BuiltValue()
abstract class BackgroundJobsDtoOutputJobsInnerLastRun implements Built<BackgroundJobsDtoOutputJobsInnerLastRun, BackgroundJobsDtoOutputJobsInnerLastRunBuilder> {
  @BuiltValueField(wireName: r'state')
  BackgroundJobsDtoOutputJobsInnerLastRunStateEnum get state;
  // enum stateEnum {  completed,  failed,  active,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'processed')
  int? get processed;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'attempts')
  int get attempts;

  BackgroundJobsDtoOutputJobsInnerLastRun._();

  factory BackgroundJobsDtoOutputJobsInnerLastRun([void updates(BackgroundJobsDtoOutputJobsInnerLastRunBuilder b)]) = _$BackgroundJobsDtoOutputJobsInnerLastRun;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackgroundJobsDtoOutputJobsInnerLastRunBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackgroundJobsDtoOutputJobsInnerLastRun> get serializer => _$BackgroundJobsDtoOutputJobsInnerLastRunSerializer();
}

class _$BackgroundJobsDtoOutputJobsInnerLastRunSerializer implements PrimitiveSerializer<BackgroundJobsDtoOutputJobsInnerLastRun> {
  @override
  final Iterable<Type> types = const [BackgroundJobsDtoOutputJobsInnerLastRun, _$BackgroundJobsDtoOutputJobsInnerLastRun];

  @override
  final String wireName = r'BackgroundJobsDtoOutputJobsInnerLastRun';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackgroundJobsDtoOutputJobsInnerLastRun object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(BackgroundJobsDtoOutputJobsInnerLastRunStateEnum),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'processed';
    yield object.processed == null ? null : serializers.serialize(
      object.processed,
      specifiedType: const FullType.nullable(int),
    );
    yield r'error';
    yield object.error == null ? null : serializers.serialize(
      object.error,
      specifiedType: const FullType.nullable(String),
    );
    yield r'attempts';
    yield serializers.serialize(
      object.attempts,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackgroundJobsDtoOutputJobsInnerLastRun object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackgroundJobsDtoOutputJobsInnerLastRunBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BackgroundJobsDtoOutputJobsInnerLastRunStateEnum),
          ) as BackgroundJobsDtoOutputJobsInnerLastRunStateEnum;
          result.state = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'processed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.processed = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attempts = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackgroundJobsDtoOutputJobsInnerLastRun deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackgroundJobsDtoOutputJobsInnerLastRunBuilder();
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


class BackgroundJobsDtoOutputJobsInnerLastRunStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'completed')
  static const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum completed = _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_completed;
  @BuiltValueEnumConst(wireName: r'failed')
  static const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum failed = _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_failed;
  @BuiltValueEnumConst(wireName: r'active')
  static const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum active = _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_active;

  static Serializer<BackgroundJobsDtoOutputJobsInnerLastRunStateEnum> get serializer => _$backgroundJobsDtoOutputJobsInnerLastRunStateEnumSerializer;

  const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum._(String name): super(name);

  static BuiltSet<BackgroundJobsDtoOutputJobsInnerLastRunStateEnum> get values => _$backgroundJobsDtoOutputJobsInnerLastRunStateEnumValues;
  static BackgroundJobsDtoOutputJobsInnerLastRunStateEnum valueOf(String name) => _$backgroundJobsDtoOutputJobsInnerLastRunStateEnumValueOf(name);
}

