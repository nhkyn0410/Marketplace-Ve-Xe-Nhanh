//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_catalog_rename_dto.g.dart';

/// AdminCatalogRenameDto
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class AdminCatalogRenameDto implements Built<AdminCatalogRenameDto, AdminCatalogRenameDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  AdminCatalogRenameDto._();

  factory AdminCatalogRenameDto([void updates(AdminCatalogRenameDtoBuilder b)]) = _$AdminCatalogRenameDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCatalogRenameDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCatalogRenameDto> get serializer => _$AdminCatalogRenameDtoSerializer();
}

class _$AdminCatalogRenameDtoSerializer implements PrimitiveSerializer<AdminCatalogRenameDto> {
  @override
  final Iterable<Type> types = const [AdminCatalogRenameDto, _$AdminCatalogRenameDto];

  @override
  final String wireName = r'AdminCatalogRenameDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCatalogRenameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCatalogRenameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminCatalogRenameDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCatalogRenameDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCatalogRenameDtoBuilder();
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


