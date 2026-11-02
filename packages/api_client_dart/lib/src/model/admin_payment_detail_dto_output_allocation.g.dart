// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_detail_dto_output_allocation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPaymentDetailDtoOutputAllocation
    extends AdminPaymentDetailDtoOutputAllocation {
  @override
  final int commissionAmount;
  @override
  final int? commissionRateBps;
  @override
  final int operatorNet;

  factory _$AdminPaymentDetailDtoOutputAllocation(
          [void Function(AdminPaymentDetailDtoOutputAllocationBuilder)?
              updates]) =>
      (AdminPaymentDetailDtoOutputAllocationBuilder()..update(updates))
          ._build();

  _$AdminPaymentDetailDtoOutputAllocation._(
      {required this.commissionAmount,
      this.commissionRateBps,
      required this.operatorNet})
      : super._();
  @override
  AdminPaymentDetailDtoOutputAllocation rebuild(
          void Function(AdminPaymentDetailDtoOutputAllocationBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentDetailDtoOutputAllocationBuilder toBuilder() =>
      AdminPaymentDetailDtoOutputAllocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentDetailDtoOutputAllocation &&
        commissionAmount == other.commissionAmount &&
        commissionRateBps == other.commissionRateBps &&
        operatorNet == other.operatorNet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, commissionAmount.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, operatorNet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPaymentDetailDtoOutputAllocation')
          ..add('commissionAmount', commissionAmount)
          ..add('commissionRateBps', commissionRateBps)
          ..add('operatorNet', operatorNet))
        .toString();
  }
}

class AdminPaymentDetailDtoOutputAllocationBuilder
    implements
        Builder<AdminPaymentDetailDtoOutputAllocation,
            AdminPaymentDetailDtoOutputAllocationBuilder> {
  _$AdminPaymentDetailDtoOutputAllocation? _$v;

  int? _commissionAmount;
  int? get commissionAmount => _$this._commissionAmount;
  set commissionAmount(int? commissionAmount) =>
      _$this._commissionAmount = commissionAmount;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  int? _operatorNet;
  int? get operatorNet => _$this._operatorNet;
  set operatorNet(int? operatorNet) => _$this._operatorNet = operatorNet;

  AdminPaymentDetailDtoOutputAllocationBuilder() {
    AdminPaymentDetailDtoOutputAllocation._defaults(this);
  }

  AdminPaymentDetailDtoOutputAllocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _commissionAmount = $v.commissionAmount;
      _commissionRateBps = $v.commissionRateBps;
      _operatorNet = $v.operatorNet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentDetailDtoOutputAllocation other) {
    _$v = other as _$AdminPaymentDetailDtoOutputAllocation;
  }

  @override
  void update(
      void Function(AdminPaymentDetailDtoOutputAllocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentDetailDtoOutputAllocation build() => _build();

  _$AdminPaymentDetailDtoOutputAllocation _build() {
    final _$result = _$v ??
        _$AdminPaymentDetailDtoOutputAllocation._(
          commissionAmount: BuiltValueNullFieldError.checkNotNull(
              commissionAmount,
              r'AdminPaymentDetailDtoOutputAllocation',
              'commissionAmount'),
          commissionRateBps: commissionRateBps,
          operatorNet: BuiltValueNullFieldError.checkNotNull(operatorNet,
              r'AdminPaymentDetailDtoOutputAllocation', 'operatorNet'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
