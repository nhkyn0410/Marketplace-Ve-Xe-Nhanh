//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_type_list_response_dto_output_items_inner.g.dart';

/// VehicleTypeListResponseDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [description] 
/// * [form] 
/// * [class_] 
@BuiltValue()
abstract class VehicleTypeListResponseDtoOutputItemsInner implements Built<VehicleTypeListResponseDtoOutputItemsInner, VehicleTypeListResponseDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'form')
  VehicleTypeListResponseDtoOutputItemsInnerFormEnum get form;
  // enum formEnum {  SEATER,  SLEEPER,  CABIN,  };

  @BuiltValueField(wireName: r'class')
  VehicleTypeListResponseDtoOutputItemsInnerClass_Enum get class_;
  // enum class_Enum {  STANDARD,  LIMOUSINE,  };

  VehicleTypeListResponseDtoOutputItemsInner._();

  factory VehicleTypeListResponseDtoOutputItemsInner([void updates(VehicleTypeListResponseDtoOutputItemsInnerBuilder b)]) = _$VehicleTypeListResponseDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleTypeListResponseDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleTypeListResponseDtoOutputItemsInner> get serializer => _$VehicleTypeListResponseDtoOutputItemsInnerSerializer();
}

class _$VehicleTypeListResponseDtoOutputItemsInnerSerializer implements PrimitiveSerializer<VehicleTypeListResponseDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [VehicleTypeListResponseDtoOutputItemsInner, _$VehicleTypeListResponseDtoOutputItemsInner];

  @override
  final String wireName = r'VehicleTypeListResponseDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleTypeListResponseDtoOutputItemsInner object, {
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
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'form';
    yield serializers.serialize(
      object.form,
      specifiedType: const FullType(VehicleTypeListResponseDtoOutputItemsInnerFormEnum),
    );
    yield r'class';
    yield serializers.serialize(
      object.class_,
      specifiedType: const FullType(VehicleTypeListResponseDtoOutputItemsInnerClass_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleTypeListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleTypeListResponseDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(VehicleTypeListResponseDtoOutputItemsInnerFormEnum),
          ) as VehicleTypeListResponseDtoOutputItemsInnerFormEnum;
          result.form = valueDes;
          break;
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VehicleTypeListResponseDtoOutputItemsInnerClass_Enum),
          ) as VehicleTypeListResponseDtoOutputItemsInnerClass_Enum;
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
  VehicleTypeListResponseDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleTypeListResponseDtoOutputItemsInnerBuilder();
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


class VehicleTypeListResponseDtoOutputItemsInnerFormEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEATER')
  static const VehicleTypeListResponseDtoOutputItemsInnerFormEnum SEATER = _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SEATER;
  @BuiltValueEnumConst(wireName: r'SLEEPER')
  static const VehicleTypeListResponseDtoOutputItemsInnerFormEnum SLEEPER = _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SLEEPER;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const VehicleTypeListResponseDtoOutputItemsInnerFormEnum CABIN = _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_CABIN;

  static Serializer<VehicleTypeListResponseDtoOutputItemsInnerFormEnum> get serializer => _$vehicleTypeListResponseDtoOutputItemsInnerFormEnumSerializer;

  const VehicleTypeListResponseDtoOutputItemsInnerFormEnum._(String name): super(name);

  static BuiltSet<VehicleTypeListResponseDtoOutputItemsInnerFormEnum> get values => _$vehicleTypeListResponseDtoOutputItemsInnerFormEnumValues;
  static VehicleTypeListResponseDtoOutputItemsInnerFormEnum valueOf(String name) => _$vehicleTypeListResponseDtoOutputItemsInnerFormEnumValueOf(name);
}

class VehicleTypeListResponseDtoOutputItemsInnerClass_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STANDARD')
  static const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum STANDARD = _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_STANDARD;
  @BuiltValueEnumConst(wireName: r'LIMOUSINE')
  static const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum LIMOUSINE = _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_LIMOUSINE;

  static Serializer<VehicleTypeListResponseDtoOutputItemsInnerClass_Enum> get serializer => _$vehicleTypeListResponseDtoOutputItemsInnerClassEnumSerializer;

  const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum._(String name): super(name);

  static BuiltSet<VehicleTypeListResponseDtoOutputItemsInnerClass_Enum> get values => _$vehicleTypeListResponseDtoOutputItemsInnerClassEnumValues;
  static VehicleTypeListResponseDtoOutputItemsInnerClass_Enum valueOf(String name) => _$vehicleTypeListResponseDtoOutputItemsInnerClassEnumValueOf(name);
}

