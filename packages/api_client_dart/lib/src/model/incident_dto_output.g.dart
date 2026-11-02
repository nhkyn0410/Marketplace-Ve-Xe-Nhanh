// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IncidentDtoOutputTypeEnum _$incidentDtoOutputTypeEnum_VEHICLE =
    const IncidentDtoOutputTypeEnum._('VEHICLE');
const IncidentDtoOutputTypeEnum _$incidentDtoOutputTypeEnum_TRAFFIC =
    const IncidentDtoOutputTypeEnum._('TRAFFIC');
const IncidentDtoOutputTypeEnum _$incidentDtoOutputTypeEnum_PASSENGER =
    const IncidentDtoOutputTypeEnum._('PASSENGER');
const IncidentDtoOutputTypeEnum _$incidentDtoOutputTypeEnum_SAFETY =
    const IncidentDtoOutputTypeEnum._('SAFETY');
const IncidentDtoOutputTypeEnum _$incidentDtoOutputTypeEnum_OTHER =
    const IncidentDtoOutputTypeEnum._('OTHER');

IncidentDtoOutputTypeEnum _$incidentDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'VEHICLE':
      return _$incidentDtoOutputTypeEnum_VEHICLE;
    case 'TRAFFIC':
      return _$incidentDtoOutputTypeEnum_TRAFFIC;
    case 'PASSENGER':
      return _$incidentDtoOutputTypeEnum_PASSENGER;
    case 'SAFETY':
      return _$incidentDtoOutputTypeEnum_SAFETY;
    case 'OTHER':
      return _$incidentDtoOutputTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IncidentDtoOutputTypeEnum> _$incidentDtoOutputTypeEnumValues =
    BuiltSet<IncidentDtoOutputTypeEnum>(const <IncidentDtoOutputTypeEnum>[
  _$incidentDtoOutputTypeEnum_VEHICLE,
  _$incidentDtoOutputTypeEnum_TRAFFIC,
  _$incidentDtoOutputTypeEnum_PASSENGER,
  _$incidentDtoOutputTypeEnum_SAFETY,
  _$incidentDtoOutputTypeEnum_OTHER,
]);

const IncidentDtoOutputSeverityEnum _$incidentDtoOutputSeverityEnum_LOW =
    const IncidentDtoOutputSeverityEnum._('LOW');
const IncidentDtoOutputSeverityEnum _$incidentDtoOutputSeverityEnum_MEDIUM =
    const IncidentDtoOutputSeverityEnum._('MEDIUM');
const IncidentDtoOutputSeverityEnum _$incidentDtoOutputSeverityEnum_HIGH =
    const IncidentDtoOutputSeverityEnum._('HIGH');
const IncidentDtoOutputSeverityEnum _$incidentDtoOutputSeverityEnum_CRITICAL =
    const IncidentDtoOutputSeverityEnum._('CRITICAL');

IncidentDtoOutputSeverityEnum _$incidentDtoOutputSeverityEnumValueOf(
    String name) {
  switch (name) {
    case 'LOW':
      return _$incidentDtoOutputSeverityEnum_LOW;
    case 'MEDIUM':
      return _$incidentDtoOutputSeverityEnum_MEDIUM;
    case 'HIGH':
      return _$incidentDtoOutputSeverityEnum_HIGH;
    case 'CRITICAL':
      return _$incidentDtoOutputSeverityEnum_CRITICAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IncidentDtoOutputSeverityEnum>
    _$incidentDtoOutputSeverityEnumValues = BuiltSet<
        IncidentDtoOutputSeverityEnum>(const <IncidentDtoOutputSeverityEnum>[
  _$incidentDtoOutputSeverityEnum_LOW,
  _$incidentDtoOutputSeverityEnum_MEDIUM,
  _$incidentDtoOutputSeverityEnum_HIGH,
  _$incidentDtoOutputSeverityEnum_CRITICAL,
]);

Serializer<IncidentDtoOutputTypeEnum> _$incidentDtoOutputTypeEnumSerializer =
    _$IncidentDtoOutputTypeEnumSerializer();
Serializer<IncidentDtoOutputSeverityEnum>
    _$incidentDtoOutputSeverityEnumSerializer =
    _$IncidentDtoOutputSeverityEnumSerializer();

class _$IncidentDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<IncidentDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VEHICLE': 'VEHICLE',
    'TRAFFIC': 'TRAFFIC',
    'PASSENGER': 'PASSENGER',
    'SAFETY': 'SAFETY',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VEHICLE': 'VEHICLE',
    'TRAFFIC': 'TRAFFIC',
    'PASSENGER': 'PASSENGER',
    'SAFETY': 'SAFETY',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[IncidentDtoOutputTypeEnum];
  @override
  final String wireName = 'IncidentDtoOutputTypeEnum';

  @override
  Object serialize(Serializers serializers, IncidentDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IncidentDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IncidentDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IncidentDtoOutputSeverityEnumSerializer
    implements PrimitiveSerializer<IncidentDtoOutputSeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LOW': 'LOW',
    'MEDIUM': 'MEDIUM',
    'HIGH': 'HIGH',
    'CRITICAL': 'CRITICAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LOW': 'LOW',
    'MEDIUM': 'MEDIUM',
    'HIGH': 'HIGH',
    'CRITICAL': 'CRITICAL',
  };

  @override
  final Iterable<Type> types = const <Type>[IncidentDtoOutputSeverityEnum];
  @override
  final String wireName = 'IncidentDtoOutputSeverityEnum';

  @override
  Object serialize(
          Serializers serializers, IncidentDtoOutputSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IncidentDtoOutputSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IncidentDtoOutputSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IncidentDtoOutput extends IncidentDtoOutput {
  @override
  final String id;
  @override
  final String operatorId;
  @override
  final String tripId;
  @override
  final String employeeId;
  @override
  final IncidentDtoOutputTypeEnum type;
  @override
  final IncidentDtoOutputSeverityEnum severity;
  @override
  final String description;
  @override
  final String? location;
  @override
  final DateTime occurredAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? resolvedBy;
  @override
  final String? resolution;
  @override
  final BuiltList<IncidentDtoOutputEvidenceInner> evidence;

  factory _$IncidentDtoOutput(
          [void Function(IncidentDtoOutputBuilder)? updates]) =>
      (IncidentDtoOutputBuilder()..update(updates))._build();

  _$IncidentDtoOutput._(
      {required this.id,
      required this.operatorId,
      required this.tripId,
      required this.employeeId,
      required this.type,
      required this.severity,
      required this.description,
      this.location,
      required this.occurredAt,
      required this.createdAt,
      this.resolvedAt,
      this.resolvedBy,
      this.resolution,
      required this.evidence})
      : super._();
  @override
  IncidentDtoOutput rebuild(void Function(IncidentDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentDtoOutputBuilder toBuilder() =>
      IncidentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentDtoOutput &&
        id == other.id &&
        operatorId == other.operatorId &&
        tripId == other.tripId &&
        employeeId == other.employeeId &&
        type == other.type &&
        severity == other.severity &&
        description == other.description &&
        location == other.location &&
        occurredAt == other.occurredAt &&
        createdAt == other.createdAt &&
        resolvedAt == other.resolvedAt &&
        resolvedBy == other.resolvedBy &&
        resolution == other.resolution &&
        evidence == other.evidence;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, resolvedBy.hashCode);
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jc(_$hash, evidence.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IncidentDtoOutput')
          ..add('id', id)
          ..add('operatorId', operatorId)
          ..add('tripId', tripId)
          ..add('employeeId', employeeId)
          ..add('type', type)
          ..add('severity', severity)
          ..add('description', description)
          ..add('location', location)
          ..add('occurredAt', occurredAt)
          ..add('createdAt', createdAt)
          ..add('resolvedAt', resolvedAt)
          ..add('resolvedBy', resolvedBy)
          ..add('resolution', resolution)
          ..add('evidence', evidence))
        .toString();
  }
}

class IncidentDtoOutputBuilder
    implements Builder<IncidentDtoOutput, IncidentDtoOutputBuilder> {
  _$IncidentDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  IncidentDtoOutputTypeEnum? _type;
  IncidentDtoOutputTypeEnum? get type => _$this._type;
  set type(IncidentDtoOutputTypeEnum? type) => _$this._type = type;

  IncidentDtoOutputSeverityEnum? _severity;
  IncidentDtoOutputSeverityEnum? get severity => _$this._severity;
  set severity(IncidentDtoOutputSeverityEnum? severity) =>
      _$this._severity = severity;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  String? _resolvedBy;
  String? get resolvedBy => _$this._resolvedBy;
  set resolvedBy(String? resolvedBy) => _$this._resolvedBy = resolvedBy;

  String? _resolution;
  String? get resolution => _$this._resolution;
  set resolution(String? resolution) => _$this._resolution = resolution;

  ListBuilder<IncidentDtoOutputEvidenceInner>? _evidence;
  ListBuilder<IncidentDtoOutputEvidenceInner> get evidence =>
      _$this._evidence ??= ListBuilder<IncidentDtoOutputEvidenceInner>();
  set evidence(ListBuilder<IncidentDtoOutputEvidenceInner>? evidence) =>
      _$this._evidence = evidence;

  IncidentDtoOutputBuilder() {
    IncidentDtoOutput._defaults(this);
  }

  IncidentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _operatorId = $v.operatorId;
      _tripId = $v.tripId;
      _employeeId = $v.employeeId;
      _type = $v.type;
      _severity = $v.severity;
      _description = $v.description;
      _location = $v.location;
      _occurredAt = $v.occurredAt;
      _createdAt = $v.createdAt;
      _resolvedAt = $v.resolvedAt;
      _resolvedBy = $v.resolvedBy;
      _resolution = $v.resolution;
      _evidence = $v.evidence.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncidentDtoOutput other) {
    _$v = other as _$IncidentDtoOutput;
  }

  @override
  void update(void Function(IncidentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentDtoOutput build() => _build();

  _$IncidentDtoOutput _build() {
    _$IncidentDtoOutput _$result;
    try {
      _$result = _$v ??
          _$IncidentDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IncidentDtoOutput', 'id'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'IncidentDtoOutput', 'operatorId'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'IncidentDtoOutput', 'tripId'),
            employeeId: BuiltValueNullFieldError.checkNotNull(
                employeeId, r'IncidentDtoOutput', 'employeeId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'IncidentDtoOutput', 'type'),
            severity: BuiltValueNullFieldError.checkNotNull(
                severity, r'IncidentDtoOutput', 'severity'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'IncidentDtoOutput', 'description'),
            location: location,
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'IncidentDtoOutput', 'occurredAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'IncidentDtoOutput', 'createdAt'),
            resolvedAt: resolvedAt,
            resolvedBy: resolvedBy,
            resolution: resolution,
            evidence: evidence.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'evidence';
        evidence.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IncidentDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
