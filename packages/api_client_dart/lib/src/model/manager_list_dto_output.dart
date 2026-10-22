//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/manager_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manager_list_dto_output.g.dart';

/// ManagerListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class ManagerListDtoOutput implements Built<ManagerListDtoOutput, ManagerListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ManagerListDtoOutputItemsInner> get items;

  ManagerListDtoOutput._();

  factory ManagerListDtoOutput([void updates(ManagerListDtoOutputBuilder b)]) = _$ManagerListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManagerListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManagerListDtoOutput> get serializer => _$ManagerListDtoOutputSerializer();
}

class _$ManagerListDtoOutputSerializer implements PrimitiveSerializer<ManagerListDtoOutput> {
  @override
  final Iterable<Type> types = const [ManagerListDtoOutput, _$ManagerListDtoOutput];

  @override
  final String wireName = r'ManagerListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManagerListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ManagerListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ManagerListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManagerListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ManagerListDtoOutputItemsInner)]),
          ) as BuiltList<ManagerListDtoOutputItemsInner>;
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
  ManagerListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManagerListDtoOutputBuilder();
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


