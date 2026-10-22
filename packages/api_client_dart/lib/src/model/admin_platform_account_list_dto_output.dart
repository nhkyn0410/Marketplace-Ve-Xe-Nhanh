//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_platform_account_list_dto_output_grantable.dart';
import 'package:api_client_dart/src/model/admin_platform_account_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_platform_account_list_dto_output.g.dart';

/// AdminPlatformAccountListDtoOutput
///
/// Properties:
/// * [items] 
/// * [grantable] 
@BuiltValue()
abstract class AdminPlatformAccountListDtoOutput implements Built<AdminPlatformAccountListDtoOutput, AdminPlatformAccountListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminPlatformAccountListDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'grantable')
  AdminPlatformAccountListDtoOutputGrantable get grantable;

  AdminPlatformAccountListDtoOutput._();

  factory AdminPlatformAccountListDtoOutput([void updates(AdminPlatformAccountListDtoOutputBuilder b)]) = _$AdminPlatformAccountListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPlatformAccountListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPlatformAccountListDtoOutput> get serializer => _$AdminPlatformAccountListDtoOutputSerializer();
}

class _$AdminPlatformAccountListDtoOutputSerializer implements PrimitiveSerializer<AdminPlatformAccountListDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminPlatformAccountListDtoOutput, _$AdminPlatformAccountListDtoOutput];

  @override
  final String wireName = r'AdminPlatformAccountListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPlatformAccountListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputItemsInner)]),
    );
    yield r'grantable';
    yield serializers.serialize(
      object.grantable,
      specifiedType: const FullType(AdminPlatformAccountListDtoOutputGrantable),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPlatformAccountListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPlatformAccountListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputItemsInner)]),
          ) as BuiltList<AdminPlatformAccountListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'grantable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPlatformAccountListDtoOutputGrantable),
          ) as AdminPlatformAccountListDtoOutputGrantable;
          result.grantable.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPlatformAccountListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPlatformAccountListDtoOutputBuilder();
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


