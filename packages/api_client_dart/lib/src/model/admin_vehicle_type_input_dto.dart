//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vehicle_type_input_dto.g.dart';

/// AdminVehicleTypeInputDto
///
/// Properties:
/// * [code] 
/// * [name] 
/// * [description] 
/// * [form] 
/// * [class_] 
@BuiltValue()
abstract class AdminVehicleTypeInputDto implements Built<AdminVehicleTypeInputDto, AdminVehicleTypeInputDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'form')
  AdminVehicleTypeInputDtoFormEnum get form;
  // enum formEnum {  SEATER,  SLEEPER,  CABIN,  };

  @BuiltValueField(wireName: r'class')
  AdminVehicleTypeInputDtoClass_Enum get class_;
  // enum class_Enum {  STANDARD,  LIMOUSINE,  };

  AdminVehicleTypeInputDto._();

  factory AdminVehicleTypeInputDto([void updates(AdminVehicleTypeInputDtoBuilder b)]) = _$AdminVehicleTypeInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVehicleTypeInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVehicleTypeInputDto> get serializer => _$AdminVehicleTypeInputDtoSerializer();
}

class _$AdminVehicleTypeInputDtoSerializer implements PrimitiveSerializer<AdminVehicleTypeInputDto> {
  @override
  final Iterable<Type> types = const [AdminVehicleTypeInputDto, _$AdminVehicleTypeInputDto];

  @override
  final String wireName = r'AdminVehicleTypeInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVehicleTypeInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'form';
    yield serializers.serialize(
      object.form,
      specifiedType: const FullType(AdminVehicleTypeInputDtoFormEnum),
    );
    yield r'class';
    yield serializers.serialize(
      object.class_,
      specifiedType: const FullType(AdminVehicleTypeInputDtoClass_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVehicleTypeInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVehicleTypeInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(AdminVehicleTypeInputDtoFormEnum),
          ) as AdminVehicleTypeInputDtoFormEnum;
          result.form = valueDes;
          break;
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminVehicleTypeInputDtoClass_Enum),
          ) as AdminVehicleTypeInputDtoClass_Enum;
          result.class_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVehicleTypeInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVehicleTypeInputDtoBuilder();
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


class AdminVehicleTypeInputDtoFormEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEATER')
  static const AdminVehicleTypeInputDtoFormEnum SEATER = _$adminVehicleTypeInputDtoFormEnum_SEATER;
  @BuiltValueEnumConst(wireName: r'SLEEPER')
  static const AdminVehicleTypeInputDtoFormEnum SLEEPER = _$adminVehicleTypeInputDtoFormEnum_SLEEPER;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const AdminVehicleTypeInputDtoFormEnum CABIN = _$adminVehicleTypeInputDtoFormEnum_CABIN;

  static Serializer<AdminVehicleTypeInputDtoFormEnum> get serializer => _$adminVehicleTypeInputDtoFormEnumSerializer;

  const AdminVehicleTypeInputDtoFormEnum._(String name): super(name);

  static BuiltSet<AdminVehicleTypeInputDtoFormEnum> get values => _$adminVehicleTypeInputDtoFormEnumValues;
  static AdminVehicleTypeInputDtoFormEnum valueOf(String name) => _$adminVehicleTypeInputDtoFormEnumValueOf(name);
}

class AdminVehicleTypeInputDtoClass_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STANDARD')
  static const AdminVehicleTypeInputDtoClass_Enum STANDARD = _$adminVehicleTypeInputDtoClassEnum_STANDARD;
  @BuiltValueEnumConst(wireName: r'LIMOUSINE')
  static const AdminVehicleTypeInputDtoClass_Enum LIMOUSINE = _$adminVehicleTypeInputDtoClassEnum_LIMOUSINE;

  static Serializer<AdminVehicleTypeInputDtoClass_Enum> get serializer => _$adminVehicleTypeInputDtoClassEnumSerializer;

  const AdminVehicleTypeInputDtoClass_Enum._(String name): super(name);

  static BuiltSet<AdminVehicleTypeInputDtoClass_Enum> get values => _$adminVehicleTypeInputDtoClassEnumValues;
  static AdminVehicleTypeInputDtoClass_Enum valueOf(String name) => _$adminVehicleTypeInputDtoClassEnumValueOf(name);
}

