// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterReportDtoOutput extends CounterReportDtoOutput {
  @override
  final String cash;
  @override
  final String bankTransfer;
  @override
  final String exceptions;
  @override
  final String commission;
  @override
  final int receipts;
  @override
  final BuiltList<CounterReportDtoOutputSellersInner> sellers;

  factory _$CounterReportDtoOutput(
          [void Function(CounterReportDtoOutputBuilder)? updates]) =>
      (CounterReportDtoOutputBuilder()..update(updates))._build();

  _$CounterReportDtoOutput._(
      {required this.cash,
      required this.bankTransfer,
      required this.exceptions,
      required this.commission,
      required this.receipts,
      required this.sellers})
      : super._();
  @override
  CounterReportDtoOutput rebuild(
          void Function(CounterReportDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterReportDtoOutputBuilder toBuilder() =>
      CounterReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterReportDtoOutput &&
        cash == other.cash &&
        bankTransfer == other.bankTransfer &&
        exceptions == other.exceptions &&
        commission == other.commission &&
        receipts == other.receipts &&
        sellers == other.sellers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, bankTransfer.hashCode);
    _$hash = $jc(_$hash, exceptions.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, receipts.hashCode);
    _$hash = $jc(_$hash, sellers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterReportDtoOutput')
          ..add('cash', cash)
          ..add('bankTransfer', bankTransfer)
          ..add('exceptions', exceptions)
          ..add('commission', commission)
          ..add('receipts', receipts)
          ..add('sellers', sellers))
        .toString();
  }
}

class CounterReportDtoOutputBuilder
    implements Builder<CounterReportDtoOutput, CounterReportDtoOutputBuilder> {
  _$CounterReportDtoOutput? _$v;

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

  int? _receipts;
  int? get receipts => _$this._receipts;
  set receipts(int? receipts) => _$this._receipts = receipts;

  ListBuilder<CounterReportDtoOutputSellersInner>? _sellers;
  ListBuilder<CounterReportDtoOutputSellersInner> get sellers =>
      _$this._sellers ??= ListBuilder<CounterReportDtoOutputSellersInner>();
  set sellers(ListBuilder<CounterReportDtoOutputSellersInner>? sellers) =>
      _$this._sellers = sellers;

  CounterReportDtoOutputBuilder() {
    CounterReportDtoOutput._defaults(this);
  }

  CounterReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cash = $v.cash;
      _bankTransfer = $v.bankTransfer;
      _exceptions = $v.exceptions;
      _commission = $v.commission;
      _receipts = $v.receipts;
      _sellers = $v.sellers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterReportDtoOutput other) {
    _$v = other as _$CounterReportDtoOutput;
  }

  @override
  void update(void Function(CounterReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterReportDtoOutput build() => _build();

  _$CounterReportDtoOutput _build() {
    _$CounterReportDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CounterReportDtoOutput._(
            cash: BuiltValueNullFieldError.checkNotNull(
                cash, r'CounterReportDtoOutput', 'cash'),
            bankTransfer: BuiltValueNullFieldError.checkNotNull(
                bankTransfer, r'CounterReportDtoOutput', 'bankTransfer'),
            exceptions: BuiltValueNullFieldError.checkNotNull(
                exceptions, r'CounterReportDtoOutput', 'exceptions'),
            commission: BuiltValueNullFieldError.checkNotNull(
                commission, r'CounterReportDtoOutput', 'commission'),
            receipts: BuiltValueNullFieldError.checkNotNull(
                receipts, r'CounterReportDtoOutput', 'receipts'),
            sellers: sellers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sellers';
        sellers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterReportDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
