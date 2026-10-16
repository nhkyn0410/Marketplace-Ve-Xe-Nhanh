//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_overview_dto_output_overrides_inner.g.dart';

/// CommissionOverviewDtoOutputOverridesInner
///
/// Properties:
/// * [id] 
/// * [operatorId] 
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
abstract class CommissionOverviewDtoOutputOverridesInner implements Built<CommissionOverviewDtoOutputOverridesInner, CommissionOverviewDtoOutputOverridesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

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
  CommissionOverviewDtoOutputOverridesInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  CANCELLED,  };

  @BuiltValueField(wireName: r'state')
  CommissionOverviewDtoOutputOverridesInnerStateEnum get state;
  // enum stateEnum {  SCHEDULED,  ACTIVE,  EXPIRED,  CANCELLED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'cancelReason')
  String? get cancelReason;

  @BuiltValueField(wireName: r'createdBy')
  String? get createdBy;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CommissionOverviewDtoOutputOverridesInner._();

  factory CommissionOverviewDtoOutputOverridesInner([void updates(CommissionOverviewDtoOutputOverridesInnerBuilder b)]) = _$CommissionOverviewDtoOutputOverridesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionOverviewDtoOutputOverridesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionOverviewDtoOutputOverridesInner> get serializer => _$CommissionOverviewDtoOutputOverridesInnerSerializer();
}

class _$CommissionOverviewDtoOutputOverridesInnerSerializer implements PrimitiveSerializer<CommissionOverviewDtoOutputOverridesInner> {
  @override
  final Iterable<Type> types = const [CommissionOverviewDtoOutputOverridesInner, _$CommissionOverviewDtoOutputOverridesInner];

  @override
  final String wireName = r'CommissionOverviewDtoOutputOverridesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionOverviewDtoOutputOverridesInner object, {
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
      specifiedType: const FullType(CommissionOverviewDtoOutputOverridesInnerStatusEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(CommissionOverviewDtoOutputOverridesInnerStateEnum),
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
    CommissionOverviewDtoOutputOverridesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionOverviewDtoOutputOverridesInnerBuilder result,
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
            specifiedType: const FullType(CommissionOverviewDtoOutputOverridesInnerStatusEnum),
          ) as CommissionOverviewDtoOutputOverridesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionOverviewDtoOutputOverridesInnerStateEnum),
          ) as CommissionOverviewDtoOutputOverridesInnerStateEnum;
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
  CommissionOverviewDtoOutputOverridesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionOverviewDtoOutputOverridesInnerBuilder();
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


class CommissionOverviewDtoOutputOverridesInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const CommissionOverviewDtoOutputOverridesInnerStatusEnum ACTIVE = _$commissionOverviewDtoOutputOverridesInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CommissionOverviewDtoOutputOverridesInnerStatusEnum CANCELLED = _$commissionOverviewDtoOutputOverridesInnerStatusEnum_CANCELLED;

  static Serializer<CommissionOverviewDtoOutputOverridesInnerStatusEnum> get serializer => _$commissionOverviewDtoOutputOverridesInnerStatusEnumSerializer;

  const CommissionOverviewDtoOutputOverridesInnerStatusEnum._(String name): super(name);

  static BuiltSet<CommissionOverviewDtoOutputOverridesInnerStatusEnum> get values => _$commissionOverviewDtoOutputOverridesInnerStatusEnumValues;
  static CommissionOverviewDtoOutputOverridesInnerStatusEnum valueOf(String name) => _$commissionOverviewDtoOutputOverridesInnerStatusEnumValueOf(name);
}

class CommissionOverviewDtoOutputOverridesInnerStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const CommissionOverviewDtoOutputOverridesInnerStateEnum SCHEDULED = _$commissionOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const CommissionOverviewDtoOutputOverridesInnerStateEnum ACTIVE = _$commissionOverviewDtoOutputOverridesInnerStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CommissionOverviewDtoOutputOverridesInnerStateEnum EXPIRED = _$commissionOverviewDtoOutputOverridesInnerStateEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CommissionOverviewDtoOutputOverridesInnerStateEnum CANCELLED = _$commissionOverviewDtoOutputOverridesInnerStateEnum_CANCELLED;

  static Serializer<CommissionOverviewDtoOutputOverridesInnerStateEnum> get serializer => _$commissionOverviewDtoOutputOverridesInnerStateEnumSerializer;

  const CommissionOverviewDtoOutputOverridesInnerStateEnum._(String name): super(name);

  static BuiltSet<CommissionOverviewDtoOutputOverridesInnerStateEnum> get values => _$commissionOverviewDtoOutputOverridesInnerStateEnumValues;
  static CommissionOverviewDtoOutputOverridesInnerStateEnum valueOf(String name) => _$commissionOverviewDtoOutputOverridesInnerStateEnumValueOf(name);
}

