//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_page_status_input_dto.g.dart';

/// ContentPageStatusInputDto
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class ContentPageStatusInputDto implements Built<ContentPageStatusInputDto, ContentPageStatusInputDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  ContentPageStatusInputDtoStatusEnum get status;
  // enum statusEnum {  DRAFT,  PUBLISHED,  };

  ContentPageStatusInputDto._();

  factory ContentPageStatusInputDto([void updates(ContentPageStatusInputDtoBuilder b)]) = _$ContentPageStatusInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContentPageStatusInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContentPageStatusInputDto> get serializer => _$ContentPageStatusInputDtoSerializer();
}

class _$ContentPageStatusInputDtoSerializer implements PrimitiveSerializer<ContentPageStatusInputDto> {
  @override
  final Iterable<Type> types = const [ContentPageStatusInputDto, _$ContentPageStatusInputDto];

  @override
  final String wireName = r'ContentPageStatusInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContentPageStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ContentPageStatusInputDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContentPageStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContentPageStatusInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPageStatusInputDtoStatusEnum),
          ) as ContentPageStatusInputDtoStatusEnum;
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
  ContentPageStatusInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContentPageStatusInputDtoBuilder();
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


class ContentPageStatusInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ContentPageStatusInputDtoStatusEnum DRAFT = _$contentPageStatusInputDtoStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const ContentPageStatusInputDtoStatusEnum PUBLISHED = _$contentPageStatusInputDtoStatusEnum_PUBLISHED;

  static Serializer<ContentPageStatusInputDtoStatusEnum> get serializer => _$contentPageStatusInputDtoStatusEnumSerializer;

  const ContentPageStatusInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<ContentPageStatusInputDtoStatusEnum> get values => _$contentPageStatusInputDtoStatusEnumValues;
  static ContentPageStatusInputDtoStatusEnum valueOf(String name) => _$contentPageStatusInputDtoStatusEnumValueOf(name);
}

