//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_response_dto_output_transfer.g.dart';

/// PaymentResponseDtoOutputTransfer
///
/// Properties:
/// * [qrCode] 
/// * [bin] 
/// * [accountNumber] 
/// * [accountName] 
/// * [amount] 
/// * [description] 
/// * [paymentLinkId] 
@BuiltValue()
abstract class PaymentResponseDtoOutputTransfer implements Built<PaymentResponseDtoOutputTransfer, PaymentResponseDtoOutputTransferBuilder> {
  @BuiltValueField(wireName: r'qrCode')
  String get qrCode;

  @BuiltValueField(wireName: r'bin')
  String get bin;

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  @BuiltValueField(wireName: r'accountName')
  String get accountName;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'paymentLinkId')
  String get paymentLinkId;

  PaymentResponseDtoOutputTransfer._();

  factory PaymentResponseDtoOutputTransfer([void updates(PaymentResponseDtoOutputTransferBuilder b)]) = _$PaymentResponseDtoOutputTransfer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentResponseDtoOutputTransferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentResponseDtoOutputTransfer> get serializer => _$PaymentResponseDtoOutputTransferSerializer();
}

class _$PaymentResponseDtoOutputTransferSerializer implements PrimitiveSerializer<PaymentResponseDtoOutputTransfer> {
  @override
  final Iterable<Type> types = const [PaymentResponseDtoOutputTransfer, _$PaymentResponseDtoOutputTransfer];

  @override
  final String wireName = r'PaymentResponseDtoOutputTransfer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentResponseDtoOutputTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'qrCode';
    yield serializers.serialize(
      object.qrCode,
      specifiedType: const FullType(String),
    );
    yield r'bin';
    yield serializers.serialize(
      object.bin,
      specifiedType: const FullType(String),
    );
    yield r'accountNumber';
    yield serializers.serialize(
      object.accountNumber,
      specifiedType: const FullType(String),
    );
    yield r'accountName';
    yield serializers.serialize(
      object.accountName,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'paymentLinkId';
    yield serializers.serialize(
      object.paymentLinkId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentResponseDtoOutputTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentResponseDtoOutputTransferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'qrCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qrCode = valueDes;
          break;
        case r'bin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bin = valueDes;
          break;
        case r'accountNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNumber = valueDes;
          break;
        case r'accountName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountName = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'paymentLinkId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentLinkId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentResponseDtoOutputTransfer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentResponseDtoOutputTransferBuilder();
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


