// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_detail_dto_output_checks.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutDetailDtoOutputChecks extends PayoutDetailDtoOutputChecks {
  @override
  final bool ledgerMatches;
  @override
  final bool noPendingRefunds;
  @override
  final bool bankVerified;

  factory _$PayoutDetailDtoOutputChecks(
          [void Function(PayoutDetailDtoOutputChecksBuilder)? updates]) =>
      (PayoutDetailDtoOutputChecksBuilder()..update(updates))._build();

  _$PayoutDetailDtoOutputChecks._(
      {required this.ledgerMatches,
      required this.noPendingRefunds,
      required this.bankVerified})
      : super._();
  @override
  PayoutDetailDtoOutputChecks rebuild(
          void Function(PayoutDetailDtoOutputChecksBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutDetailDtoOutputChecksBuilder toBuilder() =>
      PayoutDetailDtoOutputChecksBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutDetailDtoOutputChecks &&
        ledgerMatches == other.ledgerMatches &&
        noPendingRefunds == other.noPendingRefunds &&
        bankVerified == other.bankVerified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ledgerMatches.hashCode);
    _$hash = $jc(_$hash, noPendingRefunds.hashCode);
    _$hash = $jc(_$hash, bankVerified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutDetailDtoOutputChecks')
          ..add('ledgerMatches', ledgerMatches)
          ..add('noPendingRefunds', noPendingRefunds)
          ..add('bankVerified', bankVerified))
        .toString();
  }
}

class PayoutDetailDtoOutputChecksBuilder
    implements
        Builder<PayoutDetailDtoOutputChecks,
            PayoutDetailDtoOutputChecksBuilder> {
  _$PayoutDetailDtoOutputChecks? _$v;

  bool? _ledgerMatches;
  bool? get ledgerMatches => _$this._ledgerMatches;
  set ledgerMatches(bool? ledgerMatches) =>
      _$this._ledgerMatches = ledgerMatches;

  bool? _noPendingRefunds;
  bool? get noPendingRefunds => _$this._noPendingRefunds;
  set noPendingRefunds(bool? noPendingRefunds) =>
      _$this._noPendingRefunds = noPendingRefunds;

  bool? _bankVerified;
  bool? get bankVerified => _$this._bankVerified;
  set bankVerified(bool? bankVerified) => _$this._bankVerified = bankVerified;

  PayoutDetailDtoOutputChecksBuilder() {
    PayoutDetailDtoOutputChecks._defaults(this);
  }

  PayoutDetailDtoOutputChecksBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ledgerMatches = $v.ledgerMatches;
      _noPendingRefunds = $v.noPendingRefunds;
      _bankVerified = $v.bankVerified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutDetailDtoOutputChecks other) {
    _$v = other as _$PayoutDetailDtoOutputChecks;
  }

  @override
  void update(void Function(PayoutDetailDtoOutputChecksBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutDetailDtoOutputChecks build() => _build();

  _$PayoutDetailDtoOutputChecks _build() {
    final _$result = _$v ??
        _$PayoutDetailDtoOutputChecks._(
          ledgerMatches: BuiltValueNullFieldError.checkNotNull(
              ledgerMatches, r'PayoutDetailDtoOutputChecks', 'ledgerMatches'),
          noPendingRefunds: BuiltValueNullFieldError.checkNotNull(
              noPendingRefunds,
              r'PayoutDetailDtoOutputChecks',
              'noPendingRefunds'),
          bankVerified: BuiltValueNullFieldError.checkNotNull(
              bankVerified, r'PayoutDetailDtoOutputChecks', 'bankVerified'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
