//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vehicle_image_list_dto_output_operators_inner.g.dart';

/// AdminVehicleImageListDtoOutputOperatorsInner
///
/// Properties:
/// * [id] 
/// * [name] 
@BuiltValue()
abstract class AdminVehicleImageListDtoOutputOperatorsInner implements Built<AdminVehicleImageListDtoOutputOperatorsInner, AdminVehicleImageListDtoOutputOperatorsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminVehicleImageListDtoOutputOperatorsInner._();

  factory AdminVehicleImageListDtoOutputOperatorsInner([void updates(AdminVehicleImageListDtoOutputOperatorsInnerBuilder b)]) = _$AdminVehicleImageListDtoOutputOperatorsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVehicleImageListDtoOutputOperatorsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVehicleImageListDtoOutputOperatorsInner> get serializer => _$AdminVehicleImageListDtoOutputOperatorsInnerSerializer();
}

class _$AdminVehicleImageListDtoOutputOperatorsInnerSerializer implements PrimitiveSerializer<AdminVehicleImageListDtoOutputOperatorsInner> {
  @override
  final Iterable<Type> types = const [AdminVehicleImageListDtoOutputOperatorsInner, _$AdminVehicleImageListDtoOutputOperatorsInner];

  @override
  final String wireName = r'AdminVehicleImageListDtoOutputOperatorsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVehicleImageListDtoOutputOperatorsInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVehicleImageListDtoOutputOperatorsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVehicleImageListDtoOutputOperatorsInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVehicleImageListDtoOutputOperatorsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVehicleImageListDtoOutputOperatorsInnerBuilder();
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


