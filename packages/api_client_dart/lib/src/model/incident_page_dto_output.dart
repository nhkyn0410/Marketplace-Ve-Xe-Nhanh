//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/incident_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incident_page_dto_output.g.dart';

/// IncidentPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class IncidentPageDtoOutput implements Built<IncidentPageDtoOutput, IncidentPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<IncidentPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  IncidentPageDtoOutput._();

  factory IncidentPageDtoOutput([void updates(IncidentPageDtoOutputBuilder b)]) = _$IncidentPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncidentPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IncidentPageDtoOutput> get serializer => _$IncidentPageDtoOutputSerializer();
}

class _$IncidentPageDtoOutputSerializer implements PrimitiveSerializer<IncidentPageDtoOutput> {
  @override
  final Iterable<Type> types = const [IncidentPageDtoOutput, _$IncidentPageDtoOutput];

  @override
  final String wireName = r'IncidentPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncidentPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(IncidentPageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IncidentPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IncidentPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(IncidentPageDtoOutputItemsInner)]),
          ) as BuiltList<IncidentPageDtoOutputItemsInner>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IncidentPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncidentPageDtoOutputBuilder();
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


