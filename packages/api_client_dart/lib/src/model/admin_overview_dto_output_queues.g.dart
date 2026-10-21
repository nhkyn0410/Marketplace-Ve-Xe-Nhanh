// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_dto_output_queues.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewDtoOutputQueues extends AdminOverviewDtoOutputQueues {
  @override
  final int payoutsPendingReview;
  @override
  final int refundsFailed;
  @override
  final int reconcileOpen;

  factory _$AdminOverviewDtoOutputQueues(
          [void Function(AdminOverviewDtoOutputQueuesBuilder)? updates]) =>
      (AdminOverviewDtoOutputQueuesBuilder()..update(updates))._build();

  _$AdminOverviewDtoOutputQueues._(
      {required this.payoutsPendingReview,
      required this.refundsFailed,
      required this.reconcileOpen})
      : super._();
  @override
  AdminOverviewDtoOutputQueues rebuild(
          void Function(AdminOverviewDtoOutputQueuesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewDtoOutputQueuesBuilder toBuilder() =>
      AdminOverviewDtoOutputQueuesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewDtoOutputQueues &&
        payoutsPendingReview == other.payoutsPendingReview &&
        refundsFailed == other.refundsFailed &&
        reconcileOpen == other.reconcileOpen;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payoutsPendingReview.hashCode);
    _$hash = $jc(_$hash, refundsFailed.hashCode);
    _$hash = $jc(_$hash, reconcileOpen.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewDtoOutputQueues')
          ..add('payoutsPendingReview', payoutsPendingReview)
          ..add('refundsFailed', refundsFailed)
          ..add('reconcileOpen', reconcileOpen))
        .toString();
  }
}

class AdminOverviewDtoOutputQueuesBuilder
    implements
        Builder<AdminOverviewDtoOutputQueues,
            AdminOverviewDtoOutputQueuesBuilder> {
  _$AdminOverviewDtoOutputQueues? _$v;

  int? _payoutsPendingReview;
  int? get payoutsPendingReview => _$this._payoutsPendingReview;
  set payoutsPendingReview(int? payoutsPendingReview) =>
      _$this._payoutsPendingReview = payoutsPendingReview;

  int? _refundsFailed;
  int? get refundsFailed => _$this._refundsFailed;
  set refundsFailed(int? refundsFailed) =>
      _$this._refundsFailed = refundsFailed;

  int? _reconcileOpen;
  int? get reconcileOpen => _$this._reconcileOpen;
  set reconcileOpen(int? reconcileOpen) =>
      _$this._reconcileOpen = reconcileOpen;

  AdminOverviewDtoOutputQueuesBuilder() {
    AdminOverviewDtoOutputQueues._defaults(this);
  }

  AdminOverviewDtoOutputQueuesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payoutsPendingReview = $v.payoutsPendingReview;
      _refundsFailed = $v.refundsFailed;
      _reconcileOpen = $v.reconcileOpen;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewDtoOutputQueues other) {
    _$v = other as _$AdminOverviewDtoOutputQueues;
  }

  @override
  void update(void Function(AdminOverviewDtoOutputQueuesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewDtoOutputQueues build() => _build();

  _$AdminOverviewDtoOutputQueues _build() {
    final _$result = _$v ??
        _$AdminOverviewDtoOutputQueues._(
          payoutsPendingReview: BuiltValueNullFieldError.checkNotNull(
              payoutsPendingReview,
              r'AdminOverviewDtoOutputQueues',
              'payoutsPendingReview'),
          refundsFailed: BuiltValueNullFieldError.checkNotNull(
              refundsFailed, r'AdminOverviewDtoOutputQueues', 'refundsFailed'),
          reconcileOpen: BuiltValueNullFieldError.checkNotNull(
              reconcileOpen, r'AdminOverviewDtoOutputQueues', 'reconcileOpen'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
