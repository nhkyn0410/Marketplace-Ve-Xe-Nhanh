//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/article_page_dto_output_items_inner_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'article_dto_output.g.dart';

/// ArticleDtoOutput
///
/// Properties:
/// * [title] 
/// * [slug] 
/// * [summary] 
/// * [coverImageUrl] 
/// * [featured] 
/// * [category] 
/// * [publishedAt] 
/// * [contentMarkdown] 
/// * [updatedAt] 
@BuiltValue()
abstract class ArticleDtoOutput implements Built<ArticleDtoOutput, ArticleDtoOutputBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  @BuiltValueField(wireName: r'coverImageUrl')
  String? get coverImageUrl;

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  @BuiltValueField(wireName: r'category')
  ArticlePageDtoOutputItemsInnerCategory get category;

  @BuiltValueField(wireName: r'publishedAt')
  DateTime get publishedAt;

  @BuiltValueField(wireName: r'contentMarkdown')
  String get contentMarkdown;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ArticleDtoOutput._();

  factory ArticleDtoOutput([void updates(ArticleDtoOutputBuilder b)]) = _$ArticleDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArticleDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArticleDtoOutput> get serializer => _$ArticleDtoOutputSerializer();
}

class _$ArticleDtoOutputSerializer implements PrimitiveSerializer<ArticleDtoOutput> {
  @override
  final Iterable<Type> types = const [ArticleDtoOutput, _$ArticleDtoOutput];

  @override
  final String wireName = r'ArticleDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArticleDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(ArticlePageDtoOutputItemsInnerCategory),
    );
    yield r'publishedAt';
    yield serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'contentMarkdown';
    yield serializers.serialize(
      object.contentMarkdown,
      specifiedType: const FullType(String),
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
    ArticleDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArticleDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ArticlePageDtoOutputItemsInnerCategory),
          ) as ArticlePageDtoOutputItemsInnerCategory;
          result.category.replace(valueDes);
          break;
        case r'publishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.publishedAt = valueDes;
          break;
        case r'contentMarkdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentMarkdown = valueDes;
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
  ArticleDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArticleDtoOutputBuilder();
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


