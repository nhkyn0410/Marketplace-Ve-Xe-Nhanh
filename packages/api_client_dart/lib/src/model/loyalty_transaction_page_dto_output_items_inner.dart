//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loyalty_transaction_page_dto_output_items_inner.g.dart';

/// LoyaltyTransactionPageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [points] 
/// * [tier] 
/// * [sourceLabel] 
/// * [reason] 
/// * [policyVersion] 
/// * [expiresAt] 
/// * [createdAt] 
@BuiltValue()
abstract class LoyaltyTransactionPageDtoOutputItemsInner implements Built<LoyaltyTransactionPageDtoOutputItemsInner, LoyaltyTransactionPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum get type;
  // enum typeEnum {  EARN,  REDEEM,  EXPIRE,  ADJUST,  REVERSAL,  };

  @BuiltValueField(wireName: r'points')
  int get points;

  @BuiltValueField(wireName: r'tier')
  LoyaltyTransactionPageDtoOutputItemsInnerTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'sourceLabel')
  String get sourceLabel;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'policyVersion')
  int? get policyVersion;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  LoyaltyTransactionPageDtoOutputItemsInner._();

  factory LoyaltyTransactionPageDtoOutputItemsInner([void updates(LoyaltyTransactionPageDtoOutputItemsInnerBuilder b)]) = _$LoyaltyTransactionPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoyaltyTransactionPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoyaltyTransactionPageDtoOutputItemsInner> get serializer => _$LoyaltyTransactionPageDtoOutputItemsInnerSerializer();
}

class _$LoyaltyTransactionPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<LoyaltyTransactionPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [LoyaltyTransactionPageDtoOutputItemsInner, _$LoyaltyTransactionPageDtoOutputItemsInner];

  @override
  final String wireName = r'LoyaltyTransactionPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoyaltyTransactionPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(int),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(LoyaltyTransactionPageDtoOutputItemsInnerTierEnum),
    );
    yield r'sourceLabel';
    yield serializers.serialize(
      object.sourceLabel,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'policyVersion';
    yield object.policyVersion == null ? null : serializers.serialize(
      object.policyVersion,
      specifiedType: const FullType.nullable(int),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
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
    LoyaltyTransactionPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoyaltyTransactionPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum),
          ) as LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.points = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoyaltyTransactionPageDtoOutputItemsInnerTierEnum),
          ) as LoyaltyTransactionPageDtoOutputItemsInnerTierEnum;
          result.tier = valueDes;
          break;
        case r'sourceLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceLabel = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'policyVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.policyVersion = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
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
  LoyaltyTransactionPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoyaltyTransactionPageDtoOutputItemsInnerBuilder();
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


class LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EARN')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum EARN = _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EARN;
  @BuiltValueEnumConst(wireName: r'REDEEM')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum REDEEM = _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REDEEM;
  @BuiltValueEnumConst(wireName: r'EXPIRE')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum EXPIRE = _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EXPIRE;
  @BuiltValueEnumConst(wireName: r'ADJUST')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum ADJUST = _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_ADJUST;
  @BuiltValueEnumConst(wireName: r'REVERSAL')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum REVERSAL = _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REVERSAL;

  static Serializer<LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum> get serializer => _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnumSerializer;

  const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum> get values => _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnumValues;
  static LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum valueOf(String name) => _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnumValueOf(name);
}

class LoyaltyTransactionPageDtoOutputItemsInnerTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum BRONZE = _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum SILVER = _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum GOLD = _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum PLATINUM = _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_PLATINUM;

  static Serializer<LoyaltyTransactionPageDtoOutputItemsInnerTierEnum> get serializer => _$loyaltyTransactionPageDtoOutputItemsInnerTierEnumSerializer;

  const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum._(String name): super(name);

  static BuiltSet<LoyaltyTransactionPageDtoOutputItemsInnerTierEnum> get values => _$loyaltyTransactionPageDtoOutputItemsInnerTierEnumValues;
  static LoyaltyTransactionPageDtoOutputItemsInnerTierEnum valueOf(String name) => _$loyaltyTransactionPageDtoOutputItemsInnerTierEnumValueOf(name);
}

