//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'article_category_list_dto_output_items_inner.g.dart';

/// ArticleCategoryListDtoOutputItemsInner
///
/// Properties:
/// * [name] 
/// * [slug] 
/// * [articleCount] 
@BuiltValue()
abstract class ArticleCategoryListDtoOutputItemsInner implements Built<ArticleCategoryListDtoOutputItemsInner, ArticleCategoryListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'articleCount')
  int get articleCount;

  ArticleCategoryListDtoOutputItemsInner._();

  factory ArticleCategoryListDtoOutputItemsInner([void updates(ArticleCategoryListDtoOutputItemsInnerBuilder b)]) = _$ArticleCategoryListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArticleCategoryListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArticleCategoryListDtoOutputItemsInner> get serializer => _$ArticleCategoryListDtoOutputItemsInnerSerializer();
}

class _$ArticleCategoryListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<ArticleCategoryListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [ArticleCategoryListDtoOutputItemsInner, _$ArticleCategoryListDtoOutputItemsInner];

  @override
  final String wireName = r'ArticleCategoryListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArticleCategoryListDtoOutputItemsInner object, {
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
    yield r'articleCount';
    yield serializers.serialize(
      object.articleCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArticleCategoryListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArticleCategoryListDtoOutputItemsInnerBuilder result,
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
        case r'articleCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.articleCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArticleCategoryListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArticleCategoryListDtoOutputItemsInnerBuilder();
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


