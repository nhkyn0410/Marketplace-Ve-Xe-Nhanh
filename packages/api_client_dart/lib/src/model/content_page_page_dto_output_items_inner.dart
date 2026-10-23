//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_page_page_dto_output_items_inner.g.dart';

/// ContentPagePageDtoOutputItemsInner
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
@BuiltValue()
abstract class ContentPagePageDtoOutputItemsInner implements Built<ContentPagePageDtoOutputItemsInner, ContentPagePageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ContentPagePageDtoOutputItemsInnerTypeEnum get type;
  // enum typeEnum {  FAQ,  BANNER,  PAGE,  };

  @BuiltValueField(wireName: r'placement')
  ContentPagePageDtoOutputItemsInnerPlacementEnum get placement;
  // enum placementEnum {  HOME,  FOOTER,  BOOKING,  TICKET,  ACCOUNT,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'status')
  ContentPagePageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  PUBLISHED,  };

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ContentPagePageDtoOutputItemsInner._();

  factory ContentPagePageDtoOutputItemsInner([void updates(ContentPagePageDtoOutputItemsInnerBuilder b)]) = _$ContentPagePageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContentPagePageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContentPagePageDtoOutputItemsInner> get serializer => _$ContentPagePageDtoOutputItemsInnerSerializer();
}

class _$ContentPagePageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<ContentPagePageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [ContentPagePageDtoOutputItemsInner, _$ContentPagePageDtoOutputItemsInner];

  @override
  final String wireName = r'ContentPagePageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContentPagePageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(ContentPagePageDtoOutputItemsInnerTypeEnum),
    );
    yield r'placement';
    yield serializers.serialize(
      object.placement,
      specifiedType: const FullType(ContentPagePageDtoOutputItemsInnerPlacementEnum),
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
      specifiedType: const FullType(ContentPagePageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ContentPagePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContentPagePageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(ContentPagePageDtoOutputItemsInnerTypeEnum),
          ) as ContentPagePageDtoOutputItemsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'placement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContentPagePageDtoOutputItemsInnerPlacementEnum),
          ) as ContentPagePageDtoOutputItemsInnerPlacementEnum;
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
            specifiedType: const FullType(ContentPagePageDtoOutputItemsInnerStatusEnum),
          ) as ContentPagePageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContentPagePageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContentPagePageDtoOutputItemsInnerBuilder();
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


class ContentPagePageDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAQ')
  static const ContentPagePageDtoOutputItemsInnerTypeEnum FAQ = _$contentPagePageDtoOutputItemsInnerTypeEnum_FAQ;
  @BuiltValueEnumConst(wireName: r'BANNER')
  static const ContentPagePageDtoOutputItemsInnerTypeEnum BANNER = _$contentPagePageDtoOutputItemsInnerTypeEnum_BANNER;
  @BuiltValueEnumConst(wireName: r'PAGE')
  static const ContentPagePageDtoOutputItemsInnerTypeEnum PAGE = _$contentPagePageDtoOutputItemsInnerTypeEnum_PAGE;

  static Serializer<ContentPagePageDtoOutputItemsInnerTypeEnum> get serializer => _$contentPagePageDtoOutputItemsInnerTypeEnumSerializer;

  const ContentPagePageDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<ContentPagePageDtoOutputItemsInnerTypeEnum> get values => _$contentPagePageDtoOutputItemsInnerTypeEnumValues;
  static ContentPagePageDtoOutputItemsInnerTypeEnum valueOf(String name) => _$contentPagePageDtoOutputItemsInnerTypeEnumValueOf(name);
}

class ContentPagePageDtoOutputItemsInnerPlacementEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HOME')
  static const ContentPagePageDtoOutputItemsInnerPlacementEnum HOME = _$contentPagePageDtoOutputItemsInnerPlacementEnum_HOME;
  @BuiltValueEnumConst(wireName: r'FOOTER')
  static const ContentPagePageDtoOutputItemsInnerPlacementEnum FOOTER = _$contentPagePageDtoOutputItemsInnerPlacementEnum_FOOTER;
  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const ContentPagePageDtoOutputItemsInnerPlacementEnum BOOKING = _$contentPagePageDtoOutputItemsInnerPlacementEnum_BOOKING;
  @BuiltValueEnumConst(wireName: r'TICKET')
  static const ContentPagePageDtoOutputItemsInnerPlacementEnum TICKET = _$contentPagePageDtoOutputItemsInnerPlacementEnum_TICKET;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const ContentPagePageDtoOutputItemsInnerPlacementEnum ACCOUNT = _$contentPagePageDtoOutputItemsInnerPlacementEnum_ACCOUNT;

  static Serializer<ContentPagePageDtoOutputItemsInnerPlacementEnum> get serializer => _$contentPagePageDtoOutputItemsInnerPlacementEnumSerializer;

  const ContentPagePageDtoOutputItemsInnerPlacementEnum._(String name): super(name);

  static BuiltSet<ContentPagePageDtoOutputItemsInnerPlacementEnum> get values => _$contentPagePageDtoOutputItemsInnerPlacementEnumValues;
  static ContentPagePageDtoOutputItemsInnerPlacementEnum valueOf(String name) => _$contentPagePageDtoOutputItemsInnerPlacementEnumValueOf(name);
}

class ContentPagePageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ContentPagePageDtoOutputItemsInnerStatusEnum DRAFT = _$contentPagePageDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const ContentPagePageDtoOutputItemsInnerStatusEnum PUBLISHED = _$contentPagePageDtoOutputItemsInnerStatusEnum_PUBLISHED;

  static Serializer<ContentPagePageDtoOutputItemsInnerStatusEnum> get serializer => _$contentPagePageDtoOutputItemsInnerStatusEnumSerializer;

  const ContentPagePageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ContentPagePageDtoOutputItemsInnerStatusEnum> get values => _$contentPagePageDtoOutputItemsInnerStatusEnumValues;
  static ContentPagePageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$contentPagePageDtoOutputItemsInnerStatusEnumValueOf(name);
}

