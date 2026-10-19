// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionInputDto extends PermissionInputDto {
  @override
  final bool enabled;
  @override
  final int? maxPercent;
  @override
  final int? maxAmount;
  @override
  final BuiltList<String>? routeIds;
  @override
  final int? maxDurationDays;
  @override
  final int? monthlyBudget;

  factory _$PermissionInputDto(
          [void Function(PermissionInputDtoBuilder)? updates]) =>
      (PermissionInputDtoBuilder()..update(updates))._build();

  _$PermissionInputDto._(
      {required this.enabled,
      this.maxPercent,
      this.maxAmount,
      this.routeIds,
      this.maxDurationDays,
      this.monthlyBudget})
      : super._();
  @override
  PermissionInputDto rebuild(
          void Function(PermissionInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionInputDtoBuilder toBuilder() =>
      PermissionInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionInputDto &&
        enabled == other.enabled &&
        maxPercent == other.maxPercent &&
        maxAmount == other.maxAmount &&
        routeIds == other.routeIds &&
        maxDurationDays == other.maxDurationDays &&
        monthlyBudget == other.monthlyBudget;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, maxPercent.hashCode);
    _$hash = $jc(_$hash, maxAmount.hashCode);
    _$hash = $jc(_$hash, routeIds.hashCode);
    _$hash = $jc(_$hash, maxDurationDays.hashCode);
    _$hash = $jc(_$hash, monthlyBudget.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionInputDto')
          ..add('enabled', enabled)
          ..add('maxPercent', maxPercent)
          ..add('maxAmount', maxAmount)
          ..add('routeIds', routeIds)
          ..add('maxDurationDays', maxDurationDays)
          ..add('monthlyBudget', monthlyBudget))
        .toString();
  }
}

class PermissionInputDtoBuilder
    implements Builder<PermissionInputDto, PermissionInputDtoBuilder> {
  _$PermissionInputDto? _$v;

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

  int? _maxDurationDays;
  int? get maxDurationDays => _$this._maxDurationDays;
  set maxDurationDays(int? maxDurationDays) =>
      _$this._maxDurationDays = maxDurationDays;

  int? _monthlyBudget;
  int? get monthlyBudget => _$this._monthlyBudget;
  set monthlyBudget(int? monthlyBudget) =>
      _$this._monthlyBudget = monthlyBudget;

  PermissionInputDtoBuilder() {
    PermissionInputDto._defaults(this);
  }

  PermissionInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _maxPercent = $v.maxPercent;
      _maxAmount = $v.maxAmount;
      _routeIds = $v.routeIds?.toBuilder();
      _maxDurationDays = $v.maxDurationDays;
      _monthlyBudget = $v.monthlyBudget;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionInputDto other) {
    _$v = other as _$PermissionInputDto;
  }

  @override
  void update(void Function(PermissionInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionInputDto build() => _build();

  _$PermissionInputDto _build() {
    _$PermissionInputDto _$result;
    try {
      _$result = _$v ??
          _$PermissionInputDto._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'PermissionInputDto', 'enabled'),
            maxPercent: maxPercent,
            maxAmount: maxAmount,
            routeIds: _routeIds?.build(),
            maxDurationDays: maxDurationDays,
            monthlyBudget: monthlyBudget,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routeIds';
        _routeIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PermissionInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
