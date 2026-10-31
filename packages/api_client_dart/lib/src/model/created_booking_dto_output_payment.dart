//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'created_booking_dto_output_payment.g.dart';

/// CreatedBookingDtoOutputPayment
///
/// Properties:
/// * [paymentCode] 
/// * [provider] 
/// * [status] 
/// * [amount] 
/// * [paidAt] 
@BuiltValue()
abstract class CreatedBookingDtoOutputPayment implements Built<CreatedBookingDtoOutputPayment, CreatedBookingDtoOutputPaymentBuilder> {
  @BuiltValueField(wireName: r'paymentCode')
  String get paymentCode;

  @BuiltValueField(wireName: r'provider')
  CreatedBookingDtoOutputPaymentProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'status')
  CreatedBookingDtoOutputPaymentStatusEnum get status;
  // enum statusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'paidAt')
  DateTime? get paidAt;

  CreatedBookingDtoOutputPayment._();

  factory CreatedBookingDtoOutputPayment([void updates(CreatedBookingDtoOutputPaymentBuilder b)]) = _$CreatedBookingDtoOutputPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputPaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutputPayment> get serializer => _$CreatedBookingDtoOutputPaymentSerializer();
}

class _$CreatedBookingDtoOutputPaymentSerializer implements PrimitiveSerializer<CreatedBookingDtoOutputPayment> {
  @override
  final Iterable<Type> types = const [CreatedBookingDtoOutputPayment, _$CreatedBookingDtoOutputPayment];

  @override
  final String wireName = r'CreatedBookingDtoOutputPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutputPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentCode';
    yield serializers.serialize(
      object.paymentCode,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(CreatedBookingDtoOutputPaymentProviderEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CreatedBookingDtoOutputPaymentStatusEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
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
    CreatedBookingDtoOutputPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputPaymentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(CreatedBookingDtoOutputPaymentProviderEnum),
          ) as CreatedBookingDtoOutputPaymentProviderEnum;
          result.provider = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatedBookingDtoOutputPaymentStatusEnum),
          ) as CreatedBookingDtoOutputPaymentStatusEnum;
          result.status = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
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
  CreatedBookingDtoOutputPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputPaymentBuilder();
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


class CreatedBookingDtoOutputPaymentProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const CreatedBookingDtoOutputPaymentProviderEnum VNPAY = _$createdBookingDtoOutputPaymentProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const CreatedBookingDtoOutputPaymentProviderEnum MOMO = _$createdBookingDtoOutputPaymentProviderEnum_MOMO;
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const CreatedBookingDtoOutputPaymentProviderEnum PAYOS = _$createdBookingDtoOutputPaymentProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const CreatedBookingDtoOutputPaymentProviderEnum DEMO = _$createdBookingDtoOutputPaymentProviderEnum_DEMO;

  static Serializer<CreatedBookingDtoOutputPaymentProviderEnum> get serializer => _$createdBookingDtoOutputPaymentProviderEnumSerializer;

  const CreatedBookingDtoOutputPaymentProviderEnum._(String name): super(name);

  static BuiltSet<CreatedBookingDtoOutputPaymentProviderEnum> get values => _$createdBookingDtoOutputPaymentProviderEnumValues;
  static CreatedBookingDtoOutputPaymentProviderEnum valueOf(String name) => _$createdBookingDtoOutputPaymentProviderEnumValueOf(name);
}

class CreatedBookingDtoOutputPaymentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const CreatedBookingDtoOutputPaymentStatusEnum INITIATED = _$createdBookingDtoOutputPaymentStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const CreatedBookingDtoOutputPaymentStatusEnum PROCESSING = _$createdBookingDtoOutputPaymentStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const CreatedBookingDtoOutputPaymentStatusEnum SUCCESS = _$createdBookingDtoOutputPaymentStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const CreatedBookingDtoOutputPaymentStatusEnum FAILED = _$createdBookingDtoOutputPaymentStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CreatedBookingDtoOutputPaymentStatusEnum EXPIRED = _$createdBookingDtoOutputPaymentStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CreatedBookingDtoOutputPaymentStatusEnum CANCELLED = _$createdBookingDtoOutputPaymentStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const CreatedBookingDtoOutputPaymentStatusEnum RECONCILING = _$createdBookingDtoOutputPaymentStatusEnum_RECONCILING;

  static Serializer<CreatedBookingDtoOutputPaymentStatusEnum> get serializer => _$createdBookingDtoOutputPaymentStatusEnumSerializer;

  const CreatedBookingDtoOutputPaymentStatusEnum._(String name): super(name);

  static BuiltSet<CreatedBookingDtoOutputPaymentStatusEnum> get values => _$createdBookingDtoOutputPaymentStatusEnumValues;
  static CreatedBookingDtoOutputPaymentStatusEnum valueOf(String name) => _$createdBookingDtoOutputPaymentStatusEnumValueOf(name);
}

