//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_operator_vehicle_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_vehicle_list_dto_output.g.dart';

/// AdminOperatorVehicleListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AdminOperatorVehicleListDtoOutput implements Built<AdminOperatorVehicleListDtoOutput, AdminOperatorVehicleListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminOperatorVehicleListDtoOutputItemsInner> get items;

  AdminOperatorVehicleListDtoOutput._();

  factory AdminOperatorVehicleListDtoOutput([void updates(AdminOperatorVehicleListDtoOutputBuilder b)]) = _$AdminOperatorVehicleListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorVehicleListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorVehicleListDtoOutput> get serializer => _$AdminOperatorVehicleListDtoOutputSerializer();
}

class _$AdminOperatorVehicleListDtoOutputSerializer implements PrimitiveSerializer<AdminOperatorVehicleListDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminOperatorVehicleListDtoOutput, _$AdminOperatorVehicleListDtoOutput];

  @override
  final String wireName = r'AdminOperatorVehicleListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorVehicleListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminOperatorVehicleListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorVehicleListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorVehicleListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminOperatorVehicleListDtoOutputItemsInner)]),
          ) as BuiltList<AdminOperatorVehicleListDtoOutputItemsInner>;
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
  AdminOperatorVehicleListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorVehicleListDtoOutputBuilder();
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


