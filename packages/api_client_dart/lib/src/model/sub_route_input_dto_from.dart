//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sub_route_input_dto_from.g.dart';

/// SubRouteInputDtoFrom
///
/// Properties:
/// * [catalogStopPointId] 
/// * [stopPointId] 
@BuiltValue()
abstract class SubRouteInputDtoFrom implements Built<SubRouteInputDtoFrom, SubRouteInputDtoFromBuilder> {
  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'stopPointId')
  String? get stopPointId;

  SubRouteInputDtoFrom._();

  factory SubRouteInputDtoFrom([void updates(SubRouteInputDtoFromBuilder b)]) = _$SubRouteInputDtoFrom;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubRouteInputDtoFromBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubRouteInputDtoFrom> get serializer => _$SubRouteInputDtoFromSerializer();
}

class _$SubRouteInputDtoFromSerializer implements PrimitiveSerializer<SubRouteInputDtoFrom> {
  @override
  final Iterable<Type> types = const [SubRouteInputDtoFrom, _$SubRouteInputDtoFrom];

  @override
  final String wireName = r'SubRouteInputDtoFrom';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubRouteInputDtoFrom object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SubRouteInputDtoFrom object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubRouteInputDtoFromBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubRouteInputDtoFrom deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubRouteInputDtoFromBuilder();
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


