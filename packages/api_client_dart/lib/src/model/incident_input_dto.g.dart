// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IncidentInputDtoTypeEnum _$incidentInputDtoTypeEnum_VEHICLE =
    const IncidentInputDtoTypeEnum._('VEHICLE');
const IncidentInputDtoTypeEnum _$incidentInputDtoTypeEnum_TRAFFIC =
    const IncidentInputDtoTypeEnum._('TRAFFIC');
const IncidentInputDtoTypeEnum _$incidentInputDtoTypeEnum_PASSENGER =
    const IncidentInputDtoTypeEnum._('PASSENGER');
const IncidentInputDtoTypeEnum _$incidentInputDtoTypeEnum_SAFETY =
    const IncidentInputDtoTypeEnum._('SAFETY');
const IncidentInputDtoTypeEnum _$incidentInputDtoTypeEnum_OTHER =
    const IncidentInputDtoTypeEnum._('OTHER');

IncidentInputDtoTypeEnum _$incidentInputDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'VEHICLE':
      return _$incidentInputDtoTypeEnum_VEHICLE;
    case 'TRAFFIC':
      return _$incidentInputDtoTypeEnum_TRAFFIC;
    case 'PASSENGER':
      return _$incidentInputDtoTypeEnum_PASSENGER;
    case 'SAFETY':
      return _$incidentInputDtoTypeEnum_SAFETY;
    case 'OTHER':
      return _$incidentInputDtoTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IncidentInputDtoTypeEnum> _$incidentInputDtoTypeEnumValues =
    BuiltSet<IncidentInputDtoTypeEnum>(const <IncidentInputDtoTypeEnum>[
  _$incidentInputDtoTypeEnum_VEHICLE,
  _$incidentInputDtoTypeEnum_TRAFFIC,
  _$incidentInputDtoTypeEnum_PASSENGER,
  _$incidentInputDtoTypeEnum_SAFETY,
  _$incidentInputDtoTypeEnum_OTHER,
]);

const IncidentInputDtoSeverityEnum _$incidentInputDtoSeverityEnum_LOW =
    const IncidentInputDtoSeverityEnum._('LOW');
const IncidentInputDtoSeverityEnum _$incidentInputDtoSeverityEnum_MEDIUM =
    const IncidentInputDtoSeverityEnum._('MEDIUM');
const IncidentInputDtoSeverityEnum _$incidentInputDtoSeverityEnum_HIGH =
    const IncidentInputDtoSeverityEnum._('HIGH');
const IncidentInputDtoSeverityEnum _$incidentInputDtoSeverityEnum_CRITICAL =
    const IncidentInputDtoSeverityEnum._('CRITICAL');

IncidentInputDtoSeverityEnum _$incidentInputDtoSeverityEnumValueOf(
    String name) {
  switch (name) {
    case 'LOW':
      return _$incidentInputDtoSeverityEnum_LOW;
    case 'MEDIUM':
      return _$incidentInputDtoSeverityEnum_MEDIUM;
    case 'HIGH':
      return _$incidentInputDtoSeverityEnum_HIGH;
    case 'CRITICAL':
      return _$incidentInputDtoSeverityEnum_CRITICAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IncidentInputDtoSeverityEnum>
    _$incidentInputDtoSeverityEnumValues =
    BuiltSet<IncidentInputDtoSeverityEnum>(const <IncidentInputDtoSeverityEnum>[
  _$incidentInputDtoSeverityEnum_LOW,
  _$incidentInputDtoSeverityEnum_MEDIUM,
  _$incidentInputDtoSeverityEnum_HIGH,
  _$incidentInputDtoSeverityEnum_CRITICAL,
]);

Serializer<IncidentInputDtoTypeEnum> _$incidentInputDtoTypeEnumSerializer =
    _$IncidentInputDtoTypeEnumSerializer();
Serializer<IncidentInputDtoSeverityEnum>
    _$incidentInputDtoSeverityEnumSerializer =
    _$IncidentInputDtoSeverityEnumSerializer();

class _$IncidentInputDtoTypeEnumSerializer
    implements PrimitiveSerializer<IncidentInputDtoTypeEnum> {
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
  final Iterable<Type> types = const <Type>[IncidentInputDtoTypeEnum];
  @override
  final String wireName = 'IncidentInputDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, IncidentInputDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IncidentInputDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IncidentInputDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IncidentInputDtoSeverityEnumSerializer
    implements PrimitiveSerializer<IncidentInputDtoSeverityEnum> {
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
  final Iterable<Type> types = const <Type>[IncidentInputDtoSeverityEnum];
  @override
  final String wireName = 'IncidentInputDtoSeverityEnum';

  @override
  Object serialize(Serializers serializers, IncidentInputDtoSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IncidentInputDtoSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IncidentInputDtoSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IncidentInputDto extends IncidentInputDto {
  @override
  final String tripId;
  @override
  final IncidentInputDtoTypeEnum type;
  @override
  final IncidentInputDtoSeverityEnum severity;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final DateTime occurredAt;
  @override
  final BuiltList<IncidentInputDtoEvidenceInner>? evidence;

  factory _$IncidentInputDto(
          [void Function(IncidentInputDtoBuilder)? updates]) =>
      (IncidentInputDtoBuilder()..update(updates))._build();

  _$IncidentInputDto._(
      {required this.tripId,
      required this.type,
      required this.severity,
      this.description,
      this.location,
      required this.occurredAt,
      this.evidence})
      : super._();
  @override
  IncidentInputDto rebuild(void Function(IncidentInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentInputDtoBuilder toBuilder() =>
      IncidentInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentInputDto &&
        tripId == other.tripId &&
        type == other.type &&
        severity == other.severity &&
        description == other.description &&
        location == other.location &&
        occurredAt == other.occurredAt &&
        evidence == other.evidence;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, evidence.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IncidentInputDto')
          ..add('tripId', tripId)
          ..add('type', type)
          ..add('severity', severity)
          ..add('description', description)
          ..add('location', location)
          ..add('occurredAt', occurredAt)
          ..add('evidence', evidence))
        .toString();
  }
}

class IncidentInputDtoBuilder
    implements Builder<IncidentInputDto, IncidentInputDtoBuilder> {
  _$IncidentInputDto? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  IncidentInputDtoTypeEnum? _type;
  IncidentInputDtoTypeEnum? get type => _$this._type;
  set type(IncidentInputDtoTypeEnum? type) => _$this._type = type;

  IncidentInputDtoSeverityEnum? _severity;
  IncidentInputDtoSeverityEnum? get severity => _$this._severity;
  set severity(IncidentInputDtoSeverityEnum? severity) =>
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

  ListBuilder<IncidentInputDtoEvidenceInner>? _evidence;
  ListBuilder<IncidentInputDtoEvidenceInner> get evidence =>
      _$this._evidence ??= ListBuilder<IncidentInputDtoEvidenceInner>();
  set evidence(ListBuilder<IncidentInputDtoEvidenceInner>? evidence) =>
      _$this._evidence = evidence;

  IncidentInputDtoBuilder() {
    IncidentInputDto._defaults(this);
  }

  IncidentInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _type = $v.type;
      _severity = $v.severity;
      _description = $v.description;
      _location = $v.location;
      _occurredAt = $v.occurredAt;
      _evidence = $v.evidence?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncidentInputDto other) {
    _$v = other as _$IncidentInputDto;
  }

  @override
  void update(void Function(IncidentInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentInputDto build() => _build();

  _$IncidentInputDto _build() {
    _$IncidentInputDto _$result;
    try {
      _$result = _$v ??
          _$IncidentInputDto._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'IncidentInputDto', 'tripId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'IncidentInputDto', 'type'),
            severity: BuiltValueNullFieldError.checkNotNull(
                severity, r'IncidentInputDto', 'severity'),
            description: description,
            location: location,
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'IncidentInputDto', 'occurredAt'),
            evidence: _evidence?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'evidence';
        _evidence?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IncidentInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
