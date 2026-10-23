//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_employee_page_dto_output_items_inner.g.dart';

/// AdminEmployeePageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [username] 
/// * [email] 
/// * [operatorId] 
/// * [operatorName] 
/// * [role] 
/// * [status] 
/// * [lastLoginAt] 
@BuiltValue()
abstract class AdminEmployeePageDtoOutputItemsInner implements Built<AdminEmployeePageDtoOutputItemsInner, AdminEmployeePageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'role')
  AdminEmployeePageDtoOutputItemsInnerRoleEnum get role;
  // enum roleEnum {  DRIVER,  TICKET_STAFF,  SUPPORT_STAFF,  };

  @BuiltValueField(wireName: r'status')
  AdminEmployeePageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime? get lastLoginAt;

  AdminEmployeePageDtoOutputItemsInner._();

  factory AdminEmployeePageDtoOutputItemsInner([void updates(AdminEmployeePageDtoOutputItemsInnerBuilder b)]) = _$AdminEmployeePageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmployeePageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmployeePageDtoOutputItemsInner> get serializer => _$AdminEmployeePageDtoOutputItemsInnerSerializer();
}

class _$AdminEmployeePageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminEmployeePageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminEmployeePageDtoOutputItemsInner, _$AdminEmployeePageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminEmployeePageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmployeePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminEmployeePageDtoOutputItemsInnerRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminEmployeePageDtoOutputItemsInnerStatusEnum),
    );
    yield r'lastLoginAt';
    yield object.lastLoginAt == null ? null : serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmployeePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminEmployeePageDtoOutputItemsInnerBuilder result,
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
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminEmployeePageDtoOutputItemsInnerRoleEnum),
          ) as AdminEmployeePageDtoOutputItemsInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminEmployeePageDtoOutputItemsInnerStatusEnum),
          ) as AdminEmployeePageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'lastLoginAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastLoginAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmployeePageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmployeePageDtoOutputItemsInnerBuilder();
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


class AdminEmployeePageDtoOutputItemsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRIVER')
  static const AdminEmployeePageDtoOutputItemsInnerRoleEnum DRIVER = _$adminEmployeePageDtoOutputItemsInnerRoleEnum_DRIVER;
  @BuiltValueEnumConst(wireName: r'TICKET_STAFF')
  static const AdminEmployeePageDtoOutputItemsInnerRoleEnum TICKET_STAFF = _$adminEmployeePageDtoOutputItemsInnerRoleEnum_TICKET_STAFF;
  @BuiltValueEnumConst(wireName: r'SUPPORT_STAFF')
  static const AdminEmployeePageDtoOutputItemsInnerRoleEnum SUPPORT_STAFF = _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SUPPORT_STAFF;

  static Serializer<AdminEmployeePageDtoOutputItemsInnerRoleEnum> get serializer => _$adminEmployeePageDtoOutputItemsInnerRoleEnumSerializer;

  const AdminEmployeePageDtoOutputItemsInnerRoleEnum._(String name): super(name);

  static BuiltSet<AdminEmployeePageDtoOutputItemsInnerRoleEnum> get values => _$adminEmployeePageDtoOutputItemsInnerRoleEnumValues;
  static AdminEmployeePageDtoOutputItemsInnerRoleEnum valueOf(String name) => _$adminEmployeePageDtoOutputItemsInnerRoleEnumValueOf(name);
}

class AdminEmployeePageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminEmployeePageDtoOutputItemsInnerStatusEnum ACTIVE = _$adminEmployeePageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminEmployeePageDtoOutputItemsInnerStatusEnum LOCKED = _$adminEmployeePageDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminEmployeePageDtoOutputItemsInnerStatusEnum DISABLED = _$adminEmployeePageDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<AdminEmployeePageDtoOutputItemsInnerStatusEnum> get serializer => _$adminEmployeePageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminEmployeePageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminEmployeePageDtoOutputItemsInnerStatusEnum> get values => _$adminEmployeePageDtoOutputItemsInnerStatusEnumValues;
  static AdminEmployeePageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminEmployeePageDtoOutputItemsInnerStatusEnumValueOf(name);
}

