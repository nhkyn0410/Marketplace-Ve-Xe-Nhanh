//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_voucher_dto_output.g.dart';

/// UserVoucherDtoOutput
///
/// Properties:
/// * [userVoucherId]
/// * [source_]
/// * [status]
/// * [promotionCode]
/// * [name]
/// * [discountAmount]
/// * [discountType]
/// * [discountValue]
/// * [maxDiscount]
/// * [minOrder]
/// * [expiresAt]
/// * [createdAt]
@BuiltValue()
abstract class UserVoucherDtoOutput
    implements Built<UserVoucherDtoOutput, UserVoucherDtoOutputBuilder> {
  @BuiltValueField(wireName: r'userVoucherId')
  String get userVoucherId;

  @BuiltValueField(wireName: r'source')
  UserVoucherDtoOutputSource_Enum get source_;
  // enum source_Enum {  LOYALTY_REDEMPTION,  SAVED_PROMOTION,  };

  @BuiltValueField(wireName: r'status')
  UserVoucherDtoOutputStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  RESERVED,  USED,  EXPIRED,  };

  @BuiltValueField(wireName: r'promotionCode')
  String? get promotionCode;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discountAmount')
  String? get discountAmount;

  @BuiltValueField(wireName: r'discountType')
  UserVoucherDtoOutputDiscountTypeEnum get discountType;
  // enum discountTypeEnum {  PERCENT,  AMOUNT,  };

  @BuiltValueField(wireName: r'discountValue')
  String get discountValue;

  @BuiltValueField(wireName: r'maxDiscount')
  String? get maxDiscount;

  @BuiltValueField(wireName: r'minOrder')
  String get minOrder;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  UserVoucherDtoOutput._();

  factory UserVoucherDtoOutput([void updates(UserVoucherDtoOutputBuilder b)]) =
      _$UserVoucherDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserVoucherDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserVoucherDtoOutput> get serializer =>
      _$UserVoucherDtoOutputSerializer();
}

class _$UserVoucherDtoOutputSerializer
    implements PrimitiveSerializer<UserVoucherDtoOutput> {
  @override
  final Iterable<Type> types = const [
    UserVoucherDtoOutput,
    _$UserVoucherDtoOutput
  ];

  @override
  final String wireName = r'UserVoucherDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserVoucherDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userVoucherId';
    yield serializers.serialize(
      object.userVoucherId,
      specifiedType: const FullType(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(UserVoucherDtoOutputSource_Enum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UserVoucherDtoOutputStatusEnum),
    );
    yield r'promotionCode';
    yield object.promotionCode == null
        ? null
        : serializers.serialize(
            object.promotionCode,
            specifiedType: const FullType.nullable(String),
          );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'discountAmount';
    yield object.discountAmount == null
        ? null
        : serializers.serialize(
            object.discountAmount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'discountType';
    yield serializers.serialize(
      object.discountType,
      specifiedType: const FullType(UserVoucherDtoOutputDiscountTypeEnum),
    );
    yield r'discountValue';
    yield serializers.serialize(
      object.discountValue,
      specifiedType: const FullType(String),
    );
    yield r'maxDiscount';
    yield object.maxDiscount == null
        ? null
        : serializers.serialize(
            object.maxDiscount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'minOrder';
    yield serializers.serialize(
      object.minOrder,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
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
    UserVoucherDtoOutput object, {
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
    required UserVoucherDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userVoucherId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userVoucherId = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserVoucherDtoOutputSource_Enum),
          ) as UserVoucherDtoOutputSource_Enum;
          result.source_ = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserVoucherDtoOutputStatusEnum),
          ) as UserVoucherDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'promotionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.promotionCode = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'discountAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.discountAmount = valueDes;
          break;
        case r'discountType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserVoucherDtoOutputDiscountTypeEnum),
          ) as UserVoucherDtoOutputDiscountTypeEnum;
          result.discountType = valueDes;
          break;
        case r'discountValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discountValue = valueDes;
          break;
        case r'maxDiscount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'minOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.minOrder = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  UserVoucherDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserVoucherDtoOutputBuilder();
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

class UserVoucherDtoOutputSource_Enum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'LOYALTY_REDEMPTION')
  static const UserVoucherDtoOutputSource_Enum LOYALTY_REDEMPTION =
      _$userVoucherDtoOutputSourceEnum_LOYALTY_REDEMPTION;
  @BuiltValueEnumConst(wireName: r'SAVED_PROMOTION')
  static const UserVoucherDtoOutputSource_Enum SAVED_PROMOTION =
      _$userVoucherDtoOutputSourceEnum_SAVED_PROMOTION;

  static Serializer<UserVoucherDtoOutputSource_Enum> get serializer =>
      _$userVoucherDtoOutputSourceEnumSerializer;

  const UserVoucherDtoOutputSource_Enum._(String name) : super(name);

  static BuiltSet<UserVoucherDtoOutputSource_Enum> get values =>
      _$userVoucherDtoOutputSourceEnumValues;
  static UserVoucherDtoOutputSource_Enum valueOf(String name) =>
      _$userVoucherDtoOutputSourceEnumValueOf(name);
}

class UserVoucherDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const UserVoucherDtoOutputStatusEnum AVAILABLE =
      _$userVoucherDtoOutputStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'RESERVED')
  static const UserVoucherDtoOutputStatusEnum RESERVED =
      _$userVoucherDtoOutputStatusEnum_RESERVED;
  @BuiltValueEnumConst(wireName: r'USED')
  static const UserVoucherDtoOutputStatusEnum USED =
      _$userVoucherDtoOutputStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const UserVoucherDtoOutputStatusEnum EXPIRED =
      _$userVoucherDtoOutputStatusEnum_EXPIRED;

  static Serializer<UserVoucherDtoOutputStatusEnum> get serializer =>
      _$userVoucherDtoOutputStatusEnumSerializer;

  const UserVoucherDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<UserVoucherDtoOutputStatusEnum> get values =>
      _$userVoucherDtoOutputStatusEnumValues;
  static UserVoucherDtoOutputStatusEnum valueOf(String name) =>
      _$userVoucherDtoOutputStatusEnumValueOf(name);
}

class UserVoucherDtoOutputDiscountTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PERCENT')
  static const UserVoucherDtoOutputDiscountTypeEnum PERCENT =
      _$userVoucherDtoOutputDiscountTypeEnum_PERCENT;
  @BuiltValueEnumConst(wireName: r'AMOUNT')
  static const UserVoucherDtoOutputDiscountTypeEnum AMOUNT =
      _$userVoucherDtoOutputDiscountTypeEnum_AMOUNT;

  static Serializer<UserVoucherDtoOutputDiscountTypeEnum> get serializer =>
      _$userVoucherDtoOutputDiscountTypeEnumSerializer;

  const UserVoucherDtoOutputDiscountTypeEnum._(String name) : super(name);

  static BuiltSet<UserVoucherDtoOutputDiscountTypeEnum> get values =>
      _$userVoucherDtoOutputDiscountTypeEnumValues;
  static UserVoucherDtoOutputDiscountTypeEnum valueOf(String name) =>
      _$userVoucherDtoOutputDiscountTypeEnumValueOf(name);
}
