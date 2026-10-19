//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/permission_page_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_page_dto_output.g.dart';

/// PermissionPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
@BuiltValue()
abstract class PermissionPageDtoOutput implements Built<PermissionPageDtoOutput, PermissionPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PermissionPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  PermissionPageDtoOutput._();

  factory PermissionPageDtoOutput([void updates(PermissionPageDtoOutputBuilder b)]) = _$PermissionPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionPageDtoOutput> get serializer => _$PermissionPageDtoOutputSerializer();
}

class _$PermissionPageDtoOutputSerializer implements PrimitiveSerializer<PermissionPageDtoOutput> {
  @override
  final Iterable<Type> types = const [PermissionPageDtoOutput, _$PermissionPageDtoOutput];

  @override
  final String wireName = r'PermissionPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PermissionPageDtoOutputItemsInner)]),
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
    PermissionPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PermissionPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PermissionPageDtoOutputItemsInner)]),
          ) as BuiltList<PermissionPageDtoOutputItemsInner>;
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
  PermissionPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionPageDtoOutputBuilder();
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


