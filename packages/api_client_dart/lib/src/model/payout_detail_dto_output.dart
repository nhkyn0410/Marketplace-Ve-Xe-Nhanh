//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/payout_detail_dto_output_checks.dart';
import 'package:api_client_dart/src/model/payout_detail_dto_output_histories_inner.dart';
import 'package:api_client_dart/src/model/payout_detail_dto_output_trips_inner.dart';
import 'package:api_client_dart/src/model/payout_page_dto_output_items_inner_bank.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_detail_dto_output.g.dart';

/// PayoutDetailDtoOutput
///
/// Properties:
/// * [payoutId] 
/// * [payoutCode] 
/// * [operatorId] 
/// * [operatorName] 
/// * [period] 
/// * [status] 
/// * [grossAmount] 
/// * [commissionAmount] 
/// * [refundAmount] 
/// * [adjustmentAmount] 
/// * [amount] 
/// * [commissionRateBps] 
/// * [holdReason] 
/// * [bank] 
/// * [paidAt] 
/// * [createdAt] 
/// * [trips] 
/// * [checks] 
/// * [bankReference] 
/// * [transferredAt] 
/// * [confirmationNote] 
/// * [cancelReason] 
/// * [histories] 
@BuiltValue()
abstract class PayoutDetailDtoOutput implements Built<PayoutDetailDtoOutput, PayoutDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'payoutId')
  String get payoutId;

  @BuiltValueField(wireName: r'payoutCode')
  String get payoutCode;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'period')
  Date get period;

  @BuiltValueField(wireName: r'status')
  PayoutDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  PENDING_REVIEW,  ON_HOLD,  READY_TO_TRANSFER,  TRANSFERRING,  PAID,  FAILED,  CANCELLED,  };

  @BuiltValueField(wireName: r'grossAmount')
  int get grossAmount;

  @BuiltValueField(wireName: r'commissionAmount')
  int get commissionAmount;

  @BuiltValueField(wireName: r'refundAmount')
  int get refundAmount;

  @BuiltValueField(wireName: r'adjustmentAmount')
  int get adjustmentAmount;

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'commissionRateBps')
  int? get commissionRateBps;

  @BuiltValueField(wireName: r'holdReason')
  String? get holdReason;

  @BuiltValueField(wireName: r'bank')
  PayoutPageDtoOutputItemsInnerBank? get bank;

  @BuiltValueField(wireName: r'paidAt')
  DateTime? get paidAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'trips')
  BuiltList<PayoutDetailDtoOutputTripsInner> get trips;

  @BuiltValueField(wireName: r'checks')
  PayoutDetailDtoOutputChecks get checks;

  @BuiltValueField(wireName: r'bankReference')
  String? get bankReference;

  @BuiltValueField(wireName: r'transferredAt')
  DateTime? get transferredAt;

  @BuiltValueField(wireName: r'confirmationNote')
  String? get confirmationNote;

  @BuiltValueField(wireName: r'cancelReason')
  String? get cancelReason;

  @BuiltValueField(wireName: r'histories')
  BuiltList<PayoutDetailDtoOutputHistoriesInner> get histories;

  PayoutDetailDtoOutput._();

  factory PayoutDetailDtoOutput([void updates(PayoutDetailDtoOutputBuilder b)]) = _$PayoutDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutDetailDtoOutput> get serializer => _$PayoutDetailDtoOutputSerializer();
}

class _$PayoutDetailDtoOutputSerializer implements PrimitiveSerializer<PayoutDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [PayoutDetailDtoOutput, _$PayoutDetailDtoOutput];

  @override
  final String wireName = r'PayoutDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payoutId';
    yield serializers.serialize(
      object.payoutId,
      specifiedType: const FullType(String),
    );
    yield r'payoutCode';
    yield serializers.serialize(
      object.payoutCode,
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
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PayoutDetailDtoOutputStatusEnum),
    );
    yield r'grossAmount';
    yield serializers.serialize(
      object.grossAmount,
      specifiedType: const FullType(int),
    );
    yield r'commissionAmount';
    yield serializers.serialize(
      object.commissionAmount,
      specifiedType: const FullType(int),
    );
    yield r'refundAmount';
    yield serializers.serialize(
      object.refundAmount,
      specifiedType: const FullType(int),
    );
    yield r'adjustmentAmount';
    yield serializers.serialize(
      object.adjustmentAmount,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'commissionRateBps';
    yield object.commissionRateBps == null ? null : serializers.serialize(
      object.commissionRateBps,
      specifiedType: const FullType.nullable(int),
    );
    yield r'holdReason';
    yield object.holdReason == null ? null : serializers.serialize(
      object.holdReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bank';
    yield object.bank == null ? null : serializers.serialize(
      object.bank,
      specifiedType: const FullType.nullable(PayoutPageDtoOutputItemsInnerBank),
    );
    yield r'paidAt';
    yield object.paidAt == null ? null : serializers.serialize(
      object.paidAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(BuiltList, [FullType(PayoutDetailDtoOutputTripsInner)]),
    );
    yield r'checks';
    yield serializers.serialize(
      object.checks,
      specifiedType: const FullType(PayoutDetailDtoOutputChecks),
    );
    yield r'bankReference';
    yield object.bankReference == null ? null : serializers.serialize(
      object.bankReference,
      specifiedType: const FullType.nullable(String),
    );
    yield r'transferredAt';
    yield object.transferredAt == null ? null : serializers.serialize(
      object.transferredAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'confirmationNote';
    yield object.confirmationNote == null ? null : serializers.serialize(
      object.confirmationNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'cancelReason';
    yield object.cancelReason == null ? null : serializers.serialize(
      object.cancelReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'histories';
    yield serializers.serialize(
      object.histories,
      specifiedType: const FullType(BuiltList, [FullType(PayoutDetailDtoOutputHistoriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutDetailDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payoutId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.payoutId = valueDes;
          break;
        case r'payoutCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.payoutCode = valueDes;
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
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.period = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PayoutDetailDtoOutputStatusEnum),
          ) as PayoutDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'grossAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossAmount = valueDes;
          break;
        case r'commissionAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionAmount = valueDes;
          break;
        case r'refundAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundAmount = valueDes;
          break;
        case r'adjustmentAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.adjustmentAmount = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'commissionRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.commissionRateBps = valueDes;
          break;
        case r'holdReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.holdReason = valueDes;
          break;
        case r'bank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PayoutPageDtoOutputItemsInnerBank),
          ) as PayoutPageDtoOutputItemsInnerBank?;
          if (valueDes == null) continue;
          result.bank.replace(valueDes);
          break;
        case r'paidAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paidAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PayoutDetailDtoOutputTripsInner)]),
          ) as BuiltList<PayoutDetailDtoOutputTripsInner>;
          result.trips.replace(valueDes);
          break;
        case r'checks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PayoutDetailDtoOutputChecks),
          ) as PayoutDetailDtoOutputChecks;
          result.checks.replace(valueDes);
          break;
        case r'bankReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankReference = valueDes;
          break;
        case r'transferredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.transferredAt = valueDes;
          break;
        case r'confirmationNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.confirmationNote = valueDes;
          break;
        case r'cancelReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cancelReason = valueDes;
          break;
        case r'histories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PayoutDetailDtoOutputHistoriesInner)]),
          ) as BuiltList<PayoutDetailDtoOutputHistoriesInner>;
          result.histories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutDetailDtoOutputBuilder();
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


class PayoutDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_REVIEW')
  static const PayoutDetailDtoOutputStatusEnum PENDING_REVIEW = _$payoutDetailDtoOutputStatusEnum_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'ON_HOLD')
  static const PayoutDetailDtoOutputStatusEnum ON_HOLD = _$payoutDetailDtoOutputStatusEnum_ON_HOLD;
  @BuiltValueEnumConst(wireName: r'READY_TO_TRANSFER')
  static const PayoutDetailDtoOutputStatusEnum READY_TO_TRANSFER = _$payoutDetailDtoOutputStatusEnum_READY_TO_TRANSFER;
  @BuiltValueEnumConst(wireName: r'TRANSFERRING')
  static const PayoutDetailDtoOutputStatusEnum TRANSFERRING = _$payoutDetailDtoOutputStatusEnum_TRANSFERRING;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const PayoutDetailDtoOutputStatusEnum PAID = _$payoutDetailDtoOutputStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const PayoutDetailDtoOutputStatusEnum FAILED = _$payoutDetailDtoOutputStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PayoutDetailDtoOutputStatusEnum CANCELLED = _$payoutDetailDtoOutputStatusEnum_CANCELLED;

  static Serializer<PayoutDetailDtoOutputStatusEnum> get serializer => _$payoutDetailDtoOutputStatusEnumSerializer;

  const PayoutDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<PayoutDetailDtoOutputStatusEnum> get values => _$payoutDetailDtoOutputStatusEnumValues;
  static PayoutDetailDtoOutputStatusEnum valueOf(String name) => _$payoutDetailDtoOutputStatusEnumValueOf(name);
}

