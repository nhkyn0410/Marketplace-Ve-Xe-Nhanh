//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_category_input_dto.g.dart';

/// AdminArticleCategoryInputDto
///
/// Properties:
/// * [name] 
/// * [slug] 
/// * [displayOrder] 
/// * [status] 
@BuiltValue()
abstract class AdminArticleCategoryInputDto implements Built<AdminArticleCategoryInputDto, AdminArticleCategoryInputDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'status')
  AdminArticleCategoryInputDtoStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  AdminArticleCategoryInputDto._();

  factory AdminArticleCategoryInputDto([void updates(AdminArticleCategoryInputDtoBuilder b)]) = _$AdminArticleCategoryInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleCategoryInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleCategoryInputDto> get serializer => _$AdminArticleCategoryInputDtoSerializer();
}

class _$AdminArticleCategoryInputDtoSerializer implements PrimitiveSerializer<AdminArticleCategoryInputDto> {
  @override
  final Iterable<Type> types = const [AdminArticleCategoryInputDto, _$AdminArticleCategoryInputDto];

  @override
  final String wireName = r'AdminArticleCategoryInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleCategoryInputDto object, {
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
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminArticleCategoryInputDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminArticleCategoryInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleCategoryInputDtoBuilder result,
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
            specifiedType: const FullType(AdminArticleCategoryInputDtoStatusEnum),
          ) as AdminArticleCategoryInputDtoStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminArticleCategoryInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleCategoryInputDtoBuilder();
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


class AdminArticleCategoryInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminArticleCategoryInputDtoStatusEnum ACTIVE = _$adminArticleCategoryInputDtoStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminArticleCategoryInputDtoStatusEnum INACTIVE = _$adminArticleCategoryInputDtoStatusEnum_INACTIVE;

  static Serializer<AdminArticleCategoryInputDtoStatusEnum> get serializer => _$adminArticleCategoryInputDtoStatusEnumSerializer;

  const AdminArticleCategoryInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<AdminArticleCategoryInputDtoStatusEnum> get values => _$adminArticleCategoryInputDtoStatusEnumValues;
  static AdminArticleCategoryInputDtoStatusEnum valueOf(String name) => _$adminArticleCategoryInputDtoStatusEnumValueOf(name);
}

