//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_input_dto.g.dart';

/// PaymentInputDto
///
/// Properties:
/// * [provider] 
@BuiltValue()
abstract class PaymentInputDto implements Built<PaymentInputDto, PaymentInputDtoBuilder> {
  @BuiltValueField(wireName: r'provider')
  PaymentInputDtoProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  };

  PaymentInputDto._();

  factory PaymentInputDto([void updates(PaymentInputDtoBuilder b)]) = _$PaymentInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentInputDto> get serializer => _$PaymentInputDtoSerializer();
}

class _$PaymentInputDtoSerializer implements PrimitiveSerializer<PaymentInputDto> {
  @override
  final Iterable<Type> types = const [PaymentInputDto, _$PaymentInputDto];

  @override
  final String wireName = r'PaymentInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentInputDtoProviderEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentInputDtoProviderEnum),
          ) as PaymentInputDtoProviderEnum;
          result.provider = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentInputDtoBuilder();
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


class PaymentInputDtoProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const PaymentInputDtoProviderEnum VNPAY = _$paymentInputDtoProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const PaymentInputDtoProviderEnum MOMO = _$paymentInputDtoProviderEnum_MOMO;

  static Serializer<PaymentInputDtoProviderEnum> get serializer => _$paymentInputDtoProviderEnumSerializer;

  const PaymentInputDtoProviderEnum._(String name): super(name);

  static BuiltSet<PaymentInputDtoProviderEnum> get values => _$paymentInputDtoProviderEnumValues;
  static PaymentInputDtoProviderEnum valueOf(String name) => _$paymentInputDtoProviderEnumValueOf(name);
}

