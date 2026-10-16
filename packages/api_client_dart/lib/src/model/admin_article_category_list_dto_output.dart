//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_article_category_list_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_category_list_dto_output.g.dart';

/// AdminArticleCategoryListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AdminArticleCategoryListDtoOutput implements Built<AdminArticleCategoryListDtoOutput, AdminArticleCategoryListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminArticleCategoryListDtoOutputItemsInner> get items;

  AdminArticleCategoryListDtoOutput._();

  factory AdminArticleCategoryListDtoOutput([void updates(AdminArticleCategoryListDtoOutputBuilder b)]) = _$AdminArticleCategoryListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleCategoryListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleCategoryListDtoOutput> get serializer => _$AdminArticleCategoryListDtoOutputSerializer();
}

class _$AdminArticleCategoryListDtoOutputSerializer implements PrimitiveSerializer<AdminArticleCategoryListDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminArticleCategoryListDtoOutput, _$AdminArticleCategoryListDtoOutput];

  @override
  final String wireName = r'AdminArticleCategoryListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleCategoryListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminArticleCategoryListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminArticleCategoryListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleCategoryListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminArticleCategoryListDtoOutputItemsInner)]),
          ) as BuiltList<AdminArticleCategoryListDtoOutputItemsInner>;
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
  AdminArticleCategoryListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleCategoryListDtoOutputBuilder();
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


