//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/article_category_list_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'article_category_list_dto_output.g.dart';

/// ArticleCategoryListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class ArticleCategoryListDtoOutput implements Built<ArticleCategoryListDtoOutput, ArticleCategoryListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ArticleCategoryListDtoOutputItemsInner> get items;

  ArticleCategoryListDtoOutput._();

  factory ArticleCategoryListDtoOutput([void updates(ArticleCategoryListDtoOutputBuilder b)]) = _$ArticleCategoryListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArticleCategoryListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArticleCategoryListDtoOutput> get serializer => _$ArticleCategoryListDtoOutputSerializer();
}

class _$ArticleCategoryListDtoOutputSerializer implements PrimitiveSerializer<ArticleCategoryListDtoOutput> {
  @override
  final Iterable<Type> types = const [ArticleCategoryListDtoOutput, _$ArticleCategoryListDtoOutput];

  @override
  final String wireName = r'ArticleCategoryListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArticleCategoryListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ArticleCategoryListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArticleCategoryListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArticleCategoryListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ArticleCategoryListDtoOutputItemsInner)]),
          ) as BuiltList<ArticleCategoryListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArticleCategoryListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArticleCategoryListDtoOutputBuilder();
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


