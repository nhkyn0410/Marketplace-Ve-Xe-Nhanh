// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_report_dto_output_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoyaltyReportDtoOutputTotals extends LoyaltyReportDtoOutputTotals {
  @override
  final int issued;
  @override
  final int redeemed;
  @override
  final int expired;
  @override
  final int vouchersRedeemed;
  @override
  final int vouchersUsed;
  @override
  final int platformDiscount;

  factory _$LoyaltyReportDtoOutputTotals(
          [void Function(LoyaltyReportDtoOutputTotalsBuilder)? updates]) =>
      (LoyaltyReportDtoOutputTotalsBuilder()..update(updates))._build();

  _$LoyaltyReportDtoOutputTotals._(
      {required this.issued,
      required this.redeemed,
      required this.expired,
      required this.vouchersRedeemed,
      required this.vouchersUsed,
      required this.platformDiscount})
      : super._();
  @override
  LoyaltyReportDtoOutputTotals rebuild(
          void Function(LoyaltyReportDtoOutputTotalsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyReportDtoOutputTotalsBuilder toBuilder() =>
      LoyaltyReportDtoOutputTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyReportDtoOutputTotals &&
        issued == other.issued &&
        redeemed == other.redeemed &&
        expired == other.expired &&
        vouchersRedeemed == other.vouchersRedeemed &&
        vouchersUsed == other.vouchersUsed &&
        platformDiscount == other.platformDiscount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, issued.hashCode);
    _$hash = $jc(_$hash, redeemed.hashCode);
    _$hash = $jc(_$hash, expired.hashCode);
    _$hash = $jc(_$hash, vouchersRedeemed.hashCode);
    _$hash = $jc(_$hash, vouchersUsed.hashCode);
    _$hash = $jc(_$hash, platformDiscount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyReportDtoOutputTotals')
          ..add('issued', issued)
          ..add('redeemed', redeemed)
          ..add('expired', expired)
          ..add('vouchersRedeemed', vouchersRedeemed)
          ..add('vouchersUsed', vouchersUsed)
          ..add('platformDiscount', platformDiscount))
        .toString();
  }
}

class LoyaltyReportDtoOutputTotalsBuilder
    implements
        Builder<LoyaltyReportDtoOutputTotals,
            LoyaltyReportDtoOutputTotalsBuilder> {
  _$LoyaltyReportDtoOutputTotals? _$v;

  int? _issued;
  int? get issued => _$this._issued;
  set issued(int? issued) => _$this._issued = issued;

  int? _redeemed;
  int? get redeemed => _$this._redeemed;
  set redeemed(int? redeemed) => _$this._redeemed = redeemed;

  int? _expired;
  int? get expired => _$this._expired;
  set expired(int? expired) => _$this._expired = expired;

  int? _vouchersRedeemed;
  int? get vouchersRedeemed => _$this._vouchersRedeemed;
  set vouchersRedeemed(int? vouchersRedeemed) =>
      _$this._vouchersRedeemed = vouchersRedeemed;

  int? _vouchersUsed;
  int? get vouchersUsed => _$this._vouchersUsed;
  set vouchersUsed(int? vouchersUsed) => _$this._vouchersUsed = vouchersUsed;

  int? _platformDiscount;
  int? get platformDiscount => _$this._platformDiscount;
  set platformDiscount(int? platformDiscount) =>
      _$this._platformDiscount = platformDiscount;

  LoyaltyReportDtoOutputTotalsBuilder() {
    LoyaltyReportDtoOutputTotals._defaults(this);
  }

  LoyaltyReportDtoOutputTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _issued = $v.issued;
      _redeemed = $v.redeemed;
      _expired = $v.expired;
      _vouchersRedeemed = $v.vouchersRedeemed;
      _vouchersUsed = $v.vouchersUsed;
      _platformDiscount = $v.platformDiscount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyReportDtoOutputTotals other) {
    _$v = other as _$LoyaltyReportDtoOutputTotals;
  }

  @override
  void update(void Function(LoyaltyReportDtoOutputTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyReportDtoOutputTotals build() => _build();

  _$LoyaltyReportDtoOutputTotals _build() {
    final _$result = _$v ??
        _$LoyaltyReportDtoOutputTotals._(
          issued: BuiltValueNullFieldError.checkNotNull(
              issued, r'LoyaltyReportDtoOutputTotals', 'issued'),
          redeemed: BuiltValueNullFieldError.checkNotNull(
              redeemed, r'LoyaltyReportDtoOutputTotals', 'redeemed'),
          expired: BuiltValueNullFieldError.checkNotNull(
              expired, r'LoyaltyReportDtoOutputTotals', 'expired'),
          vouchersRedeemed: BuiltValueNullFieldError.checkNotNull(
              vouchersRedeemed,
              r'LoyaltyReportDtoOutputTotals',
              'vouchersRedeemed'),
          vouchersUsed: BuiltValueNullFieldError.checkNotNull(
              vouchersUsed, r'LoyaltyReportDtoOutputTotals', 'vouchersUsed'),
          platformDiscount: BuiltValueNullFieldError.checkNotNull(
              platformDiscount,
              r'LoyaltyReportDtoOutputTotals',
              'platformDiscount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
