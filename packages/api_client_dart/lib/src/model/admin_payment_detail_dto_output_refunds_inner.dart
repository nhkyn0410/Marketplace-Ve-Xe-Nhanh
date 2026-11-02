//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output_refunds_inner.g.dart';

/// AdminPaymentDetailDtoOutputRefundsInner
///
/// Properties:
/// * [refundId] 
/// * [refundCode] 
/// * [status] 
/// * [amount] 
/// * [createdAt] 
@BuiltValue()
abstract class AdminPaymentDetailDtoOutputRefundsInner implements Built<AdminPaymentDetailDtoOutputRefundsInner, AdminPaymentDetailDtoOutputRefundsInnerBuilder> {
  @BuiltValueField(wireName: r'refundId')
  String get refundId;

  @BuiltValueField(wireName: r'refundCode')
  String get refundCode;

  @BuiltValueField(wireName: r'status')
  AdminPaymentDetailDtoOutputRefundsInnerStatusEnum get status;
  // enum statusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminPaymentDetailDtoOutputRefundsInner._();

  factory AdminPaymentDetailDtoOutputRefundsInner([void updates(AdminPaymentDetailDtoOutputRefundsInnerBuilder b)]) = _$AdminPaymentDetailDtoOutputRefundsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputRefundsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutputRefundsInner> get serializer => _$AdminPaymentDetailDtoOutputRefundsInnerSerializer();
}

class _$AdminPaymentDetailDtoOutputRefundsInnerSerializer implements PrimitiveSerializer<AdminPaymentDetailDtoOutputRefundsInner> {
  @override
  final Iterable<Type> types = const [AdminPaymentDetailDtoOutputRefundsInner, _$AdminPaymentDetailDtoOutputRefundsInner];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutputRefundsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutputRefundsInner object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputRefundsInnerStatusEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
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
    AdminPaymentDetailDtoOutputRefundsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentDetailDtoOutputRefundsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputRefundsInnerStatusEnum),
          ) as AdminPaymentDetailDtoOutputRefundsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
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
  AdminPaymentDetailDtoOutputRefundsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputRefundsInnerBuilder();
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


class AdminPaymentDetailDtoOutputRefundsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum REQUESTED = _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum APPROVED = _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum PROCESSING = _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum SUCCESS = _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum FAILED = _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum REJECTED = _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REJECTED;

  static Serializer<AdminPaymentDetailDtoOutputRefundsInnerStatusEnum> get serializer => _$adminPaymentDetailDtoOutputRefundsInnerStatusEnumSerializer;

  const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputRefundsInnerStatusEnum> get values => _$adminPaymentDetailDtoOutputRefundsInnerStatusEnumValues;
  static AdminPaymentDetailDtoOutputRefundsInnerStatusEnum valueOf(String name) => _$adminPaymentDetailDtoOutputRefundsInnerStatusEnumValueOf(name);
}

