// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_quote_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancellationQuoteDtoOutput extends CancellationQuoteDtoOutput {
  @override
  final BuiltList<CancellationQuoteDtoOutputTicketsInner> tickets;
  @override
  final CancellationQuoteDtoOutputTier? tier;
  @override
  final int refundPercent;
  @override
  final int selectedTotal;
  @override
  final int refundAmount;
  @override
  final int nonRefundable;

  factory _$CancellationQuoteDtoOutput(
          [void Function(CancellationQuoteDtoOutputBuilder)? updates]) =>
      (CancellationQuoteDtoOutputBuilder()..update(updates))._build();

  _$CancellationQuoteDtoOutput._(
      {required this.tickets,
      this.tier,
      required this.refundPercent,
      required this.selectedTotal,
      required this.refundAmount,
      required this.nonRefundable})
      : super._();
  @override
  CancellationQuoteDtoOutput rebuild(
          void Function(CancellationQuoteDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationQuoteDtoOutputBuilder toBuilder() =>
      CancellationQuoteDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationQuoteDtoOutput &&
        tickets == other.tickets &&
        tier == other.tier &&
        refundPercent == other.refundPercent &&
        selectedTotal == other.selectedTotal &&
        refundAmount == other.refundAmount &&
        nonRefundable == other.nonRefundable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, refundPercent.hashCode);
    _$hash = $jc(_$hash, selectedTotal.hashCode);
    _$hash = $jc(_$hash, refundAmount.hashCode);
    _$hash = $jc(_$hash, nonRefundable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationQuoteDtoOutput')
          ..add('tickets', tickets)
          ..add('tier', tier)
          ..add('refundPercent', refundPercent)
          ..add('selectedTotal', selectedTotal)
          ..add('refundAmount', refundAmount)
          ..add('nonRefundable', nonRefundable))
        .toString();
  }
}

class CancellationQuoteDtoOutputBuilder
    implements
        Builder<CancellationQuoteDtoOutput, CancellationQuoteDtoOutputBuilder> {
  _$CancellationQuoteDtoOutput? _$v;

  ListBuilder<CancellationQuoteDtoOutputTicketsInner>? _tickets;
  ListBuilder<CancellationQuoteDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??= ListBuilder<CancellationQuoteDtoOutputTicketsInner>();
  set tickets(ListBuilder<CancellationQuoteDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  CancellationQuoteDtoOutputTierBuilder? _tier;
  CancellationQuoteDtoOutputTierBuilder get tier =>
      _$this._tier ??= CancellationQuoteDtoOutputTierBuilder();
  set tier(CancellationQuoteDtoOutputTierBuilder? tier) => _$this._tier = tier;

  int? _refundPercent;
  int? get refundPercent => _$this._refundPercent;
  set refundPercent(int? refundPercent) =>
      _$this._refundPercent = refundPercent;

  int? _selectedTotal;
  int? get selectedTotal => _$this._selectedTotal;
  set selectedTotal(int? selectedTotal) =>
      _$this._selectedTotal = selectedTotal;

  int? _refundAmount;
  int? get refundAmount => _$this._refundAmount;
  set refundAmount(int? refundAmount) => _$this._refundAmount = refundAmount;

  int? _nonRefundable;
  int? get nonRefundable => _$this._nonRefundable;
  set nonRefundable(int? nonRefundable) =>
      _$this._nonRefundable = nonRefundable;

  CancellationQuoteDtoOutputBuilder() {
    CancellationQuoteDtoOutput._defaults(this);
  }

  CancellationQuoteDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tickets = $v.tickets.toBuilder();
      _tier = $v.tier?.toBuilder();
      _refundPercent = $v.refundPercent;
      _selectedTotal = $v.selectedTotal;
      _refundAmount = $v.refundAmount;
      _nonRefundable = $v.nonRefundable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationQuoteDtoOutput other) {
    _$v = other as _$CancellationQuoteDtoOutput;
  }

  @override
  void update(void Function(CancellationQuoteDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationQuoteDtoOutput build() => _build();

  _$CancellationQuoteDtoOutput _build() {
    _$CancellationQuoteDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CancellationQuoteDtoOutput._(
            tickets: tickets.build(),
            tier: _tier?.build(),
            refundPercent: BuiltValueNullFieldError.checkNotNull(
                refundPercent, r'CancellationQuoteDtoOutput', 'refundPercent'),
            selectedTotal: BuiltValueNullFieldError.checkNotNull(
                selectedTotal, r'CancellationQuoteDtoOutput', 'selectedTotal'),
            refundAmount: BuiltValueNullFieldError.checkNotNull(
                refundAmount, r'CancellationQuoteDtoOutput', 'refundAmount'),
            nonRefundable: BuiltValueNullFieldError.checkNotNull(
                nonRefundable, r'CancellationQuoteDtoOutput', 'nonRefundable'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'tier';
        _tier?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CancellationQuoteDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
