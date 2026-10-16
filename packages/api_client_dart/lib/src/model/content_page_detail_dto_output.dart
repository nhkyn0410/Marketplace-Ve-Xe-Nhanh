//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_page_detail_dto_output.g.dart';

/// ContentPageDetailDtoOutput
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [placement] 
/// * [title] 
/// * [slug] 
/// * [status] 
/// * [displayOrder] 
/// * [imageUrl] 
/// * [updatedAt] 
/// * [bodyMarkdown] 
/// * [imageKey] 
/// * [linkUrl] 
/// * [publishedAt] 
/// * [createdAt] 
/// * [updatedByName] 
@BuiltValue()
abstract class ContentPageDetailDtoOutput implements Built<ContentPageDetailDtoOutput, ContentPageDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ContentPageDetailDtoOutputTypeEnum get type;
  // enum typeEnum {  FAQ,  BANNER,  PAGE,  };

  @BuiltValueField(wireName: r'placement')
  ContentPageDetailDtoOutputPlacementEnum get placement;
  // enum placementEnum {  HOME,  FOOTER,  BOOKING,  TICKET,  ACCOUNT,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'status')
  ContentPageDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  PUBLISHED,  };

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'bodyMarkdown')
  String get bodyMarkdown;

  @BuiltValueField(wireName: r'imageKey')
  String? get imageKey;

  @BuiltValueField(wireName: r'linkUrl')
  String? get linkUrl;

  @BuiltValueField(wireName: r'publishedAt')
  DateTime? get publishedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedByName')
  String? get updatedByName;

  ContentPageDetailDtoOutput._();

  factory ContentPageDetailDtoOutput([void updates(ContentPageDetailDtoOutputBuilder b)]) = _$ContentPageDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContentPageDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContentPageDetailDtoOutput> get serializer => _$ContentPageDetailDtoOutputSerializer();
}

class _$ContentPageDetailDtoOutputSerializer implements PrimitiveSerializer<ContentPageDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [ContentPageDetailDtoOutput, _$ContentPageDetailDtoOutput];

  @override
  final String wireName = r'ContentPageDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContentPageDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ContentPageDetailDtoOutputTypeEnum),
    );
    yield r'placement';
    yield serializers.serialize(
      object.placement,
      specifiedType: const FullType(ContentPageDetailDtoOutputPlacementEnum),
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ContentPageDetailDtoOutputStatusEnum),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
    yield r'imageUrl';
    yield object.imageUrl == null ? null : serializers.serialize(
      object.imageUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
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
    yield r'publishedAt';
    yield object.publishedAt == null ? null : serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedByName';
    yield object.updatedByName == null ? null : serializers.serialize(
      object.updatedByName,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContentPageDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContentPageDetailDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPageDetailDtoOutputTypeEnum),
          ) as ContentPageDetailDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'placement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPageDetailDtoOutputPlacementEnum),
          ) as ContentPageDetailDtoOutputPlacementEnum;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPageDetailDtoOutputStatusEnum),
          ) as ContentPageDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
          break;
        case r'imageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageUrl = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
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
        case r'publishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.publishedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedByName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updatedByName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContentPageDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContentPageDetailDtoOutputBuilder();
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


class ContentPageDetailDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAQ')
  static const ContentPageDetailDtoOutputTypeEnum FAQ = _$contentPageDetailDtoOutputTypeEnum_FAQ;
  @BuiltValueEnumConst(wireName: r'BANNER')
  static const ContentPageDetailDtoOutputTypeEnum BANNER = _$contentPageDetailDtoOutputTypeEnum_BANNER;
  @BuiltValueEnumConst(wireName: r'PAGE')
  static const ContentPageDetailDtoOutputTypeEnum PAGE = _$contentPageDetailDtoOutputTypeEnum_PAGE;

  static Serializer<ContentPageDetailDtoOutputTypeEnum> get serializer => _$contentPageDetailDtoOutputTypeEnumSerializer;

  const ContentPageDetailDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<ContentPageDetailDtoOutputTypeEnum> get values => _$contentPageDetailDtoOutputTypeEnumValues;
  static ContentPageDetailDtoOutputTypeEnum valueOf(String name) => _$contentPageDetailDtoOutputTypeEnumValueOf(name);
}

class ContentPageDetailDtoOutputPlacementEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HOME')
  static const ContentPageDetailDtoOutputPlacementEnum HOME = _$contentPageDetailDtoOutputPlacementEnum_HOME;
  @BuiltValueEnumConst(wireName: r'FOOTER')
  static const ContentPageDetailDtoOutputPlacementEnum FOOTER = _$contentPageDetailDtoOutputPlacementEnum_FOOTER;
  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const ContentPageDetailDtoOutputPlacementEnum BOOKING = _$contentPageDetailDtoOutputPlacementEnum_BOOKING;
  @BuiltValueEnumConst(wireName: r'TICKET')
  static const ContentPageDetailDtoOutputPlacementEnum TICKET = _$contentPageDetailDtoOutputPlacementEnum_TICKET;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const ContentPageDetailDtoOutputPlacementEnum ACCOUNT = _$contentPageDetailDtoOutputPlacementEnum_ACCOUNT;

  static Serializer<ContentPageDetailDtoOutputPlacementEnum> get serializer => _$contentPageDetailDtoOutputPlacementEnumSerializer;

  const ContentPageDetailDtoOutputPlacementEnum._(String name): super(name);

  static BuiltSet<ContentPageDetailDtoOutputPlacementEnum> get values => _$contentPageDetailDtoOutputPlacementEnumValues;
  static ContentPageDetailDtoOutputPlacementEnum valueOf(String name) => _$contentPageDetailDtoOutputPlacementEnumValueOf(name);
}

class ContentPageDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ContentPageDetailDtoOutputStatusEnum DRAFT = _$contentPageDetailDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const ContentPageDetailDtoOutputStatusEnum PUBLISHED = _$contentPageDetailDtoOutputStatusEnum_PUBLISHED;

  static Serializer<ContentPageDetailDtoOutputStatusEnum> get serializer => _$contentPageDetailDtoOutputStatusEnumSerializer;

  const ContentPageDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<ContentPageDetailDtoOutputStatusEnum> get values => _$contentPageDetailDtoOutputStatusEnumValues;
  static ContentPageDetailDtoOutputStatusEnum valueOf(String name) => _$contentPageDetailDtoOutputStatusEnumValueOf(name);
}

