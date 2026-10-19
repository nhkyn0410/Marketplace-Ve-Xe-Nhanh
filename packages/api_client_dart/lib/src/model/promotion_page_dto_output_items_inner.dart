//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_page_dto_output_items_inner.g.dart';

/// PromotionPageDtoOutputItemsInner
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
abstract class PromotionPageDtoOutputItemsInner implements Built<PromotionPageDtoOutputItemsInner, PromotionPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'promotionId')
  String get promotionId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'scope')
  PromotionPageDtoOutputItemsInnerScopeEnum get scope;
  // enum scopeEnum {  PLATFORM,  OPERATOR,  };

  @BuiltValueField(wireName: r'operatorId')
  String? get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String? get operatorName;

  @BuiltValueField(wireName: r'discountType')
  PromotionPageDtoOutputItemsInnerDiscountTypeEnum get discountType;
  // enum discountTypeEnum {  PERCENT,  AMOUNT,  };

  @BuiltValueField(wireName: r'discountValue')
  int get discountValue;

  @BuiltValueField(wireName: r'maxDiscount')
  int? get maxDiscount;

  @BuiltValueField(wireName: r'minOrder')
  int get minOrder;

  @BuiltValueField(wireName: r'routeId')
  String? get routeId;

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
  PromotionPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  ACTIVE,  PAUSED,  ENDED,  };

  @BuiltValueField(wireName: r'display')
  PromotionPageDtoOutputItemsInnerDisplayEnum get display;
  // enum displayEnum {  DRAFT,  SCHEDULED,  RUNNING,  PAUSED,  ENDED,  };

  @BuiltValueField(wireName: r'editable')
  bool get editable;

  @BuiltValueField(wireName: r'joined')
  bool? get joined;

  @BuiltValueField(wireName: r'participants')
  int? get participants;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PromotionPageDtoOutputItemsInner._();

  factory PromotionPageDtoOutputItemsInner([void updates(PromotionPageDtoOutputItemsInnerBuilder b)]) = _$PromotionPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionPageDtoOutputItemsInner> get serializer => _$PromotionPageDtoOutputItemsInnerSerializer();
}

class _$PromotionPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PromotionPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PromotionPageDtoOutputItemsInner, _$PromotionPageDtoOutputItemsInner];

  @override
  final String wireName = r'PromotionPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(PromotionPageDtoOutputItemsInnerScopeEnum),
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
      specifiedType: const FullType(PromotionPageDtoOutputItemsInnerDiscountTypeEnum),
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
      specifiedType: const FullType(PromotionPageDtoOutputItemsInnerStatusEnum),
    );
    yield r'display';
    yield serializers.serialize(
      object.display,
      specifiedType: const FullType(PromotionPageDtoOutputItemsInnerDisplayEnum),
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
    PromotionPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(PromotionPageDtoOutputItemsInnerScopeEnum),
          ) as PromotionPageDtoOutputItemsInnerScopeEnum;
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
            specifiedType: const FullType(PromotionPageDtoOutputItemsInnerDiscountTypeEnum),
          ) as PromotionPageDtoOutputItemsInnerDiscountTypeEnum;
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
            specifiedType: const FullType(PromotionPageDtoOutputItemsInnerStatusEnum),
          ) as PromotionPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'display':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionPageDtoOutputItemsInnerDisplayEnum),
          ) as PromotionPageDtoOutputItemsInnerDisplayEnum;
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
  PromotionPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionPageDtoOutputItemsInnerBuilder();
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


class PromotionPageDtoOutputItemsInnerScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const PromotionPageDtoOutputItemsInnerScopeEnum PLATFORM = _$promotionPageDtoOutputItemsInnerScopeEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const PromotionPageDtoOutputItemsInnerScopeEnum OPERATOR = _$promotionPageDtoOutputItemsInnerScopeEnum_OPERATOR;

  static Serializer<PromotionPageDtoOutputItemsInnerScopeEnum> get serializer => _$promotionPageDtoOutputItemsInnerScopeEnumSerializer;

  const PromotionPageDtoOutputItemsInnerScopeEnum._(String name): super(name);

  static BuiltSet<PromotionPageDtoOutputItemsInnerScopeEnum> get values => _$promotionPageDtoOutputItemsInnerScopeEnumValues;
  static PromotionPageDtoOutputItemsInnerScopeEnum valueOf(String name) => _$promotionPageDtoOutputItemsInnerScopeEnumValueOf(name);
}

class PromotionPageDtoOutputItemsInnerDiscountTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PERCENT')
  static const PromotionPageDtoOutputItemsInnerDiscountTypeEnum PERCENT = _$promotionPageDtoOutputItemsInnerDiscountTypeEnum_PERCENT;
  @BuiltValueEnumConst(wireName: r'AMOUNT')
  static const PromotionPageDtoOutputItemsInnerDiscountTypeEnum AMOUNT = _$promotionPageDtoOutputItemsInnerDiscountTypeEnum_AMOUNT;

  static Serializer<PromotionPageDtoOutputItemsInnerDiscountTypeEnum> get serializer => _$promotionPageDtoOutputItemsInnerDiscountTypeEnumSerializer;

  const PromotionPageDtoOutputItemsInnerDiscountTypeEnum._(String name): super(name);

  static BuiltSet<PromotionPageDtoOutputItemsInnerDiscountTypeEnum> get values => _$promotionPageDtoOutputItemsInnerDiscountTypeEnumValues;
  static PromotionPageDtoOutputItemsInnerDiscountTypeEnum valueOf(String name) => _$promotionPageDtoOutputItemsInnerDiscountTypeEnumValueOf(name);
}

class PromotionPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PromotionPageDtoOutputItemsInnerStatusEnum DRAFT = _$promotionPageDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const PromotionPageDtoOutputItemsInnerStatusEnum ACTIVE = _$promotionPageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const PromotionPageDtoOutputItemsInnerStatusEnum PAUSED = _$promotionPageDtoOutputItemsInnerStatusEnum_PAUSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const PromotionPageDtoOutputItemsInnerStatusEnum ENDED = _$promotionPageDtoOutputItemsInnerStatusEnum_ENDED;

  static Serializer<PromotionPageDtoOutputItemsInnerStatusEnum> get serializer => _$promotionPageDtoOutputItemsInnerStatusEnumSerializer;

  const PromotionPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<PromotionPageDtoOutputItemsInnerStatusEnum> get values => _$promotionPageDtoOutputItemsInnerStatusEnumValues;
  static PromotionPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$promotionPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

class PromotionPageDtoOutputItemsInnerDisplayEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PromotionPageDtoOutputItemsInnerDisplayEnum DRAFT = _$promotionPageDtoOutputItemsInnerDisplayEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const PromotionPageDtoOutputItemsInnerDisplayEnum SCHEDULED = _$promotionPageDtoOutputItemsInnerDisplayEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const PromotionPageDtoOutputItemsInnerDisplayEnum RUNNING = _$promotionPageDtoOutputItemsInnerDisplayEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const PromotionPageDtoOutputItemsInnerDisplayEnum PAUSED = _$promotionPageDtoOutputItemsInnerDisplayEnum_PAUSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const PromotionPageDtoOutputItemsInnerDisplayEnum ENDED = _$promotionPageDtoOutputItemsInnerDisplayEnum_ENDED;

  static Serializer<PromotionPageDtoOutputItemsInnerDisplayEnum> get serializer => _$promotionPageDtoOutputItemsInnerDisplayEnumSerializer;

  const PromotionPageDtoOutputItemsInnerDisplayEnum._(String name): super(name);

  static BuiltSet<PromotionPageDtoOutputItemsInnerDisplayEnum> get values => _$promotionPageDtoOutputItemsInnerDisplayEnumValues;
  static PromotionPageDtoOutputItemsInnerDisplayEnum valueOf(String name) => _$promotionPageDtoOutputItemsInnerDisplayEnumValueOf(name);
}

