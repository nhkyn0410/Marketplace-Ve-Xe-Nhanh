// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_operator_profile_dto_output_scorecard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicOperatorProfileDtoOutputScorecard
    extends PublicOperatorProfileDtoOutputScorecard {
  @override
  final num? averageRating;
  @override
  final int reviewCount;
  @override
  final num? operatorCancellationRate;
  @override
  final num? refundBookingRate;
  @override
  final num? disputeBookingRate;
  @override
  final num? checkInRate;
  @override
  final num? noShowRate;

  factory _$PublicOperatorProfileDtoOutputScorecard(
          [void Function(PublicOperatorProfileDtoOutputScorecardBuilder)?
              updates]) =>
      (PublicOperatorProfileDtoOutputScorecardBuilder()..update(updates))
          ._build();

  _$PublicOperatorProfileDtoOutputScorecard._(
      {this.averageRating,
      required this.reviewCount,
      this.operatorCancellationRate,
      this.refundBookingRate,
      this.disputeBookingRate,
      this.checkInRate,
      this.noShowRate})
      : super._();
  @override
  PublicOperatorProfileDtoOutputScorecard rebuild(
          void Function(PublicOperatorProfileDtoOutputScorecardBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicOperatorProfileDtoOutputScorecardBuilder toBuilder() =>
      PublicOperatorProfileDtoOutputScorecardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicOperatorProfileDtoOutputScorecard &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount &&
        operatorCancellationRate == other.operatorCancellationRate &&
        refundBookingRate == other.refundBookingRate &&
        disputeBookingRate == other.disputeBookingRate &&
        checkInRate == other.checkInRate &&
        noShowRate == other.noShowRate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jc(_$hash, operatorCancellationRate.hashCode);
    _$hash = $jc(_$hash, refundBookingRate.hashCode);
    _$hash = $jc(_$hash, disputeBookingRate.hashCode);
    _$hash = $jc(_$hash, checkInRate.hashCode);
    _$hash = $jc(_$hash, noShowRate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicOperatorProfileDtoOutputScorecard')
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount)
          ..add('operatorCancellationRate', operatorCancellationRate)
          ..add('refundBookingRate', refundBookingRate)
          ..add('disputeBookingRate', disputeBookingRate)
          ..add('checkInRate', checkInRate)
          ..add('noShowRate', noShowRate))
        .toString();
  }
}

class PublicOperatorProfileDtoOutputScorecardBuilder
    implements
        Builder<PublicOperatorProfileDtoOutputScorecard,
            PublicOperatorProfileDtoOutputScorecardBuilder> {
  _$PublicOperatorProfileDtoOutputScorecard? _$v;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  num? _operatorCancellationRate;
  num? get operatorCancellationRate => _$this._operatorCancellationRate;
  set operatorCancellationRate(num? operatorCancellationRate) =>
      _$this._operatorCancellationRate = operatorCancellationRate;

  num? _refundBookingRate;
  num? get refundBookingRate => _$this._refundBookingRate;
  set refundBookingRate(num? refundBookingRate) =>
      _$this._refundBookingRate = refundBookingRate;

  num? _disputeBookingRate;
  num? get disputeBookingRate => _$this._disputeBookingRate;
  set disputeBookingRate(num? disputeBookingRate) =>
      _$this._disputeBookingRate = disputeBookingRate;

  num? _checkInRate;
  num? get checkInRate => _$this._checkInRate;
  set checkInRate(num? checkInRate) => _$this._checkInRate = checkInRate;

  num? _noShowRate;
  num? get noShowRate => _$this._noShowRate;
  set noShowRate(num? noShowRate) => _$this._noShowRate = noShowRate;

  PublicOperatorProfileDtoOutputScorecardBuilder() {
    PublicOperatorProfileDtoOutputScorecard._defaults(this);
  }

  PublicOperatorProfileDtoOutputScorecardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _operatorCancellationRate = $v.operatorCancellationRate;
      _refundBookingRate = $v.refundBookingRate;
      _disputeBookingRate = $v.disputeBookingRate;
      _checkInRate = $v.checkInRate;
      _noShowRate = $v.noShowRate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicOperatorProfileDtoOutputScorecard other) {
    _$v = other as _$PublicOperatorProfileDtoOutputScorecard;
  }

  @override
  void update(
      void Function(PublicOperatorProfileDtoOutputScorecardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicOperatorProfileDtoOutputScorecard build() => _build();

  _$PublicOperatorProfileDtoOutputScorecard _build() {
    final _$result = _$v ??
        _$PublicOperatorProfileDtoOutputScorecard._(
          averageRating: averageRating,
          reviewCount: BuiltValueNullFieldError.checkNotNull(reviewCount,
              r'PublicOperatorProfileDtoOutputScorecard', 'reviewCount'),
          operatorCancellationRate: operatorCancellationRate,
          refundBookingRate: refundBookingRate,
          disputeBookingRate: disputeBookingRate,
          checkInRate: checkInRate,
          noShowRate: noShowRate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
