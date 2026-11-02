// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_jobs_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackgroundJobsDtoOutput extends BackgroundJobsDtoOutput {
  @override
  final DateTime checkedAt;
  @override
  final bool available;
  @override
  final BuiltList<BackgroundJobsDtoOutputJobsInner> jobs;
  @override
  final BuiltList<BackgroundJobsDtoOutputQueuesInner> queues;

  factory _$BackgroundJobsDtoOutput(
          [void Function(BackgroundJobsDtoOutputBuilder)? updates]) =>
      (BackgroundJobsDtoOutputBuilder()..update(updates))._build();

  _$BackgroundJobsDtoOutput._(
      {required this.checkedAt,
      required this.available,
      required this.jobs,
      required this.queues})
      : super._();
  @override
  BackgroundJobsDtoOutput rebuild(
          void Function(BackgroundJobsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackgroundJobsDtoOutputBuilder toBuilder() =>
      BackgroundJobsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackgroundJobsDtoOutput &&
        checkedAt == other.checkedAt &&
        available == other.available &&
        jobs == other.jobs &&
        queues == other.queues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checkedAt.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, jobs.hashCode);
    _$hash = $jc(_$hash, queues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackgroundJobsDtoOutput')
          ..add('checkedAt', checkedAt)
          ..add('available', available)
          ..add('jobs', jobs)
          ..add('queues', queues))
        .toString();
  }
}

class BackgroundJobsDtoOutputBuilder
    implements
        Builder<BackgroundJobsDtoOutput, BackgroundJobsDtoOutputBuilder> {
  _$BackgroundJobsDtoOutput? _$v;

  DateTime? _checkedAt;
  DateTime? get checkedAt => _$this._checkedAt;
  set checkedAt(DateTime? checkedAt) => _$this._checkedAt = checkedAt;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  ListBuilder<BackgroundJobsDtoOutputJobsInner>? _jobs;
  ListBuilder<BackgroundJobsDtoOutputJobsInner> get jobs =>
      _$this._jobs ??= ListBuilder<BackgroundJobsDtoOutputJobsInner>();
  set jobs(ListBuilder<BackgroundJobsDtoOutputJobsInner>? jobs) =>
      _$this._jobs = jobs;

  ListBuilder<BackgroundJobsDtoOutputQueuesInner>? _queues;
  ListBuilder<BackgroundJobsDtoOutputQueuesInner> get queues =>
      _$this._queues ??= ListBuilder<BackgroundJobsDtoOutputQueuesInner>();
  set queues(ListBuilder<BackgroundJobsDtoOutputQueuesInner>? queues) =>
      _$this._queues = queues;

  BackgroundJobsDtoOutputBuilder() {
    BackgroundJobsDtoOutput._defaults(this);
  }

  BackgroundJobsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checkedAt = $v.checkedAt;
      _available = $v.available;
      _jobs = $v.jobs.toBuilder();
      _queues = $v.queues.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackgroundJobsDtoOutput other) {
    _$v = other as _$BackgroundJobsDtoOutput;
  }

  @override
  void update(void Function(BackgroundJobsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackgroundJobsDtoOutput build() => _build();

  _$BackgroundJobsDtoOutput _build() {
    _$BackgroundJobsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$BackgroundJobsDtoOutput._(
            checkedAt: BuiltValueNullFieldError.checkNotNull(
                checkedAt, r'BackgroundJobsDtoOutput', 'checkedAt'),
            available: BuiltValueNullFieldError.checkNotNull(
                available, r'BackgroundJobsDtoOutput', 'available'),
            jobs: jobs.build(),
            queues: queues.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'jobs';
        jobs.build();
        _$failedField = 'queues';
        queues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackgroundJobsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
