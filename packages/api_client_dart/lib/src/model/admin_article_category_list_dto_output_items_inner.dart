//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_category_list_dto_output_items_inner.g.dart';

/// AdminArticleCategoryListDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [slug] 
/// * [displayOrder] 
/// * [status] 
/// * [articleCount] 
@BuiltValue()
abstract class AdminArticleCategoryListDtoOutputItemsInner implements Built<AdminArticleCategoryListDtoOutputItemsInner, AdminArticleCategoryListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'status')
  AdminArticleCategoryListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'articleCount')
  int get articleCount;

  AdminArticleCategoryListDtoOutputItemsInner._();

  factory AdminArticleCategoryListDtoOutputItemsInner([void updates(AdminArticleCategoryListDtoOutputItemsInnerBuilder b)]) = _$AdminArticleCategoryListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleCategoryListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleCategoryListDtoOutputItemsInner> get serializer => _$AdminArticleCategoryListDtoOutputItemsInnerSerializer();
}

class _$AdminArticleCategoryListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminArticleCategoryListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminArticleCategoryListDtoOutputItemsInner, _$AdminArticleCategoryListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminArticleCategoryListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleCategoryListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminArticleCategoryListDtoOutputItemsInnerStatusEnum),
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
    AdminArticleCategoryListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleCategoryListDtoOutputItemsInnerBuilder result,
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
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminArticleCategoryListDtoOutputItemsInnerStatusEnum),
          ) as AdminArticleCategoryListDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
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
  AdminArticleCategoryListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleCategoryListDtoOutputItemsInnerBuilder();
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


class AdminArticleCategoryListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum ACTIVE = _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum INACTIVE = _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_INACTIVE;

  static Serializer<AdminArticleCategoryListDtoOutputItemsInnerStatusEnum> get serializer => _$adminArticleCategoryListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminArticleCategoryListDtoOutputItemsInnerStatusEnum> get values => _$adminArticleCategoryListDtoOutputItemsInnerStatusEnumValues;
  static AdminArticleCategoryListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminArticleCategoryListDtoOutputItemsInnerStatusEnumValueOf(name);
}

