// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_draft_create_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyDraftCreateDto extends PolicyDraftCreateDto {
  @override
  final PolicyOverviewDtoOutputVersionsInnerRules rules;
  @override
  final String? description;
  @override
  final DateTime? effectiveFrom;
  @override
  final String? operatorId;

  factory _$PolicyDraftCreateDto(
          [void Function(PolicyDraftCreateDtoBuilder)? updates]) =>
      (PolicyDraftCreateDtoBuilder()..update(updates))._build();

  _$PolicyDraftCreateDto._(
      {required this.rules,
      this.description,
      this.effectiveFrom,
      this.operatorId})
      : super._();
  @override
  PolicyDraftCreateDto rebuild(
          void Function(PolicyDraftCreateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyDraftCreateDtoBuilder toBuilder() =>
      PolicyDraftCreateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyDraftCreateDto &&
        rules == other.rules &&
        description == other.description &&
        effectiveFrom == other.effectiveFrom &&
        operatorId == other.operatorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PolicyDraftCreateDto')
          ..add('rules', rules)
          ..add('description', description)
          ..add('effectiveFrom', effectiveFrom)
          ..add('operatorId', operatorId))
        .toString();
  }
}

class PolicyDraftCreateDtoBuilder
    implements Builder<PolicyDraftCreateDto, PolicyDraftCreateDtoBuilder> {
  _$PolicyDraftCreateDto? _$v;

  PolicyOverviewDtoOutputVersionsInnerRulesBuilder? _rules;
  PolicyOverviewDtoOutputVersionsInnerRulesBuilder get rules =>
      _$this._rules ??= PolicyOverviewDtoOutputVersionsInnerRulesBuilder();
  set rules(PolicyOverviewDtoOutputVersionsInnerRulesBuilder? rules) =>
      _$this._rules = rules;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  PolicyDraftCreateDtoBuilder() {
    PolicyDraftCreateDto._defaults(this);
  }

  PolicyDraftCreateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rules = $v.rules.toBuilder();
      _description = $v.description;
      _effectiveFrom = $v.effectiveFrom;
      _operatorId = $v.operatorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyDraftCreateDto other) {
    _$v = other as _$PolicyDraftCreateDto;
  }

  @override
  void update(void Function(PolicyDraftCreateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyDraftCreateDto build() => _build();

  _$PolicyDraftCreateDto _build() {
    _$PolicyDraftCreateDto _$result;
    try {
      _$result = _$v ??
          _$PolicyDraftCreateDto._(
            rules: rules.build(),
            description: description,
            effectiveFrom: effectiveFrom,
            operatorId: operatorId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyDraftCreateDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
