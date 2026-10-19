//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_payment_detail_dto_output_ledger_inner.dart';
import 'package:api_client_dart/src/model/admin_payment_detail_dto_output_tickets_inner.dart';
import 'package:api_client_dart/src/model/admin_payment_detail_dto_output_allocation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_payment_detail_dto_output_booking.dart';
import 'package:api_client_dart/src/model/admin_payment_detail_dto_output_histories_inner.dart';
import 'package:api_client_dart/src/model/admin_payment_detail_dto_output_refunds_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output.g.dart';

/// AdminPaymentDetailDtoOutput
///
/// Properties:
/// * [paymentId] 
/// * [paymentCode] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [operatorId] 
/// * [operatorName] 
/// * [provider] 
/// * [amount] 
/// * [status] 
/// * [reconcileReason] 
/// * [failureCode] 
/// * [reconcileResolved] 
/// * [createdAt] 
/// * [paidAt] 
/// * [providerTxnId] 
/// * [expiresAt] 
/// * [lastCallbackAt] 
/// * [amountMatches] 
/// * [booking] 
/// * [allocation] 
/// * [histories] 
/// * [tickets] 
/// * [ledger] 
/// * [refunds] 
/// * [canRefund] 
@BuiltValue()
abstract class AdminPaymentDetailDtoOutput implements Built<AdminPaymentDetailDtoOutput, AdminPaymentDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'paymentCode')
  String get paymentCode;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'provider')
  AdminPaymentDetailDtoOutputProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'status')
  AdminPaymentDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'reconcileReason')
  String? get reconcileReason;

  @BuiltValueField(wireName: r'failureCode')
  String? get failureCode;

  @BuiltValueField(wireName: r'reconcileResolved')
  bool get reconcileResolved;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'paidAt')
  DateTime? get paidAt;

  @BuiltValueField(wireName: r'providerTxnId')
  String? get providerTxnId;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'lastCallbackAt')
  DateTime? get lastCallbackAt;

  @BuiltValueField(wireName: r'amountMatches')
  bool? get amountMatches;

  @BuiltValueField(wireName: r'booking')
  AdminPaymentDetailDtoOutputBooking get booking;

  @BuiltValueField(wireName: r'allocation')
  AdminPaymentDetailDtoOutputAllocation? get allocation;

  @BuiltValueField(wireName: r'histories')
  BuiltList<AdminPaymentDetailDtoOutputHistoriesInner> get histories;

  @BuiltValueField(wireName: r'tickets')
  BuiltList<AdminPaymentDetailDtoOutputTicketsInner> get tickets;

  @BuiltValueField(wireName: r'ledger')
  BuiltList<AdminPaymentDetailDtoOutputLedgerInner> get ledger;

  @BuiltValueField(wireName: r'refunds')
  BuiltList<AdminPaymentDetailDtoOutputRefundsInner> get refunds;

  @BuiltValueField(wireName: r'canRefund')
  bool get canRefund;

  AdminPaymentDetailDtoOutput._();

  factory AdminPaymentDetailDtoOutput([void updates(AdminPaymentDetailDtoOutputBuilder b)]) = _$AdminPaymentDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutput> get serializer => _$AdminPaymentDetailDtoOutputSerializer();
}

class _$AdminPaymentDetailDtoOutputSerializer implements PrimitiveSerializer<AdminPaymentDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminPaymentDetailDtoOutput, _$AdminPaymentDetailDtoOutput];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentId';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'paymentCode';
    yield serializers.serialize(
      object.paymentCode,
      specifiedType: const FullType(String),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'bookingCode';
    yield serializers.serialize(
      object.bookingCode,
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
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputProviderEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputStatusEnum),
    );
    yield r'reconcileReason';
    yield object.reconcileReason == null ? null : serializers.serialize(
      object.reconcileReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'failureCode';
    yield object.failureCode == null ? null : serializers.serialize(
      object.failureCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reconcileResolved';
    yield serializers.serialize(
      object.reconcileResolved,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'paidAt';
    yield object.paidAt == null ? null : serializers.serialize(
      object.paidAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'providerTxnId';
    yield object.providerTxnId == null ? null : serializers.serialize(
      object.providerTxnId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastCallbackAt';
    yield object.lastCallbackAt == null ? null : serializers.serialize(
      object.lastCallbackAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'amountMatches';
    yield object.amountMatches == null ? null : serializers.serialize(
      object.amountMatches,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'booking';
    yield serializers.serialize(
      object.booking,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputBooking),
    );
    yield r'allocation';
    yield object.allocation == null ? null : serializers.serialize(
      object.allocation,
      specifiedType: const FullType.nullable(AdminPaymentDetailDtoOutputAllocation),
    );
    yield r'histories';
    yield serializers.serialize(
      object.histories,
      specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputHistoriesInner)]),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputTicketsInner)]),
    );
    yield r'ledger';
    yield serializers.serialize(
      object.ledger,
      specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputLedgerInner)]),
    );
    yield r'refunds';
    yield serializers.serialize(
      object.refunds,
      specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputRefundsInner)]),
    );
    yield r'canRefund';
    yield serializers.serialize(
      object.canRefund,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPaymentDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentDetailDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
        case r'paymentCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentCode = valueDes;
          break;
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingCode = valueDes;
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
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputProviderEnum),
          ) as AdminPaymentDetailDtoOutputProviderEnum;
          result.provider = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputStatusEnum),
          ) as AdminPaymentDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'reconcileReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reconcileReason = valueDes;
          break;
        case r'failureCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.failureCode = valueDes;
          break;
        case r'reconcileResolved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reconcileResolved = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'paidAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paidAt = valueDes;
          break;
        case r'providerTxnId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerTxnId = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'lastCallbackAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastCallbackAt = valueDes;
          break;
        case r'amountMatches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.amountMatches = valueDes;
          break;
        case r'booking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputBooking),
          ) as AdminPaymentDetailDtoOutputBooking;
          result.booking.replace(valueDes);
          break;
        case r'allocation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminPaymentDetailDtoOutputAllocation),
          ) as AdminPaymentDetailDtoOutputAllocation?;
          if (valueDes == null) continue;
          result.allocation.replace(valueDes);
          break;
        case r'histories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputHistoriesInner)]),
          ) as BuiltList<AdminPaymentDetailDtoOutputHistoriesInner>;
          result.histories.replace(valueDes);
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputTicketsInner)]),
          ) as BuiltList<AdminPaymentDetailDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'ledger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputLedgerInner)]),
          ) as BuiltList<AdminPaymentDetailDtoOutputLedgerInner>;
          result.ledger.replace(valueDes);
          break;
        case r'refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPaymentDetailDtoOutputRefundsInner)]),
          ) as BuiltList<AdminPaymentDetailDtoOutputRefundsInner>;
          result.refunds.replace(valueDes);
          break;
        case r'canRefund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRefund = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPaymentDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputBuilder();
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


class AdminPaymentDetailDtoOutputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const AdminPaymentDetailDtoOutputProviderEnum VNPAY = _$adminPaymentDetailDtoOutputProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const AdminPaymentDetailDtoOutputProviderEnum MOMO = _$adminPaymentDetailDtoOutputProviderEnum_MOMO;

  static Serializer<AdminPaymentDetailDtoOutputProviderEnum> get serializer => _$adminPaymentDetailDtoOutputProviderEnumSerializer;

  const AdminPaymentDetailDtoOutputProviderEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputProviderEnum> get values => _$adminPaymentDetailDtoOutputProviderEnumValues;
  static AdminPaymentDetailDtoOutputProviderEnum valueOf(String name) => _$adminPaymentDetailDtoOutputProviderEnumValueOf(name);
}

class AdminPaymentDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const AdminPaymentDetailDtoOutputStatusEnum INITIATED = _$adminPaymentDetailDtoOutputStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminPaymentDetailDtoOutputStatusEnum PROCESSING = _$adminPaymentDetailDtoOutputStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminPaymentDetailDtoOutputStatusEnum SUCCESS = _$adminPaymentDetailDtoOutputStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminPaymentDetailDtoOutputStatusEnum FAILED = _$adminPaymentDetailDtoOutputStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const AdminPaymentDetailDtoOutputStatusEnum EXPIRED = _$adminPaymentDetailDtoOutputStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminPaymentDetailDtoOutputStatusEnum CANCELLED = _$adminPaymentDetailDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const AdminPaymentDetailDtoOutputStatusEnum RECONCILING = _$adminPaymentDetailDtoOutputStatusEnum_RECONCILING;

  static Serializer<AdminPaymentDetailDtoOutputStatusEnum> get serializer => _$adminPaymentDetailDtoOutputStatusEnumSerializer;

  const AdminPaymentDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputStatusEnum> get values => _$adminPaymentDetailDtoOutputStatusEnumValues;
  static AdminPaymentDetailDtoOutputStatusEnum valueOf(String name) => _$adminPaymentDetailDtoOutputStatusEnumValueOf(name);
}

