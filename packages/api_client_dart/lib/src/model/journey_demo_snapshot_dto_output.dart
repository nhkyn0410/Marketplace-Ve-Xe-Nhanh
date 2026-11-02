//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journey_demo_snapshot_dto_output.g.dart';

/// JourneyDemoSnapshotDtoOutput
///
/// Properties:
/// * [type] 
/// * [schemaVersion] 
/// * [sessionId] 
/// * [bookingId] 
/// * [revision] 
/// * [stage] 
/// * [routeLabel] 
/// * [provinceName] 
/// * [etaAt] 
/// * [progress] 
/// * [updatedAt] 
/// * [expiresAt] 
/// * [ended] 
@BuiltValue()
abstract class JourneyDemoSnapshotDtoOutput implements Built<JourneyDemoSnapshotDtoOutput, JourneyDemoSnapshotDtoOutputBuilder> {
  @BuiltValueField(wireName: r'type')
  JourneyDemoSnapshotDtoOutputTypeEnum get type;
  // enum typeEnum {  journey_demo,  };

  @BuiltValueField(wireName: r'schemaVersion')
  int get schemaVersion;

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'stage')
  JourneyDemoSnapshotDtoOutputStageEnum get stage;
  // enum stageEnum {  approaching,  travelling,  arrived,  stopped,  };

  @BuiltValueField(wireName: r'routeLabel')
  String get routeLabel;

  @BuiltValueField(wireName: r'provinceName')
  String get provinceName;

  @BuiltValueField(wireName: r'etaAt')
  DateTime get etaAt;

  @BuiltValueField(wireName: r'progress')
  int get progress;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'ended')
  bool get ended;

  JourneyDemoSnapshotDtoOutput._();

  factory JourneyDemoSnapshotDtoOutput([void updates(JourneyDemoSnapshotDtoOutputBuilder b)]) = _$JourneyDemoSnapshotDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JourneyDemoSnapshotDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JourneyDemoSnapshotDtoOutput> get serializer => _$JourneyDemoSnapshotDtoOutputSerializer();
}

class _$JourneyDemoSnapshotDtoOutputSerializer implements PrimitiveSerializer<JourneyDemoSnapshotDtoOutput> {
  @override
  final Iterable<Type> types = const [JourneyDemoSnapshotDtoOutput, _$JourneyDemoSnapshotDtoOutput];

  @override
  final String wireName = r'JourneyDemoSnapshotDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JourneyDemoSnapshotDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(JourneyDemoSnapshotDtoOutputTypeEnum),
    );
    yield r'schemaVersion';
    yield serializers.serialize(
      object.schemaVersion,
      specifiedType: const FullType(int),
    );
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'stage';
    yield serializers.serialize(
      object.stage,
      specifiedType: const FullType(JourneyDemoSnapshotDtoOutputStageEnum),
    );
    yield r'routeLabel';
    yield serializers.serialize(
      object.routeLabel,
      specifiedType: const FullType(String),
    );
    yield r'provinceName';
    yield serializers.serialize(
      object.provinceName,
      specifiedType: const FullType(String),
    );
    yield r'etaAt';
    yield serializers.serialize(
      object.etaAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'progress';
    yield serializers.serialize(
      object.progress,
      specifiedType: const FullType(int),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'ended';
    yield serializers.serialize(
      object.ended,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JourneyDemoSnapshotDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JourneyDemoSnapshotDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JourneyDemoSnapshotDtoOutputTypeEnum),
          ) as JourneyDemoSnapshotDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'schemaVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.schemaVersion = valueDes;
          break;
        case r'sessionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'stage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JourneyDemoSnapshotDtoOutputStageEnum),
          ) as JourneyDemoSnapshotDtoOutputStageEnum;
          result.stage = valueDes;
          break;
        case r'routeLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeLabel = valueDes;
          break;
        case r'provinceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceName = valueDes;
          break;
        case r'etaAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.etaAt = valueDes;
          break;
        case r'progress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.progress = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'ended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ended = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JourneyDemoSnapshotDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JourneyDemoSnapshotDtoOutputBuilder();
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


class JourneyDemoSnapshotDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'journey_demo')
  static const JourneyDemoSnapshotDtoOutputTypeEnum journeyDemo = _$journeyDemoSnapshotDtoOutputTypeEnum_journeyDemo;

  static Serializer<JourneyDemoSnapshotDtoOutputTypeEnum> get serializer => _$journeyDemoSnapshotDtoOutputTypeEnumSerializer;

  const JourneyDemoSnapshotDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<JourneyDemoSnapshotDtoOutputTypeEnum> get values => _$journeyDemoSnapshotDtoOutputTypeEnumValues;
  static JourneyDemoSnapshotDtoOutputTypeEnum valueOf(String name) => _$journeyDemoSnapshotDtoOutputTypeEnumValueOf(name);
}

class JourneyDemoSnapshotDtoOutputStageEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'approaching')
  static const JourneyDemoSnapshotDtoOutputStageEnum approaching = _$journeyDemoSnapshotDtoOutputStageEnum_approaching;
  @BuiltValueEnumConst(wireName: r'travelling')
  static const JourneyDemoSnapshotDtoOutputStageEnum travelling = _$journeyDemoSnapshotDtoOutputStageEnum_travelling;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const JourneyDemoSnapshotDtoOutputStageEnum arrived = _$journeyDemoSnapshotDtoOutputStageEnum_arrived;
  @BuiltValueEnumConst(wireName: r'stopped')
  static const JourneyDemoSnapshotDtoOutputStageEnum stopped = _$journeyDemoSnapshotDtoOutputStageEnum_stopped;

  static Serializer<JourneyDemoSnapshotDtoOutputStageEnum> get serializer => _$journeyDemoSnapshotDtoOutputStageEnumSerializer;

  const JourneyDemoSnapshotDtoOutputStageEnum._(String name): super(name);

  static BuiltSet<JourneyDemoSnapshotDtoOutputStageEnum> get values => _$journeyDemoSnapshotDtoOutputStageEnumValues;
  static JourneyDemoSnapshotDtoOutputStageEnum valueOf(String name) => _$journeyDemoSnapshotDtoOutputStageEnumValueOf(name);
}

