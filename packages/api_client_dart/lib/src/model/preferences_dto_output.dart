//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/preferences_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'preferences_dto_output.g.dart';

/// PreferencesDtoOutput
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class PreferencesDtoOutput
    implements Built<PreferencesDtoOutput, PreferencesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PreferencesDtoOutputItemsInner> get items;

  PreferencesDtoOutput._();

  factory PreferencesDtoOutput([void updates(PreferencesDtoOutputBuilder b)]) =
      _$PreferencesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PreferencesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PreferencesDtoOutput> get serializer =>
      _$PreferencesDtoOutputSerializer();
}

class _$PreferencesDtoOutputSerializer
    implements PrimitiveSerializer<PreferencesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    PreferencesDtoOutput,
    _$PreferencesDtoOutput
  ];

  @override
  final String wireName = r'PreferencesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PreferencesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(PreferencesDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PreferencesDtoOutput object, {
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
    required PreferencesDtoOutputBuilder result,
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
                BuiltList, [FullType(PreferencesDtoOutputItemsInner)]),
          ) as BuiltList<PreferencesDtoOutputItemsInner>;
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
  PreferencesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PreferencesDtoOutputBuilder();
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
