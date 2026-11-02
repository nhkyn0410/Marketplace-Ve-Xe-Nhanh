//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/public_content_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_content_list_dto_output.g.dart';

/// PublicContentListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class PublicContentListDtoOutput implements Built<PublicContentListDtoOutput, PublicContentListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PublicContentListDtoOutputItemsInner> get items;

  PublicContentListDtoOutput._();

  factory PublicContentListDtoOutput([void updates(PublicContentListDtoOutputBuilder b)]) = _$PublicContentListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicContentListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicContentListDtoOutput> get serializer => _$PublicContentListDtoOutputSerializer();
}

class _$PublicContentListDtoOutputSerializer implements PrimitiveSerializer<PublicContentListDtoOutput> {
  @override
  final Iterable<Type> types = const [PublicContentListDtoOutput, _$PublicContentListDtoOutput];

  @override
  final String wireName = r'PublicContentListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicContentListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PublicContentListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicContentListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicContentListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicContentListDtoOutputItemsInner)]),
          ) as BuiltList<PublicContentListDtoOutputItemsInner>;
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
  PublicContentListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicContentListDtoOutputBuilder();
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


