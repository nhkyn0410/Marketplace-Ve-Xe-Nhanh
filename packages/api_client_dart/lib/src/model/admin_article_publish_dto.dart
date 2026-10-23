//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_publish_dto.g.dart';

/// AdminArticlePublishDto
///
/// Properties:
/// * [publishedAt] 
@BuiltValue()
abstract class AdminArticlePublishDto implements Built<AdminArticlePublishDto, AdminArticlePublishDtoBuilder> {
  @BuiltValueField(wireName: r'publishedAt')
  DateTime? get publishedAt;

  AdminArticlePublishDto._();

  factory AdminArticlePublishDto([void updates(AdminArticlePublishDtoBuilder b)]) = _$AdminArticlePublishDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticlePublishDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticlePublishDto> get serializer => _$AdminArticlePublishDtoSerializer();
}

class _$AdminArticlePublishDtoSerializer implements PrimitiveSerializer<AdminArticlePublishDto> {
  @override
  final Iterable<Type> types = const [AdminArticlePublishDto, _$AdminArticlePublishDto];

  @override
  final String wireName = r'AdminArticlePublishDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticlePublishDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.publishedAt != null) {
      yield r'publishedAt';
      yield serializers.serialize(
        object.publishedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminArticlePublishDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticlePublishDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  AdminArticlePublishDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticlePublishDtoBuilder();
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


