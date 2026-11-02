//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_profile_response_dto_output_bank_account.g.dart';

/// OperatorProfileResponseDtoOutputBankAccount
///
/// Properties:
/// * [bankName] 
/// * [accountNumberMasked] 
/// * [accountHolder] 
/// * [verifiedAt] 
@BuiltValue()
abstract class OperatorProfileResponseDtoOutputBankAccount implements Built<OperatorProfileResponseDtoOutputBankAccount, OperatorProfileResponseDtoOutputBankAccountBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumberMasked')
  String get accountNumberMasked;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  @BuiltValueField(wireName: r'verifiedAt')
  DateTime? get verifiedAt;

  OperatorProfileResponseDtoOutputBankAccount._();

  factory OperatorProfileResponseDtoOutputBankAccount([void updates(OperatorProfileResponseDtoOutputBankAccountBuilder b)]) = _$OperatorProfileResponseDtoOutputBankAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorProfileResponseDtoOutputBankAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorProfileResponseDtoOutputBankAccount> get serializer => _$OperatorProfileResponseDtoOutputBankAccountSerializer();
}

class _$OperatorProfileResponseDtoOutputBankAccountSerializer implements PrimitiveSerializer<OperatorProfileResponseDtoOutputBankAccount> {
  @override
  final Iterable<Type> types = const [OperatorProfileResponseDtoOutputBankAccount, _$OperatorProfileResponseDtoOutputBankAccount];

  @override
  final String wireName = r'OperatorProfileResponseDtoOutputBankAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorProfileResponseDtoOutputBankAccount object, {
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
    yield r'verifiedAt';
    yield object.verifiedAt == null ? null : serializers.serialize(
      object.verifiedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorProfileResponseDtoOutputBankAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorProfileResponseDtoOutputBankAccountBuilder result,
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
        case r'verifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.verifiedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorProfileResponseDtoOutputBankAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorProfileResponseDtoOutputBankAccountBuilder();
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


