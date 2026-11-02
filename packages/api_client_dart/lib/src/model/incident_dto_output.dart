//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/incident_dto_output_evidence_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incident_dto_output.g.dart';

/// IncidentDtoOutput
///
/// Properties:
/// * [id] 
/// * [operatorId] 
/// * [tripId] 
/// * [employeeId] 
/// * [type] 
/// * [severity] 
/// * [description] 
/// * [location] 
/// * [occurredAt] 
/// * [createdAt] 
/// * [resolvedAt] 
/// * [resolvedBy] 
/// * [resolution] 
/// * [evidence] 
@BuiltValue()
abstract class IncidentDtoOutput implements Built<IncidentDtoOutput, IncidentDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  @BuiltValueField(wireName: r'type')
  IncidentDtoOutputTypeEnum get type;
  // enum typeEnum {  VEHICLE,  TRAFFIC,  PASSENGER,  SAFETY,  OTHER,  };

  @BuiltValueField(wireName: r'severity')
  IncidentDtoOutputSeverityEnum get severity;
  // enum severityEnum {  LOW,  MEDIUM,  HIGH,  CRITICAL,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'location')
  String? get location;

  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'resolvedBy')
  String? get resolvedBy;

  @BuiltValueField(wireName: r'resolution')
  String? get resolution;

  @BuiltValueField(wireName: r'evidence')
  BuiltList<IncidentDtoOutputEvidenceInner> get evidence;

  IncidentDtoOutput._();

  factory IncidentDtoOutput([void updates(IncidentDtoOutputBuilder b)]) = _$IncidentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncidentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IncidentDtoOutput> get serializer => _$IncidentDtoOutputSerializer();
}

class _$IncidentDtoOutputSerializer implements PrimitiveSerializer<IncidentDtoOutput> {
  @override
  final Iterable<Type> types = const [IncidentDtoOutput, _$IncidentDtoOutput];

  @override
  final String wireName = r'IncidentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncidentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(IncidentDtoOutputTypeEnum),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(IncidentDtoOutputSeverityEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield object.location == null ? null : serializers.serialize(
      object.location,
      specifiedType: const FullType.nullable(String),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resolvedAt';
    yield object.resolvedAt == null ? null : serializers.serialize(
      object.resolvedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'resolvedBy';
    yield object.resolvedBy == null ? null : serializers.serialize(
      object.resolvedBy,
      specifiedType: const FullType.nullable(String),
    );
    yield r'resolution';
    yield object.resolution == null ? null : serializers.serialize(
      object.resolution,
      specifiedType: const FullType.nullable(String),
    );
    yield r'evidence';
    yield serializers.serialize(
      object.evidence,
      specifiedType: const FullType(BuiltList, [FullType(IncidentDtoOutputEvidenceInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IncidentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IncidentDtoOutputBuilder result,
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
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IncidentDtoOutputTypeEnum),
          ) as IncidentDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IncidentDtoOutputSeverityEnum),
          ) as IncidentDtoOutputSeverityEnum;
          result.severity = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        case r'resolvedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resolvedBy = valueDes;
          break;
        case r'resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resolution = valueDes;
          break;
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(IncidentDtoOutputEvidenceInner)]),
          ) as BuiltList<IncidentDtoOutputEvidenceInner>;
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
  IncidentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncidentDtoOutputBuilder();
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


class IncidentDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VEHICLE')
  static const IncidentDtoOutputTypeEnum VEHICLE = _$incidentDtoOutputTypeEnum_VEHICLE;
  @BuiltValueEnumConst(wireName: r'TRAFFIC')
  static const IncidentDtoOutputTypeEnum TRAFFIC = _$incidentDtoOutputTypeEnum_TRAFFIC;
  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const IncidentDtoOutputTypeEnum PASSENGER = _$incidentDtoOutputTypeEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'SAFETY')
  static const IncidentDtoOutputTypeEnum SAFETY = _$incidentDtoOutputTypeEnum_SAFETY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const IncidentDtoOutputTypeEnum OTHER = _$incidentDtoOutputTypeEnum_OTHER;

  static Serializer<IncidentDtoOutputTypeEnum> get serializer => _$incidentDtoOutputTypeEnumSerializer;

  const IncidentDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<IncidentDtoOutputTypeEnum> get values => _$incidentDtoOutputTypeEnumValues;
  static IncidentDtoOutputTypeEnum valueOf(String name) => _$incidentDtoOutputTypeEnumValueOf(name);
}

class IncidentDtoOutputSeverityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOW')
  static const IncidentDtoOutputSeverityEnum LOW = _$incidentDtoOutputSeverityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const IncidentDtoOutputSeverityEnum MEDIUM = _$incidentDtoOutputSeverityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const IncidentDtoOutputSeverityEnum HIGH = _$incidentDtoOutputSeverityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'CRITICAL')
  static const IncidentDtoOutputSeverityEnum CRITICAL = _$incidentDtoOutputSeverityEnum_CRITICAL;

  static Serializer<IncidentDtoOutputSeverityEnum> get serializer => _$incidentDtoOutputSeverityEnumSerializer;

  const IncidentDtoOutputSeverityEnum._(String name): super(name);

  static BuiltSet<IncidentDtoOutputSeverityEnum> get values => _$incidentDtoOutputSeverityEnumValues;
  static IncidentDtoOutputSeverityEnum valueOf(String name) => _$incidentDtoOutputSeverityEnumValueOf(name);
}

