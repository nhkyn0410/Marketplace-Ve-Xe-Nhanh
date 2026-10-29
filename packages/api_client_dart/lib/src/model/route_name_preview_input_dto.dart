//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/route_name_preview_input_dto_stops_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_name_preview_input_dto.g.dart';

/// RouteNamePreviewInputDto
///
/// Properties:
/// * [stops] 
/// * [routeId] 
@BuiltValue()
abstract class RouteNamePreviewInputDto implements Built<RouteNamePreviewInputDto, RouteNamePreviewInputDtoBuilder> {
  @BuiltValueField(wireName: r'stops')
  BuiltList<RouteNamePreviewInputDtoStopsInner> get stops;

  @BuiltValueField(wireName: r'routeId')
  String? get routeId;

  RouteNamePreviewInputDto._();

  factory RouteNamePreviewInputDto([void updates(RouteNamePreviewInputDtoBuilder b)]) = _$RouteNamePreviewInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteNamePreviewInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteNamePreviewInputDto> get serializer => _$RouteNamePreviewInputDtoSerializer();
}

class _$RouteNamePreviewInputDtoSerializer implements PrimitiveSerializer<RouteNamePreviewInputDto> {
  @override
  final Iterable<Type> types = const [RouteNamePreviewInputDto, _$RouteNamePreviewInputDto];

  @override
  final String wireName = r'RouteNamePreviewInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteNamePreviewInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stops';
    yield serializers.serialize(
      object.stops,
      specifiedType: const FullType(BuiltList, [FullType(RouteNamePreviewInputDtoStopsInner)]),
    );
    if (object.routeId != null) {
      yield r'routeId';
      yield serializers.serialize(
        object.routeId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteNamePreviewInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteNamePreviewInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stops':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RouteNamePreviewInputDtoStopsInner)]),
          ) as BuiltList<RouteNamePreviewInputDtoStopsInner>;
          result.stops.replace(valueDes);
          break;
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.routeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteNamePreviewInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteNamePreviewInputDtoBuilder();
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


