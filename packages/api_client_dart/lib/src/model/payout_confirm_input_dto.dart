//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_confirm_input_dto.g.dart';

/// PayoutConfirmInputDto
///
/// Properties:
/// * [bankReference] 
/// * [transferredAt] 
/// * [note] 
@BuiltValue()
abstract class PayoutConfirmInputDto implements Built<PayoutConfirmInputDto, PayoutConfirmInputDtoBuilder> {
  @BuiltValueField(wireName: r'bankReference')
  String get bankReference;

  @BuiltValueField(wireName: r'transferredAt')
  DateTime get transferredAt;

  @BuiltValueField(wireName: r'note')
  String get note;

  PayoutConfirmInputDto._();

  factory PayoutConfirmInputDto([void updates(PayoutConfirmInputDtoBuilder b)]) = _$PayoutConfirmInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutConfirmInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutConfirmInputDto> get serializer => _$PayoutConfirmInputDtoSerializer();
}

class _$PayoutConfirmInputDtoSerializer implements PrimitiveSerializer<PayoutConfirmInputDto> {
  @override
  final Iterable<Type> types = const [PayoutConfirmInputDto, _$PayoutConfirmInputDto];

  @override
  final String wireName = r'PayoutConfirmInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutConfirmInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bankReference';
    yield serializers.serialize(
      object.bankReference,
      specifiedType: const FullType(String),
    );
    yield r'transferredAt';
    yield serializers.serialize(
      object.transferredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutConfirmInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutConfirmInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bankReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bankReference = valueDes;
          break;
        case r'transferredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.transferredAt = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutConfirmInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutConfirmInputDtoBuilder();
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


