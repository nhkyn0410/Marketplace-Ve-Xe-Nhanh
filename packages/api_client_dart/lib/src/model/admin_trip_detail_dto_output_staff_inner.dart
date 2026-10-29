//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_trip_detail_dto_output_staff_inner.g.dart';

/// AdminTripDetailDtoOutputStaffInner
///
/// Properties:
/// * [username] 
/// * [role] 
@BuiltValue()
abstract class AdminTripDetailDtoOutputStaffInner implements Built<AdminTripDetailDtoOutputStaffInner, AdminTripDetailDtoOutputStaffInnerBuilder> {
  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'role')
  AdminTripDetailDtoOutputStaffInnerRoleEnum get role;
  // enum roleEnum {  DRIVER,  TICKET_STAFF,  SUPPORT_STAFF,  SALES_STAFF,  };

  AdminTripDetailDtoOutputStaffInner._();

  factory AdminTripDetailDtoOutputStaffInner([void updates(AdminTripDetailDtoOutputStaffInnerBuilder b)]) = _$AdminTripDetailDtoOutputStaffInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTripDetailDtoOutputStaffInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTripDetailDtoOutputStaffInner> get serializer => _$AdminTripDetailDtoOutputStaffInnerSerializer();
}

class _$AdminTripDetailDtoOutputStaffInnerSerializer implements PrimitiveSerializer<AdminTripDetailDtoOutputStaffInner> {
  @override
  final Iterable<Type> types = const [AdminTripDetailDtoOutputStaffInner, _$AdminTripDetailDtoOutputStaffInner];

  @override
  final String wireName = r'AdminTripDetailDtoOutputStaffInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTripDetailDtoOutputStaffInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminTripDetailDtoOutputStaffInnerRoleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTripDetailDtoOutputStaffInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTripDetailDtoOutputStaffInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTripDetailDtoOutputStaffInnerRoleEnum),
          ) as AdminTripDetailDtoOutputStaffInnerRoleEnum;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTripDetailDtoOutputStaffInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTripDetailDtoOutputStaffInnerBuilder();
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


class AdminTripDetailDtoOutputStaffInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRIVER')
  static const AdminTripDetailDtoOutputStaffInnerRoleEnum DRIVER = _$adminTripDetailDtoOutputStaffInnerRoleEnum_DRIVER;
  @BuiltValueEnumConst(wireName: r'TICKET_STAFF')
  static const AdminTripDetailDtoOutputStaffInnerRoleEnum TICKET_STAFF = _$adminTripDetailDtoOutputStaffInnerRoleEnum_TICKET_STAFF;
  @BuiltValueEnumConst(wireName: r'SUPPORT_STAFF')
  static const AdminTripDetailDtoOutputStaffInnerRoleEnum SUPPORT_STAFF = _$adminTripDetailDtoOutputStaffInnerRoleEnum_SUPPORT_STAFF;
  @BuiltValueEnumConst(wireName: r'SALES_STAFF')
  static const AdminTripDetailDtoOutputStaffInnerRoleEnum SALES_STAFF = _$adminTripDetailDtoOutputStaffInnerRoleEnum_SALES_STAFF;

  static Serializer<AdminTripDetailDtoOutputStaffInnerRoleEnum> get serializer => _$adminTripDetailDtoOutputStaffInnerRoleEnumSerializer;

  const AdminTripDetailDtoOutputStaffInnerRoleEnum._(String name): super(name);

  static BuiltSet<AdminTripDetailDtoOutputStaffInnerRoleEnum> get values => _$adminTripDetailDtoOutputStaffInnerRoleEnumValues;
  static AdminTripDetailDtoOutputStaffInnerRoleEnum valueOf(String name) => _$adminTripDetailDtoOutputStaffInnerRoleEnumValueOf(name);
}

