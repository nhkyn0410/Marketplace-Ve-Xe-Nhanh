// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_report_dto_output_sellers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterReportDtoOutputSellersInner
    extends CounterReportDtoOutputSellersInner {
  @override
  final String seller;
  @override
  final String cash;
  @override
  final String bankTransfer;
  @override
  final String exceptions;
  @override
  final String commission;

  factory _$CounterReportDtoOutputSellersInner(
          [void Function(CounterReportDtoOutputSellersInnerBuilder)?
              updates]) =>
      (CounterReportDtoOutputSellersInnerBuilder()..update(updates))._build();

  _$CounterReportDtoOutputSellersInner._(
      {required this.seller,
      required this.cash,
      required this.bankTransfer,
      required this.exceptions,
      required this.commission})
      : super._();
  @override
  CounterReportDtoOutputSellersInner rebuild(
          void Function(CounterReportDtoOutputSellersInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterReportDtoOutputSellersInnerBuilder toBuilder() =>
      CounterReportDtoOutputSellersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterReportDtoOutputSellersInner &&
        seller == other.seller &&
        cash == other.cash &&
        bankTransfer == other.bankTransfer &&
        exceptions == other.exceptions &&
        commission == other.commission;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seller.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, bankTransfer.hashCode);
    _$hash = $jc(_$hash, exceptions.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterReportDtoOutputSellersInner')
          ..add('seller', seller)
          ..add('cash', cash)
          ..add('bankTransfer', bankTransfer)
          ..add('exceptions', exceptions)
          ..add('commission', commission))
        .toString();
  }
}

class CounterReportDtoOutputSellersInnerBuilder
    implements
        Builder<CounterReportDtoOutputSellersInner,
            CounterReportDtoOutputSellersInnerBuilder> {
  _$CounterReportDtoOutputSellersInner? _$v;

  String? _seller;
  String? get seller => _$this._seller;
  set seller(String? seller) => _$this._seller = seller;

  String? _cash;
  String? get cash => _$this._cash;
  set cash(String? cash) => _$this._cash = cash;

  String? _bankTransfer;
  String? get bankTransfer => _$this._bankTransfer;
  set bankTransfer(String? bankTransfer) => _$this._bankTransfer = bankTransfer;

  String? _exceptions;
  String? get exceptions => _$this._exceptions;
  set exceptions(String? exceptions) => _$this._exceptions = exceptions;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  CounterReportDtoOutputSellersInnerBuilder() {
    CounterReportDtoOutputSellersInner._defaults(this);
  }

  CounterReportDtoOutputSellersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seller = $v.seller;
      _cash = $v.cash;
      _bankTransfer = $v.bankTransfer;
      _exceptions = $v.exceptions;
      _commission = $v.commission;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterReportDtoOutputSellersInner other) {
    _$v = other as _$CounterReportDtoOutputSellersInner;
  }

  @override
  void update(
      void Function(CounterReportDtoOutputSellersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterReportDtoOutputSellersInner build() => _build();

  _$CounterReportDtoOutputSellersInner _build() {
    final _$result = _$v ??
        _$CounterReportDtoOutputSellersInner._(
          seller: BuiltValueNullFieldError.checkNotNull(
              seller, r'CounterReportDtoOutputSellersInner', 'seller'),
          cash: BuiltValueNullFieldError.checkNotNull(
              cash, r'CounterReportDtoOutputSellersInner', 'cash'),
          bankTransfer: BuiltValueNullFieldError.checkNotNull(bankTransfer,
              r'CounterReportDtoOutputSellersInner', 'bankTransfer'),
          exceptions: BuiltValueNullFieldError.checkNotNull(
              exceptions, r'CounterReportDtoOutputSellersInner', 'exceptions'),
          commission: BuiltValueNullFieldError.checkNotNull(
              commission, r'CounterReportDtoOutputSellersInner', 'commission'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
