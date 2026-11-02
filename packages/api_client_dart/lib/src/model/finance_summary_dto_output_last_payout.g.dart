// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_summary_dto_output_last_payout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceSummaryDtoOutputLastPayout
    extends FinanceSummaryDtoOutputLastPayout {
  @override
  final String payoutId;
  @override
  final int amount;
  @override
  final DateTime paidAt;

  factory _$FinanceSummaryDtoOutputLastPayout(
          [void Function(FinanceSummaryDtoOutputLastPayoutBuilder)? updates]) =>
      (FinanceSummaryDtoOutputLastPayoutBuilder()..update(updates))._build();

  _$FinanceSummaryDtoOutputLastPayout._(
      {required this.payoutId, required this.amount, required this.paidAt})
      : super._();
  @override
  FinanceSummaryDtoOutputLastPayout rebuild(
          void Function(FinanceSummaryDtoOutputLastPayoutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceSummaryDtoOutputLastPayoutBuilder toBuilder() =>
      FinanceSummaryDtoOutputLastPayoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceSummaryDtoOutputLastPayout &&
        payoutId == other.payoutId &&
        amount == other.amount &&
        paidAt == other.paidAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payoutId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceSummaryDtoOutputLastPayout')
          ..add('payoutId', payoutId)
          ..add('amount', amount)
          ..add('paidAt', paidAt))
        .toString();
  }
}

class FinanceSummaryDtoOutputLastPayoutBuilder
    implements
        Builder<FinanceSummaryDtoOutputLastPayout,
            FinanceSummaryDtoOutputLastPayoutBuilder> {
  _$FinanceSummaryDtoOutputLastPayout? _$v;

  String? _payoutId;
  String? get payoutId => _$this._payoutId;
  set payoutId(String? payoutId) => _$this._payoutId = payoutId;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  FinanceSummaryDtoOutputLastPayoutBuilder() {
    FinanceSummaryDtoOutputLastPayout._defaults(this);
  }

  FinanceSummaryDtoOutputLastPayoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payoutId = $v.payoutId;
      _amount = $v.amount;
      _paidAt = $v.paidAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceSummaryDtoOutputLastPayout other) {
    _$v = other as _$FinanceSummaryDtoOutputLastPayout;
  }

  @override
  void update(
      void Function(FinanceSummaryDtoOutputLastPayoutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceSummaryDtoOutputLastPayout build() => _build();

  _$FinanceSummaryDtoOutputLastPayout _build() {
    final _$result = _$v ??
        _$FinanceSummaryDtoOutputLastPayout._(
          payoutId: BuiltValueNullFieldError.checkNotNull(
              payoutId, r'FinanceSummaryDtoOutputLastPayout', 'payoutId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'FinanceSummaryDtoOutputLastPayout', 'amount'),
          paidAt: BuiltValueNullFieldError.checkNotNull(
              paidAt, r'FinanceSummaryDtoOutputLastPayout', 'paidAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
