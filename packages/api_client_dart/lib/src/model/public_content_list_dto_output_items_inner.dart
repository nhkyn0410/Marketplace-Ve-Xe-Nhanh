//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_content_list_dto_output_items_inner.g.dart';

/// PublicContentListDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [placement] 
/// * [title] 
/// * [slug] 
/// * [bodyMarkdown] 
/// * [imageUrl] 
/// * [linkUrl] 
/// * [displayOrder] 
/// * [updatedAt] 
@BuiltValue()
abstract class PublicContentListDtoOutputItemsInner implements Built<PublicContentListDtoOutputItemsInner, PublicContentListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  PublicContentListDtoOutputItemsInnerTypeEnum get type;
  // enum typeEnum {  FAQ,  BANNER,  PAGE,  };

  @BuiltValueField(wireName: r'placement')
  PublicContentListDtoOutputItemsInnerPlacementEnum get placement;
  // enum placementEnum {  HOME,  FOOTER,  BOOKING,  TICKET,  ACCOUNT,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'bodyMarkdown')
  String get bodyMarkdown;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  @BuiltValueField(wireName: r'linkUrl')
  String? get linkUrl;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  PublicContentListDtoOutputItemsInner._();

  factory PublicContentListDtoOutputItemsInner([void updates(PublicContentListDtoOutputItemsInnerBuilder b)]) = _$PublicContentListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicContentListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicContentListDtoOutputItemsInner> get serializer => _$PublicContentListDtoOutputItemsInnerSerializer();
}

class _$PublicContentListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PublicContentListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PublicContentListDtoOutputItemsInner, _$PublicContentListDtoOutputItemsInner];

  @override
  final String wireName = r'PublicContentListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicContentListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PublicContentListDtoOutputItemsInnerTypeEnum),
    );
    yield r'placement';
    yield serializers.serialize(
      object.placement,
      specifiedType: const FullType(PublicContentListDtoOutputItemsInnerPlacementEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield object.slug == null ? null : serializers.serialize(
      object.slug,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bodyMarkdown';
    yield serializers.serialize(
      object.bodyMarkdown,
      specifiedType: const FullType(String),
    );
    yield r'imageUrl';
    yield object.imageUrl == null ? null : serializers.serialize(
      object.imageUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'linkUrl';
    yield object.linkUrl == null ? null : serializers.serialize(
      object.linkUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
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
    PublicContentListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicContentListDtoOutputItemsInnerBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicContentListDtoOutputItemsInnerTypeEnum),
          ) as PublicContentListDtoOutputItemsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'placement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicContentListDtoOutputItemsInnerPlacementEnum),
          ) as PublicContentListDtoOutputItemsInnerPlacementEnum;
          result.placement = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.slug = valueDes;
          break;
        case r'bodyMarkdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bodyMarkdown = valueDes;
          break;
        case r'imageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageUrl = valueDes;
          break;
        case r'linkUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.linkUrl = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
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
  PublicContentListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicContentListDtoOutputItemsInnerBuilder();
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


class PublicContentListDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAQ')
  static const PublicContentListDtoOutputItemsInnerTypeEnum FAQ = _$publicContentListDtoOutputItemsInnerTypeEnum_FAQ;
  @BuiltValueEnumConst(wireName: r'BANNER')
  static const PublicContentListDtoOutputItemsInnerTypeEnum BANNER = _$publicContentListDtoOutputItemsInnerTypeEnum_BANNER;
  @BuiltValueEnumConst(wireName: r'PAGE')
  static const PublicContentListDtoOutputItemsInnerTypeEnum PAGE = _$publicContentListDtoOutputItemsInnerTypeEnum_PAGE;

  static Serializer<PublicContentListDtoOutputItemsInnerTypeEnum> get serializer => _$publicContentListDtoOutputItemsInnerTypeEnumSerializer;

  const PublicContentListDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<PublicContentListDtoOutputItemsInnerTypeEnum> get values => _$publicContentListDtoOutputItemsInnerTypeEnumValues;
  static PublicContentListDtoOutputItemsInnerTypeEnum valueOf(String name) => _$publicContentListDtoOutputItemsInnerTypeEnumValueOf(name);
}

class PublicContentListDtoOutputItemsInnerPlacementEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HOME')
  static const PublicContentListDtoOutputItemsInnerPlacementEnum HOME = _$publicContentListDtoOutputItemsInnerPlacementEnum_HOME;
  @BuiltValueEnumConst(wireName: r'FOOTER')
  static const PublicContentListDtoOutputItemsInnerPlacementEnum FOOTER = _$publicContentListDtoOutputItemsInnerPlacementEnum_FOOTER;
  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const PublicContentListDtoOutputItemsInnerPlacementEnum BOOKING = _$publicContentListDtoOutputItemsInnerPlacementEnum_BOOKING;
  @BuiltValueEnumConst(wireName: r'TICKET')
  static const PublicContentListDtoOutputItemsInnerPlacementEnum TICKET = _$publicContentListDtoOutputItemsInnerPlacementEnum_TICKET;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const PublicContentListDtoOutputItemsInnerPlacementEnum ACCOUNT = _$publicContentListDtoOutputItemsInnerPlacementEnum_ACCOUNT;

  static Serializer<PublicContentListDtoOutputItemsInnerPlacementEnum> get serializer => _$publicContentListDtoOutputItemsInnerPlacementEnumSerializer;

  const PublicContentListDtoOutputItemsInnerPlacementEnum._(String name): super(name);

  static BuiltSet<PublicContentListDtoOutputItemsInnerPlacementEnum> get values => _$publicContentListDtoOutputItemsInnerPlacementEnumValues;
  static PublicContentListDtoOutputItemsInnerPlacementEnum valueOf(String name) => _$publicContentListDtoOutputItemsInnerPlacementEnumValueOf(name);
}

