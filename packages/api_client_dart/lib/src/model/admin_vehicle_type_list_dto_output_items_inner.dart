//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vehicle_type_list_dto_output_items_inner.g.dart';

/// AdminVehicleTypeListDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [status] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [description] 
/// * [form] 
/// * [class_] 
/// * [vehicleCount] 
/// * [operatorCount] 
/// * [fareRuleCount] 
@BuiltValue()
abstract class AdminVehicleTypeListDtoOutputItemsInner implements Built<AdminVehicleTypeListDtoOutputItemsInner, AdminVehicleTypeListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminVehicleTypeListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'form')
  AdminVehicleTypeListDtoOutputItemsInnerFormEnum get form;
  // enum formEnum {  SEATER,  SLEEPER,  CABIN,  };

  @BuiltValueField(wireName: r'class')
  AdminVehicleTypeListDtoOutputItemsInnerClass_Enum get class_;
  // enum class_Enum {  STANDARD,  LIMOUSINE,  };

  @BuiltValueField(wireName: r'vehicleCount')
  int get vehicleCount;

  @BuiltValueField(wireName: r'operatorCount')
  int get operatorCount;

  @BuiltValueField(wireName: r'fareRuleCount')
  int get fareRuleCount;

  AdminVehicleTypeListDtoOutputItemsInner._();

  factory AdminVehicleTypeListDtoOutputItemsInner([void updates(AdminVehicleTypeListDtoOutputItemsInnerBuilder b)]) = _$AdminVehicleTypeListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVehicleTypeListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVehicleTypeListDtoOutputItemsInner> get serializer => _$AdminVehicleTypeListDtoOutputItemsInnerSerializer();
}

class _$AdminVehicleTypeListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminVehicleTypeListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminVehicleTypeListDtoOutputItemsInner, _$AdminVehicleTypeListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminVehicleTypeListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVehicleTypeListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminVehicleTypeListDtoOutputItemsInnerStatusEnum),
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
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'form';
    yield serializers.serialize(
      object.form,
      specifiedType: const FullType(AdminVehicleTypeListDtoOutputItemsInnerFormEnum),
    );
    yield r'class';
    yield serializers.serialize(
      object.class_,
      specifiedType: const FullType(AdminVehicleTypeListDtoOutputItemsInnerClass_Enum),
    );
    yield r'vehicleCount';
    yield serializers.serialize(
      object.vehicleCount,
      specifiedType: const FullType(int),
    );
    yield r'operatorCount';
    yield serializers.serialize(
      object.operatorCount,
      specifiedType: const FullType(int),
    );
    yield r'fareRuleCount';
    yield serializers.serialize(
      object.fareRuleCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVehicleTypeListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVehicleTypeListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminVehicleTypeListDtoOutputItemsInnerStatusEnum),
          ) as AdminVehicleTypeListDtoOutputItemsInnerStatusEnum;
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'form':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminVehicleTypeListDtoOutputItemsInnerFormEnum),
          ) as AdminVehicleTypeListDtoOutputItemsInnerFormEnum;
          result.form = valueDes;
          break;
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminVehicleTypeListDtoOutputItemsInnerClass_Enum),
          ) as AdminVehicleTypeListDtoOutputItemsInnerClass_Enum;
          result.class_ = valueDes;
          break;
        case r'vehicleCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehicleCount = valueDes;
          break;
        case r'operatorCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.operatorCount = valueDes;
          break;
        case r'fareRuleCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fareRuleCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVehicleTypeListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVehicleTypeListDtoOutputItemsInnerBuilder();
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


class AdminVehicleTypeListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum ACTIVE = _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum INACTIVE = _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_INACTIVE;

  static Serializer<AdminVehicleTypeListDtoOutputItemsInnerStatusEnum> get serializer => _$adminVehicleTypeListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminVehicleTypeListDtoOutputItemsInnerStatusEnum> get values => _$adminVehicleTypeListDtoOutputItemsInnerStatusEnumValues;
  static AdminVehicleTypeListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminVehicleTypeListDtoOutputItemsInnerStatusEnumValueOf(name);
}

class AdminVehicleTypeListDtoOutputItemsInnerFormEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEATER')
  static const AdminVehicleTypeListDtoOutputItemsInnerFormEnum SEATER = _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SEATER;
  @BuiltValueEnumConst(wireName: r'SLEEPER')
  static const AdminVehicleTypeListDtoOutputItemsInnerFormEnum SLEEPER = _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SLEEPER;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const AdminVehicleTypeListDtoOutputItemsInnerFormEnum CABIN = _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_CABIN;

  static Serializer<AdminVehicleTypeListDtoOutputItemsInnerFormEnum> get serializer => _$adminVehicleTypeListDtoOutputItemsInnerFormEnumSerializer;

  const AdminVehicleTypeListDtoOutputItemsInnerFormEnum._(String name): super(name);

  static BuiltSet<AdminVehicleTypeListDtoOutputItemsInnerFormEnum> get values => _$adminVehicleTypeListDtoOutputItemsInnerFormEnumValues;
  static AdminVehicleTypeListDtoOutputItemsInnerFormEnum valueOf(String name) => _$adminVehicleTypeListDtoOutputItemsInnerFormEnumValueOf(name);
}

class AdminVehicleTypeListDtoOutputItemsInnerClass_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STANDARD')
  static const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum STANDARD = _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_STANDARD;
  @BuiltValueEnumConst(wireName: r'LIMOUSINE')
  static const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum LIMOUSINE = _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_LIMOUSINE;

  static Serializer<AdminVehicleTypeListDtoOutputItemsInnerClass_Enum> get serializer => _$adminVehicleTypeListDtoOutputItemsInnerClassEnumSerializer;

  const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum._(String name): super(name);

  static BuiltSet<AdminVehicleTypeListDtoOutputItemsInnerClass_Enum> get values => _$adminVehicleTypeListDtoOutputItemsInnerClassEnumValues;
  static AdminVehicleTypeListDtoOutputItemsInnerClass_Enum valueOf(String name) => _$adminVehicleTypeListDtoOutputItemsInnerClassEnumValueOf(name);
}

