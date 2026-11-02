// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail_dto_output_cancellation_tiers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeDetailDtoOutputCancellationTiersInner
    extends DisputeDetailDtoOutputCancellationTiersInner {
  @override
  final num minHoursBefore;
  @override
  final num refundPercent;

  factory _$DisputeDetailDtoOutputCancellationTiersInner(
          [void Function(DisputeDetailDtoOutputCancellationTiersInnerBuilder)?
              updates]) =>
      (DisputeDetailDtoOutputCancellationTiersInnerBuilder()..update(updates))
          ._build();

  _$DisputeDetailDtoOutputCancellationTiersInner._(
      {required this.minHoursBefore, required this.refundPercent})
      : super._();
  @override
  DisputeDetailDtoOutputCancellationTiersInner rebuild(
          void Function(DisputeDetailDtoOutputCancellationTiersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailDtoOutputCancellationTiersInnerBuilder toBuilder() =>
      DisputeDetailDtoOutputCancellationTiersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetailDtoOutputCancellationTiersInner &&
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
    return (newBuiltValueToStringHelper(
            r'DisputeDetailDtoOutputCancellationTiersInner')
          ..add('minHoursBefore', minHoursBefore)
          ..add('refundPercent', refundPercent))
        .toString();
  }
}

class DisputeDetailDtoOutputCancellationTiersInnerBuilder
    implements
        Builder<DisputeDetailDtoOutputCancellationTiersInner,
            DisputeDetailDtoOutputCancellationTiersInnerBuilder> {
  _$DisputeDetailDtoOutputCancellationTiersInner? _$v;

  num? _minHoursBefore;
  num? get minHoursBefore => _$this._minHoursBefore;
  set minHoursBefore(num? minHoursBefore) =>
      _$this._minHoursBefore = minHoursBefore;

  num? _refundPercent;
  num? get refundPercent => _$this._refundPercent;
  set refundPercent(num? refundPercent) =>
      _$this._refundPercent = refundPercent;

  DisputeDetailDtoOutputCancellationTiersInnerBuilder() {
    DisputeDetailDtoOutputCancellationTiersInner._defaults(this);
  }

  DisputeDetailDtoOutputCancellationTiersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minHoursBefore = $v.minHoursBefore;
      _refundPercent = $v.refundPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDetailDtoOutputCancellationTiersInner other) {
    _$v = other as _$DisputeDetailDtoOutputCancellationTiersInner;
  }

  @override
  void update(
      void Function(DisputeDetailDtoOutputCancellationTiersInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetailDtoOutputCancellationTiersInner build() => _build();

  _$DisputeDetailDtoOutputCancellationTiersInner _build() {
    final _$result = _$v ??
        _$DisputeDetailDtoOutputCancellationTiersInner._(
          minHoursBefore: BuiltValueNullFieldError.checkNotNull(
              minHoursBefore,
              r'DisputeDetailDtoOutputCancellationTiersInner',
              'minHoursBefore'),
          refundPercent: BuiltValueNullFieldError.checkNotNull(refundPercent,
              r'DisputeDetailDtoOutputCancellationTiersInner', 'refundPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
