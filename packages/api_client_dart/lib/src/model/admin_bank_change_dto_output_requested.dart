//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bank_change_dto_output_requested.g.dart';

/// AdminBankChangeDtoOutputRequested
///
/// Properties:
/// * [bankName] 
/// * [accountNumber] 
/// * [accountHolder] 
/// * [reason] 
/// * [requestedAt] 
/// * [requestedBy] 
@BuiltValue()
abstract class AdminBankChangeDtoOutputRequested implements Built<AdminBankChangeDtoOutputRequested, AdminBankChangeDtoOutputRequestedBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'requestedAt')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'requestedBy')
  String? get requestedBy;

  AdminBankChangeDtoOutputRequested._();

  factory AdminBankChangeDtoOutputRequested([void updates(AdminBankChangeDtoOutputRequestedBuilder b)]) = _$AdminBankChangeDtoOutputRequested;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBankChangeDtoOutputRequestedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBankChangeDtoOutputRequested> get serializer => _$AdminBankChangeDtoOutputRequestedSerializer();
}

class _$AdminBankChangeDtoOutputRequestedSerializer implements PrimitiveSerializer<AdminBankChangeDtoOutputRequested> {
  @override
  final Iterable<Type> types = const [AdminBankChangeDtoOutputRequested, _$AdminBankChangeDtoOutputRequested];

  @override
  final String wireName = r'AdminBankChangeDtoOutputRequested';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBankChangeDtoOutputRequested object, {
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
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'requestedAt';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'requestedBy';
    yield object.requestedBy == null ? null : serializers.serialize(
      object.requestedBy,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBankChangeDtoOutputRequested object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminBankChangeDtoOutputRequestedBuilder result,
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
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'requestedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'requestedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.requestedBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBankChangeDtoOutputRequested deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBankChangeDtoOutputRequestedBuilder();
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


