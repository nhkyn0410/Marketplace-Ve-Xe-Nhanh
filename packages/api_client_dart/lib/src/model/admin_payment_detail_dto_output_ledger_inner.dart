//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output_ledger_inner.g.dart';

/// AdminPaymentDetailDtoOutputLedgerInner
///
/// Properties:
/// * [entryType]
/// * [amount]
/// * [eligibleAt]
/// * [createdAt]
@BuiltValue()
abstract class AdminPaymentDetailDtoOutputLedgerInner
    implements
        Built<AdminPaymentDetailDtoOutputLedgerInner,
            AdminPaymentDetailDtoOutputLedgerInnerBuilder> {
  @BuiltValueField(wireName: r'entryType')
  AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum get entryType;
  // enum entryTypeEnum {  PAYMENT_CAPTURED,  COMMISSION,  REFUND,  COMMISSION_REVERSAL,  PLATFORM_FUNDED_DISCOUNT,  PLATFORM_FUNDED_DISCOUNT_REVERSAL,  PAYOUT,  ADJUSTMENT,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'eligibleAt')
  DateTime get eligibleAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminPaymentDetailDtoOutputLedgerInner._();

  factory AdminPaymentDetailDtoOutputLedgerInner(
          [void updates(AdminPaymentDetailDtoOutputLedgerInnerBuilder b)]) =
      _$AdminPaymentDetailDtoOutputLedgerInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputLedgerInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutputLedgerInner> get serializer =>
      _$AdminPaymentDetailDtoOutputLedgerInnerSerializer();
}

class _$AdminPaymentDetailDtoOutputLedgerInnerSerializer
    implements PrimitiveSerializer<AdminPaymentDetailDtoOutputLedgerInner> {
  @override
  final Iterable<Type> types = const [
    AdminPaymentDetailDtoOutputLedgerInner,
    _$AdminPaymentDetailDtoOutputLedgerInner
  ];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutputLedgerInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutputLedgerInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entryType';
    yield serializers.serialize(
      object.entryType,
      specifiedType:
          const FullType(AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'eligibleAt';
    yield serializers.serialize(
      object.eligibleAt,
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
    AdminPaymentDetailDtoOutputLedgerInner object, {
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
    required AdminPaymentDetailDtoOutputLedgerInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entryType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum),
          ) as AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum;
          result.entryType = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'eligibleAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.eligibleAt = valueDes;
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
  AdminPaymentDetailDtoOutputLedgerInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputLedgerInnerBuilder();
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

class AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PAYMENT_CAPTURED')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
      PAYMENT_CAPTURED =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYMENT_CAPTURED;
  @BuiltValueEnumConst(wireName: r'COMMISSION')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum COMMISSION =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum REFUND =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'COMMISSION_REVERSAL')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
      COMMISSION_REVERSAL =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION_REVERSAL;
  @BuiltValueEnumConst(wireName: r'PLATFORM_FUNDED_DISCOUNT')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
      PLATFORM_FUNDED_DISCOUNT =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT;
  @BuiltValueEnumConst(wireName: r'PLATFORM_FUNDED_DISCOUNT_REVERSAL')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
      PLATFORM_FUNDED_DISCOUNT_REVERSAL =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT_REVERSAL;
  @BuiltValueEnumConst(wireName: r'PAYOUT')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum PAYOUT =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYOUT;
  @BuiltValueEnumConst(wireName: r'ADJUSTMENT')
  static const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum ADJUSTMENT =
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_ADJUSTMENT;

  static Serializer<AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum>
      get serializer =>
          _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumSerializer;

  const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._(String name)
      : super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum>
      get values => _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumValues;
  static AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum valueOf(
          String name) =>
      _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumValueOf(name);
}
