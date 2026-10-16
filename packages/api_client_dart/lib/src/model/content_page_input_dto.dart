//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_page_input_dto.g.dart';

/// ContentPageInputDto
///
/// Properties:
/// * [type] 
/// * [placement] 
/// * [title] 
/// * [slug] 
/// * [bodyMarkdown] 
/// * [imageKey] 
/// * [linkUrl] 
/// * [displayOrder] 
@BuiltValue()
abstract class ContentPageInputDto implements Built<ContentPageInputDto, ContentPageInputDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  ContentPageInputDtoTypeEnum get type;
  // enum typeEnum {  FAQ,  BANNER,  PAGE,  };

  @BuiltValueField(wireName: r'placement')
  ContentPageInputDtoPlacementEnum get placement;
  // enum placementEnum {  HOME,  FOOTER,  BOOKING,  TICKET,  ACCOUNT,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'bodyMarkdown')
  String get bodyMarkdown;

  @BuiltValueField(wireName: r'imageKey')
  String? get imageKey;

  @BuiltValueField(wireName: r'linkUrl')
  String? get linkUrl;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  ContentPageInputDto._();

  factory ContentPageInputDto([void updates(ContentPageInputDtoBuilder b)]) = _$ContentPageInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContentPageInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContentPageInputDto> get serializer => _$ContentPageInputDtoSerializer();
}

class _$ContentPageInputDtoSerializer implements PrimitiveSerializer<ContentPageInputDto> {
  @override
  final Iterable<Type> types = const [ContentPageInputDto, _$ContentPageInputDto];

  @override
  final String wireName = r'ContentPageInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContentPageInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ContentPageInputDtoTypeEnum),
    );
    yield r'placement';
    yield serializers.serialize(
      object.placement,
      specifiedType: const FullType(ContentPageInputDtoPlacementEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield object.slug == null ? null : serializers.serialize(
      object.slug,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bodyMarkdown';
    yield serializers.serialize(
      object.bodyMarkdown,
      specifiedType: const FullType(String),
    );
    yield r'imageKey';
    yield object.imageKey == null ? null : serializers.serialize(
      object.imageKey,
      specifiedType: const FullType.nullable(String),
    );
    yield r'linkUrl';
    yield object.linkUrl == null ? null : serializers.serialize(
      object.linkUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContentPageInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContentPageInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPageInputDtoTypeEnum),
          ) as ContentPageInputDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'placement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPageInputDtoPlacementEnum),
          ) as ContentPageInputDtoPlacementEnum;
          result.placement = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.slug = valueDes;
          break;
        case r'bodyMarkdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bodyMarkdown = valueDes;
          break;
        case r'imageKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageKey = valueDes;
          break;
        case r'linkUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.linkUrl = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContentPageInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContentPageInputDtoBuilder();
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


class ContentPageInputDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAQ')
  static const ContentPageInputDtoTypeEnum FAQ = _$contentPageInputDtoTypeEnum_FAQ;
  @BuiltValueEnumConst(wireName: r'BANNER')
  static const ContentPageInputDtoTypeEnum BANNER = _$contentPageInputDtoTypeEnum_BANNER;
  @BuiltValueEnumConst(wireName: r'PAGE')
  static const ContentPageInputDtoTypeEnum PAGE = _$contentPageInputDtoTypeEnum_PAGE;

  static Serializer<ContentPageInputDtoTypeEnum> get serializer => _$contentPageInputDtoTypeEnumSerializer;

  const ContentPageInputDtoTypeEnum._(String name): super(name);

  static BuiltSet<ContentPageInputDtoTypeEnum> get values => _$contentPageInputDtoTypeEnumValues;
  static ContentPageInputDtoTypeEnum valueOf(String name) => _$contentPageInputDtoTypeEnumValueOf(name);
}

class ContentPageInputDtoPlacementEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HOME')
  static const ContentPageInputDtoPlacementEnum HOME = _$contentPageInputDtoPlacementEnum_HOME;
  @BuiltValueEnumConst(wireName: r'FOOTER')
  static const ContentPageInputDtoPlacementEnum FOOTER = _$contentPageInputDtoPlacementEnum_FOOTER;
  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const ContentPageInputDtoPlacementEnum BOOKING = _$contentPageInputDtoPlacementEnum_BOOKING;
  @BuiltValueEnumConst(wireName: r'TICKET')
  static const ContentPageInputDtoPlacementEnum TICKET = _$contentPageInputDtoPlacementEnum_TICKET;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const ContentPageInputDtoPlacementEnum ACCOUNT = _$contentPageInputDtoPlacementEnum_ACCOUNT;

  static Serializer<ContentPageInputDtoPlacementEnum> get serializer => _$contentPageInputDtoPlacementEnumSerializer;

  const ContentPageInputDtoPlacementEnum._(String name): super(name);

  static BuiltSet<ContentPageInputDtoPlacementEnum> get values => _$contentPageInputDtoPlacementEnumValues;
  static ContentPageInputDtoPlacementEnum valueOf(String name) => _$contentPageInputDtoPlacementEnumValueOf(name);
}

