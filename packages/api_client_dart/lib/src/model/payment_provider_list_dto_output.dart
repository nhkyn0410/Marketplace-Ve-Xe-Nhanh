//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/payment_provider_list_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_provider_list_dto_output.g.dart';

/// PaymentProviderListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class PaymentProviderListDtoOutput implements Built<PaymentProviderListDtoOutput, PaymentProviderListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PaymentProviderListDtoOutputItemsInner> get items;

  PaymentProviderListDtoOutput._();

  factory PaymentProviderListDtoOutput([void updates(PaymentProviderListDtoOutputBuilder b)]) = _$PaymentProviderListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentProviderListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentProviderListDtoOutput> get serializer => _$PaymentProviderListDtoOutputSerializer();
}

class _$PaymentProviderListDtoOutputSerializer implements PrimitiveSerializer<PaymentProviderListDtoOutput> {
  @override
  final Iterable<Type> types = const [PaymentProviderListDtoOutput, _$PaymentProviderListDtoOutput];

  @override
  final String wireName = r'PaymentProviderListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentProviderListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PaymentProviderListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentProviderListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentProviderListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentProviderListDtoOutputItemsInner)]),
          ) as BuiltList<PaymentProviderListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentProviderListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentProviderListDtoOutputBuilder();
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


