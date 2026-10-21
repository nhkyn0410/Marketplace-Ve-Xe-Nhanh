// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_rule_create_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionRuleCreateDto extends CommissionRuleCreateDto {
  @override
  final String operatorId;
  @override
  final int rateBps;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final String reason;

  factory _$CommissionRuleCreateDto(
          [void Function(CommissionRuleCreateDtoBuilder)? updates]) =>
      (CommissionRuleCreateDtoBuilder()..update(updates))._build();

  _$CommissionRuleCreateDto._(
      {required this.operatorId,
      required this.rateBps,
      required this.effectiveFrom,
      this.effectiveTo,
      required this.reason})
      : super._();
  @override
  CommissionRuleCreateDto rebuild(
          void Function(CommissionRuleCreateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionRuleCreateDtoBuilder toBuilder() =>
      CommissionRuleCreateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionRuleCreateDto &&
        operatorId == other.operatorId &&
        rateBps == other.rateBps &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionRuleCreateDto')
          ..add('operatorId', operatorId)
          ..add('rateBps', rateBps)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('reason', reason))
        .toString();
  }
}

class CommissionRuleCreateDtoBuilder
    implements
        Builder<CommissionRuleCreateDto, CommissionRuleCreateDtoBuilder> {
  _$CommissionRuleCreateDto? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  int? _rateBps;
  int? get rateBps => _$this._rateBps;
  set rateBps(int? rateBps) => _$this._rateBps = rateBps;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  DateTime? _effectiveTo;
  DateTime? get effectiveTo => _$this._effectiveTo;
  set effectiveTo(DateTime? effectiveTo) => _$this._effectiveTo = effectiveTo;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CommissionRuleCreateDtoBuilder() {
    CommissionRuleCreateDto._defaults(this);
  }

  CommissionRuleCreateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _rateBps = $v.rateBps;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionRuleCreateDto other) {
    _$v = other as _$CommissionRuleCreateDto;
  }

  @override
  void update(void Function(CommissionRuleCreateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionRuleCreateDto build() => _build();

  _$CommissionRuleCreateDto _build() {
    final _$result = _$v ??
        _$CommissionRuleCreateDto._(
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'CommissionRuleCreateDto', 'operatorId'),
          rateBps: BuiltValueNullFieldError.checkNotNull(
              rateBps, r'CommissionRuleCreateDto', 'rateBps'),
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'CommissionRuleCreateDto', 'effectiveFrom'),
          effectiveTo: effectiveTo,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionRuleCreateDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
