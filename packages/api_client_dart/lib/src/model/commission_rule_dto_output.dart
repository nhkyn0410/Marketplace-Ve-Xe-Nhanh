//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_rule_dto_output.g.dart';

/// CommissionRuleDtoOutput
///
/// Properties:
/// * [id] 
/// * [operatorId] 
/// * [channel] 
/// * [operatorName] 
/// * [operatorSlug] 
/// * [rateBps] 
/// * [effectiveFrom] 
/// * [effectiveTo] 
/// * [status] 
/// * [state] 
/// * [reason] 
/// * [cancelReason] 
/// * [createdBy] 
/// * [createdAt] 
@BuiltValue()
abstract class CommissionRuleDtoOutput implements Built<CommissionRuleDtoOutput, CommissionRuleDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'channel')
  CommissionRuleDtoOutputChannelEnum get channel;
  // enum channelEnum {  ONLINE,  COUNTER,  };

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'operatorSlug')
  String get operatorSlug;

  @BuiltValueField(wireName: r'rateBps')
  int get rateBps;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'effectiveTo')
  DateTime? get effectiveTo;

  @BuiltValueField(wireName: r'status')
  CommissionRuleDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  CANCELLED,  };

  @BuiltValueField(wireName: r'state')
  CommissionRuleDtoOutputStateEnum get state;
  // enum stateEnum {  SCHEDULED,  ACTIVE,  EXPIRED,  CANCELLED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'cancelReason')
  String? get cancelReason;

  @BuiltValueField(wireName: r'createdBy')
  String? get createdBy;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CommissionRuleDtoOutput._();

  factory CommissionRuleDtoOutput([void updates(CommissionRuleDtoOutputBuilder b)]) = _$CommissionRuleDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionRuleDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionRuleDtoOutput> get serializer => _$CommissionRuleDtoOutputSerializer();
}

class _$CommissionRuleDtoOutputSerializer implements PrimitiveSerializer<CommissionRuleDtoOutput> {
  @override
  final Iterable<Type> types = const [CommissionRuleDtoOutput, _$CommissionRuleDtoOutput];

  @override
  final String wireName = r'CommissionRuleDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionRuleDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(CommissionRuleDtoOutputChannelEnum),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'operatorSlug';
    yield serializers.serialize(
      object.operatorSlug,
      specifiedType: const FullType(String),
    );
    yield r'rateBps';
    yield serializers.serialize(
      object.rateBps,
      specifiedType: const FullType(int),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'effectiveTo';
    yield object.effectiveTo == null ? null : serializers.serialize(
      object.effectiveTo,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CommissionRuleDtoOutputStatusEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(CommissionRuleDtoOutputStateEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'cancelReason';
    yield object.cancelReason == null ? null : serializers.serialize(
      object.cancelReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdBy';
    yield object.createdBy == null ? null : serializers.serialize(
      object.createdBy,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionRuleDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionRuleDtoOutputBuilder result,
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
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionRuleDtoOutputChannelEnum),
          ) as CommissionRuleDtoOutputChannelEnum;
          result.channel = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'operatorSlug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorSlug = valueDes;
          break;
        case r'rateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBps = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'effectiveTo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveTo = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionRuleDtoOutputStatusEnum),
          ) as CommissionRuleDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionRuleDtoOutputStateEnum),
          ) as CommissionRuleDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'cancelReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cancelReason = valueDes;
          break;
        case r'createdBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionRuleDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionRuleDtoOutputBuilder();
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


class CommissionRuleDtoOutputChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const CommissionRuleDtoOutputChannelEnum ONLINE = _$commissionRuleDtoOutputChannelEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'COUNTER')
  static const CommissionRuleDtoOutputChannelEnum COUNTER = _$commissionRuleDtoOutputChannelEnum_COUNTER;

  static Serializer<CommissionRuleDtoOutputChannelEnum> get serializer => _$commissionRuleDtoOutputChannelEnumSerializer;

  const CommissionRuleDtoOutputChannelEnum._(String name): super(name);

  static BuiltSet<CommissionRuleDtoOutputChannelEnum> get values => _$commissionRuleDtoOutputChannelEnumValues;
  static CommissionRuleDtoOutputChannelEnum valueOf(String name) => _$commissionRuleDtoOutputChannelEnumValueOf(name);
}

class CommissionRuleDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const CommissionRuleDtoOutputStatusEnum ACTIVE = _$commissionRuleDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CommissionRuleDtoOutputStatusEnum CANCELLED = _$commissionRuleDtoOutputStatusEnum_CANCELLED;

  static Serializer<CommissionRuleDtoOutputStatusEnum> get serializer => _$commissionRuleDtoOutputStatusEnumSerializer;

  const CommissionRuleDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<CommissionRuleDtoOutputStatusEnum> get values => _$commissionRuleDtoOutputStatusEnumValues;
  static CommissionRuleDtoOutputStatusEnum valueOf(String name) => _$commissionRuleDtoOutputStatusEnumValueOf(name);
}

class CommissionRuleDtoOutputStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const CommissionRuleDtoOutputStateEnum SCHEDULED = _$commissionRuleDtoOutputStateEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const CommissionRuleDtoOutputStateEnum ACTIVE = _$commissionRuleDtoOutputStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CommissionRuleDtoOutputStateEnum EXPIRED = _$commissionRuleDtoOutputStateEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CommissionRuleDtoOutputStateEnum CANCELLED = _$commissionRuleDtoOutputStateEnum_CANCELLED;

  static Serializer<CommissionRuleDtoOutputStateEnum> get serializer => _$commissionRuleDtoOutputStateEnumSerializer;

  const CommissionRuleDtoOutputStateEnum._(String name): super(name);

  static BuiltSet<CommissionRuleDtoOutputStateEnum> get values => _$commissionRuleDtoOutputStateEnumValues;
  static CommissionRuleDtoOutputStateEnum valueOf(String name) => _$commissionRuleDtoOutputStateEnumValueOf(name);
}

