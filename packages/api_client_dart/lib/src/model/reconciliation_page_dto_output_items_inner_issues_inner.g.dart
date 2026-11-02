// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_page_dto_output_items_inner_issues_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReconciliationPageDtoOutputItemsInnerIssuesInner
    extends ReconciliationPageDtoOutputItemsInnerIssuesInner {
  @override
  final String checkpoint;
  @override
  final String entityId;
  @override
  final String operatorId;
  @override
  final String expected;
  @override
  final String actual;

  factory _$ReconciliationPageDtoOutputItemsInnerIssuesInner(
          [void Function(
                  ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder)?
              updates]) =>
      (ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder()
            ..update(updates))
          ._build();

  _$ReconciliationPageDtoOutputItemsInnerIssuesInner._(
      {required this.checkpoint,
      required this.entityId,
      required this.operatorId,
      required this.expected,
      required this.actual})
      : super._();
  @override
  ReconciliationPageDtoOutputItemsInnerIssuesInner rebuild(
          void Function(ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder toBuilder() =>
      ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReconciliationPageDtoOutputItemsInnerIssuesInner &&
        checkpoint == other.checkpoint &&
        entityId == other.entityId &&
        operatorId == other.operatorId &&
        expected == other.expected &&
        actual == other.actual;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checkpoint.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, expected.hashCode);
    _$hash = $jc(_$hash, actual.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ReconciliationPageDtoOutputItemsInnerIssuesInner')
          ..add('checkpoint', checkpoint)
          ..add('entityId', entityId)
          ..add('operatorId', operatorId)
          ..add('expected', expected)
          ..add('actual', actual))
        .toString();
  }
}

class ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder
    implements
        Builder<ReconciliationPageDtoOutputItemsInnerIssuesInner,
            ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder> {
  _$ReconciliationPageDtoOutputItemsInnerIssuesInner? _$v;

  String? _checkpoint;
  String? get checkpoint => _$this._checkpoint;
  set checkpoint(String? checkpoint) => _$this._checkpoint = checkpoint;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _expected;
  String? get expected => _$this._expected;
  set expected(String? expected) => _$this._expected = expected;

  String? _actual;
  String? get actual => _$this._actual;
  set actual(String? actual) => _$this._actual = actual;

  ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder() {
    ReconciliationPageDtoOutputItemsInnerIssuesInner._defaults(this);
  }

  ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checkpoint = $v.checkpoint;
      _entityId = $v.entityId;
      _operatorId = $v.operatorId;
      _expected = $v.expected;
      _actual = $v.actual;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReconciliationPageDtoOutputItemsInnerIssuesInner other) {
    _$v = other as _$ReconciliationPageDtoOutputItemsInnerIssuesInner;
  }

  @override
  void update(
      void Function(ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ReconciliationPageDtoOutputItemsInnerIssuesInner build() => _build();

  _$ReconciliationPageDtoOutputItemsInnerIssuesInner _build() {
    final _$result = _$v ??
        _$ReconciliationPageDtoOutputItemsInnerIssuesInner._(
          checkpoint: BuiltValueNullFieldError.checkNotNull(
              checkpoint,
              r'ReconciliationPageDtoOutputItemsInnerIssuesInner',
              'checkpoint'),
          entityId: BuiltValueNullFieldError.checkNotNull(entityId,
              r'ReconciliationPageDtoOutputItemsInnerIssuesInner', 'entityId'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId,
              r'ReconciliationPageDtoOutputItemsInnerIssuesInner',
              'operatorId'),
          expected: BuiltValueNullFieldError.checkNotNull(expected,
              r'ReconciliationPageDtoOutputItemsInnerIssuesInner', 'expected'),
          actual: BuiltValueNullFieldError.checkNotNull(actual,
              r'ReconciliationPageDtoOutputItemsInnerIssuesInner', 'actual'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
