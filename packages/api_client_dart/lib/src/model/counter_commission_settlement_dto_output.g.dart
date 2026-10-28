// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_commission_settlement_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterCommissionSettlementDtoOutput
    extends CounterCommissionSettlementDtoOutput {
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

  factory _$CounterCommissionSettlementDtoOutput(
          [void Function(CounterCommissionSettlementDtoOutputBuilder)?
              updates]) =>
      (CounterCommissionSettlementDtoOutputBuilder()..update(updates))._build();

  _$CounterCommissionSettlementDtoOutput._(
      {required this.id,
      required this.operatorId,
      required this.amount,
      required this.reference,
      required this.reason,
      required this.createdBy,
      required this.createdAt})
      : super._();
  @override
  CounterCommissionSettlementDtoOutput rebuild(
          void Function(CounterCommissionSettlementDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterCommissionSettlementDtoOutputBuilder toBuilder() =>
      CounterCommissionSettlementDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterCommissionSettlementDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CounterCommissionSettlementDtoOutput')
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

class CounterCommissionSettlementDtoOutputBuilder
    implements
        Builder<CounterCommissionSettlementDtoOutput,
            CounterCommissionSettlementDtoOutputBuilder> {
  _$CounterCommissionSettlementDtoOutput? _$v;

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

  CounterCommissionSettlementDtoOutputBuilder() {
    CounterCommissionSettlementDtoOutput._defaults(this);
  }

  CounterCommissionSettlementDtoOutputBuilder get _$this {
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
  void replace(CounterCommissionSettlementDtoOutput other) {
    _$v = other as _$CounterCommissionSettlementDtoOutput;
  }

  @override
  void update(
      void Function(CounterCommissionSettlementDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterCommissionSettlementDtoOutput build() => _build();

  _$CounterCommissionSettlementDtoOutput _build() {
    final _$result = _$v ??
        _$CounterCommissionSettlementDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CounterCommissionSettlementDtoOutput', 'id'),
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'CounterCommissionSettlementDtoOutput', 'operatorId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CounterCommissionSettlementDtoOutput', 'amount'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'CounterCommissionSettlementDtoOutput', 'reference'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CounterCommissionSettlementDtoOutput', 'reason'),
          createdBy: BuiltValueNullFieldError.checkNotNull(
              createdBy, r'CounterCommissionSettlementDtoOutput', 'createdBy'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CounterCommissionSettlementDtoOutput', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
