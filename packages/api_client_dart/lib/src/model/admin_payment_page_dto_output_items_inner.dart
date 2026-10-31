//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_page_dto_output_items_inner.g.dart';

/// AdminPaymentPageDtoOutputItemsInner
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
@BuiltValue()
abstract class AdminPaymentPageDtoOutputItemsInner implements Built<AdminPaymentPageDtoOutputItemsInner, AdminPaymentPageDtoOutputItemsInnerBuilder> {
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
  AdminPaymentPageDtoOutputItemsInnerProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'status')
  AdminPaymentPageDtoOutputItemsInnerStatusEnum get status;
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

  AdminPaymentPageDtoOutputItemsInner._();

  factory AdminPaymentPageDtoOutputItemsInner([void updates(AdminPaymentPageDtoOutputItemsInnerBuilder b)]) = _$AdminPaymentPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentPageDtoOutputItemsInner> get serializer => _$AdminPaymentPageDtoOutputItemsInnerSerializer();
}

class _$AdminPaymentPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminPaymentPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminPaymentPageDtoOutputItemsInner, _$AdminPaymentPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminPaymentPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminPaymentPageDtoOutputItemsInnerProviderEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPaymentPageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPaymentPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminPaymentPageDtoOutputItemsInnerProviderEnum),
          ) as AdminPaymentPageDtoOutputItemsInnerProviderEnum;
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
            specifiedType: const FullType(AdminPaymentPageDtoOutputItemsInnerStatusEnum),
          ) as AdminPaymentPageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPaymentPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentPageDtoOutputItemsInnerBuilder();
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


class AdminPaymentPageDtoOutputItemsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const AdminPaymentPageDtoOutputItemsInnerProviderEnum VNPAY = _$adminPaymentPageDtoOutputItemsInnerProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const AdminPaymentPageDtoOutputItemsInnerProviderEnum MOMO = _$adminPaymentPageDtoOutputItemsInnerProviderEnum_MOMO;
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const AdminPaymentPageDtoOutputItemsInnerProviderEnum PAYOS = _$adminPaymentPageDtoOutputItemsInnerProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const AdminPaymentPageDtoOutputItemsInnerProviderEnum DEMO = _$adminPaymentPageDtoOutputItemsInnerProviderEnum_DEMO;

  static Serializer<AdminPaymentPageDtoOutputItemsInnerProviderEnum> get serializer => _$adminPaymentPageDtoOutputItemsInnerProviderEnumSerializer;

  const AdminPaymentPageDtoOutputItemsInnerProviderEnum._(String name): super(name);

  static BuiltSet<AdminPaymentPageDtoOutputItemsInnerProviderEnum> get values => _$adminPaymentPageDtoOutputItemsInnerProviderEnumValues;
  static AdminPaymentPageDtoOutputItemsInnerProviderEnum valueOf(String name) => _$adminPaymentPageDtoOutputItemsInnerProviderEnumValueOf(name);
}

class AdminPaymentPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum INITIATED = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum PROCESSING = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum SUCCESS = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum FAILED = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum EXPIRED = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum CANCELLED = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const AdminPaymentPageDtoOutputItemsInnerStatusEnum RECONCILING = _$adminPaymentPageDtoOutputItemsInnerStatusEnum_RECONCILING;

  static Serializer<AdminPaymentPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminPaymentPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminPaymentPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentPageDtoOutputItemsInnerStatusEnum> get values => _$adminPaymentPageDtoOutputItemsInnerStatusEnumValues;
  static AdminPaymentPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminPaymentPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

