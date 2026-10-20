//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/incident_input_dto_evidence_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incident_input_dto.g.dart';

/// IncidentInputDto
///
/// Properties:
/// * [tripId]
/// * [type]
/// * [severity]
/// * [description]
/// * [location]
/// * [occurredAt]
/// * [evidence]
@BuiltValue()
abstract class IncidentInputDto
    implements Built<IncidentInputDto, IncidentInputDtoBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'type')
  IncidentInputDtoTypeEnum get type;
  // enum typeEnum {  VEHICLE,  TRAFFIC,  PASSENGER,  SAFETY,  OTHER,  };

  @BuiltValueField(wireName: r'severity')
  IncidentInputDtoSeverityEnum get severity;
  // enum severityEnum {  LOW,  MEDIUM,  HIGH,  CRITICAL,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'location')
  String? get location;

  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'evidence')
  BuiltList<IncidentInputDtoEvidenceInner>? get evidence;

  IncidentInputDto._();

  factory IncidentInputDto([void updates(IncidentInputDtoBuilder b)]) =
      _$IncidentInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncidentInputDtoBuilder b) =>
      b..evidence = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<IncidentInputDto> get serializer =>
      _$IncidentInputDtoSerializer();
}

class _$IncidentInputDtoSerializer
    implements PrimitiveSerializer<IncidentInputDto> {
  @override
  final Iterable<Type> types = const [IncidentInputDto, _$IncidentInputDto];

  @override
  final String wireName = r'IncidentInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncidentInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(IncidentInputDtoTypeEnum),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(IncidentInputDtoSeverityEnum),
    );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    if (object.location != null) {
      yield r'location';
      yield serializers.serialize(
        object.location,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.evidence != null) {
      yield r'evidence';
      yield serializers.serialize(
        object.evidence,
        specifiedType: const FullType(
            BuiltList, [FullType(IncidentInputDtoEvidenceInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IncidentInputDto object, {
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
    required IncidentInputDtoBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IncidentInputDtoTypeEnum),
          ) as IncidentInputDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IncidentInputDtoSeverityEnum),
          ) as IncidentInputDtoSeverityEnum;
          result.severity = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.location = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(IncidentInputDtoEvidenceInner)]),
          ) as BuiltList<IncidentInputDtoEvidenceInner>?;
          if (valueDes == null) continue;
          result.evidence.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IncidentInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncidentInputDtoBuilder();
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

class IncidentInputDtoTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'VEHICLE')
  static const IncidentInputDtoTypeEnum VEHICLE =
      _$incidentInputDtoTypeEnum_VEHICLE;
  @BuiltValueEnumConst(wireName: r'TRAFFIC')
  static const IncidentInputDtoTypeEnum TRAFFIC =
      _$incidentInputDtoTypeEnum_TRAFFIC;
  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const IncidentInputDtoTypeEnum PASSENGER =
      _$incidentInputDtoTypeEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'SAFETY')
  static const IncidentInputDtoTypeEnum SAFETY =
      _$incidentInputDtoTypeEnum_SAFETY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const IncidentInputDtoTypeEnum OTHER =
      _$incidentInputDtoTypeEnum_OTHER;

  static Serializer<IncidentInputDtoTypeEnum> get serializer =>
      _$incidentInputDtoTypeEnumSerializer;

  const IncidentInputDtoTypeEnum._(String name) : super(name);

  static BuiltSet<IncidentInputDtoTypeEnum> get values =>
      _$incidentInputDtoTypeEnumValues;
  static IncidentInputDtoTypeEnum valueOf(String name) =>
      _$incidentInputDtoTypeEnumValueOf(name);
}

class IncidentInputDtoSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'LOW')
  static const IncidentInputDtoSeverityEnum LOW =
      _$incidentInputDtoSeverityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const IncidentInputDtoSeverityEnum MEDIUM =
      _$incidentInputDtoSeverityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const IncidentInputDtoSeverityEnum HIGH =
      _$incidentInputDtoSeverityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'CRITICAL')
  static const IncidentInputDtoSeverityEnum CRITICAL =
      _$incidentInputDtoSeverityEnum_CRITICAL;

  static Serializer<IncidentInputDtoSeverityEnum> get serializer =>
      _$incidentInputDtoSeverityEnumSerializer;

  const IncidentInputDtoSeverityEnum._(String name) : super(name);

  static BuiltSet<IncidentInputDtoSeverityEnum> get values =>
      _$incidentInputDtoSeverityEnumValues;
  static IncidentInputDtoSeverityEnum valueOf(String name) =>
      _$incidentInputDtoSeverityEnumValueOf(name);
}
