//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/sales_office_assignments_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sales_office_assignments_dto_output.g.dart';

/// SalesOfficeAssignmentsDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class SalesOfficeAssignmentsDtoOutput implements Built<SalesOfficeAssignmentsDtoOutput, SalesOfficeAssignmentsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SalesOfficeAssignmentsDtoOutputItemsInner> get items;

  SalesOfficeAssignmentsDtoOutput._();

  factory SalesOfficeAssignmentsDtoOutput([void updates(SalesOfficeAssignmentsDtoOutputBuilder b)]) = _$SalesOfficeAssignmentsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalesOfficeAssignmentsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalesOfficeAssignmentsDtoOutput> get serializer => _$SalesOfficeAssignmentsDtoOutputSerializer();
}

class _$SalesOfficeAssignmentsDtoOutputSerializer implements PrimitiveSerializer<SalesOfficeAssignmentsDtoOutput> {
  @override
  final Iterable<Type> types = const [SalesOfficeAssignmentsDtoOutput, _$SalesOfficeAssignmentsDtoOutput];

  @override
  final String wireName = r'SalesOfficeAssignmentsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalesOfficeAssignmentsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SalesOfficeAssignmentsDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalesOfficeAssignmentsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalesOfficeAssignmentsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SalesOfficeAssignmentsDtoOutputItemsInner)]),
          ) as BuiltList<SalesOfficeAssignmentsDtoOutputItemsInner>;
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
  SalesOfficeAssignmentsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalesOfficeAssignmentsDtoOutputBuilder();
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


