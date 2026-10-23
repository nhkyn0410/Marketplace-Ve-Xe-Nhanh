// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IncidentPageDtoOutputItemsInnerTypeEnum
    _$incidentPageDtoOutputItemsInnerTypeEnum_VEHICLE =
    const IncidentPageDtoOutputItemsInnerTypeEnum._('VEHICLE');
const IncidentPageDtoOutputItemsInnerTypeEnum
    _$incidentPageDtoOutputItemsInnerTypeEnum_TRAFFIC =
    const IncidentPageDtoOutputItemsInnerTypeEnum._('TRAFFIC');
const IncidentPageDtoOutputItemsInnerTypeEnum
    _$incidentPageDtoOutputItemsInnerTypeEnum_PASSENGER =
    const IncidentPageDtoOutputItemsInnerTypeEnum._('PASSENGER');
const IncidentPageDtoOutputItemsInnerTypeEnum
    _$incidentPageDtoOutputItemsInnerTypeEnum_SAFETY =
    const IncidentPageDtoOutputItemsInnerTypeEnum._('SAFETY');
const IncidentPageDtoOutputItemsInnerTypeEnum
    _$incidentPageDtoOutputItemsInnerTypeEnum_OTHER =
    const IncidentPageDtoOutputItemsInnerTypeEnum._('OTHER');

IncidentPageDtoOutputItemsInnerTypeEnum
    _$incidentPageDtoOutputItemsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'VEHICLE':
      return _$incidentPageDtoOutputItemsInnerTypeEnum_VEHICLE;
    case 'TRAFFIC':
      return _$incidentPageDtoOutputItemsInnerTypeEnum_TRAFFIC;
    case 'PASSENGER':
      return _$incidentPageDtoOutputItemsInnerTypeEnum_PASSENGER;
    case 'SAFETY':
      return _$incidentPageDtoOutputItemsInnerTypeEnum_SAFETY;
    case 'OTHER':
      return _$incidentPageDtoOutputItemsInnerTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IncidentPageDtoOutputItemsInnerTypeEnum>
    _$incidentPageDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        IncidentPageDtoOutputItemsInnerTypeEnum>(const <IncidentPageDtoOutputItemsInnerTypeEnum>[
  _$incidentPageDtoOutputItemsInnerTypeEnum_VEHICLE,
  _$incidentPageDtoOutputItemsInnerTypeEnum_TRAFFIC,
  _$incidentPageDtoOutputItemsInnerTypeEnum_PASSENGER,
  _$incidentPageDtoOutputItemsInnerTypeEnum_SAFETY,
  _$incidentPageDtoOutputItemsInnerTypeEnum_OTHER,
]);

const IncidentPageDtoOutputItemsInnerSeverityEnum
    _$incidentPageDtoOutputItemsInnerSeverityEnum_LOW =
    const IncidentPageDtoOutputItemsInnerSeverityEnum._('LOW');
const IncidentPageDtoOutputItemsInnerSeverityEnum
    _$incidentPageDtoOutputItemsInnerSeverityEnum_MEDIUM =
    const IncidentPageDtoOutputItemsInnerSeverityEnum._('MEDIUM');
const IncidentPageDtoOutputItemsInnerSeverityEnum
    _$incidentPageDtoOutputItemsInnerSeverityEnum_HIGH =
    const IncidentPageDtoOutputItemsInnerSeverityEnum._('HIGH');
const IncidentPageDtoOutputItemsInnerSeverityEnum
    _$incidentPageDtoOutputItemsInnerSeverityEnum_CRITICAL =
    const IncidentPageDtoOutputItemsInnerSeverityEnum._('CRITICAL');

IncidentPageDtoOutputItemsInnerSeverityEnum
    _$incidentPageDtoOutputItemsInnerSeverityEnumValueOf(String name) {
  switch (name) {
    case 'LOW':
      return _$incidentPageDtoOutputItemsInnerSeverityEnum_LOW;
    case 'MEDIUM':
      return _$incidentPageDtoOutputItemsInnerSeverityEnum_MEDIUM;
    case 'HIGH':
      return _$incidentPageDtoOutputItemsInnerSeverityEnum_HIGH;
    case 'CRITICAL':
      return _$incidentPageDtoOutputItemsInnerSeverityEnum_CRITICAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IncidentPageDtoOutputItemsInnerSeverityEnum>
    _$incidentPageDtoOutputItemsInnerSeverityEnumValues = BuiltSet<
        IncidentPageDtoOutputItemsInnerSeverityEnum>(const <IncidentPageDtoOutputItemsInnerSeverityEnum>[
  _$incidentPageDtoOutputItemsInnerSeverityEnum_LOW,
  _$incidentPageDtoOutputItemsInnerSeverityEnum_MEDIUM,
  _$incidentPageDtoOutputItemsInnerSeverityEnum_HIGH,
  _$incidentPageDtoOutputItemsInnerSeverityEnum_CRITICAL,
]);

Serializer<IncidentPageDtoOutputItemsInnerTypeEnum>
    _$incidentPageDtoOutputItemsInnerTypeEnumSerializer =
    _$IncidentPageDtoOutputItemsInnerTypeEnumSerializer();
Serializer<IncidentPageDtoOutputItemsInnerSeverityEnum>
    _$incidentPageDtoOutputItemsInnerSeverityEnumSerializer =
    _$IncidentPageDtoOutputItemsInnerSeverityEnumSerializer();

class _$IncidentPageDtoOutputItemsInnerTypeEnumSerializer
    implements PrimitiveSerializer<IncidentPageDtoOutputItemsInnerTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    IncidentPageDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName = 'IncidentPageDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          IncidentPageDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IncidentPageDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IncidentPageDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IncidentPageDtoOutputItemsInnerSeverityEnumSerializer
    implements
        PrimitiveSerializer<IncidentPageDtoOutputItemsInnerSeverityEnum> {
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
  final Iterable<Type> types = const <Type>[
    IncidentPageDtoOutputItemsInnerSeverityEnum
  ];
  @override
  final String wireName = 'IncidentPageDtoOutputItemsInnerSeverityEnum';

  @override
  Object serialize(Serializers serializers,
          IncidentPageDtoOutputItemsInnerSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IncidentPageDtoOutputItemsInnerSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IncidentPageDtoOutputItemsInnerSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IncidentPageDtoOutputItemsInner
    extends IncidentPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String operatorId;
  @override
  final String tripId;
  @override
  final String employeeId;
  @override
  final IncidentPageDtoOutputItemsInnerTypeEnum type;
  @override
  final IncidentPageDtoOutputItemsInnerSeverityEnum severity;
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

  factory _$IncidentPageDtoOutputItemsInner(
          [void Function(IncidentPageDtoOutputItemsInnerBuilder)? updates]) =>
      (IncidentPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$IncidentPageDtoOutputItemsInner._(
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
  IncidentPageDtoOutputItemsInner rebuild(
          void Function(IncidentPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentPageDtoOutputItemsInnerBuilder toBuilder() =>
      IncidentPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentPageDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(r'IncidentPageDtoOutputItemsInner')
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

class IncidentPageDtoOutputItemsInnerBuilder
    implements
        Builder<IncidentPageDtoOutputItemsInner,
            IncidentPageDtoOutputItemsInnerBuilder> {
  _$IncidentPageDtoOutputItemsInner? _$v;

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

  IncidentPageDtoOutputItemsInnerTypeEnum? _type;
  IncidentPageDtoOutputItemsInnerTypeEnum? get type => _$this._type;
  set type(IncidentPageDtoOutputItemsInnerTypeEnum? type) =>
      _$this._type = type;

  IncidentPageDtoOutputItemsInnerSeverityEnum? _severity;
  IncidentPageDtoOutputItemsInnerSeverityEnum? get severity => _$this._severity;
  set severity(IncidentPageDtoOutputItemsInnerSeverityEnum? severity) =>
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

  IncidentPageDtoOutputItemsInnerBuilder() {
    IncidentPageDtoOutputItemsInner._defaults(this);
  }

  IncidentPageDtoOutputItemsInnerBuilder get _$this {
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
  void replace(IncidentPageDtoOutputItemsInner other) {
    _$v = other as _$IncidentPageDtoOutputItemsInner;
  }

  @override
  void update(void Function(IncidentPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentPageDtoOutputItemsInner build() => _build();

  _$IncidentPageDtoOutputItemsInner _build() {
    _$IncidentPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$IncidentPageDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IncidentPageDtoOutputItemsInner', 'id'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'IncidentPageDtoOutputItemsInner', 'operatorId'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'IncidentPageDtoOutputItemsInner', 'tripId'),
            employeeId: BuiltValueNullFieldError.checkNotNull(
                employeeId, r'IncidentPageDtoOutputItemsInner', 'employeeId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'IncidentPageDtoOutputItemsInner', 'type'),
            severity: BuiltValueNullFieldError.checkNotNull(
                severity, r'IncidentPageDtoOutputItemsInner', 'severity'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'IncidentPageDtoOutputItemsInner', 'description'),
            location: location,
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'IncidentPageDtoOutputItemsInner', 'occurredAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'IncidentPageDtoOutputItemsInner', 'createdAt'),
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
            r'IncidentPageDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
