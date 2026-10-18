// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_quote_dto_output_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancellationQuoteDtoOutputTier extends CancellationQuoteDtoOutputTier {
  @override
  final int minHoursBefore;
  @override
  final int refundPercent;

  factory _$CancellationQuoteDtoOutputTier(
          [void Function(CancellationQuoteDtoOutputTierBuilder)? updates]) =>
      (CancellationQuoteDtoOutputTierBuilder()..update(updates))._build();

  _$CancellationQuoteDtoOutputTier._(
      {required this.minHoursBefore, required this.refundPercent})
      : super._();
  @override
  CancellationQuoteDtoOutputTier rebuild(
          void Function(CancellationQuoteDtoOutputTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationQuoteDtoOutputTierBuilder toBuilder() =>
      CancellationQuoteDtoOutputTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationQuoteDtoOutputTier &&
        minHoursBefore == other.minHoursBefore &&
        refundPercent == other.refundPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minHoursBefore.hashCode);
    _$hash = $jc(_$hash, refundPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationQuoteDtoOutputTier')
          ..add('minHoursBefore', minHoursBefore)
          ..add('refundPercent', refundPercent))
        .toString();
  }
}

class CancellationQuoteDtoOutputTierBuilder
    implements
        Builder<CancellationQuoteDtoOutputTier,
            CancellationQuoteDtoOutputTierBuilder> {
  _$CancellationQuoteDtoOutputTier? _$v;

  int? _minHoursBefore;
  int? get minHoursBefore => _$this._minHoursBefore;
  set minHoursBefore(int? minHoursBefore) =>
      _$this._minHoursBefore = minHoursBefore;

  int? _refundPercent;
  int? get refundPercent => _$this._refundPercent;
  set refundPercent(int? refundPercent) =>
      _$this._refundPercent = refundPercent;

  CancellationQuoteDtoOutputTierBuilder() {
    CancellationQuoteDtoOutputTier._defaults(this);
  }

  CancellationQuoteDtoOutputTierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minHoursBefore = $v.minHoursBefore;
      _refundPercent = $v.refundPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationQuoteDtoOutputTier other) {
    _$v = other as _$CancellationQuoteDtoOutputTier;
  }

  @override
  void update(void Function(CancellationQuoteDtoOutputTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationQuoteDtoOutputTier build() => _build();

  _$CancellationQuoteDtoOutputTier _build() {
    final _$result = _$v ??
        _$CancellationQuoteDtoOutputTier._(
          minHoursBefore: BuiltValueNullFieldError.checkNotNull(minHoursBefore,
              r'CancellationQuoteDtoOutputTier', 'minHoursBefore'),
          refundPercent: BuiltValueNullFieldError.checkNotNull(refundPercent,
              r'CancellationQuoteDtoOutputTier', 'refundPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
