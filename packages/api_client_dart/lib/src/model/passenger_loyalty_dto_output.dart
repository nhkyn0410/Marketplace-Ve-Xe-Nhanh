//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/passenger_loyalty_dto_output_next_tier.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/passenger_loyalty_dto_output_rules.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_loyalty_dto_output.g.dart';

/// PassengerLoyaltyDtoOutput
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
/// * [rules]
@BuiltValue()
abstract class PassengerLoyaltyDtoOutput
    implements
        Built<PassengerLoyaltyDtoOutput, PassengerLoyaltyDtoOutputBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'status')
  PassengerLoyaltyDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'memberSince')
  DateTime get memberSince;

  @BuiltValueField(wireName: r'availablePoints')
  int get availablePoints;

  @BuiltValueField(wireName: r'earned12m')
  int get earned12m;

  @BuiltValueField(wireName: r'tier')
  PassengerLoyaltyDtoOutputTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'nextTier')
  PassengerLoyaltyDtoOutputNextTier? get nextTier;

  @BuiltValueField(wireName: r'policyVersion')
  int? get policyVersion;

  @BuiltValueField(wireName: r'rules')
  PassengerLoyaltyDtoOutputRules? get rules;

  PassengerLoyaltyDtoOutput._();

  factory PassengerLoyaltyDtoOutput(
          [void updates(PassengerLoyaltyDtoOutputBuilder b)]) =
      _$PassengerLoyaltyDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerLoyaltyDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerLoyaltyDtoOutput> get serializer =>
      _$PassengerLoyaltyDtoOutputSerializer();
}

class _$PassengerLoyaltyDtoOutputSerializer
    implements PrimitiveSerializer<PassengerLoyaltyDtoOutput> {
  @override
  final Iterable<Type> types = const [
    PassengerLoyaltyDtoOutput,
    _$PassengerLoyaltyDtoOutput
  ];

  @override
  final String wireName = r'PassengerLoyaltyDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerLoyaltyDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
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
      specifiedType: const FullType(PassengerLoyaltyDtoOutputStatusEnum),
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
      specifiedType: const FullType(PassengerLoyaltyDtoOutputTierEnum),
    );
    yield r'nextTier';
    yield object.nextTier == null
        ? null
        : serializers.serialize(
            object.nextTier,
            specifiedType:
                const FullType.nullable(PassengerLoyaltyDtoOutputNextTier),
          );
    yield r'policyVersion';
    yield object.policyVersion == null
        ? null
        : serializers.serialize(
            object.policyVersion,
            specifiedType: const FullType.nullable(int),
          );
    yield r'rules';
    yield object.rules == null
        ? null
        : serializers.serialize(
            object.rules,
            specifiedType:
                const FullType.nullable(PassengerLoyaltyDtoOutputRules),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerLoyaltyDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerLoyaltyDtoOutputBuilder result,
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
            specifiedType: const FullType(PassengerLoyaltyDtoOutputStatusEnum),
          ) as PassengerLoyaltyDtoOutputStatusEnum;
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
            specifiedType: const FullType(PassengerLoyaltyDtoOutputTierEnum),
          ) as PassengerLoyaltyDtoOutputTierEnum;
          result.tier = valueDes;
          break;
        case r'nextTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(PassengerLoyaltyDtoOutputNextTier),
          ) as PassengerLoyaltyDtoOutputNextTier?;
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
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(PassengerLoyaltyDtoOutputRules),
          ) as PassengerLoyaltyDtoOutputRules?;
          if (valueDes == null) continue;
          result.rules.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerLoyaltyDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerLoyaltyDtoOutputBuilder();
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

class PassengerLoyaltyDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const PassengerLoyaltyDtoOutputStatusEnum ACTIVE =
      _$passengerLoyaltyDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const PassengerLoyaltyDtoOutputStatusEnum LOCKED =
      _$passengerLoyaltyDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const PassengerLoyaltyDtoOutputStatusEnum DISABLED =
      _$passengerLoyaltyDtoOutputStatusEnum_DISABLED;

  static Serializer<PassengerLoyaltyDtoOutputStatusEnum> get serializer =>
      _$passengerLoyaltyDtoOutputStatusEnumSerializer;

  const PassengerLoyaltyDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<PassengerLoyaltyDtoOutputStatusEnum> get values =>
      _$passengerLoyaltyDtoOutputStatusEnumValues;
  static PassengerLoyaltyDtoOutputStatusEnum valueOf(String name) =>
      _$passengerLoyaltyDtoOutputStatusEnumValueOf(name);
}

class PassengerLoyaltyDtoOutputTierEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const PassengerLoyaltyDtoOutputTierEnum BRONZE =
      _$passengerLoyaltyDtoOutputTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const PassengerLoyaltyDtoOutputTierEnum SILVER =
      _$passengerLoyaltyDtoOutputTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const PassengerLoyaltyDtoOutputTierEnum GOLD =
      _$passengerLoyaltyDtoOutputTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const PassengerLoyaltyDtoOutputTierEnum PLATINUM =
      _$passengerLoyaltyDtoOutputTierEnum_PLATINUM;

  static Serializer<PassengerLoyaltyDtoOutputTierEnum> get serializer =>
      _$passengerLoyaltyDtoOutputTierEnumSerializer;

  const PassengerLoyaltyDtoOutputTierEnum._(String name) : super(name);

  static BuiltSet<PassengerLoyaltyDtoOutputTierEnum> get values =>
      _$passengerLoyaltyDtoOutputTierEnumValues;
  static PassengerLoyaltyDtoOutputTierEnum valueOf(String name) =>
      _$passengerLoyaltyDtoOutputTierEnumValueOf(name);
}
