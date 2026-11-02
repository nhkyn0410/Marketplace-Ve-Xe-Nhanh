// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorReportDtoOutput extends OperatorReportDtoOutput {
  @override
  final OperatorReportDtoOutputTotals totals;
  @override
  final BuiltList<OperatorReportDtoOutputByRouteInner> byRoute;
  @override
  final BuiltList<OperatorReportDtoOutputEmployeesInner> employees;

  factory _$OperatorReportDtoOutput(
          [void Function(OperatorReportDtoOutputBuilder)? updates]) =>
      (OperatorReportDtoOutputBuilder()..update(updates))._build();

  _$OperatorReportDtoOutput._(
      {required this.totals, required this.byRoute, required this.employees})
      : super._();
  @override
  OperatorReportDtoOutput rebuild(
          void Function(OperatorReportDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorReportDtoOutputBuilder toBuilder() =>
      OperatorReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorReportDtoOutput &&
        totals == other.totals &&
        byRoute == other.byRoute &&
        employees == other.employees;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, byRoute.hashCode);
    _$hash = $jc(_$hash, employees.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorReportDtoOutput')
          ..add('totals', totals)
          ..add('byRoute', byRoute)
          ..add('employees', employees))
        .toString();
  }
}

class OperatorReportDtoOutputBuilder
    implements
        Builder<OperatorReportDtoOutput, OperatorReportDtoOutputBuilder> {
  _$OperatorReportDtoOutput? _$v;

  OperatorReportDtoOutputTotalsBuilder? _totals;
  OperatorReportDtoOutputTotalsBuilder get totals =>
      _$this._totals ??= OperatorReportDtoOutputTotalsBuilder();
  set totals(OperatorReportDtoOutputTotalsBuilder? totals) =>
      _$this._totals = totals;

  ListBuilder<OperatorReportDtoOutputByRouteInner>? _byRoute;
  ListBuilder<OperatorReportDtoOutputByRouteInner> get byRoute =>
      _$this._byRoute ??= ListBuilder<OperatorReportDtoOutputByRouteInner>();
  set byRoute(ListBuilder<OperatorReportDtoOutputByRouteInner>? byRoute) =>
      _$this._byRoute = byRoute;

  ListBuilder<OperatorReportDtoOutputEmployeesInner>? _employees;
  ListBuilder<OperatorReportDtoOutputEmployeesInner> get employees =>
      _$this._employees ??=
          ListBuilder<OperatorReportDtoOutputEmployeesInner>();
  set employees(
          ListBuilder<OperatorReportDtoOutputEmployeesInner>? employees) =>
      _$this._employees = employees;

  OperatorReportDtoOutputBuilder() {
    OperatorReportDtoOutput._defaults(this);
  }

  OperatorReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totals = $v.totals.toBuilder();
      _byRoute = $v.byRoute.toBuilder();
      _employees = $v.employees.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorReportDtoOutput other) {
    _$v = other as _$OperatorReportDtoOutput;
  }

  @override
  void update(void Function(OperatorReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorReportDtoOutput build() => _build();

  _$OperatorReportDtoOutput _build() {
    _$OperatorReportDtoOutput _$result;
    try {
      _$result = _$v ??
          _$OperatorReportDtoOutput._(
            totals: totals.build(),
            byRoute: byRoute.build(),
            employees: employees.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'byRoute';
        byRoute.build();
        _$failedField = 'employees';
        employees.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OperatorReportDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
