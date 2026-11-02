//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_dto_output.g.dart';

/// AdminArticleDtoOutput
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
/// * [contentMarkdown] 
/// * [createdAt] 
/// * [updatedByName] 
@BuiltValue()
abstract class AdminArticleDtoOutput implements Built<AdminArticleDtoOutput, AdminArticleDtoOutputBuilder> {
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
  AdminArticleDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  PUBLISHED,  ARCHIVED,  };

  @BuiltValueField(wireName: r'publishedAt')
  DateTime? get publishedAt;

  @BuiltValueField(wireName: r'viewCount')
  int get viewCount;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'contentMarkdown')
  String get contentMarkdown;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedByName')
  String? get updatedByName;

  AdminArticleDtoOutput._();

  factory AdminArticleDtoOutput([void updates(AdminArticleDtoOutputBuilder b)]) = _$AdminArticleDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleDtoOutput> get serializer => _$AdminArticleDtoOutputSerializer();
}

class _$AdminArticleDtoOutputSerializer implements PrimitiveSerializer<AdminArticleDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminArticleDtoOutput, _$AdminArticleDtoOutput];

  @override
  final String wireName = r'AdminArticleDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleDtoOutput object, {
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
      specifiedType: const FullType(AdminArticleDtoOutputStatusEnum),
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
    yield r'contentMarkdown';
    yield serializers.serialize(
      object.contentMarkdown,
      specifiedType: const FullType(String),
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
    AdminArticleDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleDtoOutputBuilder result,
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
            specifiedType: const FullType(AdminArticleDtoOutputStatusEnum),
          ) as AdminArticleDtoOutputStatusEnum;
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
        case r'contentMarkdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentMarkdown = valueDes;
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
  AdminArticleDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleDtoOutputBuilder();
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


class AdminArticleDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminArticleDtoOutputStatusEnum DRAFT = _$adminArticleDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const AdminArticleDtoOutputStatusEnum PUBLISHED = _$adminArticleDtoOutputStatusEnum_PUBLISHED;
  @BuiltValueEnumConst(wireName: r'ARCHIVED')
  static const AdminArticleDtoOutputStatusEnum ARCHIVED = _$adminArticleDtoOutputStatusEnum_ARCHIVED;

  static Serializer<AdminArticleDtoOutputStatusEnum> get serializer => _$adminArticleDtoOutputStatusEnumSerializer;

  const AdminArticleDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminArticleDtoOutputStatusEnum> get values => _$adminArticleDtoOutputStatusEnumValues;
  static AdminArticleDtoOutputStatusEnum valueOf(String name) => _$adminArticleDtoOutputStatusEnumValueOf(name);
}

