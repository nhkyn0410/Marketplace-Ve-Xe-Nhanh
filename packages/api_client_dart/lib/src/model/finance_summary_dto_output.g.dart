// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_summary_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceSummaryDtoOutput extends FinanceSummaryDtoOutput {
  @override
  final int heldBalance;
  @override
  final int eligibleAmount;
  @override
  final int pendingAmount;
  @override
  final FinanceSummaryDtoOutputLastPayout? lastPayout;
  @override
  final int payoutDelayDays;

  factory _$FinanceSummaryDtoOutput(
          [void Function(FinanceSummaryDtoOutputBuilder)? updates]) =>
      (FinanceSummaryDtoOutputBuilder()..update(updates))._build();

  _$FinanceSummaryDtoOutput._(
      {required this.heldBalance,
      required this.eligibleAmount,
      required this.pendingAmount,
      this.lastPayout,
      required this.payoutDelayDays})
      : super._();
  @override
  FinanceSummaryDtoOutput rebuild(
          void Function(FinanceSummaryDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceSummaryDtoOutputBuilder toBuilder() =>
      FinanceSummaryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceSummaryDtoOutput &&
        heldBalance == other.heldBalance &&
        eligibleAmount == other.eligibleAmount &&
        pendingAmount == other.pendingAmount &&
        lastPayout == other.lastPayout &&
        payoutDelayDays == other.payoutDelayDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, heldBalance.hashCode);
    _$hash = $jc(_$hash, eligibleAmount.hashCode);
    _$hash = $jc(_$hash, pendingAmount.hashCode);
    _$hash = $jc(_$hash, lastPayout.hashCode);
    _$hash = $jc(_$hash, payoutDelayDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceSummaryDtoOutput')
          ..add('heldBalance', heldBalance)
          ..add('eligibleAmount', eligibleAmount)
          ..add('pendingAmount', pendingAmount)
          ..add('lastPayout', lastPayout)
          ..add('payoutDelayDays', payoutDelayDays))
        .toString();
  }
}

class FinanceSummaryDtoOutputBuilder
    implements
        Builder<FinanceSummaryDtoOutput, FinanceSummaryDtoOutputBuilder> {
  _$FinanceSummaryDtoOutput? _$v;

  int? _heldBalance;
  int? get heldBalance => _$this._heldBalance;
  set heldBalance(int? heldBalance) => _$this._heldBalance = heldBalance;

  int? _eligibleAmount;
  int? get eligibleAmount => _$this._eligibleAmount;
  set eligibleAmount(int? eligibleAmount) =>
      _$this._eligibleAmount = eligibleAmount;

  int? _pendingAmount;
  int? get pendingAmount => _$this._pendingAmount;
  set pendingAmount(int? pendingAmount) =>
      _$this._pendingAmount = pendingAmount;

  FinanceSummaryDtoOutputLastPayoutBuilder? _lastPayout;
  FinanceSummaryDtoOutputLastPayoutBuilder get lastPayout =>
      _$this._lastPayout ??= FinanceSummaryDtoOutputLastPayoutBuilder();
  set lastPayout(FinanceSummaryDtoOutputLastPayoutBuilder? lastPayout) =>
      _$this._lastPayout = lastPayout;

  int? _payoutDelayDays;
  int? get payoutDelayDays => _$this._payoutDelayDays;
  set payoutDelayDays(int? payoutDelayDays) =>
      _$this._payoutDelayDays = payoutDelayDays;

  FinanceSummaryDtoOutputBuilder() {
    FinanceSummaryDtoOutput._defaults(this);
  }

  FinanceSummaryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _heldBalance = $v.heldBalance;
      _eligibleAmount = $v.eligibleAmount;
      _pendingAmount = $v.pendingAmount;
      _lastPayout = $v.lastPayout?.toBuilder();
      _payoutDelayDays = $v.payoutDelayDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceSummaryDtoOutput other) {
    _$v = other as _$FinanceSummaryDtoOutput;
  }

  @override
  void update(void Function(FinanceSummaryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceSummaryDtoOutput build() => _build();

  _$FinanceSummaryDtoOutput _build() {
    _$FinanceSummaryDtoOutput _$result;
    try {
      _$result = _$v ??
          _$FinanceSummaryDtoOutput._(
            heldBalance: BuiltValueNullFieldError.checkNotNull(
                heldBalance, r'FinanceSummaryDtoOutput', 'heldBalance'),
            eligibleAmount: BuiltValueNullFieldError.checkNotNull(
                eligibleAmount, r'FinanceSummaryDtoOutput', 'eligibleAmount'),
            pendingAmount: BuiltValueNullFieldError.checkNotNull(
                pendingAmount, r'FinanceSummaryDtoOutput', 'pendingAmount'),
            lastPayout: _lastPayout?.build(),
            payoutDelayDays: BuiltValueNullFieldError.checkNotNull(
                payoutDelayDays, r'FinanceSummaryDtoOutput', 'payoutDelayDays'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lastPayout';
        _lastPayout?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FinanceSummaryDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
