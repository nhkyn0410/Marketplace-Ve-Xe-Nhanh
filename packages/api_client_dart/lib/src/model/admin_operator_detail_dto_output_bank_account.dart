//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_detail_dto_output_bank_account.g.dart';

/// AdminOperatorDetailDtoOutputBankAccount
///
/// Properties:
/// * [bankName] 
/// * [accountNumber] 
/// * [accountHolder] 
/// * [verifiedAt] 
@BuiltValue()
abstract class AdminOperatorDetailDtoOutputBankAccount implements Built<AdminOperatorDetailDtoOutputBankAccount, AdminOperatorDetailDtoOutputBankAccountBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  @BuiltValueField(wireName: r'verifiedAt')
  DateTime? get verifiedAt;

  AdminOperatorDetailDtoOutputBankAccount._();

  factory AdminOperatorDetailDtoOutputBankAccount([void updates(AdminOperatorDetailDtoOutputBankAccountBuilder b)]) = _$AdminOperatorDetailDtoOutputBankAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorDetailDtoOutputBankAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorDetailDtoOutputBankAccount> get serializer => _$AdminOperatorDetailDtoOutputBankAccountSerializer();
}

class _$AdminOperatorDetailDtoOutputBankAccountSerializer implements PrimitiveSerializer<AdminOperatorDetailDtoOutputBankAccount> {
  @override
  final Iterable<Type> types = const [AdminOperatorDetailDtoOutputBankAccount, _$AdminOperatorDetailDtoOutputBankAccount];

  @override
  final String wireName = r'AdminOperatorDetailDtoOutputBankAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorDetailDtoOutputBankAccount object, {
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
    yield r'verifiedAt';
    yield object.verifiedAt == null ? null : serializers.serialize(
      object.verifiedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorDetailDtoOutputBankAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorDetailDtoOutputBankAccountBuilder result,
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
  AdminOperatorDetailDtoOutputBankAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorDetailDtoOutputBankAccountBuilder();
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


