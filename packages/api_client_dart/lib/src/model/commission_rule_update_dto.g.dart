// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_rule_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionRuleUpdateDto extends CommissionRuleUpdateDto {
  @override
  final int rateBps;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final String reason;

  factory _$CommissionRuleUpdateDto(
          [void Function(CommissionRuleUpdateDtoBuilder)? updates]) =>
      (CommissionRuleUpdateDtoBuilder()..update(updates))._build();

  _$CommissionRuleUpdateDto._(
      {required this.rateBps,
      required this.effectiveFrom,
      this.effectiveTo,
      required this.reason})
      : super._();
  @override
  CommissionRuleUpdateDto rebuild(
          void Function(CommissionRuleUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionRuleUpdateDtoBuilder toBuilder() =>
      CommissionRuleUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionRuleUpdateDto &&
        rateBps == other.rateBps &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionRuleUpdateDto')
          ..add('rateBps', rateBps)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('reason', reason))
        .toString();
  }
}

class CommissionRuleUpdateDtoBuilder
    implements
        Builder<CommissionRuleUpdateDto, CommissionRuleUpdateDtoBuilder> {
  _$CommissionRuleUpdateDto? _$v;

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

  CommissionRuleUpdateDtoBuilder() {
    CommissionRuleUpdateDto._defaults(this);
  }

  CommissionRuleUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBps = $v.rateBps;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionRuleUpdateDto other) {
    _$v = other as _$CommissionRuleUpdateDto;
  }

  @override
  void update(void Function(CommissionRuleUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionRuleUpdateDto build() => _build();

  _$CommissionRuleUpdateDto _build() {
    final _$result = _$v ??
        _$CommissionRuleUpdateDto._(
          rateBps: BuiltValueNullFieldError.checkNotNull(
              rateBps, r'CommissionRuleUpdateDto', 'rateBps'),
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'CommissionRuleUpdateDto', 'effectiveFrom'),
          effectiveTo: effectiveTo,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionRuleUpdateDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
