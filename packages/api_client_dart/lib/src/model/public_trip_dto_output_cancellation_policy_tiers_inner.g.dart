// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_cancellation_policy_tiers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicTripDtoOutputCancellationPolicyTiersInner
    extends PublicTripDtoOutputCancellationPolicyTiersInner {
  @override
  final int minHoursBefore;
  @override
  final int refundPercent;

  factory _$PublicTripDtoOutputCancellationPolicyTiersInner(
          [void Function(
                  PublicTripDtoOutputCancellationPolicyTiersInnerBuilder)?
              updates]) =>
      (PublicTripDtoOutputCancellationPolicyTiersInnerBuilder()
            ..update(updates))
          ._build();

  _$PublicTripDtoOutputCancellationPolicyTiersInner._(
      {required this.minHoursBefore, required this.refundPercent})
      : super._();
  @override
  PublicTripDtoOutputCancellationPolicyTiersInner rebuild(
          void Function(PublicTripDtoOutputCancellationPolicyTiersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputCancellationPolicyTiersInnerBuilder toBuilder() =>
      PublicTripDtoOutputCancellationPolicyTiersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputCancellationPolicyTiersInner &&
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
            r'PublicTripDtoOutputCancellationPolicyTiersInner')
          ..add('minHoursBefore', minHoursBefore)
          ..add('refundPercent', refundPercent))
        .toString();
  }
}

class PublicTripDtoOutputCancellationPolicyTiersInnerBuilder
    implements
        Builder<PublicTripDtoOutputCancellationPolicyTiersInner,
            PublicTripDtoOutputCancellationPolicyTiersInnerBuilder> {
  _$PublicTripDtoOutputCancellationPolicyTiersInner? _$v;

  int? _minHoursBefore;
  int? get minHoursBefore => _$this._minHoursBefore;
  set minHoursBefore(int? minHoursBefore) =>
      _$this._minHoursBefore = minHoursBefore;

  int? _refundPercent;
  int? get refundPercent => _$this._refundPercent;
  set refundPercent(int? refundPercent) =>
      _$this._refundPercent = refundPercent;

  PublicTripDtoOutputCancellationPolicyTiersInnerBuilder() {
    PublicTripDtoOutputCancellationPolicyTiersInner._defaults(this);
  }

  PublicTripDtoOutputCancellationPolicyTiersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minHoursBefore = $v.minHoursBefore;
      _refundPercent = $v.refundPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputCancellationPolicyTiersInner other) {
    _$v = other as _$PublicTripDtoOutputCancellationPolicyTiersInner;
  }

  @override
  void update(
      void Function(PublicTripDtoOutputCancellationPolicyTiersInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputCancellationPolicyTiersInner build() => _build();

  _$PublicTripDtoOutputCancellationPolicyTiersInner _build() {
    final _$result = _$v ??
        _$PublicTripDtoOutputCancellationPolicyTiersInner._(
          minHoursBefore: BuiltValueNullFieldError.checkNotNull(
              minHoursBefore,
              r'PublicTripDtoOutputCancellationPolicyTiersInner',
              'minHoursBefore'),
          refundPercent: BuiltValueNullFieldError.checkNotNull(
              refundPercent,
              r'PublicTripDtoOutputCancellationPolicyTiersInner',
              'refundPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
