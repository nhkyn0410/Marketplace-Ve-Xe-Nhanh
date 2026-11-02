//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_employee_page_dto_output_items_inner.dart';
import 'package:api_client_dart/src/model/admin_vehicle_image_list_dto_output_operators_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_employee_page_dto_output.g.dart';

/// AdminEmployeePageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
/// * [operators] 
@BuiltValue()
abstract class AdminEmployeePageDtoOutput implements Built<AdminEmployeePageDtoOutput, AdminEmployeePageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminEmployeePageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'operators')
  BuiltList<AdminVehicleImageListDtoOutputOperatorsInner> get operators;

  AdminEmployeePageDtoOutput._();

  factory AdminEmployeePageDtoOutput([void updates(AdminEmployeePageDtoOutputBuilder b)]) = _$AdminEmployeePageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmployeePageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmployeePageDtoOutput> get serializer => _$AdminEmployeePageDtoOutputSerializer();
}

class _$AdminEmployeePageDtoOutputSerializer implements PrimitiveSerializer<AdminEmployeePageDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminEmployeePageDtoOutput, _$AdminEmployeePageDtoOutput];

  @override
  final String wireName = r'AdminEmployeePageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmployeePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminEmployeePageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'operators';
    yield serializers.serialize(
      object.operators,
      specifiedType: const FullType(BuiltList, [FullType(AdminVehicleImageListDtoOutputOperatorsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmployeePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminEmployeePageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminEmployeePageDtoOutputItemsInner)]),
          ) as BuiltList<AdminEmployeePageDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'operators':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminVehicleImageListDtoOutputOperatorsInner)]),
          ) as BuiltList<AdminVehicleImageListDtoOutputOperatorsInner>;
          result.operators.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmployeePageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmployeePageDtoOutputBuilder();
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


