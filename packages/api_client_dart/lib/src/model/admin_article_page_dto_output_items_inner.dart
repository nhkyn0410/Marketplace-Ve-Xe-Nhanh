//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_page_dto_output_items_inner.g.dart';

/// AdminArticlePageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [slug] 
/// * [summary] 
/// * [categoryId] 
/// * [categoryName] 
/// * [coverImageKey] 
/// * [coverImageUrl] 
/// * [featured] 
/// * [status] 
/// * [publishedAt] 
/// * [viewCount] 
/// * [updatedAt] 
@BuiltValue()
abstract class AdminArticlePageDtoOutputItemsInner implements Built<AdminArticlePageDtoOutputItemsInner, AdminArticlePageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'categoryName')
  String get categoryName;

  @BuiltValueField(wireName: r'coverImageKey')
  String? get coverImageKey;

  @BuiltValueField(wireName: r'coverImageUrl')
  String? get coverImageUrl;

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  @BuiltValueField(wireName: r'status')
  AdminArticlePageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  PUBLISHED,  ARCHIVED,  };

  @BuiltValueField(wireName: r'publishedAt')
  DateTime? get publishedAt;

  @BuiltValueField(wireName: r'viewCount')
  int get viewCount;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AdminArticlePageDtoOutputItemsInner._();

  factory AdminArticlePageDtoOutputItemsInner([void updates(AdminArticlePageDtoOutputItemsInnerBuilder b)]) = _$AdminArticlePageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticlePageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticlePageDtoOutputItemsInner> get serializer => _$AdminArticlePageDtoOutputItemsInnerSerializer();
}

class _$AdminArticlePageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminArticlePageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminArticlePageDtoOutputItemsInner, _$AdminArticlePageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminArticlePageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticlePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(String),
    );
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'categoryName';
    yield serializers.serialize(
      object.categoryName,
      specifiedType: const FullType(String),
    );
    yield r'coverImageKey';
    yield object.coverImageKey == null ? null : serializers.serialize(
      object.coverImageKey,
      specifiedType: const FullType.nullable(String),
    );
    yield r'coverImageUrl';
    yield object.coverImageUrl == null ? null : serializers.serialize(
      object.coverImageUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'featured';
    yield serializers.serialize(
      object.featured,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminArticlePageDtoOutputItemsInnerStatusEnum),
    );
    yield r'publishedAt';
    yield object.publishedAt == null ? null : serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'viewCount';
    yield serializers.serialize(
      object.viewCount,
      specifiedType: const FullType(int),
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
    AdminArticlePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticlePageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summary = valueDes;
          break;
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'categoryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryName = valueDes;
          break;
        case r'coverImageKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.coverImageKey = valueDes;
          break;
        case r'coverImageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.coverImageUrl = valueDes;
          break;
        case r'featured':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.featured = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminArticlePageDtoOutputItemsInnerStatusEnum),
          ) as AdminArticlePageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'publishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.publishedAt = valueDes;
          break;
        case r'viewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.viewCount = valueDes;
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
  AdminArticlePageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticlePageDtoOutputItemsInnerBuilder();
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


class AdminArticlePageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminArticlePageDtoOutputItemsInnerStatusEnum DRAFT = _$adminArticlePageDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const AdminArticlePageDtoOutputItemsInnerStatusEnum PUBLISHED = _$adminArticlePageDtoOutputItemsInnerStatusEnum_PUBLISHED;
  @BuiltValueEnumConst(wireName: r'ARCHIVED')
  static const AdminArticlePageDtoOutputItemsInnerStatusEnum ARCHIVED = _$adminArticlePageDtoOutputItemsInnerStatusEnum_ARCHIVED;

  static Serializer<AdminArticlePageDtoOutputItemsInnerStatusEnum> get serializer => _$adminArticlePageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminArticlePageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminArticlePageDtoOutputItemsInnerStatusEnum> get values => _$adminArticlePageDtoOutputItemsInnerStatusEnumValues;
  static AdminArticlePageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminArticlePageDtoOutputItemsInnerStatusEnumValueOf(name);
}

