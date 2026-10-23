//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_check_input_dto.g.dart';

/// PromotionCheckInputDto
///
/// Properties:
/// * [tripId] 
/// * [code] 
/// * [subtotal] 
@BuiltValue()
abstract class PromotionCheckInputDto implements Built<PromotionCheckInputDto, PromotionCheckInputDtoBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'subtotal')
  int get subtotal;

  PromotionCheckInputDto._();

  factory PromotionCheckInputDto([void updates(PromotionCheckInputDtoBuilder b)]) = _$PromotionCheckInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionCheckInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionCheckInputDto> get serializer => _$PromotionCheckInputDtoSerializer();
}

class _$PromotionCheckInputDtoSerializer implements PrimitiveSerializer<PromotionCheckInputDto> {
  @override
  final Iterable<Type> types = const [PromotionCheckInputDto, _$PromotionCheckInputDto];

  @override
  final String wireName = r'PromotionCheckInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionCheckInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionCheckInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionCheckInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.subtotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionCheckInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionCheckInputDtoBuilder();
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


