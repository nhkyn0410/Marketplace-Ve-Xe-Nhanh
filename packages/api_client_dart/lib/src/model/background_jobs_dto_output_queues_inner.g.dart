// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_jobs_dto_output_queues_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackgroundJobsDtoOutputQueuesInner
    extends BackgroundJobsDtoOutputQueuesInner {
  @override
  final String name;
  @override
  final int waiting;
  @override
  final int active;
  @override
  final int delayed;
  @override
  final int failed;

  factory _$BackgroundJobsDtoOutputQueuesInner(
          [void Function(BackgroundJobsDtoOutputQueuesInnerBuilder)?
              updates]) =>
      (BackgroundJobsDtoOutputQueuesInnerBuilder()..update(updates))._build();

  _$BackgroundJobsDtoOutputQueuesInner._(
      {required this.name,
      required this.waiting,
      required this.active,
      required this.delayed,
      required this.failed})
      : super._();
  @override
  BackgroundJobsDtoOutputQueuesInner rebuild(
          void Function(BackgroundJobsDtoOutputQueuesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackgroundJobsDtoOutputQueuesInnerBuilder toBuilder() =>
      BackgroundJobsDtoOutputQueuesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackgroundJobsDtoOutputQueuesInner &&
        name == other.name &&
        waiting == other.waiting &&
        active == other.active &&
        delayed == other.delayed &&
        failed == other.failed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, waiting.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, delayed.hashCode);
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackgroundJobsDtoOutputQueuesInner')
          ..add('name', name)
          ..add('waiting', waiting)
          ..add('active', active)
          ..add('delayed', delayed)
          ..add('failed', failed))
        .toString();
  }
}

class BackgroundJobsDtoOutputQueuesInnerBuilder
    implements
        Builder<BackgroundJobsDtoOutputQueuesInner,
            BackgroundJobsDtoOutputQueuesInnerBuilder> {
  _$BackgroundJobsDtoOutputQueuesInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _waiting;
  int? get waiting => _$this._waiting;
  set waiting(int? waiting) => _$this._waiting = waiting;

  int? _active;
  int? get active => _$this._active;
  set active(int? active) => _$this._active = active;

  int? _delayed;
  int? get delayed => _$this._delayed;
  set delayed(int? delayed) => _$this._delayed = delayed;

  int? _failed;
  int? get failed => _$this._failed;
  set failed(int? failed) => _$this._failed = failed;

  BackgroundJobsDtoOutputQueuesInnerBuilder() {
    BackgroundJobsDtoOutputQueuesInner._defaults(this);
  }

  BackgroundJobsDtoOutputQueuesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _waiting = $v.waiting;
      _active = $v.active;
      _delayed = $v.delayed;
      _failed = $v.failed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackgroundJobsDtoOutputQueuesInner other) {
    _$v = other as _$BackgroundJobsDtoOutputQueuesInner;
  }

  @override
  void update(
      void Function(BackgroundJobsDtoOutputQueuesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackgroundJobsDtoOutputQueuesInner build() => _build();

  _$BackgroundJobsDtoOutputQueuesInner _build() {
    final _$result = _$v ??
        _$BackgroundJobsDtoOutputQueuesInner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'BackgroundJobsDtoOutputQueuesInner', 'name'),
          waiting: BuiltValueNullFieldError.checkNotNull(
              waiting, r'BackgroundJobsDtoOutputQueuesInner', 'waiting'),
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'BackgroundJobsDtoOutputQueuesInner', 'active'),
          delayed: BuiltValueNullFieldError.checkNotNull(
              delayed, r'BackgroundJobsDtoOutputQueuesInner', 'delayed'),
          failed: BuiltValueNullFieldError.checkNotNull(
              failed, r'BackgroundJobsDtoOutputQueuesInner', 'failed'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
