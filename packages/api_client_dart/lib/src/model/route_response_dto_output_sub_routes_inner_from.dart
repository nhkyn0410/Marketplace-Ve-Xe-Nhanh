//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_response_dto_output_sub_routes_inner_from.g.dart';

/// RouteResponseDtoOutputSubRoutesInnerFrom
///
/// Properties:
/// * [catalogStopPointId] 
/// * [stopPointId] 
/// * [name] 
@BuiltValue()
abstract class RouteResponseDtoOutputSubRoutesInnerFrom implements Built<RouteResponseDtoOutputSubRoutesInnerFrom, RouteResponseDtoOutputSubRoutesInnerFromBuilder> {
  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'stopPointId')
  String? get stopPointId;

  @BuiltValueField(wireName: r'name')
  String get name;

  RouteResponseDtoOutputSubRoutesInnerFrom._();

  factory RouteResponseDtoOutputSubRoutesInnerFrom([void updates(RouteResponseDtoOutputSubRoutesInnerFromBuilder b)]) = _$RouteResponseDtoOutputSubRoutesInnerFrom;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteResponseDtoOutputSubRoutesInnerFromBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteResponseDtoOutputSubRoutesInnerFrom> get serializer => _$RouteResponseDtoOutputSubRoutesInnerFromSerializer();
}

class _$RouteResponseDtoOutputSubRoutesInnerFromSerializer implements PrimitiveSerializer<RouteResponseDtoOutputSubRoutesInnerFrom> {
  @override
  final Iterable<Type> types = const [RouteResponseDtoOutputSubRoutesInnerFrom, _$RouteResponseDtoOutputSubRoutesInnerFrom];

  @override
  final String wireName = r'RouteResponseDtoOutputSubRoutesInnerFrom';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteResponseDtoOutputSubRoutesInnerFrom object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'catalogStopPointId';
    yield object.catalogStopPointId == null ? null : serializers.serialize(
      object.catalogStopPointId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stopPointId';
    yield object.stopPointId == null ? null : serializers.serialize(
      object.stopPointId,
      specifiedType: const FullType.nullable(String),
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
    RouteResponseDtoOutputSubRoutesInnerFrom object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteResponseDtoOutputSubRoutesInnerFromBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'catalogStopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.catalogStopPointId = valueDes;
          break;
        case r'stopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stopPointId = valueDes;
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
  RouteResponseDtoOutputSubRoutesInnerFrom deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteResponseDtoOutputSubRoutesInnerFromBuilder();
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


