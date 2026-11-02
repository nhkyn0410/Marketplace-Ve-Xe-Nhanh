//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/article_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'article_page_dto_output.g.dart';

/// ArticlePageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class ArticlePageDtoOutput implements Built<ArticlePageDtoOutput, ArticlePageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ArticlePageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  ArticlePageDtoOutput._();

  factory ArticlePageDtoOutput([void updates(ArticlePageDtoOutputBuilder b)]) = _$ArticlePageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArticlePageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArticlePageDtoOutput> get serializer => _$ArticlePageDtoOutputSerializer();
}

class _$ArticlePageDtoOutputSerializer implements PrimitiveSerializer<ArticlePageDtoOutput> {
  @override
  final Iterable<Type> types = const [ArticlePageDtoOutput, _$ArticlePageDtoOutput];

  @override
  final String wireName = r'ArticlePageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArticlePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ArticlePageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArticlePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArticlePageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ArticlePageDtoOutputItemsInner)]),
          ) as BuiltList<ArticlePageDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArticlePageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArticlePageDtoOutputBuilder();
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


