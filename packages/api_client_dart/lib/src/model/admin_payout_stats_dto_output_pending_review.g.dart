// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payout_stats_dto_output_pending_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayoutStatsDtoOutputPendingReview
    extends AdminPayoutStatsDtoOutputPendingReview {
  @override
  final int count;
  @override
  final int amount;

  factory _$AdminPayoutStatsDtoOutputPendingReview(
          [void Function(AdminPayoutStatsDtoOutputPendingReviewBuilder)?
              updates]) =>
      (AdminPayoutStatsDtoOutputPendingReviewBuilder()..update(updates))
          ._build();

  _$AdminPayoutStatsDtoOutputPendingReview._(
      {required this.count, required this.amount})
      : super._();
  @override
  AdminPayoutStatsDtoOutputPendingReview rebuild(
          void Function(AdminPayoutStatsDtoOutputPendingReviewBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPayoutStatsDtoOutputPendingReviewBuilder toBuilder() =>
      AdminPayoutStatsDtoOutputPendingReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayoutStatsDtoOutputPendingReview &&
        count == other.count &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPayoutStatsDtoOutputPendingReview')
          ..add('count', count)
          ..add('amount', amount))
        .toString();
  }
}

class AdminPayoutStatsDtoOutputPendingReviewBuilder
    implements
        Builder<AdminPayoutStatsDtoOutputPendingReview,
            AdminPayoutStatsDtoOutputPendingReviewBuilder> {
  _$AdminPayoutStatsDtoOutputPendingReview? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  AdminPayoutStatsDtoOutputPendingReviewBuilder() {
    AdminPayoutStatsDtoOutputPendingReview._defaults(this);
  }

  AdminPayoutStatsDtoOutputPendingReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayoutStatsDtoOutputPendingReview other) {
    _$v = other as _$AdminPayoutStatsDtoOutputPendingReview;
  }

  @override
  void update(
      void Function(AdminPayoutStatsDtoOutputPendingReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayoutStatsDtoOutputPendingReview build() => _build();

  _$AdminPayoutStatsDtoOutputPendingReview _build() {
    final _$result = _$v ??
        _$AdminPayoutStatsDtoOutputPendingReview._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'AdminPayoutStatsDtoOutputPendingReview', 'count'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'AdminPayoutStatsDtoOutputPendingReview', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
