//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_content_item_dto_output.g.dart';

/// PublicContentItemDtoOutput
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
abstract class PublicContentItemDtoOutput implements Built<PublicContentItemDtoOutput, PublicContentItemDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  PublicContentItemDtoOutputTypeEnum get type;
  // enum typeEnum {  FAQ,  BANNER,  PAGE,  };

  @BuiltValueField(wireName: r'placement')
  PublicContentItemDtoOutputPlacementEnum get placement;
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

  PublicContentItemDtoOutput._();

  factory PublicContentItemDtoOutput([void updates(PublicContentItemDtoOutputBuilder b)]) = _$PublicContentItemDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicContentItemDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicContentItemDtoOutput> get serializer => _$PublicContentItemDtoOutputSerializer();
}

class _$PublicContentItemDtoOutputSerializer implements PrimitiveSerializer<PublicContentItemDtoOutput> {
  @override
  final Iterable<Type> types = const [PublicContentItemDtoOutput, _$PublicContentItemDtoOutput];

  @override
  final String wireName = r'PublicContentItemDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicContentItemDtoOutput object, {
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
      specifiedType: const FullType(PublicContentItemDtoOutputTypeEnum),
    );
    yield r'placement';
    yield serializers.serialize(
      object.placement,
      specifiedType: const FullType(PublicContentItemDtoOutputPlacementEnum),
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
    PublicContentItemDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicContentItemDtoOutputBuilder result,
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
            specifiedType: const FullType(PublicContentItemDtoOutputTypeEnum),
          ) as PublicContentItemDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'placement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicContentItemDtoOutputPlacementEnum),
          ) as PublicContentItemDtoOutputPlacementEnum;
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
  PublicContentItemDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicContentItemDtoOutputBuilder();
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


class PublicContentItemDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAQ')
  static const PublicContentItemDtoOutputTypeEnum FAQ = _$publicContentItemDtoOutputTypeEnum_FAQ;
  @BuiltValueEnumConst(wireName: r'BANNER')
  static const PublicContentItemDtoOutputTypeEnum BANNER = _$publicContentItemDtoOutputTypeEnum_BANNER;
  @BuiltValueEnumConst(wireName: r'PAGE')
  static const PublicContentItemDtoOutputTypeEnum PAGE = _$publicContentItemDtoOutputTypeEnum_PAGE;

  static Serializer<PublicContentItemDtoOutputTypeEnum> get serializer => _$publicContentItemDtoOutputTypeEnumSerializer;

  const PublicContentItemDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<PublicContentItemDtoOutputTypeEnum> get values => _$publicContentItemDtoOutputTypeEnumValues;
  static PublicContentItemDtoOutputTypeEnum valueOf(String name) => _$publicContentItemDtoOutputTypeEnumValueOf(name);
}

class PublicContentItemDtoOutputPlacementEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HOME')
  static const PublicContentItemDtoOutputPlacementEnum HOME = _$publicContentItemDtoOutputPlacementEnum_HOME;
  @BuiltValueEnumConst(wireName: r'FOOTER')
  static const PublicContentItemDtoOutputPlacementEnum FOOTER = _$publicContentItemDtoOutputPlacementEnum_FOOTER;
  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const PublicContentItemDtoOutputPlacementEnum BOOKING = _$publicContentItemDtoOutputPlacementEnum_BOOKING;
  @BuiltValueEnumConst(wireName: r'TICKET')
  static const PublicContentItemDtoOutputPlacementEnum TICKET = _$publicContentItemDtoOutputPlacementEnum_TICKET;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const PublicContentItemDtoOutputPlacementEnum ACCOUNT = _$publicContentItemDtoOutputPlacementEnum_ACCOUNT;

  static Serializer<PublicContentItemDtoOutputPlacementEnum> get serializer => _$publicContentItemDtoOutputPlacementEnumSerializer;

  const PublicContentItemDtoOutputPlacementEnum._(String name): super(name);

  static BuiltSet<PublicContentItemDtoOutputPlacementEnum> get values => _$publicContentItemDtoOutputPlacementEnumValues;
  static PublicContentItemDtoOutputPlacementEnum valueOf(String name) => _$publicContentItemDtoOutputPlacementEnumValueOf(name);
}

