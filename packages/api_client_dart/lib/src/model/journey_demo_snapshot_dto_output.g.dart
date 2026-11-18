// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_demo_snapshot_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JourneyDemoSnapshotDtoOutputTypeEnum
    _$journeyDemoSnapshotDtoOutputTypeEnum_journeyDemo =
    const JourneyDemoSnapshotDtoOutputTypeEnum._('journeyDemo');

JourneyDemoSnapshotDtoOutputTypeEnum
    _$journeyDemoSnapshotDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'journeyDemo':
      return _$journeyDemoSnapshotDtoOutputTypeEnum_journeyDemo;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<JourneyDemoSnapshotDtoOutputTypeEnum>
    _$journeyDemoSnapshotDtoOutputTypeEnumValues = BuiltSet<
        JourneyDemoSnapshotDtoOutputTypeEnum>(const <JourneyDemoSnapshotDtoOutputTypeEnum>[
  _$journeyDemoSnapshotDtoOutputTypeEnum_journeyDemo,
]);

const JourneyDemoSnapshotDtoOutputStageEnum
    _$journeyDemoSnapshotDtoOutputStageEnum_approaching =
    const JourneyDemoSnapshotDtoOutputStageEnum._('approaching');
const JourneyDemoSnapshotDtoOutputStageEnum
    _$journeyDemoSnapshotDtoOutputStageEnum_travelling =
    const JourneyDemoSnapshotDtoOutputStageEnum._('travelling');
const JourneyDemoSnapshotDtoOutputStageEnum
    _$journeyDemoSnapshotDtoOutputStageEnum_arrived =
    const JourneyDemoSnapshotDtoOutputStageEnum._('arrived');
const JourneyDemoSnapshotDtoOutputStageEnum
    _$journeyDemoSnapshotDtoOutputStageEnum_stopped =
    const JourneyDemoSnapshotDtoOutputStageEnum._('stopped');

JourneyDemoSnapshotDtoOutputStageEnum
    _$journeyDemoSnapshotDtoOutputStageEnumValueOf(String name) {
  switch (name) {
    case 'approaching':
      return _$journeyDemoSnapshotDtoOutputStageEnum_approaching;
    case 'travelling':
      return _$journeyDemoSnapshotDtoOutputStageEnum_travelling;
    case 'arrived':
      return _$journeyDemoSnapshotDtoOutputStageEnum_arrived;
    case 'stopped':
      return _$journeyDemoSnapshotDtoOutputStageEnum_stopped;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<JourneyDemoSnapshotDtoOutputStageEnum>
    _$journeyDemoSnapshotDtoOutputStageEnumValues = BuiltSet<
        JourneyDemoSnapshotDtoOutputStageEnum>(const <JourneyDemoSnapshotDtoOutputStageEnum>[
  _$journeyDemoSnapshotDtoOutputStageEnum_approaching,
  _$journeyDemoSnapshotDtoOutputStageEnum_travelling,
  _$journeyDemoSnapshotDtoOutputStageEnum_arrived,
  _$journeyDemoSnapshotDtoOutputStageEnum_stopped,
]);

Serializer<JourneyDemoSnapshotDtoOutputTypeEnum>
    _$journeyDemoSnapshotDtoOutputTypeEnumSerializer =
    _$JourneyDemoSnapshotDtoOutputTypeEnumSerializer();
Serializer<JourneyDemoSnapshotDtoOutputStageEnum>
    _$journeyDemoSnapshotDtoOutputStageEnumSerializer =
    _$JourneyDemoSnapshotDtoOutputStageEnumSerializer();

class _$JourneyDemoSnapshotDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<JourneyDemoSnapshotDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'journeyDemo': 'journey_demo',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'journey_demo': 'journeyDemo',
  };

  @override
  final Iterable<Type> types = const <Type>[
    JourneyDemoSnapshotDtoOutputTypeEnum
  ];
  @override
  final String wireName = 'JourneyDemoSnapshotDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, JourneyDemoSnapshotDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JourneyDemoSnapshotDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JourneyDemoSnapshotDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$JourneyDemoSnapshotDtoOutputStageEnumSerializer
    implements PrimitiveSerializer<JourneyDemoSnapshotDtoOutputStageEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'approaching': 'approaching',
    'travelling': 'travelling',
    'arrived': 'arrived',
    'stopped': 'stopped',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'approaching': 'approaching',
    'travelling': 'travelling',
    'arrived': 'arrived',
    'stopped': 'stopped',
  };

  @override
  final Iterable<Type> types = const <Type>[
    JourneyDemoSnapshotDtoOutputStageEnum
  ];
  @override
  final String wireName = 'JourneyDemoSnapshotDtoOutputStageEnum';

  @override
  Object serialize(
          Serializers serializers, JourneyDemoSnapshotDtoOutputStageEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JourneyDemoSnapshotDtoOutputStageEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JourneyDemoSnapshotDtoOutputStageEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$JourneyDemoSnapshotDtoOutput extends JourneyDemoSnapshotDtoOutput {
  @override
  final JourneyDemoSnapshotDtoOutputTypeEnum type;
  @override
  final int schemaVersion;
  @override
  final String sessionId;
  @override
  final String bookingId;
  @override
  final int revision;
  @override
  final JourneyDemoSnapshotDtoOutputStageEnum stage;
  @override
  final String routeLabel;
  @override
  final String provinceName;
  @override
  final DateTime etaAt;
  @override
  final int progress;
  @override
  final DateTime updatedAt;
  @override
  final DateTime expiresAt;
  @override
  final bool ended;

  factory _$JourneyDemoSnapshotDtoOutput(
          [void Function(JourneyDemoSnapshotDtoOutputBuilder)? updates]) =>
      (JourneyDemoSnapshotDtoOutputBuilder()..update(updates))._build();

  _$JourneyDemoSnapshotDtoOutput._(
      {required this.type,
      required this.schemaVersion,
      required this.sessionId,
      required this.bookingId,
      required this.revision,
      required this.stage,
      required this.routeLabel,
      required this.provinceName,
      required this.etaAt,
      required this.progress,
      required this.updatedAt,
      required this.expiresAt,
      required this.ended})
      : super._();
  @override
  JourneyDemoSnapshotDtoOutput rebuild(
          void Function(JourneyDemoSnapshotDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JourneyDemoSnapshotDtoOutputBuilder toBuilder() =>
      JourneyDemoSnapshotDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JourneyDemoSnapshotDtoOutput &&
        type == other.type &&
        schemaVersion == other.schemaVersion &&
        sessionId == other.sessionId &&
        bookingId == other.bookingId &&
        revision == other.revision &&
        stage == other.stage &&
        routeLabel == other.routeLabel &&
        provinceName == other.provinceName &&
        etaAt == other.etaAt &&
        progress == other.progress &&
        updatedAt == other.updatedAt &&
        expiresAt == other.expiresAt &&
        ended == other.ended;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, schemaVersion.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jc(_$hash, routeLabel.hashCode);
    _$hash = $jc(_$hash, provinceName.hashCode);
    _$hash = $jc(_$hash, etaAt.hashCode);
    _$hash = $jc(_$hash, progress.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, ended.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JourneyDemoSnapshotDtoOutput')
          ..add('type', type)
          ..add('schemaVersion', schemaVersion)
          ..add('sessionId', sessionId)
          ..add('bookingId', bookingId)
          ..add('revision', revision)
          ..add('stage', stage)
          ..add('routeLabel', routeLabel)
          ..add('provinceName', provinceName)
          ..add('etaAt', etaAt)
          ..add('progress', progress)
          ..add('updatedAt', updatedAt)
          ..add('expiresAt', expiresAt)
          ..add('ended', ended))
        .toString();
  }
}

class JourneyDemoSnapshotDtoOutputBuilder
    implements
        Builder<JourneyDemoSnapshotDtoOutput,
            JourneyDemoSnapshotDtoOutputBuilder> {
  _$JourneyDemoSnapshotDtoOutput? _$v;

  JourneyDemoSnapshotDtoOutputTypeEnum? _type;
  JourneyDemoSnapshotDtoOutputTypeEnum? get type => _$this._type;
  set type(JourneyDemoSnapshotDtoOutputTypeEnum? type) => _$this._type = type;

  int? _schemaVersion;
  int? get schemaVersion => _$this._schemaVersion;
  set schemaVersion(int? schemaVersion) =>
      _$this._schemaVersion = schemaVersion;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  JourneyDemoSnapshotDtoOutputStageEnum? _stage;
  JourneyDemoSnapshotDtoOutputStageEnum? get stage => _$this._stage;
  set stage(JourneyDemoSnapshotDtoOutputStageEnum? stage) =>
      _$this._stage = stage;

  String? _routeLabel;
  String? get routeLabel => _$this._routeLabel;
  set routeLabel(String? routeLabel) => _$this._routeLabel = routeLabel;

  String? _provinceName;
  String? get provinceName => _$this._provinceName;
  set provinceName(String? provinceName) => _$this._provinceName = provinceName;

  DateTime? _etaAt;
  DateTime? get etaAt => _$this._etaAt;
  set etaAt(DateTime? etaAt) => _$this._etaAt = etaAt;

  int? _progress;
  int? get progress => _$this._progress;
  set progress(int? progress) => _$this._progress = progress;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  bool? _ended;
  bool? get ended => _$this._ended;
  set ended(bool? ended) => _$this._ended = ended;

  JourneyDemoSnapshotDtoOutputBuilder() {
    JourneyDemoSnapshotDtoOutput._defaults(this);
  }

  JourneyDemoSnapshotDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _schemaVersion = $v.schemaVersion;
      _sessionId = $v.sessionId;
      _bookingId = $v.bookingId;
      _revision = $v.revision;
      _stage = $v.stage;
      _routeLabel = $v.routeLabel;
      _provinceName = $v.provinceName;
      _etaAt = $v.etaAt;
      _progress = $v.progress;
      _updatedAt = $v.updatedAt;
      _expiresAt = $v.expiresAt;
      _ended = $v.ended;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JourneyDemoSnapshotDtoOutput other) {
    _$v = other as _$JourneyDemoSnapshotDtoOutput;
  }

  @override
  void update(void Function(JourneyDemoSnapshotDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JourneyDemoSnapshotDtoOutput build() => _build();

  _$JourneyDemoSnapshotDtoOutput _build() {
    final _$result = _$v ??
        _$JourneyDemoSnapshotDtoOutput._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'JourneyDemoSnapshotDtoOutput', 'type'),
          schemaVersion: BuiltValueNullFieldError.checkNotNull(
              schemaVersion, r'JourneyDemoSnapshotDtoOutput', 'schemaVersion'),
          sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId, r'JourneyDemoSnapshotDtoOutput', 'sessionId'),
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'JourneyDemoSnapshotDtoOutput', 'bookingId'),
          revision: BuiltValueNullFieldError.checkNotNull(
              revision, r'JourneyDemoSnapshotDtoOutput', 'revision'),
          stage: BuiltValueNullFieldError.checkNotNull(
              stage, r'JourneyDemoSnapshotDtoOutput', 'stage'),
          routeLabel: BuiltValueNullFieldError.checkNotNull(
              routeLabel, r'JourneyDemoSnapshotDtoOutput', 'routeLabel'),
          provinceName: BuiltValueNullFieldError.checkNotNull(
              provinceName, r'JourneyDemoSnapshotDtoOutput', 'provinceName'),
          etaAt: BuiltValueNullFieldError.checkNotNull(
              etaAt, r'JourneyDemoSnapshotDtoOutput', 'etaAt'),
          progress: BuiltValueNullFieldError.checkNotNull(
              progress, r'JourneyDemoSnapshotDtoOutput', 'progress'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'JourneyDemoSnapshotDtoOutput', 'updatedAt'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'JourneyDemoSnapshotDtoOutput', 'expiresAt'),
          ended: BuiltValueNullFieldError.checkNotNull(
              ended, r'JourneyDemoSnapshotDtoOutput', 'ended'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
