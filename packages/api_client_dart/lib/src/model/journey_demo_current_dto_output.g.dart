// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_demo_current_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JourneyDemoCurrentDtoOutputTypeEnum
    _$journeyDemoCurrentDtoOutputTypeEnum_journeyDemo =
    const JourneyDemoCurrentDtoOutputTypeEnum._('journeyDemo');

JourneyDemoCurrentDtoOutputTypeEnum
    _$journeyDemoCurrentDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'journeyDemo':
      return _$journeyDemoCurrentDtoOutputTypeEnum_journeyDemo;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<JourneyDemoCurrentDtoOutputTypeEnum>
    _$journeyDemoCurrentDtoOutputTypeEnumValues = BuiltSet<
        JourneyDemoCurrentDtoOutputTypeEnum>(const <JourneyDemoCurrentDtoOutputTypeEnum>[
  _$journeyDemoCurrentDtoOutputTypeEnum_journeyDemo,
]);

const JourneyDemoCurrentDtoOutputStageEnum
    _$journeyDemoCurrentDtoOutputStageEnum_approaching =
    const JourneyDemoCurrentDtoOutputStageEnum._('approaching');
const JourneyDemoCurrentDtoOutputStageEnum
    _$journeyDemoCurrentDtoOutputStageEnum_travelling =
    const JourneyDemoCurrentDtoOutputStageEnum._('travelling');
const JourneyDemoCurrentDtoOutputStageEnum
    _$journeyDemoCurrentDtoOutputStageEnum_arrived =
    const JourneyDemoCurrentDtoOutputStageEnum._('arrived');
const JourneyDemoCurrentDtoOutputStageEnum
    _$journeyDemoCurrentDtoOutputStageEnum_stopped =
    const JourneyDemoCurrentDtoOutputStageEnum._('stopped');

JourneyDemoCurrentDtoOutputStageEnum
    _$journeyDemoCurrentDtoOutputStageEnumValueOf(String name) {
  switch (name) {
    case 'approaching':
      return _$journeyDemoCurrentDtoOutputStageEnum_approaching;
    case 'travelling':
      return _$journeyDemoCurrentDtoOutputStageEnum_travelling;
    case 'arrived':
      return _$journeyDemoCurrentDtoOutputStageEnum_arrived;
    case 'stopped':
      return _$journeyDemoCurrentDtoOutputStageEnum_stopped;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<JourneyDemoCurrentDtoOutputStageEnum>
    _$journeyDemoCurrentDtoOutputStageEnumValues = BuiltSet<
        JourneyDemoCurrentDtoOutputStageEnum>(const <JourneyDemoCurrentDtoOutputStageEnum>[
  _$journeyDemoCurrentDtoOutputStageEnum_approaching,
  _$journeyDemoCurrentDtoOutputStageEnum_travelling,
  _$journeyDemoCurrentDtoOutputStageEnum_arrived,
  _$journeyDemoCurrentDtoOutputStageEnum_stopped,
]);

Serializer<JourneyDemoCurrentDtoOutputTypeEnum>
    _$journeyDemoCurrentDtoOutputTypeEnumSerializer =
    _$JourneyDemoCurrentDtoOutputTypeEnumSerializer();
Serializer<JourneyDemoCurrentDtoOutputStageEnum>
    _$journeyDemoCurrentDtoOutputStageEnumSerializer =
    _$JourneyDemoCurrentDtoOutputStageEnumSerializer();

class _$JourneyDemoCurrentDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<JourneyDemoCurrentDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'journeyDemo': 'journey_demo',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'journey_demo': 'journeyDemo',
  };

  @override
  final Iterable<Type> types = const <Type>[
    JourneyDemoCurrentDtoOutputTypeEnum
  ];
  @override
  final String wireName = 'JourneyDemoCurrentDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, JourneyDemoCurrentDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JourneyDemoCurrentDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JourneyDemoCurrentDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$JourneyDemoCurrentDtoOutputStageEnumSerializer
    implements PrimitiveSerializer<JourneyDemoCurrentDtoOutputStageEnum> {
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
    JourneyDemoCurrentDtoOutputStageEnum
  ];
  @override
  final String wireName = 'JourneyDemoCurrentDtoOutputStageEnum';

  @override
  Object serialize(
          Serializers serializers, JourneyDemoCurrentDtoOutputStageEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JourneyDemoCurrentDtoOutputStageEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JourneyDemoCurrentDtoOutputStageEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$JourneyDemoCurrentDtoOutput extends JourneyDemoCurrentDtoOutput {
  @override
  final JourneyDemoCurrentDtoOutputTypeEnum type;
  @override
  final int schemaVersion;
  @override
  final String sessionId;
  @override
  final String bookingId;
  @override
  final int revision;
  @override
  final JourneyDemoCurrentDtoOutputStageEnum stage;
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

  factory _$JourneyDemoCurrentDtoOutput(
          [void Function(JourneyDemoCurrentDtoOutputBuilder)? updates]) =>
      (JourneyDemoCurrentDtoOutputBuilder()..update(updates))._build();

  _$JourneyDemoCurrentDtoOutput._(
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
  JourneyDemoCurrentDtoOutput rebuild(
          void Function(JourneyDemoCurrentDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JourneyDemoCurrentDtoOutputBuilder toBuilder() =>
      JourneyDemoCurrentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JourneyDemoCurrentDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'JourneyDemoCurrentDtoOutput')
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

class JourneyDemoCurrentDtoOutputBuilder
    implements
        Builder<JourneyDemoCurrentDtoOutput,
            JourneyDemoCurrentDtoOutputBuilder> {
  _$JourneyDemoCurrentDtoOutput? _$v;

  JourneyDemoCurrentDtoOutputTypeEnum? _type;
  JourneyDemoCurrentDtoOutputTypeEnum? get type => _$this._type;
  set type(JourneyDemoCurrentDtoOutputTypeEnum? type) => _$this._type = type;

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

  JourneyDemoCurrentDtoOutputStageEnum? _stage;
  JourneyDemoCurrentDtoOutputStageEnum? get stage => _$this._stage;
  set stage(JourneyDemoCurrentDtoOutputStageEnum? stage) =>
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

  JourneyDemoCurrentDtoOutputBuilder() {
    JourneyDemoCurrentDtoOutput._defaults(this);
  }

  JourneyDemoCurrentDtoOutputBuilder get _$this {
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
  void replace(JourneyDemoCurrentDtoOutput other) {
    _$v = other as _$JourneyDemoCurrentDtoOutput;
  }

  @override
  void update(void Function(JourneyDemoCurrentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JourneyDemoCurrentDtoOutput build() => _build();

  _$JourneyDemoCurrentDtoOutput _build() {
    final _$result = _$v ??
        _$JourneyDemoCurrentDtoOutput._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'JourneyDemoCurrentDtoOutput', 'type'),
          schemaVersion: BuiltValueNullFieldError.checkNotNull(
              schemaVersion, r'JourneyDemoCurrentDtoOutput', 'schemaVersion'),
          sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId, r'JourneyDemoCurrentDtoOutput', 'sessionId'),
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'JourneyDemoCurrentDtoOutput', 'bookingId'),
          revision: BuiltValueNullFieldError.checkNotNull(
              revision, r'JourneyDemoCurrentDtoOutput', 'revision'),
          stage: BuiltValueNullFieldError.checkNotNull(
              stage, r'JourneyDemoCurrentDtoOutput', 'stage'),
          routeLabel: BuiltValueNullFieldError.checkNotNull(
              routeLabel, r'JourneyDemoCurrentDtoOutput', 'routeLabel'),
          provinceName: BuiltValueNullFieldError.checkNotNull(
              provinceName, r'JourneyDemoCurrentDtoOutput', 'provinceName'),
          etaAt: BuiltValueNullFieldError.checkNotNull(
              etaAt, r'JourneyDemoCurrentDtoOutput', 'etaAt'),
          progress: BuiltValueNullFieldError.checkNotNull(
              progress, r'JourneyDemoCurrentDtoOutput', 'progress'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'JourneyDemoCurrentDtoOutput', 'updatedAt'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'JourneyDemoCurrentDtoOutput', 'expiresAt'),
          ended: BuiltValueNullFieldError.checkNotNull(
              ended, r'JourneyDemoCurrentDtoOutput', 'ended'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
