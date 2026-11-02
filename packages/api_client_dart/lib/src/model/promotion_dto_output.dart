//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_dto_output.g.dart';

/// PromotionDtoOutput
///
/// Properties:
/// * [promotionId] 
/// * [code] 
/// * [name] 
/// * [scope] 
/// * [operatorId] 
/// * [operatorName] 
/// * [discountType] 
/// * [discountValue] 
/// * [maxDiscount] 
/// * [minOrder] 
/// * [routeId] 
/// * [routeIds] 
/// * [routeNames] 
/// * [routeName] 
/// * [tripId] 
/// * [startsAt] 
/// * [endsAt] 
/// * [usageLimit] 
/// * [usedCount] 
/// * [status] 
/// * [display] 
/// * [editable] 
/// * [joined] 
/// * [participants] 
/// * [createdAt] 
@BuiltValue()
abstract class PromotionDtoOutput implements Built<PromotionDtoOutput, PromotionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'promotionId')
  String get promotionId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'scope')
  PromotionDtoOutputScopeEnum get scope;
  // enum scopeEnum {  PLATFORM,  OPERATOR,  };

  @BuiltValueField(wireName: r'operatorId')
  String? get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String? get operatorName;

  @BuiltValueField(wireName: r'discountType')
  PromotionDtoOutputDiscountTypeEnum get discountType;
  // enum discountTypeEnum {  PERCENT,  AMOUNT,  };

  @BuiltValueField(wireName: r'discountValue')
  int get discountValue;

  @BuiltValueField(wireName: r'maxDiscount')
  int? get maxDiscount;

  @BuiltValueField(wireName: r'minOrder')
  int get minOrder;

  @BuiltValueField(wireName: r'routeId')
  String? get routeId;

  @BuiltValueField(wireName: r'routeIds')
  BuiltList<String> get routeIds;

  @BuiltValueField(wireName: r'routeNames')
  BuiltList<String> get routeNames;

  @BuiltValueField(wireName: r'routeName')
  String? get routeName;

  @BuiltValueField(wireName: r'tripId')
  String? get tripId;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'usageLimit')
  int get usageLimit;

  @BuiltValueField(wireName: r'usedCount')
  int get usedCount;

  @BuiltValueField(wireName: r'status')
  PromotionDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  ACTIVE,  PAUSED,  ENDED,  };

  @BuiltValueField(wireName: r'display')
  PromotionDtoOutputDisplayEnum get display;
  // enum displayEnum {  DRAFT,  SCHEDULED,  RUNNING,  PAUSED,  ENDED,  };

  @BuiltValueField(wireName: r'editable')
  bool get editable;

  @BuiltValueField(wireName: r'joined')
  bool? get joined;

  @BuiltValueField(wireName: r'participants')
  int? get participants;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PromotionDtoOutput._();

  factory PromotionDtoOutput([void updates(PromotionDtoOutputBuilder b)]) = _$PromotionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionDtoOutput> get serializer => _$PromotionDtoOutputSerializer();
}

class _$PromotionDtoOutputSerializer implements PrimitiveSerializer<PromotionDtoOutput> {
  @override
  final Iterable<Type> types = const [PromotionDtoOutput, _$PromotionDtoOutput];

  @override
  final String wireName = r'PromotionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'promotionId';
    yield serializers.serialize(
      object.promotionId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(PromotionDtoOutputScopeEnum),
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
    yield r'discountType';
    yield serializers.serialize(
      object.discountType,
      specifiedType: const FullType(PromotionDtoOutputDiscountTypeEnum),
    );
    yield r'discountValue';
    yield serializers.serialize(
      object.discountValue,
      specifiedType: const FullType(int),
    );
    yield r'maxDiscount';
    yield object.maxDiscount == null ? null : serializers.serialize(
      object.maxDiscount,
      specifiedType: const FullType.nullable(int),
    );
    yield r'minOrder';
    yield serializers.serialize(
      object.minOrder,
      specifiedType: const FullType(int),
    );
    yield r'routeId';
    yield object.routeId == null ? null : serializers.serialize(
      object.routeId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'routeIds';
    yield serializers.serialize(
      object.routeIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'routeNames';
    yield serializers.serialize(
      object.routeNames,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'routeName';
    yield object.routeName == null ? null : serializers.serialize(
      object.routeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'tripId';
    yield object.tripId == null ? null : serializers.serialize(
      object.tripId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'usageLimit';
    yield serializers.serialize(
      object.usageLimit,
      specifiedType: const FullType(int),
    );
    yield r'usedCount';
    yield serializers.serialize(
      object.usedCount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PromotionDtoOutputStatusEnum),
    );
    yield r'display';
    yield serializers.serialize(
      object.display,
      specifiedType: const FullType(PromotionDtoOutputDisplayEnum),
    );
    yield r'editable';
    yield serializers.serialize(
      object.editable,
      specifiedType: const FullType(bool),
    );
    yield r'joined';
    yield object.joined == null ? null : serializers.serialize(
      object.joined,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'participants';
    yield object.participants == null ? null : serializers.serialize(
      object.participants,
      specifiedType: const FullType.nullable(int),
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
    PromotionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'promotionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.promotionId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionDtoOutputScopeEnum),
          ) as PromotionDtoOutputScopeEnum;
          result.scope = valueDes;
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
        case r'discountType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionDtoOutputDiscountTypeEnum),
          ) as PromotionDtoOutputDiscountTypeEnum;
          result.discountType = valueDes;
          break;
        case r'discountValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discountValue = valueDes;
          break;
        case r'maxDiscount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'minOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minOrder = valueDes;
          break;
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.routeId = valueDes;
          break;
        case r'routeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.routeIds.replace(valueDes);
          break;
        case r'routeNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.routeNames.replace(valueDes);
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.routeName = valueDes;
          break;
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tripId = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'usageLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usageLimit = valueDes;
          break;
        case r'usedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usedCount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionDtoOutputStatusEnum),
          ) as PromotionDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'display':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionDtoOutputDisplayEnum),
          ) as PromotionDtoOutputDisplayEnum;
          result.display = valueDes;
          break;
        case r'editable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.editable = valueDes;
          break;
        case r'joined':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.joined = valueDes;
          break;
        case r'participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.participants = valueDes;
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
  PromotionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionDtoOutputBuilder();
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


class PromotionDtoOutputScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const PromotionDtoOutputScopeEnum PLATFORM = _$promotionDtoOutputScopeEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const PromotionDtoOutputScopeEnum OPERATOR = _$promotionDtoOutputScopeEnum_OPERATOR;

  static Serializer<PromotionDtoOutputScopeEnum> get serializer => _$promotionDtoOutputScopeEnumSerializer;

  const PromotionDtoOutputScopeEnum._(String name): super(name);

  static BuiltSet<PromotionDtoOutputScopeEnum> get values => _$promotionDtoOutputScopeEnumValues;
  static PromotionDtoOutputScopeEnum valueOf(String name) => _$promotionDtoOutputScopeEnumValueOf(name);
}

class PromotionDtoOutputDiscountTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PERCENT')
  static const PromotionDtoOutputDiscountTypeEnum PERCENT = _$promotionDtoOutputDiscountTypeEnum_PERCENT;
  @BuiltValueEnumConst(wireName: r'AMOUNT')
  static const PromotionDtoOutputDiscountTypeEnum AMOUNT = _$promotionDtoOutputDiscountTypeEnum_AMOUNT;

  static Serializer<PromotionDtoOutputDiscountTypeEnum> get serializer => _$promotionDtoOutputDiscountTypeEnumSerializer;

  const PromotionDtoOutputDiscountTypeEnum._(String name): super(name);

  static BuiltSet<PromotionDtoOutputDiscountTypeEnum> get values => _$promotionDtoOutputDiscountTypeEnumValues;
  static PromotionDtoOutputDiscountTypeEnum valueOf(String name) => _$promotionDtoOutputDiscountTypeEnumValueOf(name);
}

class PromotionDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PromotionDtoOutputStatusEnum DRAFT = _$promotionDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const PromotionDtoOutputStatusEnum ACTIVE = _$promotionDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const PromotionDtoOutputStatusEnum PAUSED = _$promotionDtoOutputStatusEnum_PAUSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const PromotionDtoOutputStatusEnum ENDED = _$promotionDtoOutputStatusEnum_ENDED;

  static Serializer<PromotionDtoOutputStatusEnum> get serializer => _$promotionDtoOutputStatusEnumSerializer;

  const PromotionDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<PromotionDtoOutputStatusEnum> get values => _$promotionDtoOutputStatusEnumValues;
  static PromotionDtoOutputStatusEnum valueOf(String name) => _$promotionDtoOutputStatusEnumValueOf(name);
}

class PromotionDtoOutputDisplayEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PromotionDtoOutputDisplayEnum DRAFT = _$promotionDtoOutputDisplayEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const PromotionDtoOutputDisplayEnum SCHEDULED = _$promotionDtoOutputDisplayEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const PromotionDtoOutputDisplayEnum RUNNING = _$promotionDtoOutputDisplayEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const PromotionDtoOutputDisplayEnum PAUSED = _$promotionDtoOutputDisplayEnum_PAUSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const PromotionDtoOutputDisplayEnum ENDED = _$promotionDtoOutputDisplayEnum_ENDED;

  static Serializer<PromotionDtoOutputDisplayEnum> get serializer => _$promotionDtoOutputDisplayEnumSerializer;

  const PromotionDtoOutputDisplayEnum._(String name): super(name);

  static BuiltSet<PromotionDtoOutputDisplayEnum> get values => _$promotionDtoOutputDisplayEnumValues;
  static PromotionDtoOutputDisplayEnum valueOf(String name) => _$promotionDtoOutputDisplayEnumValueOf(name);
}

