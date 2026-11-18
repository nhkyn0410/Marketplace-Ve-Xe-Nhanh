//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journey_demo_current_dto_output.g.dart';

/// JourneyDemoCurrentDtoOutput
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
abstract class JourneyDemoCurrentDtoOutput implements Built<JourneyDemoCurrentDtoOutput, JourneyDemoCurrentDtoOutputBuilder> {
  @BuiltValueField(wireName: r'type')
  JourneyDemoCurrentDtoOutputTypeEnum get type;
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
  JourneyDemoCurrentDtoOutputStageEnum get stage;
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

  JourneyDemoCurrentDtoOutput._();

  factory JourneyDemoCurrentDtoOutput([void updates(JourneyDemoCurrentDtoOutputBuilder b)]) = _$JourneyDemoCurrentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JourneyDemoCurrentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JourneyDemoCurrentDtoOutput> get serializer => _$JourneyDemoCurrentDtoOutputSerializer();
}

class _$JourneyDemoCurrentDtoOutputSerializer implements PrimitiveSerializer<JourneyDemoCurrentDtoOutput> {
  @override
  final Iterable<Type> types = const [JourneyDemoCurrentDtoOutput, _$JourneyDemoCurrentDtoOutput];

  @override
  final String wireName = r'JourneyDemoCurrentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JourneyDemoCurrentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(JourneyDemoCurrentDtoOutputTypeEnum),
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
      specifiedType: const FullType(JourneyDemoCurrentDtoOutputStageEnum),
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
    JourneyDemoCurrentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JourneyDemoCurrentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JourneyDemoCurrentDtoOutputTypeEnum),
          ) as JourneyDemoCurrentDtoOutputTypeEnum;
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
            specifiedType: const FullType(JourneyDemoCurrentDtoOutputStageEnum),
          ) as JourneyDemoCurrentDtoOutputStageEnum;
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
  JourneyDemoCurrentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JourneyDemoCurrentDtoOutputBuilder();
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


class JourneyDemoCurrentDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'journey_demo')
  static const JourneyDemoCurrentDtoOutputTypeEnum journeyDemo = _$journeyDemoCurrentDtoOutputTypeEnum_journeyDemo;

  static Serializer<JourneyDemoCurrentDtoOutputTypeEnum> get serializer => _$journeyDemoCurrentDtoOutputTypeEnumSerializer;

  const JourneyDemoCurrentDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<JourneyDemoCurrentDtoOutputTypeEnum> get values => _$journeyDemoCurrentDtoOutputTypeEnumValues;
  static JourneyDemoCurrentDtoOutputTypeEnum valueOf(String name) => _$journeyDemoCurrentDtoOutputTypeEnumValueOf(name);
}

class JourneyDemoCurrentDtoOutputStageEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'approaching')
  static const JourneyDemoCurrentDtoOutputStageEnum approaching = _$journeyDemoCurrentDtoOutputStageEnum_approaching;
  @BuiltValueEnumConst(wireName: r'travelling')
  static const JourneyDemoCurrentDtoOutputStageEnum travelling = _$journeyDemoCurrentDtoOutputStageEnum_travelling;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const JourneyDemoCurrentDtoOutputStageEnum arrived = _$journeyDemoCurrentDtoOutputStageEnum_arrived;
  @BuiltValueEnumConst(wireName: r'stopped')
  static const JourneyDemoCurrentDtoOutputStageEnum stopped = _$journeyDemoCurrentDtoOutputStageEnum_stopped;

  static Serializer<JourneyDemoCurrentDtoOutputStageEnum> get serializer => _$journeyDemoCurrentDtoOutputStageEnumSerializer;

  const JourneyDemoCurrentDtoOutputStageEnum._(String name): super(name);

  static BuiltSet<JourneyDemoCurrentDtoOutputStageEnum> get values => _$journeyDemoCurrentDtoOutputStageEnumValues;
  static JourneyDemoCurrentDtoOutputStageEnum valueOf(String name) => _$journeyDemoCurrentDtoOutputStageEnumValueOf(name);
}

