// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionDtoOutput extends PermissionDtoOutput {
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String operatorSlug;
  @override
  final bool enabled;
  @override
  final int? maxPercent;
  @override
  final int? maxAmount;
  @override
  final BuiltList<String> routeIds;
  @override
  final BuiltList<String> routeNames;
  @override
  final int maxDurationDays;
  @override
  final int? monthlyBudget;

  factory _$PermissionDtoOutput(
          [void Function(PermissionDtoOutputBuilder)? updates]) =>
      (PermissionDtoOutputBuilder()..update(updates))._build();

  _$PermissionDtoOutput._(
      {required this.operatorId,
      required this.operatorName,
      required this.operatorSlug,
      required this.enabled,
      this.maxPercent,
      this.maxAmount,
      required this.routeIds,
      required this.routeNames,
      required this.maxDurationDays,
      this.monthlyBudget})
      : super._();
  @override
  PermissionDtoOutput rebuild(
          void Function(PermissionDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionDtoOutputBuilder toBuilder() =>
      PermissionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionDtoOutput &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        operatorSlug == other.operatorSlug &&
        enabled == other.enabled &&
        maxPercent == other.maxPercent &&
        maxAmount == other.maxAmount &&
        routeIds == other.routeIds &&
        routeNames == other.routeNames &&
        maxDurationDays == other.maxDurationDays &&
        monthlyBudget == other.monthlyBudget;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, maxPercent.hashCode);
    _$hash = $jc(_$hash, maxAmount.hashCode);
    _$hash = $jc(_$hash, routeIds.hashCode);
    _$hash = $jc(_$hash, routeNames.hashCode);
    _$hash = $jc(_$hash, maxDurationDays.hashCode);
    _$hash = $jc(_$hash, monthlyBudget.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionDtoOutput')
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('operatorSlug', operatorSlug)
          ..add('enabled', enabled)
          ..add('maxPercent', maxPercent)
          ..add('maxAmount', maxAmount)
          ..add('routeIds', routeIds)
          ..add('routeNames', routeNames)
          ..add('maxDurationDays', maxDurationDays)
          ..add('monthlyBudget', monthlyBudget))
        .toString();
  }
}

class PermissionDtoOutputBuilder
    implements Builder<PermissionDtoOutput, PermissionDtoOutputBuilder> {
  _$PermissionDtoOutput? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _maxPercent;
  int? get maxPercent => _$this._maxPercent;
  set maxPercent(int? maxPercent) => _$this._maxPercent = maxPercent;

  int? _maxAmount;
  int? get maxAmount => _$this._maxAmount;
  set maxAmount(int? maxAmount) => _$this._maxAmount = maxAmount;

  ListBuilder<String>? _routeIds;
  ListBuilder<String> get routeIds =>
      _$this._routeIds ??= ListBuilder<String>();
  set routeIds(ListBuilder<String>? routeIds) => _$this._routeIds = routeIds;

  ListBuilder<String>? _routeNames;
  ListBuilder<String> get routeNames =>
      _$this._routeNames ??= ListBuilder<String>();
  set routeNames(ListBuilder<String>? routeNames) =>
      _$this._routeNames = routeNames;

  int? _maxDurationDays;
  int? get maxDurationDays => _$this._maxDurationDays;
  set maxDurationDays(int? maxDurationDays) =>
      _$this._maxDurationDays = maxDurationDays;

  int? _monthlyBudget;
  int? get monthlyBudget => _$this._monthlyBudget;
  set monthlyBudget(int? monthlyBudget) =>
      _$this._monthlyBudget = monthlyBudget;

  PermissionDtoOutputBuilder() {
    PermissionDtoOutput._defaults(this);
  }

  PermissionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _operatorSlug = $v.operatorSlug;
      _enabled = $v.enabled;
      _maxPercent = $v.maxPercent;
      _maxAmount = $v.maxAmount;
      _routeIds = $v.routeIds.toBuilder();
      _routeNames = $v.routeNames.toBuilder();
      _maxDurationDays = $v.maxDurationDays;
      _monthlyBudget = $v.monthlyBudget;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionDtoOutput other) {
    _$v = other as _$PermissionDtoOutput;
  }

  @override
  void update(void Function(PermissionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionDtoOutput build() => _build();

  _$PermissionDtoOutput _build() {
    _$PermissionDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PermissionDtoOutput._(
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'PermissionDtoOutput', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'PermissionDtoOutput', 'operatorName'),
            operatorSlug: BuiltValueNullFieldError.checkNotNull(
                operatorSlug, r'PermissionDtoOutput', 'operatorSlug'),
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'PermissionDtoOutput', 'enabled'),
            maxPercent: maxPercent,
            maxAmount: maxAmount,
            routeIds: routeIds.build(),
            routeNames: routeNames.build(),
            maxDurationDays: BuiltValueNullFieldError.checkNotNull(
                maxDurationDays, r'PermissionDtoOutput', 'maxDurationDays'),
            monthlyBudget: monthlyBudget,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routeIds';
        routeIds.build();
        _$failedField = 'routeNames';
        routeNames.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PermissionDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
