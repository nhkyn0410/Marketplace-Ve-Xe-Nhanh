//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_name_preview_dto_output.g.dart';

/// RouteNamePreviewDtoOutput
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class RouteNamePreviewDtoOutput implements Built<RouteNamePreviewDtoOutput, RouteNamePreviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  RouteNamePreviewDtoOutput._();

  factory RouteNamePreviewDtoOutput([void updates(RouteNamePreviewDtoOutputBuilder b)]) = _$RouteNamePreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteNamePreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteNamePreviewDtoOutput> get serializer => _$RouteNamePreviewDtoOutputSerializer();
}

class _$RouteNamePreviewDtoOutputSerializer implements PrimitiveSerializer<RouteNamePreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [RouteNamePreviewDtoOutput, _$RouteNamePreviewDtoOutput];

  @override
  final String wireName = r'RouteNamePreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteNamePreviewDtoOutput object, {
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
    RouteNamePreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteNamePreviewDtoOutputBuilder result,
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
  RouteNamePreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteNamePreviewDtoOutputBuilder();
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


