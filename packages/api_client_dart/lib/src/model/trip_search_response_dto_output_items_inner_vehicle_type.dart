//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_items_inner_vehicle_type.g.dart';

/// TripSearchResponseDtoOutputItemsInnerVehicleType
///
/// Properties:
/// * [name] 
/// * [form] 
/// * [class_] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputItemsInnerVehicleType implements Built<TripSearchResponseDtoOutputItemsInnerVehicleType, TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'form')
  TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum get form;
  // enum formEnum {  SEATER,  SLEEPER,  CABIN,  };

  @BuiltValueField(wireName: r'class')
  TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum get class_;
  // enum class_Enum {  STANDARD,  LIMOUSINE,  };

  TripSearchResponseDtoOutputItemsInnerVehicleType._();

  factory TripSearchResponseDtoOutputItemsInnerVehicleType([void updates(TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder b)]) = _$TripSearchResponseDtoOutputItemsInnerVehicleType;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputItemsInnerVehicleType> get serializer => _$TripSearchResponseDtoOutputItemsInnerVehicleTypeSerializer();
}

class _$TripSearchResponseDtoOutputItemsInnerVehicleTypeSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputItemsInnerVehicleType> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputItemsInnerVehicleType, _$TripSearchResponseDtoOutputItemsInnerVehicleType];

  @override
  final String wireName = r'TripSearchResponseDtoOutputItemsInnerVehicleType';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInnerVehicleType object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'form';
    yield serializers.serialize(
      object.form,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum),
    );
    yield r'class';
    yield serializers.serialize(
      object.class_,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInnerVehicleType object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder result,
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
        case r'form':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum),
          ) as TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum;
          result.form = valueDes;
          break;
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum),
          ) as TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum;
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
  TripSearchResponseDtoOutputItemsInnerVehicleType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder();
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


class TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEATER')
  static const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum SEATER = _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SEATER;
  @BuiltValueEnumConst(wireName: r'SLEEPER')
  static const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum SLEEPER = _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SLEEPER;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum CABIN = _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_CABIN;

  static Serializer<TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum> get serializer => _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumSerializer;

  const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum._(String name): super(name);

  static BuiltSet<TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum> get values => _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumValues;
  static TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum valueOf(String name) => _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumValueOf(name);
}

class TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STANDARD')
  static const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum STANDARD = _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_STANDARD;
  @BuiltValueEnumConst(wireName: r'LIMOUSINE')
  static const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum LIMOUSINE = _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_LIMOUSINE;

  static Serializer<TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum> get serializer => _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnumSerializer;

  const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum._(String name): super(name);

  static BuiltSet<TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum> get values => _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnumValues;
  static TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum valueOf(String name) => _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnumValueOf(name);
}

