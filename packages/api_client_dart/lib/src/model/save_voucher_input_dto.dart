//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_voucher_input_dto.g.dart';

/// SaveVoucherInputDto
///
/// Properties:
/// * [promotionCode] 
@BuiltValue()
abstract class SaveVoucherInputDto implements Built<SaveVoucherInputDto, SaveVoucherInputDtoBuilder> {
  @BuiltValueField(wireName: r'promotionCode')
  String get promotionCode;

  SaveVoucherInputDto._();

  factory SaveVoucherInputDto([void updates(SaveVoucherInputDtoBuilder b)]) = _$SaveVoucherInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveVoucherInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveVoucherInputDto> get serializer => _$SaveVoucherInputDtoSerializer();
}

class _$SaveVoucherInputDtoSerializer implements PrimitiveSerializer<SaveVoucherInputDto> {
  @override
  final Iterable<Type> types = const [SaveVoucherInputDto, _$SaveVoucherInputDto];

  @override
  final String wireName = r'SaveVoucherInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveVoucherInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'promotionCode';
    yield serializers.serialize(
      object.promotionCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveVoucherInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveVoucherInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'promotionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.promotionCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveVoucherInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveVoucherInputDtoBuilder();
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


