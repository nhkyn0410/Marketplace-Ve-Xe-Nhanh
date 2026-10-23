//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incident_resolution_dto.g.dart';

/// IncidentResolutionDto
///
/// Properties:
/// * [resolution] 
@BuiltValue()
abstract class IncidentResolutionDto implements Built<IncidentResolutionDto, IncidentResolutionDtoBuilder> {
  @BuiltValueField(wireName: r'resolution')
  String get resolution;

  IncidentResolutionDto._();

  factory IncidentResolutionDto([void updates(IncidentResolutionDtoBuilder b)]) = _$IncidentResolutionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncidentResolutionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IncidentResolutionDto> get serializer => _$IncidentResolutionDtoSerializer();
}

class _$IncidentResolutionDtoSerializer implements PrimitiveSerializer<IncidentResolutionDto> {
  @override
  final Iterable<Type> types = const [IncidentResolutionDto, _$IncidentResolutionDto];

  @override
  final String wireName = r'IncidentResolutionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncidentResolutionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'resolution';
    yield serializers.serialize(
      object.resolution,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IncidentResolutionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IncidentResolutionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resolution = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IncidentResolutionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncidentResolutionDtoBuilder();
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


