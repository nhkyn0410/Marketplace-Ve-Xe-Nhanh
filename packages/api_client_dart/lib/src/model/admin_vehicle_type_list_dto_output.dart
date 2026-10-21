//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_vehicle_type_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vehicle_type_list_dto_output.g.dart';

/// AdminVehicleTypeListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AdminVehicleTypeListDtoOutput implements Built<AdminVehicleTypeListDtoOutput, AdminVehicleTypeListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminVehicleTypeListDtoOutputItemsInner> get items;

  AdminVehicleTypeListDtoOutput._();

  factory AdminVehicleTypeListDtoOutput([void updates(AdminVehicleTypeListDtoOutputBuilder b)]) = _$AdminVehicleTypeListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVehicleTypeListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVehicleTypeListDtoOutput> get serializer => _$AdminVehicleTypeListDtoOutputSerializer();
}

class _$AdminVehicleTypeListDtoOutputSerializer implements PrimitiveSerializer<AdminVehicleTypeListDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminVehicleTypeListDtoOutput, _$AdminVehicleTypeListDtoOutput];

  @override
  final String wireName = r'AdminVehicleTypeListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVehicleTypeListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminVehicleTypeListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVehicleTypeListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVehicleTypeListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminVehicleTypeListDtoOutputItemsInner)]),
          ) as BuiltList<AdminVehicleTypeListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVehicleTypeListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVehicleTypeListDtoOutputBuilder();
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


