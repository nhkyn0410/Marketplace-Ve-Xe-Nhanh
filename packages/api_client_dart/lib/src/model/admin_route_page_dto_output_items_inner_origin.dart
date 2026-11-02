//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_route_page_dto_output_items_inner_origin.g.dart';

/// AdminRoutePageDtoOutputItemsInnerOrigin
///
/// Properties:
/// * [id] 
/// * [name] 
@BuiltValue()
abstract class AdminRoutePageDtoOutputItemsInnerOrigin implements Built<AdminRoutePageDtoOutputItemsInnerOrigin, AdminRoutePageDtoOutputItemsInnerOriginBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminRoutePageDtoOutputItemsInnerOrigin._();

  factory AdminRoutePageDtoOutputItemsInnerOrigin([void updates(AdminRoutePageDtoOutputItemsInnerOriginBuilder b)]) = _$AdminRoutePageDtoOutputItemsInnerOrigin;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRoutePageDtoOutputItemsInnerOriginBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRoutePageDtoOutputItemsInnerOrigin> get serializer => _$AdminRoutePageDtoOutputItemsInnerOriginSerializer();
}

class _$AdminRoutePageDtoOutputItemsInnerOriginSerializer implements PrimitiveSerializer<AdminRoutePageDtoOutputItemsInnerOrigin> {
  @override
  final Iterable<Type> types = const [AdminRoutePageDtoOutputItemsInnerOrigin, _$AdminRoutePageDtoOutputItemsInnerOrigin];

  @override
  final String wireName = r'AdminRoutePageDtoOutputItemsInnerOrigin';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRoutePageDtoOutputItemsInnerOrigin object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRoutePageDtoOutputItemsInnerOrigin object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRoutePageDtoOutputItemsInnerOriginBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
  AdminRoutePageDtoOutputItemsInnerOrigin deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRoutePageDtoOutputItemsInnerOriginBuilder();
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


