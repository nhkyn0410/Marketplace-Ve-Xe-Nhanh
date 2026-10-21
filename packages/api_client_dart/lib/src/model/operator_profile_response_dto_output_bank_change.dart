//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_profile_response_dto_output_bank_change.g.dart';

/// OperatorProfileResponseDtoOutputBankChange
///
/// Properties:
/// * [status] 
/// * [bankName] 
/// * [accountNumberMasked] 
/// * [accountHolder] 
/// * [reason] 
/// * [reviewNote] 
/// * [requestedAt] 
/// * [reviewedAt] 
@BuiltValue()
abstract class OperatorProfileResponseDtoOutputBankChange implements Built<OperatorProfileResponseDtoOutputBankChange, OperatorProfileResponseDtoOutputBankChangeBuilder> {
  @BuiltValueField(wireName: r'status')
  OperatorProfileResponseDtoOutputBankChangeStatusEnum get status;
  // enum statusEnum {  PENDING,  REJECTED,  };

  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'accountNumberMasked')
  String get accountNumberMasked;

  @BuiltValueField(wireName: r'accountHolder')
  String get accountHolder;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'reviewNote')
  String? get reviewNote;

  @BuiltValueField(wireName: r'requestedAt')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime? get reviewedAt;

  OperatorProfileResponseDtoOutputBankChange._();

  factory OperatorProfileResponseDtoOutputBankChange([void updates(OperatorProfileResponseDtoOutputBankChangeBuilder b)]) = _$OperatorProfileResponseDtoOutputBankChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorProfileResponseDtoOutputBankChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorProfileResponseDtoOutputBankChange> get serializer => _$OperatorProfileResponseDtoOutputBankChangeSerializer();
}

class _$OperatorProfileResponseDtoOutputBankChangeSerializer implements PrimitiveSerializer<OperatorProfileResponseDtoOutputBankChange> {
  @override
  final Iterable<Type> types = const [OperatorProfileResponseDtoOutputBankChange, _$OperatorProfileResponseDtoOutputBankChange];

  @override
  final String wireName = r'OperatorProfileResponseDtoOutputBankChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorProfileResponseDtoOutputBankChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OperatorProfileResponseDtoOutputBankChangeStatusEnum),
    );
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
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reviewNote';
    yield object.reviewNote == null ? null : serializers.serialize(
      object.reviewNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'requestedAt';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reviewedAt';
    yield object.reviewedAt == null ? null : serializers.serialize(
      object.reviewedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorProfileResponseDtoOutputBankChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorProfileResponseDtoOutputBankChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorProfileResponseDtoOutputBankChangeStatusEnum),
          ) as OperatorProfileResponseDtoOutputBankChangeStatusEnum;
          result.status = valueDes;
          break;
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
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'reviewNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewNote = valueDes;
          break;
        case r'requestedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'reviewedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorProfileResponseDtoOutputBankChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorProfileResponseDtoOutputBankChangeBuilder();
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


class OperatorProfileResponseDtoOutputBankChangeStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const OperatorProfileResponseDtoOutputBankChangeStatusEnum PENDING = _$operatorProfileResponseDtoOutputBankChangeStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const OperatorProfileResponseDtoOutputBankChangeStatusEnum REJECTED = _$operatorProfileResponseDtoOutputBankChangeStatusEnum_REJECTED;

  static Serializer<OperatorProfileResponseDtoOutputBankChangeStatusEnum> get serializer => _$operatorProfileResponseDtoOutputBankChangeStatusEnumSerializer;

  const OperatorProfileResponseDtoOutputBankChangeStatusEnum._(String name): super(name);

  static BuiltSet<OperatorProfileResponseDtoOutputBankChangeStatusEnum> get values => _$operatorProfileResponseDtoOutputBankChangeStatusEnumValues;
  static OperatorProfileResponseDtoOutputBankChangeStatusEnum valueOf(String name) => _$operatorProfileResponseDtoOutputBankChangeStatusEnumValueOf(name);
}

