//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_name_preview_input_dto_stops_inner.g.dart';

/// RouteNamePreviewInputDtoStopsInner
///
/// Properties:
/// * [catalogStopPointId] 
/// * [stopPointId] 
/// * [note] 
/// * [allowPickup] 
/// * [allowDropoff] 
/// * [durationMinutesFromPrevious] 
@BuiltValue()
abstract class RouteNamePreviewInputDtoStopsInner implements Built<RouteNamePreviewInputDtoStopsInner, RouteNamePreviewInputDtoStopsInnerBuilder> {
  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'stopPointId')
  String? get stopPointId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  @BuiltValueField(wireName: r'durationMinutesFromPrevious')
  int? get durationMinutesFromPrevious;

  RouteNamePreviewInputDtoStopsInner._();

  factory RouteNamePreviewInputDtoStopsInner([void updates(RouteNamePreviewInputDtoStopsInnerBuilder b)]) = _$RouteNamePreviewInputDtoStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteNamePreviewInputDtoStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteNamePreviewInputDtoStopsInner> get serializer => _$RouteNamePreviewInputDtoStopsInnerSerializer();
}

class _$RouteNamePreviewInputDtoStopsInnerSerializer implements PrimitiveSerializer<RouteNamePreviewInputDtoStopsInner> {
  @override
  final Iterable<Type> types = const [RouteNamePreviewInputDtoStopsInner, _$RouteNamePreviewInputDtoStopsInner];

  @override
  final String wireName = r'RouteNamePreviewInputDtoStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteNamePreviewInputDtoStopsInner object, {
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
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'allowPickup';
    yield serializers.serialize(
      object.allowPickup,
      specifiedType: const FullType(bool),
    );
    yield r'allowDropoff';
    yield serializers.serialize(
      object.allowDropoff,
      specifiedType: const FullType(bool),
    );
    if (object.durationMinutesFromPrevious != null) {
      yield r'durationMinutesFromPrevious';
      yield serializers.serialize(
        object.durationMinutesFromPrevious,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteNamePreviewInputDtoStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteNamePreviewInputDtoStopsInnerBuilder result,
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
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'allowPickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowPickup = valueDes;
          break;
        case r'allowDropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowDropoff = valueDes;
          break;
        case r'durationMinutesFromPrevious':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationMinutesFromPrevious = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteNamePreviewInputDtoStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteNamePreviewInputDtoStopsInnerBuilder();
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


