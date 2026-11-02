//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_refund_detail_dto_output_tickets_inner.dart';
import 'package:api_client_dart/src/model/admin_refund_detail_dto_output_histories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_refund_detail_dto_output.g.dart';

/// AdminRefundDetailDtoOutput
///
/// Properties:
/// * [refundId] 
/// * [refundCode] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [paymentId] 
/// * [paymentCode] 
/// * [provider] 
/// * [operatorId] 
/// * [operatorName] 
/// * [source_] 
/// * [amount] 
/// * [refundPercent] 
/// * [status] 
/// * [failureCode] 
/// * [reason] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [paidAmount] 
/// * [paymentStatus] 
/// * [attempt] 
/// * [providerRefundId] 
/// * [bankReference] 
/// * [processedAt] 
/// * [tickets] 
/// * [histories] 
/// * [canRetry] 
/// * [canResolve] 
@BuiltValue()
abstract class AdminRefundDetailDtoOutput implements Built<AdminRefundDetailDtoOutput, AdminRefundDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'refundId')
  String get refundId;

  @BuiltValueField(wireName: r'refundCode')
  String get refundCode;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'paymentCode')
  String get paymentCode;

  @BuiltValueField(wireName: r'provider')
  AdminRefundDetailDtoOutputProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'source')
  AdminRefundDetailDtoOutputSource_Enum get source_;
  // enum source_Enum {  CUSTOMER,  OPERATOR,  PLATFORM,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'refundPercent')
  int get refundPercent;

  @BuiltValueField(wireName: r'status')
  AdminRefundDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  @BuiltValueField(wireName: r'failureCode')
  String? get failureCode;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'paidAmount')
  int get paidAmount;

  @BuiltValueField(wireName: r'paymentStatus')
  AdminRefundDetailDtoOutputPaymentStatusEnum get paymentStatus;
  // enum paymentStatusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'attempt')
  int get attempt;

  @BuiltValueField(wireName: r'providerRefundId')
  String? get providerRefundId;

  @BuiltValueField(wireName: r'bankReference')
  String? get bankReference;

  @BuiltValueField(wireName: r'processedAt')
  DateTime? get processedAt;

  @BuiltValueField(wireName: r'tickets')
  BuiltList<AdminRefundDetailDtoOutputTicketsInner> get tickets;

  @BuiltValueField(wireName: r'histories')
  BuiltList<AdminRefundDetailDtoOutputHistoriesInner> get histories;

  @BuiltValueField(wireName: r'canRetry')
  bool get canRetry;

  @BuiltValueField(wireName: r'canResolve')
  bool get canResolve;

  AdminRefundDetailDtoOutput._();

  factory AdminRefundDetailDtoOutput([void updates(AdminRefundDetailDtoOutputBuilder b)]) = _$AdminRefundDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRefundDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRefundDetailDtoOutput> get serializer => _$AdminRefundDetailDtoOutputSerializer();
}

class _$AdminRefundDetailDtoOutputSerializer implements PrimitiveSerializer<AdminRefundDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminRefundDetailDtoOutput, _$AdminRefundDetailDtoOutput];

  @override
  final String wireName = r'AdminRefundDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRefundDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refundId';
    yield serializers.serialize(
      object.refundId,
      specifiedType: const FullType(String),
    );
    yield r'refundCode';
    yield serializers.serialize(
      object.refundCode,
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
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(AdminRefundDetailDtoOutputProviderEnum),
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
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(AdminRefundDetailDtoOutputSource_Enum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'refundPercent';
    yield serializers.serialize(
      object.refundPercent,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminRefundDetailDtoOutputStatusEnum),
    );
    yield r'failureCode';
    yield object.failureCode == null ? null : serializers.serialize(
      object.failureCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'paidAmount';
    yield serializers.serialize(
      object.paidAmount,
      specifiedType: const FullType(int),
    );
    yield r'paymentStatus';
    yield serializers.serialize(
      object.paymentStatus,
      specifiedType: const FullType(AdminRefundDetailDtoOutputPaymentStatusEnum),
    );
    yield r'attempt';
    yield serializers.serialize(
      object.attempt,
      specifiedType: const FullType(int),
    );
    yield r'providerRefundId';
    yield object.providerRefundId == null ? null : serializers.serialize(
      object.providerRefundId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bankReference';
    yield object.bankReference == null ? null : serializers.serialize(
      object.bankReference,
      specifiedType: const FullType.nullable(String),
    );
    yield r'processedAt';
    yield object.processedAt == null ? null : serializers.serialize(
      object.processedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [FullType(AdminRefundDetailDtoOutputTicketsInner)]),
    );
    yield r'histories';
    yield serializers.serialize(
      object.histories,
      specifiedType: const FullType(BuiltList, [FullType(AdminRefundDetailDtoOutputHistoriesInner)]),
    );
    yield r'canRetry';
    yield serializers.serialize(
      object.canRetry,
      specifiedType: const FullType(bool),
    );
    yield r'canResolve';
    yield serializers.serialize(
      object.canResolve,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRefundDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRefundDetailDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refundId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundId = valueDes;
          break;
        case r'refundCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundCode = valueDes;
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
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundDetailDtoOutputProviderEnum),
          ) as AdminRefundDetailDtoOutputProviderEnum;
          result.provider = valueDes;
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
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundDetailDtoOutputSource_Enum),
          ) as AdminRefundDetailDtoOutputSource_Enum;
          result.source_ = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'refundPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundPercent = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundDetailDtoOutputStatusEnum),
          ) as AdminRefundDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'failureCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.failureCode = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'paidAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paidAmount = valueDes;
          break;
        case r'paymentStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundDetailDtoOutputPaymentStatusEnum),
          ) as AdminRefundDetailDtoOutputPaymentStatusEnum;
          result.paymentStatus = valueDes;
          break;
        case r'attempt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attempt = valueDes;
          break;
        case r'providerRefundId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerRefundId = valueDes;
          break;
        case r'bankReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankReference = valueDes;
          break;
        case r'processedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.processedAt = valueDes;
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRefundDetailDtoOutputTicketsInner)]),
          ) as BuiltList<AdminRefundDetailDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'histories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRefundDetailDtoOutputHistoriesInner)]),
          ) as BuiltList<AdminRefundDetailDtoOutputHistoriesInner>;
          result.histories.replace(valueDes);
          break;
        case r'canRetry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRetry = valueDes;
          break;
        case r'canResolve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canResolve = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRefundDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRefundDetailDtoOutputBuilder();
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


class AdminRefundDetailDtoOutputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const AdminRefundDetailDtoOutputProviderEnum VNPAY = _$adminRefundDetailDtoOutputProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const AdminRefundDetailDtoOutputProviderEnum MOMO = _$adminRefundDetailDtoOutputProviderEnum_MOMO;
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const AdminRefundDetailDtoOutputProviderEnum PAYOS = _$adminRefundDetailDtoOutputProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const AdminRefundDetailDtoOutputProviderEnum DEMO = _$adminRefundDetailDtoOutputProviderEnum_DEMO;

  static Serializer<AdminRefundDetailDtoOutputProviderEnum> get serializer => _$adminRefundDetailDtoOutputProviderEnumSerializer;

  const AdminRefundDetailDtoOutputProviderEnum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputProviderEnum> get values => _$adminRefundDetailDtoOutputProviderEnumValues;
  static AdminRefundDetailDtoOutputProviderEnum valueOf(String name) => _$adminRefundDetailDtoOutputProviderEnumValueOf(name);
}

class AdminRefundDetailDtoOutputSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CUSTOMER')
  static const AdminRefundDetailDtoOutputSource_Enum CUSTOMER = _$adminRefundDetailDtoOutputSourceEnum_CUSTOMER;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const AdminRefundDetailDtoOutputSource_Enum OPERATOR = _$adminRefundDetailDtoOutputSourceEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const AdminRefundDetailDtoOutputSource_Enum PLATFORM = _$adminRefundDetailDtoOutputSourceEnum_PLATFORM;

  static Serializer<AdminRefundDetailDtoOutputSource_Enum> get serializer => _$adminRefundDetailDtoOutputSourceEnumSerializer;

  const AdminRefundDetailDtoOutputSource_Enum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputSource_Enum> get values => _$adminRefundDetailDtoOutputSourceEnumValues;
  static AdminRefundDetailDtoOutputSource_Enum valueOf(String name) => _$adminRefundDetailDtoOutputSourceEnumValueOf(name);
}

class AdminRefundDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const AdminRefundDetailDtoOutputStatusEnum REQUESTED = _$adminRefundDetailDtoOutputStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminRefundDetailDtoOutputStatusEnum APPROVED = _$adminRefundDetailDtoOutputStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminRefundDetailDtoOutputStatusEnum PROCESSING = _$adminRefundDetailDtoOutputStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminRefundDetailDtoOutputStatusEnum SUCCESS = _$adminRefundDetailDtoOutputStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminRefundDetailDtoOutputStatusEnum FAILED = _$adminRefundDetailDtoOutputStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminRefundDetailDtoOutputStatusEnum REJECTED = _$adminRefundDetailDtoOutputStatusEnum_REJECTED;

  static Serializer<AdminRefundDetailDtoOutputStatusEnum> get serializer => _$adminRefundDetailDtoOutputStatusEnumSerializer;

  const AdminRefundDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputStatusEnum> get values => _$adminRefundDetailDtoOutputStatusEnumValues;
  static AdminRefundDetailDtoOutputStatusEnum valueOf(String name) => _$adminRefundDetailDtoOutputStatusEnumValueOf(name);
}

class AdminRefundDetailDtoOutputPaymentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum INITIATED = _$adminRefundDetailDtoOutputPaymentStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum PROCESSING = _$adminRefundDetailDtoOutputPaymentStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum SUCCESS = _$adminRefundDetailDtoOutputPaymentStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum FAILED = _$adminRefundDetailDtoOutputPaymentStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum EXPIRED = _$adminRefundDetailDtoOutputPaymentStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum CANCELLED = _$adminRefundDetailDtoOutputPaymentStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const AdminRefundDetailDtoOutputPaymentStatusEnum RECONCILING = _$adminRefundDetailDtoOutputPaymentStatusEnum_RECONCILING;

  static Serializer<AdminRefundDetailDtoOutputPaymentStatusEnum> get serializer => _$adminRefundDetailDtoOutputPaymentStatusEnumSerializer;

  const AdminRefundDetailDtoOutputPaymentStatusEnum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputPaymentStatusEnum> get values => _$adminRefundDetailDtoOutputPaymentStatusEnumValues;
  static AdminRefundDetailDtoOutputPaymentStatusEnum valueOf(String name) => _$adminRefundDetailDtoOutputPaymentStatusEnumValueOf(name);
}

