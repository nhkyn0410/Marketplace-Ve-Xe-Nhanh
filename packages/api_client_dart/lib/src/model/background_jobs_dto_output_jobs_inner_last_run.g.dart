// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_jobs_dto_output_jobs_inner_last_run.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum
    _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_completed =
    const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum._('completed');
const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum
    _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_failed =
    const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum._('failed');
const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum
    _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_active =
    const BackgroundJobsDtoOutputJobsInnerLastRunStateEnum._('active');

BackgroundJobsDtoOutputJobsInnerLastRunStateEnum
    _$backgroundJobsDtoOutputJobsInnerLastRunStateEnumValueOf(String name) {
  switch (name) {
    case 'completed':
      return _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_completed;
    case 'failed':
      return _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_failed;
    case 'active':
      return _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_active;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BackgroundJobsDtoOutputJobsInnerLastRunStateEnum>
    _$backgroundJobsDtoOutputJobsInnerLastRunStateEnumValues = BuiltSet<
        BackgroundJobsDtoOutputJobsInnerLastRunStateEnum>(const <BackgroundJobsDtoOutputJobsInnerLastRunStateEnum>[
  _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_completed,
  _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_failed,
  _$backgroundJobsDtoOutputJobsInnerLastRunStateEnum_active,
]);

Serializer<BackgroundJobsDtoOutputJobsInnerLastRunStateEnum>
    _$backgroundJobsDtoOutputJobsInnerLastRunStateEnumSerializer =
    _$BackgroundJobsDtoOutputJobsInnerLastRunStateEnumSerializer();

class _$BackgroundJobsDtoOutputJobsInnerLastRunStateEnumSerializer
    implements
        PrimitiveSerializer<BackgroundJobsDtoOutputJobsInnerLastRunStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'completed': 'completed',
    'failed': 'failed',
    'active': 'active',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'completed': 'completed',
    'failed': 'failed',
    'active': 'active',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BackgroundJobsDtoOutputJobsInnerLastRunStateEnum
  ];
  @override
  final String wireName = 'BackgroundJobsDtoOutputJobsInnerLastRunStateEnum';

  @override
  Object serialize(Serializers serializers,
          BackgroundJobsDtoOutputJobsInnerLastRunStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BackgroundJobsDtoOutputJobsInnerLastRunStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BackgroundJobsDtoOutputJobsInnerLastRunStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BackgroundJobsDtoOutputJobsInnerLastRun
    extends BackgroundJobsDtoOutputJobsInnerLastRun {
  @override
  final BackgroundJobsDtoOutputJobsInnerLastRunStateEnum state;
  @override
  final DateTime at;
  @override
  final int? processed;
  @override
  final String? error;
  @override
  final int attempts;

  factory _$BackgroundJobsDtoOutputJobsInnerLastRun(
          [void Function(BackgroundJobsDtoOutputJobsInnerLastRunBuilder)?
              updates]) =>
      (BackgroundJobsDtoOutputJobsInnerLastRunBuilder()..update(updates))
          ._build();

  _$BackgroundJobsDtoOutputJobsInnerLastRun._(
      {required this.state,
      required this.at,
      this.processed,
      this.error,
      required this.attempts})
      : super._();
  @override
  BackgroundJobsDtoOutputJobsInnerLastRun rebuild(
          void Function(BackgroundJobsDtoOutputJobsInnerLastRunBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackgroundJobsDtoOutputJobsInnerLastRunBuilder toBuilder() =>
      BackgroundJobsDtoOutputJobsInnerLastRunBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackgroundJobsDtoOutputJobsInnerLastRun &&
        state == other.state &&
        at == other.at &&
        processed == other.processed &&
        error == other.error &&
        attempts == other.attempts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, processed.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'BackgroundJobsDtoOutputJobsInnerLastRun')
          ..add('state', state)
          ..add('at', at)
          ..add('processed', processed)
          ..add('error', error)
          ..add('attempts', attempts))
        .toString();
  }
}

class BackgroundJobsDtoOutputJobsInnerLastRunBuilder
    implements
        Builder<BackgroundJobsDtoOutputJobsInnerLastRun,
            BackgroundJobsDtoOutputJobsInnerLastRunBuilder> {
  _$BackgroundJobsDtoOutputJobsInnerLastRun? _$v;

  BackgroundJobsDtoOutputJobsInnerLastRunStateEnum? _state;
  BackgroundJobsDtoOutputJobsInnerLastRunStateEnum? get state => _$this._state;
  set state(BackgroundJobsDtoOutputJobsInnerLastRunStateEnum? state) =>
      _$this._state = state;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  int? _processed;
  int? get processed => _$this._processed;
  set processed(int? processed) => _$this._processed = processed;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  int? _attempts;
  int? get attempts => _$this._attempts;
  set attempts(int? attempts) => _$this._attempts = attempts;

  BackgroundJobsDtoOutputJobsInnerLastRunBuilder() {
    BackgroundJobsDtoOutputJobsInnerLastRun._defaults(this);
  }

  BackgroundJobsDtoOutputJobsInnerLastRunBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _at = $v.at;
      _processed = $v.processed;
      _error = $v.error;
      _attempts = $v.attempts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackgroundJobsDtoOutputJobsInnerLastRun other) {
    _$v = other as _$BackgroundJobsDtoOutputJobsInnerLastRun;
  }

  @override
  void update(
      void Function(BackgroundJobsDtoOutputJobsInnerLastRunBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackgroundJobsDtoOutputJobsInnerLastRun build() => _build();

  _$BackgroundJobsDtoOutputJobsInnerLastRun _build() {
    final _$result = _$v ??
        _$BackgroundJobsDtoOutputJobsInnerLastRun._(
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'BackgroundJobsDtoOutputJobsInnerLastRun', 'state'),
          at: BuiltValueNullFieldError.checkNotNull(
              at, r'BackgroundJobsDtoOutputJobsInnerLastRun', 'at'),
          processed: processed,
          error: error,
          attempts: BuiltValueNullFieldError.checkNotNull(
              attempts, r'BackgroundJobsDtoOutputJobsInnerLastRun', 'attempts'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
