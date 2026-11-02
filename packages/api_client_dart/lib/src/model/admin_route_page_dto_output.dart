//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_route_page_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_route_page_dto_output_period.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_route_page_dto_output.g.dart';

/// AdminRoutePageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
/// * [period] 
@BuiltValue()
abstract class AdminRoutePageDtoOutput implements Built<AdminRoutePageDtoOutput, AdminRoutePageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminRoutePageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'period')
  AdminRoutePageDtoOutputPeriod get period;

  AdminRoutePageDtoOutput._();

  factory AdminRoutePageDtoOutput([void updates(AdminRoutePageDtoOutputBuilder b)]) = _$AdminRoutePageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRoutePageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRoutePageDtoOutput> get serializer => _$AdminRoutePageDtoOutputSerializer();
}

class _$AdminRoutePageDtoOutputSerializer implements PrimitiveSerializer<AdminRoutePageDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminRoutePageDtoOutput, _$AdminRoutePageDtoOutput];

  @override
  final String wireName = r'AdminRoutePageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRoutePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminRoutePageDtoOutputItemsInner)]),
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
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(AdminRoutePageDtoOutputPeriod),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRoutePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRoutePageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRoutePageDtoOutputItemsInner)]),
          ) as BuiltList<AdminRoutePageDtoOutputItemsInner>;
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
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRoutePageDtoOutputPeriod),
          ) as AdminRoutePageDtoOutputPeriod;
          result.period.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRoutePageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRoutePageDtoOutputBuilder();
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


