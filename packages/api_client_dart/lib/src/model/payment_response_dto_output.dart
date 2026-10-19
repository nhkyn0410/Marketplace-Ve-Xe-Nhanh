//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_response_dto_output.g.dart';

/// PaymentResponseDtoOutput
///
/// Properties:
/// * [paymentId] 
/// * [paymentCode] 
/// * [provider] 
/// * [status] 
/// * [amount] 
/// * [paymentUrl] 
/// * [expiresAt] 
@BuiltValue()
abstract class PaymentResponseDtoOutput implements Built<PaymentResponseDtoOutput, PaymentResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'paymentCode')
  String get paymentCode;

  @BuiltValueField(wireName: r'provider')
  PaymentResponseDtoOutputProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  };

  @BuiltValueField(wireName: r'status')
  PaymentResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'paymentUrl')
  String get paymentUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  PaymentResponseDtoOutput._();

  factory PaymentResponseDtoOutput([void updates(PaymentResponseDtoOutputBuilder b)]) = _$PaymentResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentResponseDtoOutput> get serializer => _$PaymentResponseDtoOutputSerializer();
}

class _$PaymentResponseDtoOutputSerializer implements PrimitiveSerializer<PaymentResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [PaymentResponseDtoOutput, _$PaymentResponseDtoOutput];

  @override
  final String wireName = r'PaymentResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentResponseDtoOutput object, {
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
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentResponseDtoOutputProviderEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PaymentResponseDtoOutputStatusEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'paymentUrl';
    yield serializers.serialize(
      object.paymentUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentResponseDtoOutputBuilder result,
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
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentResponseDtoOutputProviderEnum),
          ) as PaymentResponseDtoOutputProviderEnum;
          result.provider = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentResponseDtoOutputStatusEnum),
          ) as PaymentResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'paymentUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentResponseDtoOutputBuilder();
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


class PaymentResponseDtoOutputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const PaymentResponseDtoOutputProviderEnum VNPAY = _$paymentResponseDtoOutputProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const PaymentResponseDtoOutputProviderEnum MOMO = _$paymentResponseDtoOutputProviderEnum_MOMO;

  static Serializer<PaymentResponseDtoOutputProviderEnum> get serializer => _$paymentResponseDtoOutputProviderEnumSerializer;

  const PaymentResponseDtoOutputProviderEnum._(String name): super(name);

  static BuiltSet<PaymentResponseDtoOutputProviderEnum> get values => _$paymentResponseDtoOutputProviderEnumValues;
  static PaymentResponseDtoOutputProviderEnum valueOf(String name) => _$paymentResponseDtoOutputProviderEnumValueOf(name);
}

class PaymentResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const PaymentResponseDtoOutputStatusEnum INITIATED = _$paymentResponseDtoOutputStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const PaymentResponseDtoOutputStatusEnum PROCESSING = _$paymentResponseDtoOutputStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const PaymentResponseDtoOutputStatusEnum SUCCESS = _$paymentResponseDtoOutputStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const PaymentResponseDtoOutputStatusEnum FAILED = _$paymentResponseDtoOutputStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const PaymentResponseDtoOutputStatusEnum EXPIRED = _$paymentResponseDtoOutputStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PaymentResponseDtoOutputStatusEnum CANCELLED = _$paymentResponseDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const PaymentResponseDtoOutputStatusEnum RECONCILING = _$paymentResponseDtoOutputStatusEnum_RECONCILING;

  static Serializer<PaymentResponseDtoOutputStatusEnum> get serializer => _$paymentResponseDtoOutputStatusEnumSerializer;

  const PaymentResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<PaymentResponseDtoOutputStatusEnum> get values => _$paymentResponseDtoOutputStatusEnumValues;
  static PaymentResponseDtoOutputStatusEnum valueOf(String name) => _$paymentResponseDtoOutputStatusEnumValueOf(name);
}

