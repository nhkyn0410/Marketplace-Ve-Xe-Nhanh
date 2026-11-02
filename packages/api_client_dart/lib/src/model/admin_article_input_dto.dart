//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_input_dto.g.dart';

/// AdminArticleInputDto
///
/// Properties:
/// * [title] 
/// * [slug] 
/// * [summary] 
/// * [contentMarkdown] 
/// * [categoryId] 
/// * [coverImageKey] 
/// * [featured] 
@BuiltValue()
abstract class AdminArticleInputDto implements Built<AdminArticleInputDto, AdminArticleInputDtoBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  @BuiltValueField(wireName: r'contentMarkdown')
  String get contentMarkdown;

  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'coverImageKey')
  String? get coverImageKey;

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  AdminArticleInputDto._();

  factory AdminArticleInputDto([void updates(AdminArticleInputDtoBuilder b)]) = _$AdminArticleInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleInputDto> get serializer => _$AdminArticleInputDtoSerializer();
}

class _$AdminArticleInputDtoSerializer implements PrimitiveSerializer<AdminArticleInputDto> {
  @override
  final Iterable<Type> types = const [AdminArticleInputDto, _$AdminArticleInputDto];

  @override
  final String wireName = r'AdminArticleInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleInputDto object, {
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
    yield r'contentMarkdown';
    yield serializers.serialize(
      object.contentMarkdown,
      specifiedType: const FullType(String),
    );
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'coverImageKey';
    yield object.coverImageKey == null ? null : serializers.serialize(
      object.coverImageKey,
      specifiedType: const FullType.nullable(String),
    );
    yield r'featured';
    yield serializers.serialize(
      object.featured,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminArticleInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleInputDtoBuilder result,
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
        case r'contentMarkdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentMarkdown = valueDes;
          break;
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'coverImageKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.coverImageKey = valueDes;
          break;
        case r'featured':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.featured = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminArticleInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleInputDtoBuilder();
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


