//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/assignee_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assignee_list_dto_output.g.dart';

/// AssigneeListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AssigneeListDtoOutput implements Built<AssigneeListDtoOutput, AssigneeListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AssigneeListDtoOutputItemsInner> get items;

  AssigneeListDtoOutput._();

  factory AssigneeListDtoOutput([void updates(AssigneeListDtoOutputBuilder b)]) = _$AssigneeListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssigneeListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssigneeListDtoOutput> get serializer => _$AssigneeListDtoOutputSerializer();
}

class _$AssigneeListDtoOutputSerializer implements PrimitiveSerializer<AssigneeListDtoOutput> {
  @override
  final Iterable<Type> types = const [AssigneeListDtoOutput, _$AssigneeListDtoOutput];

  @override
  final String wireName = r'AssigneeListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssigneeListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AssigneeListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssigneeListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssigneeListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssigneeListDtoOutputItemsInner)]),
          ) as BuiltList<AssigneeListDtoOutputItemsInner>;
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
  AssigneeListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssigneeListDtoOutputBuilder();
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


