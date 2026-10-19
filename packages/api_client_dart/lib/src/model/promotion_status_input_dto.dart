//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_status_input_dto.g.dart';

/// PromotionStatusInputDto
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class PromotionStatusInputDto implements Built<PromotionStatusInputDto, PromotionStatusInputDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  PromotionStatusInputDtoStatusEnum get status;
  // enum statusEnum {  ACTIVE,  PAUSED,  ENDED,  };

  PromotionStatusInputDto._();

  factory PromotionStatusInputDto([void updates(PromotionStatusInputDtoBuilder b)]) = _$PromotionStatusInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionStatusInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionStatusInputDto> get serializer => _$PromotionStatusInputDtoSerializer();
}

class _$PromotionStatusInputDtoSerializer implements PrimitiveSerializer<PromotionStatusInputDto> {
  @override
  final Iterable<Type> types = const [PromotionStatusInputDto, _$PromotionStatusInputDto];

  @override
  final String wireName = r'PromotionStatusInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PromotionStatusInputDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionStatusInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionStatusInputDtoStatusEnum),
          ) as PromotionStatusInputDtoStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionStatusInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionStatusInputDtoBuilder();
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


class PromotionStatusInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const PromotionStatusInputDtoStatusEnum ACTIVE = _$promotionStatusInputDtoStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const PromotionStatusInputDtoStatusEnum PAUSED = _$promotionStatusInputDtoStatusEnum_PAUSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const PromotionStatusInputDtoStatusEnum ENDED = _$promotionStatusInputDtoStatusEnum_ENDED;

  static Serializer<PromotionStatusInputDtoStatusEnum> get serializer => _$promotionStatusInputDtoStatusEnumSerializer;

  const PromotionStatusInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<PromotionStatusInputDtoStatusEnum> get values => _$promotionStatusInputDtoStatusEnumValues;
  static PromotionStatusInputDtoStatusEnum valueOf(String name) => _$promotionStatusInputDtoStatusEnumValueOf(name);
}

