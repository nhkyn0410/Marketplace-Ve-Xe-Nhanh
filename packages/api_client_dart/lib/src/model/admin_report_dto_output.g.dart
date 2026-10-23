// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDtoOutput extends AdminReportDtoOutput {
  @override
  final AdminReportDtoOutputTotals totals;
  @override
  final BuiltList<AdminReportDtoOutputByOperatorInner> byOperator;
  @override
  final BuiltList<AdminReportDtoOutputPaymentMethodsInner> paymentMethods;

  factory _$AdminReportDtoOutput(
          [void Function(AdminReportDtoOutputBuilder)? updates]) =>
      (AdminReportDtoOutputBuilder()..update(updates))._build();

  _$AdminReportDtoOutput._(
      {required this.totals,
      required this.byOperator,
      required this.paymentMethods})
      : super._();
  @override
  AdminReportDtoOutput rebuild(
          void Function(AdminReportDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputBuilder toBuilder() =>
      AdminReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutput &&
        totals == other.totals &&
        byOperator == other.byOperator &&
        paymentMethods == other.paymentMethods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, byOperator.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutput')
          ..add('totals', totals)
          ..add('byOperator', byOperator)
          ..add('paymentMethods', paymentMethods))
        .toString();
  }
}

class AdminReportDtoOutputBuilder
    implements Builder<AdminReportDtoOutput, AdminReportDtoOutputBuilder> {
  _$AdminReportDtoOutput? _$v;

  AdminReportDtoOutputTotalsBuilder? _totals;
  AdminReportDtoOutputTotalsBuilder get totals =>
      _$this._totals ??= AdminReportDtoOutputTotalsBuilder();
  set totals(AdminReportDtoOutputTotalsBuilder? totals) =>
      _$this._totals = totals;

  ListBuilder<AdminReportDtoOutputByOperatorInner>? _byOperator;
  ListBuilder<AdminReportDtoOutputByOperatorInner> get byOperator =>
      _$this._byOperator ??= ListBuilder<AdminReportDtoOutputByOperatorInner>();
  set byOperator(
          ListBuilder<AdminReportDtoOutputByOperatorInner>? byOperator) =>
      _$this._byOperator = byOperator;

  ListBuilder<AdminReportDtoOutputPaymentMethodsInner>? _paymentMethods;
  ListBuilder<AdminReportDtoOutputPaymentMethodsInner> get paymentMethods =>
      _$this._paymentMethods ??=
          ListBuilder<AdminReportDtoOutputPaymentMethodsInner>();
  set paymentMethods(
          ListBuilder<AdminReportDtoOutputPaymentMethodsInner>?
              paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  AdminReportDtoOutputBuilder() {
    AdminReportDtoOutput._defaults(this);
  }

  AdminReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totals = $v.totals.toBuilder();
      _byOperator = $v.byOperator.toBuilder();
      _paymentMethods = $v.paymentMethods.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutput other) {
    _$v = other as _$AdminReportDtoOutput;
  }

  @override
  void update(void Function(AdminReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutput build() => _build();

  _$AdminReportDtoOutput _build() {
    _$AdminReportDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminReportDtoOutput._(
            totals: totals.build(),
            byOperator: byOperator.build(),
            paymentMethods: paymentMethods.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'byOperator';
        byOperator.build();
        _$failedField = 'paymentMethods';
        paymentMethods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminReportDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
