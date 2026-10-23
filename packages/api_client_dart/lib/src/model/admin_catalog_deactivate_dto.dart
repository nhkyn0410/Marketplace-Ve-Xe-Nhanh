//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_catalog_deactivate_dto.g.dart';

/// AdminCatalogDeactivateDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class AdminCatalogDeactivateDto implements Built<AdminCatalogDeactivateDto, AdminCatalogDeactivateDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCatalogDeactivateDto._();

  factory AdminCatalogDeactivateDto([void updates(AdminCatalogDeactivateDtoBuilder b)]) = _$AdminCatalogDeactivateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCatalogDeactivateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCatalogDeactivateDto> get serializer => _$AdminCatalogDeactivateDtoSerializer();
}

class _$AdminCatalogDeactivateDtoSerializer implements PrimitiveSerializer<AdminCatalogDeactivateDto> {
  @override
  final Iterable<Type> types = const [AdminCatalogDeactivateDto, _$AdminCatalogDeactivateDto];

  @override
  final String wireName = r'AdminCatalogDeactivateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCatalogDeactivateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCatalogDeactivateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminCatalogDeactivateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCatalogDeactivateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCatalogDeactivateDtoBuilder();
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


