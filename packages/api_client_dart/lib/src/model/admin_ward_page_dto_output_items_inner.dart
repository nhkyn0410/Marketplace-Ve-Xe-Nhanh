//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ward_page_dto_output_items_inner.g.dart';

/// AdminWardPageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [status] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [provinceId] 
/// * [provinceName] 
/// * [stopPointCount] 
@BuiltValue()
abstract class AdminWardPageDtoOutputItemsInner implements Built<AdminWardPageDtoOutputItemsInner, AdminWardPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminWardPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'provinceId')
  String get provinceId;

  @BuiltValueField(wireName: r'provinceName')
  String get provinceName;

  @BuiltValueField(wireName: r'stopPointCount')
  int get stopPointCount;

  AdminWardPageDtoOutputItemsInner._();

  factory AdminWardPageDtoOutputItemsInner([void updates(AdminWardPageDtoOutputItemsInnerBuilder b)]) = _$AdminWardPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminWardPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminWardPageDtoOutputItemsInner> get serializer => _$AdminWardPageDtoOutputItemsInnerSerializer();
}

class _$AdminWardPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminWardPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminWardPageDtoOutputItemsInner, _$AdminWardPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminWardPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminWardPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminWardPageDtoOutputItemsInnerStatusEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'provinceId';
    yield serializers.serialize(
      object.provinceId,
      specifiedType: const FullType(String),
    );
    yield r'provinceName';
    yield serializers.serialize(
      object.provinceName,
      specifiedType: const FullType(String),
    );
    yield r'stopPointCount';
    yield serializers.serialize(
      object.stopPointCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminWardPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminWardPageDtoOutputItemsInnerBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminWardPageDtoOutputItemsInnerStatusEnum),
          ) as AdminWardPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'provinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceId = valueDes;
          break;
        case r'provinceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceName = valueDes;
          break;
        case r'stopPointCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stopPointCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminWardPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminWardPageDtoOutputItemsInnerBuilder();
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


class AdminWardPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminWardPageDtoOutputItemsInnerStatusEnum ACTIVE = _$adminWardPageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminWardPageDtoOutputItemsInnerStatusEnum INACTIVE = _$adminWardPageDtoOutputItemsInnerStatusEnum_INACTIVE;

  static Serializer<AdminWardPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminWardPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminWardPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminWardPageDtoOutputItemsInnerStatusEnum> get values => _$adminWardPageDtoOutputItemsInnerStatusEnumValues;
  static AdminWardPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminWardPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

