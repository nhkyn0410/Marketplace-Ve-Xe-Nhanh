//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/reconciliation_page_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reconciliation_page_dto_output.g.dart';

/// ReconciliationPageDtoOutput
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class ReconciliationPageDtoOutput
    implements
        Built<ReconciliationPageDtoOutput, ReconciliationPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ReconciliationPageDtoOutputItemsInner> get items;

  ReconciliationPageDtoOutput._();

  factory ReconciliationPageDtoOutput(
          [void updates(ReconciliationPageDtoOutputBuilder b)]) =
      _$ReconciliationPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReconciliationPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReconciliationPageDtoOutput> get serializer =>
      _$ReconciliationPageDtoOutputSerializer();
}

class _$ReconciliationPageDtoOutputSerializer
    implements PrimitiveSerializer<ReconciliationPageDtoOutput> {
  @override
  final Iterable<Type> types = const [
    ReconciliationPageDtoOutput,
    _$ReconciliationPageDtoOutput
  ];

  @override
  final String wireName = r'ReconciliationPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReconciliationPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(ReconciliationPageDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReconciliationPageDtoOutput object, {
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
    required ReconciliationPageDtoOutputBuilder result,
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
                BuiltList, [FullType(ReconciliationPageDtoOutputItemsInner)]),
          ) as BuiltList<ReconciliationPageDtoOutputItemsInner>;
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
  ReconciliationPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReconciliationPageDtoOutputBuilder();
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
