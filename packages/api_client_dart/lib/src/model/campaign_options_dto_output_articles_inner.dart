//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_options_dto_output_articles_inner.g.dart';

/// CampaignOptionsDtoOutputArticlesInner
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [slug] 
/// * [publishedAt] 
@BuiltValue()
abstract class CampaignOptionsDtoOutputArticlesInner implements Built<CampaignOptionsDtoOutputArticlesInner, CampaignOptionsDtoOutputArticlesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'publishedAt')
  DateTime? get publishedAt;

  CampaignOptionsDtoOutputArticlesInner._();

  factory CampaignOptionsDtoOutputArticlesInner([void updates(CampaignOptionsDtoOutputArticlesInnerBuilder b)]) = _$CampaignOptionsDtoOutputArticlesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignOptionsDtoOutputArticlesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignOptionsDtoOutputArticlesInner> get serializer => _$CampaignOptionsDtoOutputArticlesInnerSerializer();
}

class _$CampaignOptionsDtoOutputArticlesInnerSerializer implements PrimitiveSerializer<CampaignOptionsDtoOutputArticlesInner> {
  @override
  final Iterable<Type> types = const [CampaignOptionsDtoOutputArticlesInner, _$CampaignOptionsDtoOutputArticlesInner];

  @override
  final String wireName = r'CampaignOptionsDtoOutputArticlesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignOptionsDtoOutputArticlesInner object, {
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
    yield r'publishedAt';
    yield object.publishedAt == null ? null : serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignOptionsDtoOutputArticlesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignOptionsDtoOutputArticlesInnerBuilder result,
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
        case r'publishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.publishedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignOptionsDtoOutputArticlesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignOptionsDtoOutputArticlesInnerBuilder();
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


