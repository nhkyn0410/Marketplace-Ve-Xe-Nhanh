//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_voucher_page_dto_output_items_inner.g.dart';

/// UserVoucherPageDtoOutputItemsInner
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
abstract class UserVoucherPageDtoOutputItemsInner
    implements
        Built<UserVoucherPageDtoOutputItemsInner,
            UserVoucherPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'userVoucherId')
  String get userVoucherId;

  @BuiltValueField(wireName: r'source')
  UserVoucherPageDtoOutputItemsInnerSource_Enum get source_;
  // enum source_Enum {  LOYALTY_REDEMPTION,  SAVED_PROMOTION,  };

  @BuiltValueField(wireName: r'status')
  UserVoucherPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  RESERVED,  USED,  EXPIRED,  };

  @BuiltValueField(wireName: r'promotionCode')
  String? get promotionCode;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discountAmount')
  String? get discountAmount;

  @BuiltValueField(wireName: r'discountType')
  UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum get discountType;
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

  UserVoucherPageDtoOutputItemsInner._();

  factory UserVoucherPageDtoOutputItemsInner(
          [void updates(UserVoucherPageDtoOutputItemsInnerBuilder b)]) =
      _$UserVoucherPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserVoucherPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserVoucherPageDtoOutputItemsInner> get serializer =>
      _$UserVoucherPageDtoOutputItemsInnerSerializer();
}

class _$UserVoucherPageDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<UserVoucherPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    UserVoucherPageDtoOutputItemsInner,
    _$UserVoucherPageDtoOutputItemsInner
  ];

  @override
  final String wireName = r'UserVoucherPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserVoucherPageDtoOutputItemsInner object, {
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
      specifiedType:
          const FullType(UserVoucherPageDtoOutputItemsInnerSource_Enum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(UserVoucherPageDtoOutputItemsInnerStatusEnum),
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
      specifiedType:
          const FullType(UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum),
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
    UserVoucherPageDtoOutputItemsInner object, {
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
    required UserVoucherPageDtoOutputItemsInnerBuilder result,
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
            specifiedType:
                const FullType(UserVoucherPageDtoOutputItemsInnerSource_Enum),
          ) as UserVoucherPageDtoOutputItemsInnerSource_Enum;
          result.source_ = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(UserVoucherPageDtoOutputItemsInnerStatusEnum),
          ) as UserVoucherPageDtoOutputItemsInnerStatusEnum;
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
            specifiedType: const FullType(
                UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum),
          ) as UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum;
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
  UserVoucherPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserVoucherPageDtoOutputItemsInnerBuilder();
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

class UserVoucherPageDtoOutputItemsInnerSource_Enum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'LOYALTY_REDEMPTION')
  static const UserVoucherPageDtoOutputItemsInnerSource_Enum
      LOYALTY_REDEMPTION =
      _$userVoucherPageDtoOutputItemsInnerSourceEnum_LOYALTY_REDEMPTION;
  @BuiltValueEnumConst(wireName: r'SAVED_PROMOTION')
  static const UserVoucherPageDtoOutputItemsInnerSource_Enum SAVED_PROMOTION =
      _$userVoucherPageDtoOutputItemsInnerSourceEnum_SAVED_PROMOTION;

  static Serializer<UserVoucherPageDtoOutputItemsInnerSource_Enum>
      get serializer =>
          _$userVoucherPageDtoOutputItemsInnerSourceEnumSerializer;

  const UserVoucherPageDtoOutputItemsInnerSource_Enum._(String name)
      : super(name);

  static BuiltSet<UserVoucherPageDtoOutputItemsInnerSource_Enum> get values =>
      _$userVoucherPageDtoOutputItemsInnerSourceEnumValues;
  static UserVoucherPageDtoOutputItemsInnerSource_Enum valueOf(String name) =>
      _$userVoucherPageDtoOutputItemsInnerSourceEnumValueOf(name);
}

class UserVoucherPageDtoOutputItemsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const UserVoucherPageDtoOutputItemsInnerStatusEnum AVAILABLE =
      _$userVoucherPageDtoOutputItemsInnerStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'RESERVED')
  static const UserVoucherPageDtoOutputItemsInnerStatusEnum RESERVED =
      _$userVoucherPageDtoOutputItemsInnerStatusEnum_RESERVED;
  @BuiltValueEnumConst(wireName: r'USED')
  static const UserVoucherPageDtoOutputItemsInnerStatusEnum USED =
      _$userVoucherPageDtoOutputItemsInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const UserVoucherPageDtoOutputItemsInnerStatusEnum EXPIRED =
      _$userVoucherPageDtoOutputItemsInnerStatusEnum_EXPIRED;

  static Serializer<UserVoucherPageDtoOutputItemsInnerStatusEnum>
      get serializer =>
          _$userVoucherPageDtoOutputItemsInnerStatusEnumSerializer;

  const UserVoucherPageDtoOutputItemsInnerStatusEnum._(String name)
      : super(name);

  static BuiltSet<UserVoucherPageDtoOutputItemsInnerStatusEnum> get values =>
      _$userVoucherPageDtoOutputItemsInnerStatusEnumValues;
  static UserVoucherPageDtoOutputItemsInnerStatusEnum valueOf(String name) =>
      _$userVoucherPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

class UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PERCENT')
  static const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum PERCENT =
      _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_PERCENT;
  @BuiltValueEnumConst(wireName: r'AMOUNT')
  static const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum AMOUNT =
      _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_AMOUNT;

  static Serializer<UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum>
      get serializer =>
          _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnumSerializer;

  const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum._(String name)
      : super(name);

  static BuiltSet<UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum>
      get values => _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnumValues;
  static UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum valueOf(
          String name) =>
      _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnumValueOf(name);
}
