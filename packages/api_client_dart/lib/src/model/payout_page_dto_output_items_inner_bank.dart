//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_page_dto_output_items_inner_bank.g.dart';

/// PayoutPageDtoOutputItemsInnerBank
///
/// Properties:
/// * [bankName] 
/// * [accountNumberMasked] 
/// * [accountHolder] 
@BuiltValue()
abstract class PayoutPageDtoOutputItemsInnerBank implements Built<PayoutPageDtoOutputItemsInnerBank, PayoutPageDtoOutputItemsInnerBankBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumberMasked')
  String get accountNumberMasked;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  PayoutPageDtoOutputItemsInnerBank._();

  factory PayoutPageDtoOutputItemsInnerBank([void updates(PayoutPageDtoOutputItemsInnerBankBuilder b)]) = _$PayoutPageDtoOutputItemsInnerBank;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutPageDtoOutputItemsInnerBankBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutPageDtoOutputItemsInnerBank> get serializer => _$PayoutPageDtoOutputItemsInnerBankSerializer();
}

class _$PayoutPageDtoOutputItemsInnerBankSerializer implements PrimitiveSerializer<PayoutPageDtoOutputItemsInnerBank> {
  @override
  final Iterable<Type> types = const [PayoutPageDtoOutputItemsInnerBank, _$PayoutPageDtoOutputItemsInnerBank];

  @override
  final String wireName = r'PayoutPageDtoOutputItemsInnerBank';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutPageDtoOutputItemsInnerBank object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bankName';
    yield serializers.serialize(
      object.bankName,
      specifiedType: const FullType(String),
    );
    yield r'accountNumberMasked';
    yield serializers.serialize(
      object.accountNumberMasked,
      specifiedType: const FullType(String),
    );
    yield r'accountHolder';
    yield serializers.serialize(
      object.accountHolder,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutPageDtoOutputItemsInnerBank object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutPageDtoOutputItemsInnerBankBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bankName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bankName = valueDes;
          break;
        case r'accountNumberMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNumberMasked = valueDes;
          break;
        case r'accountHolder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountHolder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutPageDtoOutputItemsInnerBank deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutPageDtoOutputItemsInnerBankBuilder();
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


