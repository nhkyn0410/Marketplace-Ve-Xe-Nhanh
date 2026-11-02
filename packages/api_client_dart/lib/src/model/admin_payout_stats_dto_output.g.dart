// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payout_stats_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayoutStatsDtoOutput extends AdminPayoutStatsDtoOutput {
  @override
  final AdminPayoutStatsDtoOutputPendingReview pendingReview;
  @override
  final AdminPayoutStatsDtoOutputPendingReview readyToTransfer;
  @override
  final AdminPayoutStatsDtoOutputPendingReview onHold;
  @override
  final AdminPayoutStatsDtoOutputPendingReview paidThisMonth;

  factory _$AdminPayoutStatsDtoOutput(
          [void Function(AdminPayoutStatsDtoOutputBuilder)? updates]) =>
      (AdminPayoutStatsDtoOutputBuilder()..update(updates))._build();

  _$AdminPayoutStatsDtoOutput._(
      {required this.pendingReview,
      required this.readyToTransfer,
      required this.onHold,
      required this.paidThisMonth})
      : super._();
  @override
  AdminPayoutStatsDtoOutput rebuild(
          void Function(AdminPayoutStatsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPayoutStatsDtoOutputBuilder toBuilder() =>
      AdminPayoutStatsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayoutStatsDtoOutput &&
        pendingReview == other.pendingReview &&
        readyToTransfer == other.readyToTransfer &&
        onHold == other.onHold &&
        paidThisMonth == other.paidThisMonth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pendingReview.hashCode);
    _$hash = $jc(_$hash, readyToTransfer.hashCode);
    _$hash = $jc(_$hash, onHold.hashCode);
    _$hash = $jc(_$hash, paidThisMonth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPayoutStatsDtoOutput')
          ..add('pendingReview', pendingReview)
          ..add('readyToTransfer', readyToTransfer)
          ..add('onHold', onHold)
          ..add('paidThisMonth', paidThisMonth))
        .toString();
  }
}

class AdminPayoutStatsDtoOutputBuilder
    implements
        Builder<AdminPayoutStatsDtoOutput, AdminPayoutStatsDtoOutputBuilder> {
  _$AdminPayoutStatsDtoOutput? _$v;

  AdminPayoutStatsDtoOutputPendingReviewBuilder? _pendingReview;
  AdminPayoutStatsDtoOutputPendingReviewBuilder get pendingReview =>
      _$this._pendingReview ??= AdminPayoutStatsDtoOutputPendingReviewBuilder();
  set pendingReview(
          AdminPayoutStatsDtoOutputPendingReviewBuilder? pendingReview) =>
      _$this._pendingReview = pendingReview;

  AdminPayoutStatsDtoOutputPendingReviewBuilder? _readyToTransfer;
  AdminPayoutStatsDtoOutputPendingReviewBuilder get readyToTransfer =>
      _$this._readyToTransfer ??=
          AdminPayoutStatsDtoOutputPendingReviewBuilder();
  set readyToTransfer(
          AdminPayoutStatsDtoOutputPendingReviewBuilder? readyToTransfer) =>
      _$this._readyToTransfer = readyToTransfer;

  AdminPayoutStatsDtoOutputPendingReviewBuilder? _onHold;
  AdminPayoutStatsDtoOutputPendingReviewBuilder get onHold =>
      _$this._onHold ??= AdminPayoutStatsDtoOutputPendingReviewBuilder();
  set onHold(AdminPayoutStatsDtoOutputPendingReviewBuilder? onHold) =>
      _$this._onHold = onHold;

  AdminPayoutStatsDtoOutputPendingReviewBuilder? _paidThisMonth;
  AdminPayoutStatsDtoOutputPendingReviewBuilder get paidThisMonth =>
      _$this._paidThisMonth ??= AdminPayoutStatsDtoOutputPendingReviewBuilder();
  set paidThisMonth(
          AdminPayoutStatsDtoOutputPendingReviewBuilder? paidThisMonth) =>
      _$this._paidThisMonth = paidThisMonth;

  AdminPayoutStatsDtoOutputBuilder() {
    AdminPayoutStatsDtoOutput._defaults(this);
  }

  AdminPayoutStatsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pendingReview = $v.pendingReview.toBuilder();
      _readyToTransfer = $v.readyToTransfer.toBuilder();
      _onHold = $v.onHold.toBuilder();
      _paidThisMonth = $v.paidThisMonth.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayoutStatsDtoOutput other) {
    _$v = other as _$AdminPayoutStatsDtoOutput;
  }

  @override
  void update(void Function(AdminPayoutStatsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayoutStatsDtoOutput build() => _build();

  _$AdminPayoutStatsDtoOutput _build() {
    _$AdminPayoutStatsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPayoutStatsDtoOutput._(
            pendingReview: pendingReview.build(),
            readyToTransfer: readyToTransfer.build(),
            onHold: onHold.build(),
            paidThisMonth: paidThisMonth.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pendingReview';
        pendingReview.build();
        _$failedField = 'readyToTransfer';
        readyToTransfer.build();
        _$failedField = 'onHold';
        onHold.build();
        _$failedField = 'paidThisMonth';
        paidThisMonth.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPayoutStatsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
