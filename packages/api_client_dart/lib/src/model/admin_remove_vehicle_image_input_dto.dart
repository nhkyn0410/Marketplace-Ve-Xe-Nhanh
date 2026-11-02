//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_remove_vehicle_image_input_dto.g.dart';

/// AdminRemoveVehicleImageInputDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class AdminRemoveVehicleImageInputDto implements Built<AdminRemoveVehicleImageInputDto, AdminRemoveVehicleImageInputDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRemoveVehicleImageInputDto._();

  factory AdminRemoveVehicleImageInputDto([void updates(AdminRemoveVehicleImageInputDtoBuilder b)]) = _$AdminRemoveVehicleImageInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRemoveVehicleImageInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRemoveVehicleImageInputDto> get serializer => _$AdminRemoveVehicleImageInputDtoSerializer();
}

class _$AdminRemoveVehicleImageInputDtoSerializer implements PrimitiveSerializer<AdminRemoveVehicleImageInputDto> {
  @override
  final Iterable<Type> types = const [AdminRemoveVehicleImageInputDto, _$AdminRemoveVehicleImageInputDto];

  @override
  final String wireName = r'AdminRemoveVehicleImageInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRemoveVehicleImageInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRemoveVehicleImageInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRemoveVehicleImageInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRemoveVehicleImageInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRemoveVehicleImageInputDtoBuilder();
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


