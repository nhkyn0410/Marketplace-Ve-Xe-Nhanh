//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'moderation_input_dto.g.dart';

/// ModerationInputDto
///
/// Properties:
/// * [action] 
/// * [reason] 
@BuiltValue()
abstract class ModerationInputDto implements Built<ModerationInputDto, ModerationInputDtoBuilder> {
  @BuiltValueField(wireName: r'action')
  ModerationInputDtoActionEnum get action;
  // enum actionEnum {  HOLD,  HIDE,  SHOW,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  ModerationInputDto._();

  factory ModerationInputDto([void updates(ModerationInputDtoBuilder b)]) = _$ModerationInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModerationInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModerationInputDto> get serializer => _$ModerationInputDtoSerializer();
}

class _$ModerationInputDtoSerializer implements PrimitiveSerializer<ModerationInputDto> {
  @override
  final Iterable<Type> types = const [ModerationInputDto, _$ModerationInputDto];

  @override
  final String wireName = r'ModerationInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModerationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(ModerationInputDtoActionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ModerationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ModerationInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ModerationInputDtoActionEnum),
          ) as ModerationInputDtoActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  ModerationInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModerationInputDtoBuilder();
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


class ModerationInputDtoActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HOLD')
  static const ModerationInputDtoActionEnum HOLD = _$moderationInputDtoActionEnum_HOLD;
  @BuiltValueEnumConst(wireName: r'HIDE')
  static const ModerationInputDtoActionEnum HIDE = _$moderationInputDtoActionEnum_HIDE;
  @BuiltValueEnumConst(wireName: r'SHOW')
  static const ModerationInputDtoActionEnum SHOW = _$moderationInputDtoActionEnum_SHOW;

  static Serializer<ModerationInputDtoActionEnum> get serializer => _$moderationInputDtoActionEnumSerializer;

  const ModerationInputDtoActionEnum._(String name): super(name);

  static BuiltSet<ModerationInputDtoActionEnum> get values => _$moderationInputDtoActionEnumValues;
  static ModerationInputDtoActionEnum valueOf(String name) => _$moderationInputDtoActionEnumValueOf(name);
}

