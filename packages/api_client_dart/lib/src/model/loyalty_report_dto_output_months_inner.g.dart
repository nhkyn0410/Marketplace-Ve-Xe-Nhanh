// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_report_dto_output_months_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoyaltyReportDtoOutputMonthsInner
    extends LoyaltyReportDtoOutputMonthsInner {
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
  @override
  final String month;

  factory _$LoyaltyReportDtoOutputMonthsInner(
          [void Function(LoyaltyReportDtoOutputMonthsInnerBuilder)? updates]) =>
      (LoyaltyReportDtoOutputMonthsInnerBuilder()..update(updates))._build();

  _$LoyaltyReportDtoOutputMonthsInner._(
      {required this.issued,
      required this.redeemed,
      required this.expired,
      required this.vouchersRedeemed,
      required this.vouchersUsed,
      required this.platformDiscount,
      required this.month})
      : super._();
  @override
  LoyaltyReportDtoOutputMonthsInner rebuild(
          void Function(LoyaltyReportDtoOutputMonthsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyReportDtoOutputMonthsInnerBuilder toBuilder() =>
      LoyaltyReportDtoOutputMonthsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyReportDtoOutputMonthsInner &&
        issued == other.issued &&
        redeemed == other.redeemed &&
        expired == other.expired &&
        vouchersRedeemed == other.vouchersRedeemed &&
        vouchersUsed == other.vouchersUsed &&
        platformDiscount == other.platformDiscount &&
        month == other.month;
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
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyReportDtoOutputMonthsInner')
          ..add('issued', issued)
          ..add('redeemed', redeemed)
          ..add('expired', expired)
          ..add('vouchersRedeemed', vouchersRedeemed)
          ..add('vouchersUsed', vouchersUsed)
          ..add('platformDiscount', platformDiscount)
          ..add('month', month))
        .toString();
  }
}

class LoyaltyReportDtoOutputMonthsInnerBuilder
    implements
        Builder<LoyaltyReportDtoOutputMonthsInner,
            LoyaltyReportDtoOutputMonthsInnerBuilder> {
  _$LoyaltyReportDtoOutputMonthsInner? _$v;

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

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  LoyaltyReportDtoOutputMonthsInnerBuilder() {
    LoyaltyReportDtoOutputMonthsInner._defaults(this);
  }

  LoyaltyReportDtoOutputMonthsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _issued = $v.issued;
      _redeemed = $v.redeemed;
      _expired = $v.expired;
      _vouchersRedeemed = $v.vouchersRedeemed;
      _vouchersUsed = $v.vouchersUsed;
      _platformDiscount = $v.platformDiscount;
      _month = $v.month;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyReportDtoOutputMonthsInner other) {
    _$v = other as _$LoyaltyReportDtoOutputMonthsInner;
  }

  @override
  void update(
      void Function(LoyaltyReportDtoOutputMonthsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyReportDtoOutputMonthsInner build() => _build();

  _$LoyaltyReportDtoOutputMonthsInner _build() {
    final _$result = _$v ??
        _$LoyaltyReportDtoOutputMonthsInner._(
          issued: BuiltValueNullFieldError.checkNotNull(
              issued, r'LoyaltyReportDtoOutputMonthsInner', 'issued'),
          redeemed: BuiltValueNullFieldError.checkNotNull(
              redeemed, r'LoyaltyReportDtoOutputMonthsInner', 'redeemed'),
          expired: BuiltValueNullFieldError.checkNotNull(
              expired, r'LoyaltyReportDtoOutputMonthsInner', 'expired'),
          vouchersRedeemed: BuiltValueNullFieldError.checkNotNull(
              vouchersRedeemed,
              r'LoyaltyReportDtoOutputMonthsInner',
              'vouchersRedeemed'),
          vouchersUsed: BuiltValueNullFieldError.checkNotNull(vouchersUsed,
              r'LoyaltyReportDtoOutputMonthsInner', 'vouchersUsed'),
          platformDiscount: BuiltValueNullFieldError.checkNotNull(
              platformDiscount,
              r'LoyaltyReportDtoOutputMonthsInner',
              'platformDiscount'),
          month: BuiltValueNullFieldError.checkNotNull(
              month, r'LoyaltyReportDtoOutputMonthsInner', 'month'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
