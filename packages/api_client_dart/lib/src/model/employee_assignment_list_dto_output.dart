//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/employee_assignment_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_assignment_list_dto_output.g.dart';

/// EmployeeAssignmentListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class EmployeeAssignmentListDtoOutput implements Built<EmployeeAssignmentListDtoOutput, EmployeeAssignmentListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<EmployeeAssignmentListDtoOutputItemsInner> get items;

  EmployeeAssignmentListDtoOutput._();

  factory EmployeeAssignmentListDtoOutput([void updates(EmployeeAssignmentListDtoOutputBuilder b)]) = _$EmployeeAssignmentListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeAssignmentListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeAssignmentListDtoOutput> get serializer => _$EmployeeAssignmentListDtoOutputSerializer();
}

class _$EmployeeAssignmentListDtoOutputSerializer implements PrimitiveSerializer<EmployeeAssignmentListDtoOutput> {
  @override
  final Iterable<Type> types = const [EmployeeAssignmentListDtoOutput, _$EmployeeAssignmentListDtoOutput];

  @override
  final String wireName = r'EmployeeAssignmentListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeAssignmentListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(EmployeeAssignmentListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeAssignmentListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeAssignmentListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmployeeAssignmentListDtoOutputItemsInner)]),
          ) as BuiltList<EmployeeAssignmentListDtoOutputItemsInner>;
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
  EmployeeAssignmentListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeAssignmentListDtoOutputBuilder();
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


