// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_jobs_dto_output_jobs_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackgroundJobsDtoOutputJobsInner
    extends BackgroundJobsDtoOutputJobsInner {
  @override
  final String queue;
  @override
  final String name;
  @override
  final String label;
  @override
  final String? schedule;
  @override
  final DateTime? nextRunAt;
  @override
  final BackgroundJobsDtoOutputJobsInnerLastRun? lastRun;
  @override
  final int failedCount;

  factory _$BackgroundJobsDtoOutputJobsInner(
          [void Function(BackgroundJobsDtoOutputJobsInnerBuilder)? updates]) =>
      (BackgroundJobsDtoOutputJobsInnerBuilder()..update(updates))._build();

  _$BackgroundJobsDtoOutputJobsInner._(
      {required this.queue,
      required this.name,
      required this.label,
      this.schedule,
      this.nextRunAt,
      this.lastRun,
      required this.failedCount})
      : super._();
  @override
  BackgroundJobsDtoOutputJobsInner rebuild(
          void Function(BackgroundJobsDtoOutputJobsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackgroundJobsDtoOutputJobsInnerBuilder toBuilder() =>
      BackgroundJobsDtoOutputJobsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackgroundJobsDtoOutputJobsInner &&
        queue == other.queue &&
        name == other.name &&
        label == other.label &&
        schedule == other.schedule &&
        nextRunAt == other.nextRunAt &&
        lastRun == other.lastRun &&
        failedCount == other.failedCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, queue.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, nextRunAt.hashCode);
    _$hash = $jc(_$hash, lastRun.hashCode);
    _$hash = $jc(_$hash, failedCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackgroundJobsDtoOutputJobsInner')
          ..add('queue', queue)
          ..add('name', name)
          ..add('label', label)
          ..add('schedule', schedule)
          ..add('nextRunAt', nextRunAt)
          ..add('lastRun', lastRun)
          ..add('failedCount', failedCount))
        .toString();
  }
}

class BackgroundJobsDtoOutputJobsInnerBuilder
    implements
        Builder<BackgroundJobsDtoOutputJobsInner,
            BackgroundJobsDtoOutputJobsInnerBuilder> {
  _$BackgroundJobsDtoOutputJobsInner? _$v;

  String? _queue;
  String? get queue => _$this._queue;
  set queue(String? queue) => _$this._queue = queue;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _schedule;
  String? get schedule => _$this._schedule;
  set schedule(String? schedule) => _$this._schedule = schedule;

  DateTime? _nextRunAt;
  DateTime? get nextRunAt => _$this._nextRunAt;
  set nextRunAt(DateTime? nextRunAt) => _$this._nextRunAt = nextRunAt;

  BackgroundJobsDtoOutputJobsInnerLastRunBuilder? _lastRun;
  BackgroundJobsDtoOutputJobsInnerLastRunBuilder get lastRun =>
      _$this._lastRun ??= BackgroundJobsDtoOutputJobsInnerLastRunBuilder();
  set lastRun(BackgroundJobsDtoOutputJobsInnerLastRunBuilder? lastRun) =>
      _$this._lastRun = lastRun;

  int? _failedCount;
  int? get failedCount => _$this._failedCount;
  set failedCount(int? failedCount) => _$this._failedCount = failedCount;

  BackgroundJobsDtoOutputJobsInnerBuilder() {
    BackgroundJobsDtoOutputJobsInner._defaults(this);
  }

  BackgroundJobsDtoOutputJobsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _queue = $v.queue;
      _name = $v.name;
      _label = $v.label;
      _schedule = $v.schedule;
      _nextRunAt = $v.nextRunAt;
      _lastRun = $v.lastRun?.toBuilder();
      _failedCount = $v.failedCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackgroundJobsDtoOutputJobsInner other) {
    _$v = other as _$BackgroundJobsDtoOutputJobsInner;
  }

  @override
  void update(void Function(BackgroundJobsDtoOutputJobsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackgroundJobsDtoOutputJobsInner build() => _build();

  _$BackgroundJobsDtoOutputJobsInner _build() {
    _$BackgroundJobsDtoOutputJobsInner _$result;
    try {
      _$result = _$v ??
          _$BackgroundJobsDtoOutputJobsInner._(
            queue: BuiltValueNullFieldError.checkNotNull(
                queue, r'BackgroundJobsDtoOutputJobsInner', 'queue'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'BackgroundJobsDtoOutputJobsInner', 'name'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'BackgroundJobsDtoOutputJobsInner', 'label'),
            schedule: schedule,
            nextRunAt: nextRunAt,
            lastRun: _lastRun?.build(),
            failedCount: BuiltValueNullFieldError.checkNotNull(failedCount,
                r'BackgroundJobsDtoOutputJobsInner', 'failedCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lastRun';
        _lastRun?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackgroundJobsDtoOutputJobsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
