//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/loyalty_member_dto_output_next_tier.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loyalty_member_dto_output.g.dart';

/// LoyaltyMemberDtoOutput
///
/// Properties:
/// * [userId] 
/// * [name] 
/// * [email] 
/// * [status] 
/// * [memberSince] 
/// * [availablePoints] 
/// * [earned12m] 
/// * [tier] 
/// * [nextTier] 
/// * [policyVersion] 
@BuiltValue()
abstract class LoyaltyMemberDtoOutput implements Built<LoyaltyMemberDtoOutput, LoyaltyMemberDtoOutputBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'status')
  LoyaltyMemberDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'memberSince')
  DateTime get memberSince;

  @BuiltValueField(wireName: r'availablePoints')
  int get availablePoints;

  @BuiltValueField(wireName: r'earned12m')
  int get earned12m;

  @BuiltValueField(wireName: r'tier')
  LoyaltyMemberDtoOutputTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'nextTier')
  LoyaltyMemberDtoOutputNextTier? get nextTier;

  @BuiltValueField(wireName: r'policyVersion')
  int? get policyVersion;

  LoyaltyMemberDtoOutput._();

  factory LoyaltyMemberDtoOutput([void updates(LoyaltyMemberDtoOutputBuilder b)]) = _$LoyaltyMemberDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoyaltyMemberDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoyaltyMemberDtoOutput> get serializer => _$LoyaltyMemberDtoOutputSerializer();
}

class _$LoyaltyMemberDtoOutputSerializer implements PrimitiveSerializer<LoyaltyMemberDtoOutput> {
  @override
  final Iterable<Type> types = const [LoyaltyMemberDtoOutput, _$LoyaltyMemberDtoOutput];

  @override
  final String wireName = r'LoyaltyMemberDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoyaltyMemberDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(LoyaltyMemberDtoOutputStatusEnum),
    );
    yield r'memberSince';
    yield serializers.serialize(
      object.memberSince,
      specifiedType: const FullType(DateTime),
    );
    yield r'availablePoints';
    yield serializers.serialize(
      object.availablePoints,
      specifiedType: const FullType(int),
    );
    yield r'earned12m';
    yield serializers.serialize(
      object.earned12m,
      specifiedType: const FullType(int),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(LoyaltyMemberDtoOutputTierEnum),
    );
    yield r'nextTier';
    yield object.nextTier == null ? null : serializers.serialize(
      object.nextTier,
      specifiedType: const FullType.nullable(LoyaltyMemberDtoOutputNextTier),
    );
    yield r'policyVersion';
    yield object.policyVersion == null ? null : serializers.serialize(
      object.policyVersion,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoyaltyMemberDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoyaltyMemberDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoyaltyMemberDtoOutputStatusEnum),
          ) as LoyaltyMemberDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'memberSince':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.memberSince = valueDes;
          break;
        case r'availablePoints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.availablePoints = valueDes;
          break;
        case r'earned12m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earned12m = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoyaltyMemberDtoOutputTierEnum),
          ) as LoyaltyMemberDtoOutputTierEnum;
          result.tier = valueDes;
          break;
        case r'nextTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(LoyaltyMemberDtoOutputNextTier),
          ) as LoyaltyMemberDtoOutputNextTier?;
          if (valueDes == null) continue;
          result.nextTier.replace(valueDes);
          break;
        case r'policyVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.policyVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoyaltyMemberDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoyaltyMemberDtoOutputBuilder();
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


class LoyaltyMemberDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const LoyaltyMemberDtoOutputStatusEnum ACTIVE = _$loyaltyMemberDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const LoyaltyMemberDtoOutputStatusEnum LOCKED = _$loyaltyMemberDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const LoyaltyMemberDtoOutputStatusEnum DISABLED = _$loyaltyMemberDtoOutputStatusEnum_DISABLED;

  static Serializer<LoyaltyMemberDtoOutputStatusEnum> get serializer => _$loyaltyMemberDtoOutputStatusEnumSerializer;

  const LoyaltyMemberDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<LoyaltyMemberDtoOutputStatusEnum> get values => _$loyaltyMemberDtoOutputStatusEnumValues;
  static LoyaltyMemberDtoOutputStatusEnum valueOf(String name) => _$loyaltyMemberDtoOutputStatusEnumValueOf(name);
}

class LoyaltyMemberDtoOutputTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const LoyaltyMemberDtoOutputTierEnum BRONZE = _$loyaltyMemberDtoOutputTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const LoyaltyMemberDtoOutputTierEnum SILVER = _$loyaltyMemberDtoOutputTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const LoyaltyMemberDtoOutputTierEnum GOLD = _$loyaltyMemberDtoOutputTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const LoyaltyMemberDtoOutputTierEnum PLATINUM = _$loyaltyMemberDtoOutputTierEnum_PLATINUM;

  static Serializer<LoyaltyMemberDtoOutputTierEnum> get serializer => _$loyaltyMemberDtoOutputTierEnumSerializer;

  const LoyaltyMemberDtoOutputTierEnum._(String name): super(name);

  static BuiltSet<LoyaltyMemberDtoOutputTierEnum> get values => _$loyaltyMemberDtoOutputTierEnumValues;
  static LoyaltyMemberDtoOutputTierEnum valueOf(String name) => _$loyaltyMemberDtoOutputTierEnumValueOf(name);
}

