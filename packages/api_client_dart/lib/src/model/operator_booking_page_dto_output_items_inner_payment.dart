//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_page_dto_output_items_inner_payment.g.dart';

/// OperatorBookingPageDtoOutputItemsInnerPayment
///
/// Properties:
/// * [provider] 
/// * [status] 
/// * [paidAt] 
@BuiltValue()
abstract class OperatorBookingPageDtoOutputItemsInnerPayment implements Built<OperatorBookingPageDtoOutputItemsInnerPayment, OperatorBookingPageDtoOutputItemsInnerPaymentBuilder> {
  @BuiltValueField(wireName: r'provider')
  OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'status')
  OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum get status;
  // enum statusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'paidAt')
  DateTime? get paidAt;

  OperatorBookingPageDtoOutputItemsInnerPayment._();

  factory OperatorBookingPageDtoOutputItemsInnerPayment([void updates(OperatorBookingPageDtoOutputItemsInnerPaymentBuilder b)]) = _$OperatorBookingPageDtoOutputItemsInnerPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingPageDtoOutputItemsInnerPaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingPageDtoOutputItemsInnerPayment> get serializer => _$OperatorBookingPageDtoOutputItemsInnerPaymentSerializer();
}

class _$OperatorBookingPageDtoOutputItemsInnerPaymentSerializer implements PrimitiveSerializer<OperatorBookingPageDtoOutputItemsInnerPayment> {
  @override
  final Iterable<Type> types = const [OperatorBookingPageDtoOutputItemsInnerPayment, _$OperatorBookingPageDtoOutputItemsInnerPayment];

  @override
  final String wireName = r'OperatorBookingPageDtoOutputItemsInnerPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingPageDtoOutputItemsInnerPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum),
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
    OperatorBookingPageDtoOutputItemsInnerPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingPageDtoOutputItemsInnerPaymentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum),
          ) as OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum;
          result.provider = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum),
          ) as OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum;
          result.status = valueDes;
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
  OperatorBookingPageDtoOutputItemsInnerPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingPageDtoOutputItemsInnerPaymentBuilder();
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


class OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum VNPAY = _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum MOMO = _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_MOMO;
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum PAYOS = _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum DEMO = _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_DEMO;

  static Serializer<OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum> get serializer => _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnumSerializer;

  const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum._(String name): super(name);

  static BuiltSet<OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum> get values => _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnumValues;
  static OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum valueOf(String name) => _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnumValueOf(name);
}

class OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum INITIATED = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum PROCESSING = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum SUCCESS = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum FAILED = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum EXPIRED = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum CANCELLED = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum RECONCILING = _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_RECONCILING;

  static Serializer<OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum> get serializer => _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnumSerializer;

  const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._(String name): super(name);

  static BuiltSet<OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum> get values => _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnumValues;
  static OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum valueOf(String name) => _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnumValueOf(name);
}

