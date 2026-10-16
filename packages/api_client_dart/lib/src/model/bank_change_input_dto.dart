//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bank_change_input_dto.g.dart';

/// BankChangeInputDto
///
/// Properties:
/// * [bankName] 
/// * [accountNumber] 
/// * [accountHolder] 
/// * [reason] 
@BuiltValue()
abstract class BankChangeInputDto implements Built<BankChangeInputDto, BankChangeInputDtoBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  BankChangeInputDto._();

  factory BankChangeInputDto([void updates(BankChangeInputDtoBuilder b)]) = _$BankChangeInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BankChangeInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BankChangeInputDto> get serializer => _$BankChangeInputDtoSerializer();
}

class _$BankChangeInputDtoSerializer implements PrimitiveSerializer<BankChangeInputDto> {
  @override
  final Iterable<Type> types = const [BankChangeInputDto, _$BankChangeInputDto];

  @override
  final String wireName = r'BankChangeInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BankChangeInputDto object, {
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
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BankChangeInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BankChangeInputDtoBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BankChangeInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BankChangeInputDtoBuilder();
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


