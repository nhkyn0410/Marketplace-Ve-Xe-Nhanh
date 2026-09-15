// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_health_response_dto_output_queues_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueueHealthResponseDtoOutputQueuesInner
    extends QueueHealthResponseDtoOutputQueuesInner {
  @override
  final String name;
  @override
  final BuiltMap<String, int> counts;

  factory _$QueueHealthResponseDtoOutputQueuesInner(
          [void Function(QueueHealthResponseDtoOutputQueuesInnerBuilder)?
              updates]) =>
      (QueueHealthResponseDtoOutputQueuesInnerBuilder()..update(updates))
          ._build();

  _$QueueHealthResponseDtoOutputQueuesInner._(
      {required this.name, required this.counts})
      : super._();
  @override
  QueueHealthResponseDtoOutputQueuesInner rebuild(
          void Function(QueueHealthResponseDtoOutputQueuesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueueHealthResponseDtoOutputQueuesInnerBuilder toBuilder() =>
      QueueHealthResponseDtoOutputQueuesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueueHealthResponseDtoOutputQueuesInner &&
        name == other.name &&
        counts == other.counts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'QueueHealthResponseDtoOutputQueuesInner')
          ..add('name', name)
          ..add('counts', counts))
        .toString();
  }
}

class QueueHealthResponseDtoOutputQueuesInnerBuilder
    implements
        Builder<QueueHealthResponseDtoOutputQueuesInner,
            QueueHealthResponseDtoOutputQueuesInnerBuilder> {
  _$QueueHealthResponseDtoOutputQueuesInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  QueueHealthResponseDtoOutputQueuesInnerBuilder() {
    QueueHealthResponseDtoOutputQueuesInner._defaults(this);
  }

  QueueHealthResponseDtoOutputQueuesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _counts = $v.counts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueueHealthResponseDtoOutputQueuesInner other) {
    _$v = other as _$QueueHealthResponseDtoOutputQueuesInner;
  }

  @override
  void update(
      void Function(QueueHealthResponseDtoOutputQueuesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueueHealthResponseDtoOutputQueuesInner build() => _build();

  _$QueueHealthResponseDtoOutputQueuesInner _build() {
    _$QueueHealthResponseDtoOutputQueuesInner _$result;
    try {
      _$result = _$v ??
          _$QueueHealthResponseDtoOutputQueuesInner._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'QueueHealthResponseDtoOutputQueuesInner', 'name'),
            counts: counts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        counts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueueHealthResponseDtoOutputQueuesInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
