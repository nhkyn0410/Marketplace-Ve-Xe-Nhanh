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
/// * [client] 
@BuiltValue()
abstract class PaymentInputDto implements Built<PaymentInputDto, PaymentInputDtoBuilder> {
  @BuiltValueField(wireName: r'provider')
  PaymentInputDtoProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'client')
  PaymentInputDtoClientEnum? get client;
  // enum clientEnum {  WEB,  APP,  };

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
    if (object.client != null) {
      yield r'client';
      yield serializers.serialize(
        object.client,
        specifiedType: const FullType(PaymentInputDtoClientEnum),
      );
    }
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
        case r'client':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PaymentInputDtoClientEnum),
          ) as PaymentInputDtoClientEnum?;
          if (valueDes == null) continue;
          result.client = valueDes;
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
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const PaymentInputDtoProviderEnum PAYOS = _$paymentInputDtoProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const PaymentInputDtoProviderEnum DEMO = _$paymentInputDtoProviderEnum_DEMO;

  static Serializer<PaymentInputDtoProviderEnum> get serializer => _$paymentInputDtoProviderEnumSerializer;

  const PaymentInputDtoProviderEnum._(String name): super(name);

  static BuiltSet<PaymentInputDtoProviderEnum> get values => _$paymentInputDtoProviderEnumValues;
  static PaymentInputDtoProviderEnum valueOf(String name) => _$paymentInputDtoProviderEnumValueOf(name);
}

class PaymentInputDtoClientEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WEB')
  static const PaymentInputDtoClientEnum WEB = _$paymentInputDtoClientEnum_WEB;
  @BuiltValueEnumConst(wireName: r'APP')
  static const PaymentInputDtoClientEnum APP = _$paymentInputDtoClientEnum_APP;

  static Serializer<PaymentInputDtoClientEnum> get serializer => _$paymentInputDtoClientEnumSerializer;

  const PaymentInputDtoClientEnum._(String name): super(name);

  static BuiltSet<PaymentInputDtoClientEnum> get values => _$paymentInputDtoClientEnumValues;
  static PaymentInputDtoClientEnum valueOf(String name) => _$paymentInputDtoClientEnumValueOf(name);
}

