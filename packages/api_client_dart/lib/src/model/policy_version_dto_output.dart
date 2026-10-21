//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_version_dto_output.g.dart';

/// PolicyVersionDtoOutput
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [operatorId] 
/// * [operatorName] 
/// * [version] 
/// * [status] 
/// * [state] 
/// * [rules] 
/// * [description] 
/// * [changeReason] 
/// * [effectiveFrom] 
/// * [createdBy] 
/// * [publishedAt] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class PolicyVersionDtoOutput implements Built<PolicyVersionDtoOutput, PolicyVersionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  PolicyVersionDtoOutputTypeEnum get type;
  // enum typeEnum {  CANCELLATION,  SEAT_HOLD,  PAYOUT,  LOYALTY,  };

  @BuiltValueField(wireName: r'operatorId')
  String? get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String? get operatorName;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'status')
  PolicyVersionDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  PUBLISHED,  CANCELLED,  };

  @BuiltValueField(wireName: r'state')
  PolicyVersionDtoOutputStateEnum get state;
  // enum stateEnum {  DRAFT,  SCHEDULED,  ACTIVE,  EXPIRED,  CANCELLED,  };

  @BuiltValueField(wireName: r'rules')
  PolicyOverviewDtoOutputVersionsInnerRules get rules;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'changeReason')
  String? get changeReason;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime? get effectiveFrom;

  @BuiltValueField(wireName: r'createdBy')
  String? get createdBy;

  @BuiltValueField(wireName: r'publishedAt')
  DateTime? get publishedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  PolicyVersionDtoOutput._();

  factory PolicyVersionDtoOutput([void updates(PolicyVersionDtoOutputBuilder b)]) = _$PolicyVersionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyVersionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyVersionDtoOutput> get serializer => _$PolicyVersionDtoOutputSerializer();
}

class _$PolicyVersionDtoOutputSerializer implements PrimitiveSerializer<PolicyVersionDtoOutput> {
  @override
  final Iterable<Type> types = const [PolicyVersionDtoOutput, _$PolicyVersionDtoOutput];

  @override
  final String wireName = r'PolicyVersionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyVersionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PolicyVersionDtoOutputTypeEnum),
    );
    yield r'operatorId';
    yield object.operatorId == null ? null : serializers.serialize(
      object.operatorId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operatorName';
    yield object.operatorName == null ? null : serializers.serialize(
      object.operatorName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PolicyVersionDtoOutputStatusEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(PolicyVersionDtoOutputStateEnum),
    );
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRules),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'changeReason';
    yield object.changeReason == null ? null : serializers.serialize(
      object.changeReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'effectiveFrom';
    yield object.effectiveFrom == null ? null : serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdBy';
    yield object.createdBy == null ? null : serializers.serialize(
      object.createdBy,
      specifiedType: const FullType.nullable(String),
    );
    yield r'publishedAt';
    yield object.publishedAt == null ? null : serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyVersionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyVersionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyVersionDtoOutputTypeEnum),
          ) as PolicyVersionDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorName = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyVersionDtoOutputStatusEnum),
          ) as PolicyVersionDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyVersionDtoOutputStateEnum),
          ) as PolicyVersionDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRules),
          ) as PolicyOverviewDtoOutputVersionsInnerRules;
          result.rules.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'changeReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changeReason = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveFrom = valueDes;
          break;
        case r'createdBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'publishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.publishedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyVersionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyVersionDtoOutputBuilder();
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


class PolicyVersionDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CANCELLATION')
  static const PolicyVersionDtoOutputTypeEnum CANCELLATION = _$policyVersionDtoOutputTypeEnum_CANCELLATION;
  @BuiltValueEnumConst(wireName: r'SEAT_HOLD')
  static const PolicyVersionDtoOutputTypeEnum SEAT_HOLD = _$policyVersionDtoOutputTypeEnum_SEAT_HOLD;
  @BuiltValueEnumConst(wireName: r'PAYOUT')
  static const PolicyVersionDtoOutputTypeEnum PAYOUT = _$policyVersionDtoOutputTypeEnum_PAYOUT;
  @BuiltValueEnumConst(wireName: r'LOYALTY')
  static const PolicyVersionDtoOutputTypeEnum LOYALTY = _$policyVersionDtoOutputTypeEnum_LOYALTY;

  static Serializer<PolicyVersionDtoOutputTypeEnum> get serializer => _$policyVersionDtoOutputTypeEnumSerializer;

  const PolicyVersionDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<PolicyVersionDtoOutputTypeEnum> get values => _$policyVersionDtoOutputTypeEnumValues;
  static PolicyVersionDtoOutputTypeEnum valueOf(String name) => _$policyVersionDtoOutputTypeEnumValueOf(name);
}

class PolicyVersionDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PolicyVersionDtoOutputStatusEnum DRAFT = _$policyVersionDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const PolicyVersionDtoOutputStatusEnum PUBLISHED = _$policyVersionDtoOutputStatusEnum_PUBLISHED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PolicyVersionDtoOutputStatusEnum CANCELLED = _$policyVersionDtoOutputStatusEnum_CANCELLED;

  static Serializer<PolicyVersionDtoOutputStatusEnum> get serializer => _$policyVersionDtoOutputStatusEnumSerializer;

  const PolicyVersionDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<PolicyVersionDtoOutputStatusEnum> get values => _$policyVersionDtoOutputStatusEnumValues;
  static PolicyVersionDtoOutputStatusEnum valueOf(String name) => _$policyVersionDtoOutputStatusEnumValueOf(name);
}

class PolicyVersionDtoOutputStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PolicyVersionDtoOutputStateEnum DRAFT = _$policyVersionDtoOutputStateEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const PolicyVersionDtoOutputStateEnum SCHEDULED = _$policyVersionDtoOutputStateEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const PolicyVersionDtoOutputStateEnum ACTIVE = _$policyVersionDtoOutputStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const PolicyVersionDtoOutputStateEnum EXPIRED = _$policyVersionDtoOutputStateEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PolicyVersionDtoOutputStateEnum CANCELLED = _$policyVersionDtoOutputStateEnum_CANCELLED;

  static Serializer<PolicyVersionDtoOutputStateEnum> get serializer => _$policyVersionDtoOutputStateEnumSerializer;

  const PolicyVersionDtoOutputStateEnum._(String name): super(name);

  static BuiltSet<PolicyVersionDtoOutputStateEnum> get values => _$policyVersionDtoOutputStateEnumValues;
  static PolicyVersionDtoOutputStateEnum valueOf(String name) => _$policyVersionDtoOutputStateEnumValueOf(name);
}

