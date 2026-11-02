//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/content_page_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_page_page_dto_output.g.dart';

/// ContentPagePageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
@BuiltValue()
abstract class ContentPagePageDtoOutput implements Built<ContentPagePageDtoOutput, ContentPagePageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ContentPagePageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  ContentPagePageDtoOutput._();

  factory ContentPagePageDtoOutput([void updates(ContentPagePageDtoOutputBuilder b)]) = _$ContentPagePageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContentPagePageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContentPagePageDtoOutput> get serializer => _$ContentPagePageDtoOutputSerializer();
}

class _$ContentPagePageDtoOutputSerializer implements PrimitiveSerializer<ContentPagePageDtoOutput> {
  @override
  final Iterable<Type> types = const [ContentPagePageDtoOutput, _$ContentPagePageDtoOutput];

  @override
  final String wireName = r'ContentPagePageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContentPagePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ContentPagePageDtoOutputItemsInner)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ContentPagePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContentPagePageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ContentPagePageDtoOutputItemsInner)]),
          ) as BuiltList<ContentPagePageDtoOutputItemsInner>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContentPagePageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContentPagePageDtoOutputBuilder();
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


