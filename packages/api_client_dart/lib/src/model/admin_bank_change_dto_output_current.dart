//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bank_change_dto_output_current.g.dart';

/// AdminBankChangeDtoOutputCurrent
///
/// Properties:
/// * [bankName] 
/// * [accountNumber] 
/// * [accountHolder] 
/// * [verifiedAt] 
@BuiltValue()
abstract class AdminBankChangeDtoOutputCurrent implements Built<AdminBankChangeDtoOutputCurrent, AdminBankChangeDtoOutputCurrentBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  @BuiltValueField(wireName: r'verifiedAt')
  DateTime? get verifiedAt;

  AdminBankChangeDtoOutputCurrent._();

  factory AdminBankChangeDtoOutputCurrent([void updates(AdminBankChangeDtoOutputCurrentBuilder b)]) = _$AdminBankChangeDtoOutputCurrent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBankChangeDtoOutputCurrentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBankChangeDtoOutputCurrent> get serializer => _$AdminBankChangeDtoOutputCurrentSerializer();
}

class _$AdminBankChangeDtoOutputCurrentSerializer implements PrimitiveSerializer<AdminBankChangeDtoOutputCurrent> {
  @override
  final Iterable<Type> types = const [AdminBankChangeDtoOutputCurrent, _$AdminBankChangeDtoOutputCurrent];

  @override
  final String wireName = r'AdminBankChangeDtoOutputCurrent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBankChangeDtoOutputCurrent object, {
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
    AdminBankChangeDtoOutputCurrent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminBankChangeDtoOutputCurrentBuilder result,
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
  AdminBankChangeDtoOutputCurrent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBankChangeDtoOutputCurrentBuilder();
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


