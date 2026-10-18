//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_refund_page_dto_output_items_inner.g.dart';

/// AdminRefundPageDtoOutputItemsInner
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
@BuiltValue()
abstract class AdminRefundPageDtoOutputItemsInner implements Built<AdminRefundPageDtoOutputItemsInner, AdminRefundPageDtoOutputItemsInnerBuilder> {
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
  AdminRefundPageDtoOutputItemsInnerProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  };

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'source')
  AdminRefundPageDtoOutputItemsInnerSource_Enum get source_;
  // enum source_Enum {  CUSTOMER,  PLATFORM,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'refundPercent')
  int get refundPercent;

  @BuiltValueField(wireName: r'status')
  AdminRefundPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  @BuiltValueField(wireName: r'failureCode')
  String? get failureCode;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AdminRefundPageDtoOutputItemsInner._();

  factory AdminRefundPageDtoOutputItemsInner([void updates(AdminRefundPageDtoOutputItemsInnerBuilder b)]) = _$AdminRefundPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRefundPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRefundPageDtoOutputItemsInner> get serializer => _$AdminRefundPageDtoOutputItemsInnerSerializer();
}

class _$AdminRefundPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminRefundPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminRefundPageDtoOutputItemsInner, _$AdminRefundPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminRefundPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRefundPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminRefundPageDtoOutputItemsInnerProviderEnum),
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
      specifiedType: const FullType(AdminRefundPageDtoOutputItemsInnerSource_Enum),
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
      specifiedType: const FullType(AdminRefundPageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRefundPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRefundPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminRefundPageDtoOutputItemsInnerProviderEnum),
          ) as AdminRefundPageDtoOutputItemsInnerProviderEnum;
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
            specifiedType: const FullType(AdminRefundPageDtoOutputItemsInnerSource_Enum),
          ) as AdminRefundPageDtoOutputItemsInnerSource_Enum;
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
            specifiedType: const FullType(AdminRefundPageDtoOutputItemsInnerStatusEnum),
          ) as AdminRefundPageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRefundPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRefundPageDtoOutputItemsInnerBuilder();
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


class AdminRefundPageDtoOutputItemsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const AdminRefundPageDtoOutputItemsInnerProviderEnum VNPAY = _$adminRefundPageDtoOutputItemsInnerProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const AdminRefundPageDtoOutputItemsInnerProviderEnum MOMO = _$adminRefundPageDtoOutputItemsInnerProviderEnum_MOMO;

  static Serializer<AdminRefundPageDtoOutputItemsInnerProviderEnum> get serializer => _$adminRefundPageDtoOutputItemsInnerProviderEnumSerializer;

  const AdminRefundPageDtoOutputItemsInnerProviderEnum._(String name): super(name);

  static BuiltSet<AdminRefundPageDtoOutputItemsInnerProviderEnum> get values => _$adminRefundPageDtoOutputItemsInnerProviderEnumValues;
  static AdminRefundPageDtoOutputItemsInnerProviderEnum valueOf(String name) => _$adminRefundPageDtoOutputItemsInnerProviderEnumValueOf(name);
}

class AdminRefundPageDtoOutputItemsInnerSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CUSTOMER')
  static const AdminRefundPageDtoOutputItemsInnerSource_Enum CUSTOMER = _$adminRefundPageDtoOutputItemsInnerSourceEnum_CUSTOMER;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const AdminRefundPageDtoOutputItemsInnerSource_Enum PLATFORM = _$adminRefundPageDtoOutputItemsInnerSourceEnum_PLATFORM;

  static Serializer<AdminRefundPageDtoOutputItemsInnerSource_Enum> get serializer => _$adminRefundPageDtoOutputItemsInnerSourceEnumSerializer;

  const AdminRefundPageDtoOutputItemsInnerSource_Enum._(String name): super(name);

  static BuiltSet<AdminRefundPageDtoOutputItemsInnerSource_Enum> get values => _$adminRefundPageDtoOutputItemsInnerSourceEnumValues;
  static AdminRefundPageDtoOutputItemsInnerSource_Enum valueOf(String name) => _$adminRefundPageDtoOutputItemsInnerSourceEnumValueOf(name);
}

class AdminRefundPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const AdminRefundPageDtoOutputItemsInnerStatusEnum REQUESTED = _$adminRefundPageDtoOutputItemsInnerStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminRefundPageDtoOutputItemsInnerStatusEnum APPROVED = _$adminRefundPageDtoOutputItemsInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminRefundPageDtoOutputItemsInnerStatusEnum PROCESSING = _$adminRefundPageDtoOutputItemsInnerStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminRefundPageDtoOutputItemsInnerStatusEnum SUCCESS = _$adminRefundPageDtoOutputItemsInnerStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminRefundPageDtoOutputItemsInnerStatusEnum FAILED = _$adminRefundPageDtoOutputItemsInnerStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminRefundPageDtoOutputItemsInnerStatusEnum REJECTED = _$adminRefundPageDtoOutputItemsInnerStatusEnum_REJECTED;

  static Serializer<AdminRefundPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminRefundPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminRefundPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminRefundPageDtoOutputItemsInnerStatusEnum> get values => _$adminRefundPageDtoOutputItemsInnerStatusEnumValues;
  static AdminRefundPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminRefundPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

