//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/saved_passenger_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'saved_passenger_list_dto_output.g.dart';

/// SavedPassengerListDtoOutput
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class SavedPassengerListDtoOutput
    implements
        Built<SavedPassengerListDtoOutput, SavedPassengerListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SavedPassengerListDtoOutputItemsInner> get items;

  SavedPassengerListDtoOutput._();

  factory SavedPassengerListDtoOutput(
          [void updates(SavedPassengerListDtoOutputBuilder b)]) =
      _$SavedPassengerListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SavedPassengerListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SavedPassengerListDtoOutput> get serializer =>
      _$SavedPassengerListDtoOutputSerializer();
}

class _$SavedPassengerListDtoOutputSerializer
    implements PrimitiveSerializer<SavedPassengerListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    SavedPassengerListDtoOutput,
    _$SavedPassengerListDtoOutput
  ];

  @override
  final String wireName = r'SavedPassengerListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SavedPassengerListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(SavedPassengerListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SavedPassengerListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SavedPassengerListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(SavedPassengerListDtoOutputItemsInner)]),
          ) as BuiltList<SavedPassengerListDtoOutputItemsInner>;
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
  SavedPassengerListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SavedPassengerListDtoOutputBuilder();
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
