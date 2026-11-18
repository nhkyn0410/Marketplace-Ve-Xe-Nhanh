//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_provider_list_dto_output_items_inner.g.dart';

/// PaymentProviderListDtoOutputItemsInner
///
/// Properties:
/// * [provider] 
/// * [enabled] 
@BuiltValue()
abstract class PaymentProviderListDtoOutputItemsInner implements Built<PaymentProviderListDtoOutputItemsInner, PaymentProviderListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'provider')
  PaymentProviderListDtoOutputItemsInnerProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  PaymentProviderListDtoOutputItemsInner._();

  factory PaymentProviderListDtoOutputItemsInner([void updates(PaymentProviderListDtoOutputItemsInnerBuilder b)]) = _$PaymentProviderListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentProviderListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentProviderListDtoOutputItemsInner> get serializer => _$PaymentProviderListDtoOutputItemsInnerSerializer();
}

class _$PaymentProviderListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PaymentProviderListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PaymentProviderListDtoOutputItemsInner, _$PaymentProviderListDtoOutputItemsInner];

  @override
  final String wireName = r'PaymentProviderListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentProviderListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentProviderListDtoOutputItemsInnerProviderEnum),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentProviderListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentProviderListDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentProviderListDtoOutputItemsInnerProviderEnum),
          ) as PaymentProviderListDtoOutputItemsInnerProviderEnum;
          result.provider = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentProviderListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentProviderListDtoOutputItemsInnerBuilder();
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


class PaymentProviderListDtoOutputItemsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const PaymentProviderListDtoOutputItemsInnerProviderEnum VNPAY = _$paymentProviderListDtoOutputItemsInnerProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const PaymentProviderListDtoOutputItemsInnerProviderEnum MOMO = _$paymentProviderListDtoOutputItemsInnerProviderEnum_MOMO;
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const PaymentProviderListDtoOutputItemsInnerProviderEnum PAYOS = _$paymentProviderListDtoOutputItemsInnerProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const PaymentProviderListDtoOutputItemsInnerProviderEnum DEMO = _$paymentProviderListDtoOutputItemsInnerProviderEnum_DEMO;

  static Serializer<PaymentProviderListDtoOutputItemsInnerProviderEnum> get serializer => _$paymentProviderListDtoOutputItemsInnerProviderEnumSerializer;

  const PaymentProviderListDtoOutputItemsInnerProviderEnum._(String name): super(name);

  static BuiltSet<PaymentProviderListDtoOutputItemsInnerProviderEnum> get values => _$paymentProviderListDtoOutputItemsInnerProviderEnumValues;
  static PaymentProviderListDtoOutputItemsInnerProviderEnum valueOf(String name) => _$paymentProviderListDtoOutputItemsInnerProviderEnumValueOf(name);
}

