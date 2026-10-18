//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_bank_account_dto_output.g.dart';

/// PayoutBankAccountDtoOutput
///
/// Properties:
/// * [bankName] 
/// * [accountNumber] 
/// * [accountHolder] 
@BuiltValue()
abstract class PayoutBankAccountDtoOutput implements Built<PayoutBankAccountDtoOutput, PayoutBankAccountDtoOutputBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  PayoutBankAccountDtoOutput._();

  factory PayoutBankAccountDtoOutput([void updates(PayoutBankAccountDtoOutputBuilder b)]) = _$PayoutBankAccountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutBankAccountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutBankAccountDtoOutput> get serializer => _$PayoutBankAccountDtoOutputSerializer();
}

class _$PayoutBankAccountDtoOutputSerializer implements PrimitiveSerializer<PayoutBankAccountDtoOutput> {
  @override
  final Iterable<Type> types = const [PayoutBankAccountDtoOutput, _$PayoutBankAccountDtoOutput];

  @override
  final String wireName = r'PayoutBankAccountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutBankAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bankName';
    yield serializers.serialize(
      object.bankName,
      specifiedType: const FullType(String),
    );
    yield r'accountNumber';
    yield serializers.serialize(
      object.accountNumber,
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
    PayoutBankAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutBankAccountDtoOutputBuilder result,
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
        case r'accountNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNumber = valueDes;
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
  PayoutBankAccountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutBankAccountDtoOutputBuilder();
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


