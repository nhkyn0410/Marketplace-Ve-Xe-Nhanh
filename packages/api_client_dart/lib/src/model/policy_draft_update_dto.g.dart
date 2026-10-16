// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_draft_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyDraftUpdateDto extends PolicyDraftUpdateDto {
  @override
  final PolicyOverviewDtoOutputVersionsInnerRules rules;
  @override
  final String? description;
  @override
  final DateTime? effectiveFrom;

  factory _$PolicyDraftUpdateDto(
          [void Function(PolicyDraftUpdateDtoBuilder)? updates]) =>
      (PolicyDraftUpdateDtoBuilder()..update(updates))._build();

  _$PolicyDraftUpdateDto._(
      {required this.rules, this.description, this.effectiveFrom})
      : super._();
  @override
  PolicyDraftUpdateDto rebuild(
          void Function(PolicyDraftUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyDraftUpdateDtoBuilder toBuilder() =>
      PolicyDraftUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyDraftUpdateDto &&
        rules == other.rules &&
        description == other.description &&
        effectiveFrom == other.effectiveFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PolicyDraftUpdateDto')
          ..add('rules', rules)
          ..add('description', description)
          ..add('effectiveFrom', effectiveFrom))
        .toString();
  }
}

class PolicyDraftUpdateDtoBuilder
    implements Builder<PolicyDraftUpdateDto, PolicyDraftUpdateDtoBuilder> {
  _$PolicyDraftUpdateDto? _$v;

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

  PolicyDraftUpdateDtoBuilder() {
    PolicyDraftUpdateDto._defaults(this);
  }

  PolicyDraftUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rules = $v.rules.toBuilder();
      _description = $v.description;
      _effectiveFrom = $v.effectiveFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyDraftUpdateDto other) {
    _$v = other as _$PolicyDraftUpdateDto;
  }

  @override
  void update(void Function(PolicyDraftUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyDraftUpdateDto build() => _build();

  _$PolicyDraftUpdateDto _build() {
    _$PolicyDraftUpdateDto _$result;
    try {
      _$result = _$v ??
          _$PolicyDraftUpdateDto._(
            rules: rules.build(),
            description: description,
            effectiveFrom: effectiveFrom,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyDraftUpdateDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
