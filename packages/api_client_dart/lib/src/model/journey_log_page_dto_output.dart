//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/journey_log_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journey_log_page_dto_output.g.dart';

/// JourneyLogPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class JourneyLogPageDtoOutput implements Built<JourneyLogPageDtoOutput, JourneyLogPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<JourneyLogPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  JourneyLogPageDtoOutput._();

  factory JourneyLogPageDtoOutput([void updates(JourneyLogPageDtoOutputBuilder b)]) = _$JourneyLogPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JourneyLogPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JourneyLogPageDtoOutput> get serializer => _$JourneyLogPageDtoOutputSerializer();
}

class _$JourneyLogPageDtoOutputSerializer implements PrimitiveSerializer<JourneyLogPageDtoOutput> {
  @override
  final Iterable<Type> types = const [JourneyLogPageDtoOutput, _$JourneyLogPageDtoOutput];

  @override
  final String wireName = r'JourneyLogPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JourneyLogPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(JourneyLogPageDtoOutputItemsInner)]),
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
    JourneyLogPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JourneyLogPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(JourneyLogPageDtoOutputItemsInner)]),
          ) as BuiltList<JourneyLogPageDtoOutputItemsInner>;
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
  JourneyLogPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JourneyLogPageDtoOutputBuilder();
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


