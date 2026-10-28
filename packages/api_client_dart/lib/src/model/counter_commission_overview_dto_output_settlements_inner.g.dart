// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_commission_overview_dto_output_settlements_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterCommissionOverviewDtoOutputSettlementsInner
    extends CounterCommissionOverviewDtoOutputSettlementsInner {
  @override
  final String id;
  @override
  final String operatorId;
  @override
  final String amount;
  @override
  final String reference;
  @override
  final String reason;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  factory _$CounterCommissionOverviewDtoOutputSettlementsInner(
          [void Function(
                  CounterCommissionOverviewDtoOutputSettlementsInnerBuilder)?
              updates]) =>
      (CounterCommissionOverviewDtoOutputSettlementsInnerBuilder()
            ..update(updates))
          ._build();

  _$CounterCommissionOverviewDtoOutputSettlementsInner._(
      {required this.id,
      required this.operatorId,
      required this.amount,
      required this.reference,
      required this.reason,
      required this.createdBy,
      required this.createdAt})
      : super._();
  @override
  CounterCommissionOverviewDtoOutputSettlementsInner rebuild(
          void Function(
                  CounterCommissionOverviewDtoOutputSettlementsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterCommissionOverviewDtoOutputSettlementsInnerBuilder toBuilder() =>
      CounterCommissionOverviewDtoOutputSettlementsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterCommissionOverviewDtoOutputSettlementsInner &&
        id == other.id &&
        operatorId == other.operatorId &&
        amount == other.amount &&
        reference == other.reference &&
        reason == other.reason &&
        createdBy == other.createdBy &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterCommissionOverviewDtoOutputSettlementsInner')
          ..add('id', id)
          ..add('operatorId', operatorId)
          ..add('amount', amount)
          ..add('reference', reference)
          ..add('reason', reason)
          ..add('createdBy', createdBy)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CounterCommissionOverviewDtoOutputSettlementsInnerBuilder
    implements
        Builder<CounterCommissionOverviewDtoOutputSettlementsInner,
            CounterCommissionOverviewDtoOutputSettlementsInnerBuilder> {
  _$CounterCommissionOverviewDtoOutputSettlementsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CounterCommissionOverviewDtoOutputSettlementsInnerBuilder() {
    CounterCommissionOverviewDtoOutputSettlementsInner._defaults(this);
  }

  CounterCommissionOverviewDtoOutputSettlementsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _operatorId = $v.operatorId;
      _amount = $v.amount;
      _reference = $v.reference;
      _reason = $v.reason;
      _createdBy = $v.createdBy;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterCommissionOverviewDtoOutputSettlementsInner other) {
    _$v = other as _$CounterCommissionOverviewDtoOutputSettlementsInner;
  }

  @override
  void update(
      void Function(CounterCommissionOverviewDtoOutputSettlementsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterCommissionOverviewDtoOutputSettlementsInner build() => _build();

  _$CounterCommissionOverviewDtoOutputSettlementsInner _build() {
    final _$result = _$v ??
        _$CounterCommissionOverviewDtoOutputSettlementsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CounterCommissionOverviewDtoOutputSettlementsInner', 'id'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId,
              r'CounterCommissionOverviewDtoOutputSettlementsInner',
              'operatorId'),
          amount: BuiltValueNullFieldError.checkNotNull(amount,
              r'CounterCommissionOverviewDtoOutputSettlementsInner', 'amount'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'CounterCommissionOverviewDtoOutputSettlementsInner',
              'reference'),
          reason: BuiltValueNullFieldError.checkNotNull(reason,
              r'CounterCommissionOverviewDtoOutputSettlementsInner', 'reason'),
          createdBy: BuiltValueNullFieldError.checkNotNull(
              createdBy,
              r'CounterCommissionOverviewDtoOutputSettlementsInner',
              'createdBy'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'CounterCommissionOverviewDtoOutputSettlementsInner',
              'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
