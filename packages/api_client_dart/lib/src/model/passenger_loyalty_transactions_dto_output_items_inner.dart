//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_loyalty_transactions_dto_output_items_inner.g.dart';

/// PassengerLoyaltyTransactionsDtoOutputItemsInner
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
abstract class PassengerLoyaltyTransactionsDtoOutputItemsInner implements Built<PassengerLoyaltyTransactionsDtoOutputItemsInner, PassengerLoyaltyTransactionsDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum get type;
  // enum typeEnum {  EARN,  REDEEM,  EXPIRE,  ADJUST,  REVERSAL,  };

  @BuiltValueField(wireName: r'points')
  int get points;

  @BuiltValueField(wireName: r'tier')
  PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum get tier;
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

  PassengerLoyaltyTransactionsDtoOutputItemsInner._();

  factory PassengerLoyaltyTransactionsDtoOutputItemsInner([void updates(PassengerLoyaltyTransactionsDtoOutputItemsInnerBuilder b)]) = _$PassengerLoyaltyTransactionsDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerLoyaltyTransactionsDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerLoyaltyTransactionsDtoOutputItemsInner> get serializer => _$PassengerLoyaltyTransactionsDtoOutputItemsInnerSerializer();
}

class _$PassengerLoyaltyTransactionsDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PassengerLoyaltyTransactionsDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PassengerLoyaltyTransactionsDtoOutputItemsInner, _$PassengerLoyaltyTransactionsDtoOutputItemsInner];

  @override
  final String wireName = r'PassengerLoyaltyTransactionsDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerLoyaltyTransactionsDtoOutputItemsInner object, {
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
      specifiedType: const FullType(PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(int),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum),
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
    PassengerLoyaltyTransactionsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerLoyaltyTransactionsDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum),
          ) as PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum;
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
            specifiedType: const FullType(PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum),
          ) as PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum;
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
  PassengerLoyaltyTransactionsDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerLoyaltyTransactionsDtoOutputItemsInnerBuilder();
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


class PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EARN')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum EARN = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum_EARN;
  @BuiltValueEnumConst(wireName: r'REDEEM')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum REDEEM = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum_REDEEM;
  @BuiltValueEnumConst(wireName: r'EXPIRE')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum EXPIRE = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum_EXPIRE;
  @BuiltValueEnumConst(wireName: r'ADJUST')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum ADJUST = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum_ADJUST;
  @BuiltValueEnumConst(wireName: r'REVERSAL')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum REVERSAL = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum_REVERSAL;

  static Serializer<PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum> get serializer => _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnumSerializer;

  const PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum> get values => _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnumValues;
  static PassengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnum valueOf(String name) => _$passengerLoyaltyTransactionsDtoOutputItemsInnerTypeEnumValueOf(name);
}

class PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum BRONZE = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum SILVER = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum GOLD = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum PLATINUM = _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum_PLATINUM;

  static Serializer<PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum> get serializer => _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnumSerializer;

  const PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum._(String name): super(name);

  static BuiltSet<PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum> get values => _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnumValues;
  static PassengerLoyaltyTransactionsDtoOutputItemsInnerTierEnum valueOf(String name) => _$passengerLoyaltyTransactionsDtoOutputItemsInnerTierEnumValueOf(name);
}

