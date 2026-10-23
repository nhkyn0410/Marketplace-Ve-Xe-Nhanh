//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'article_page_dto_output_items_inner_category.g.dart';

/// ArticlePageDtoOutputItemsInnerCategory
///
/// Properties:
/// * [name] 
/// * [slug] 
@BuiltValue()
abstract class ArticlePageDtoOutputItemsInnerCategory implements Built<ArticlePageDtoOutputItemsInnerCategory, ArticlePageDtoOutputItemsInnerCategoryBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  ArticlePageDtoOutputItemsInnerCategory._();

  factory ArticlePageDtoOutputItemsInnerCategory([void updates(ArticlePageDtoOutputItemsInnerCategoryBuilder b)]) = _$ArticlePageDtoOutputItemsInnerCategory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArticlePageDtoOutputItemsInnerCategoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArticlePageDtoOutputItemsInnerCategory> get serializer => _$ArticlePageDtoOutputItemsInnerCategorySerializer();
}

class _$ArticlePageDtoOutputItemsInnerCategorySerializer implements PrimitiveSerializer<ArticlePageDtoOutputItemsInnerCategory> {
  @override
  final Iterable<Type> types = const [ArticlePageDtoOutputItemsInnerCategory, _$ArticlePageDtoOutputItemsInnerCategory];

  @override
  final String wireName = r'ArticlePageDtoOutputItemsInnerCategory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArticlePageDtoOutputItemsInnerCategory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArticlePageDtoOutputItemsInnerCategory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArticlePageDtoOutputItemsInnerCategoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArticlePageDtoOutputItemsInnerCategory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArticlePageDtoOutputItemsInnerCategoryBuilder();
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


