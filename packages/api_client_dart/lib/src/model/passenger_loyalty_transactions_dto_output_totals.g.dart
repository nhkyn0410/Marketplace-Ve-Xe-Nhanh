// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_loyalty_transactions_dto_output_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerLoyaltyTransactionsDtoOutputTotals
    extends PassengerLoyaltyTransactionsDtoOutputTotals {
  @override
  final int earned;
  @override
  final int redeemed;
  @override
  final int expired;

  factory _$PassengerLoyaltyTransactionsDtoOutputTotals(
          [void Function(PassengerLoyaltyTransactionsDtoOutputTotalsBuilder)?
              updates]) =>
      (PassengerLoyaltyTransactionsDtoOutputTotalsBuilder()..update(updates))
          ._build();

  _$PassengerLoyaltyTransactionsDtoOutputTotals._(
      {required this.earned, required this.redeemed, required this.expired})
      : super._();
  @override
  PassengerLoyaltyTransactionsDtoOutputTotals rebuild(
          void Function(PassengerLoyaltyTransactionsDtoOutputTotalsBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerLoyaltyTransactionsDtoOutputTotalsBuilder toBuilder() =>
      PassengerLoyaltyTransactionsDtoOutputTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerLoyaltyTransactionsDtoOutputTotals &&
        earned == other.earned &&
        redeemed == other.redeemed &&
        expired == other.expired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, earned.hashCode);
    _$hash = $jc(_$hash, redeemed.hashCode);
    _$hash = $jc(_$hash, expired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerLoyaltyTransactionsDtoOutputTotals')
          ..add('earned', earned)
          ..add('redeemed', redeemed)
          ..add('expired', expired))
        .toString();
  }
}

class PassengerLoyaltyTransactionsDtoOutputTotalsBuilder
    implements
        Builder<PassengerLoyaltyTransactionsDtoOutputTotals,
            PassengerLoyaltyTransactionsDtoOutputTotalsBuilder> {
  _$PassengerLoyaltyTransactionsDtoOutputTotals? _$v;

  int? _earned;
  int? get earned => _$this._earned;
  set earned(int? earned) => _$this._earned = earned;

  int? _redeemed;
  int? get redeemed => _$this._redeemed;
  set redeemed(int? redeemed) => _$this._redeemed = redeemed;

  int? _expired;
  int? get expired => _$this._expired;
  set expired(int? expired) => _$this._expired = expired;

  PassengerLoyaltyTransactionsDtoOutputTotalsBuilder() {
    PassengerLoyaltyTransactionsDtoOutputTotals._defaults(this);
  }

  PassengerLoyaltyTransactionsDtoOutputTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _earned = $v.earned;
      _redeemed = $v.redeemed;
      _expired = $v.expired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerLoyaltyTransactionsDtoOutputTotals other) {
    _$v = other as _$PassengerLoyaltyTransactionsDtoOutputTotals;
  }

  @override
  void update(
      void Function(PassengerLoyaltyTransactionsDtoOutputTotalsBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerLoyaltyTransactionsDtoOutputTotals build() => _build();

  _$PassengerLoyaltyTransactionsDtoOutputTotals _build() {
    final _$result = _$v ??
        _$PassengerLoyaltyTransactionsDtoOutputTotals._(
          earned: BuiltValueNullFieldError.checkNotNull(
              earned, r'PassengerLoyaltyTransactionsDtoOutputTotals', 'earned'),
          redeemed: BuiltValueNullFieldError.checkNotNull(redeemed,
              r'PassengerLoyaltyTransactionsDtoOutputTotals', 'redeemed'),
          expired: BuiltValueNullFieldError.checkNotNull(expired,
              r'PassengerLoyaltyTransactionsDtoOutputTotals', 'expired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
