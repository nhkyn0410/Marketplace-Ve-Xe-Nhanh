//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journey_log_input_dto.g.dart';

/// JourneyLogInputDto
///
/// Properties:
/// * [tripId]
/// * [stopSequence]
/// * [actualAt]
/// * [vehicleStatus]
/// * [note]
@BuiltValue()
abstract class JourneyLogInputDto
    implements Built<JourneyLogInputDto, JourneyLogInputDtoBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'stopSequence')
  int? get stopSequence;

  @BuiltValueField(wireName: r'actualAt')
  DateTime get actualAt;

  @BuiltValueField(wireName: r'vehicleStatus')
  String? get vehicleStatus;

  @BuiltValueField(wireName: r'note')
  String? get note;

  JourneyLogInputDto._();

  factory JourneyLogInputDto([void updates(JourneyLogInputDtoBuilder b)]) =
      _$JourneyLogInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JourneyLogInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JourneyLogInputDto> get serializer =>
      _$JourneyLogInputDtoSerializer();
}

class _$JourneyLogInputDtoSerializer
    implements PrimitiveSerializer<JourneyLogInputDto> {
  @override
  final Iterable<Type> types = const [JourneyLogInputDto, _$JourneyLogInputDto];

  @override
  final String wireName = r'JourneyLogInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JourneyLogInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    if (object.stopSequence != null) {
      yield r'stopSequence';
      yield serializers.serialize(
        object.stopSequence,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'actualAt';
    yield serializers.serialize(
      object.actualAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.vehicleStatus != null) {
      yield r'vehicleStatus';
      yield serializers.serialize(
        object.vehicleStatus,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    JourneyLogInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JourneyLogInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'stopSequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.stopSequence = valueDes;
          break;
        case r'actualAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.actualAt = valueDes;
          break;
        case r'vehicleStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleStatus = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JourneyLogInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JourneyLogInputDtoBuilder();
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
