// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_overview_dto_output_default.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionOverviewDtoOutputDefault
    extends CommissionOverviewDtoOutputDefault {
  @override
  final int rateBps;
  @override
  final DateTime effectiveFrom;

  factory _$CommissionOverviewDtoOutputDefault(
          [void Function(CommissionOverviewDtoOutputDefaultBuilder)?
              updates]) =>
      (CommissionOverviewDtoOutputDefaultBuilder()..update(updates))._build();

  _$CommissionOverviewDtoOutputDefault._(
      {required this.rateBps, required this.effectiveFrom})
      : super._();
  @override
  CommissionOverviewDtoOutputDefault rebuild(
          void Function(CommissionOverviewDtoOutputDefaultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionOverviewDtoOutputDefaultBuilder toBuilder() =>
      CommissionOverviewDtoOutputDefaultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionOverviewDtoOutputDefault &&
        rateBps == other.rateBps &&
        effectiveFrom == other.effectiveFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionOverviewDtoOutputDefault')
          ..add('rateBps', rateBps)
          ..add('effectiveFrom', effectiveFrom))
        .toString();
  }
}

class CommissionOverviewDtoOutputDefaultBuilder
    implements
        Builder<CommissionOverviewDtoOutputDefault,
            CommissionOverviewDtoOutputDefaultBuilder> {
  _$CommissionOverviewDtoOutputDefault? _$v;

  int? _rateBps;
  int? get rateBps => _$this._rateBps;
  set rateBps(int? rateBps) => _$this._rateBps = rateBps;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  CommissionOverviewDtoOutputDefaultBuilder() {
    CommissionOverviewDtoOutputDefault._defaults(this);
  }

  CommissionOverviewDtoOutputDefaultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBps = $v.rateBps;
      _effectiveFrom = $v.effectiveFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionOverviewDtoOutputDefault other) {
    _$v = other as _$CommissionOverviewDtoOutputDefault;
  }

  @override
  void update(
      void Function(CommissionOverviewDtoOutputDefaultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionOverviewDtoOutputDefault build() => _build();

  _$CommissionOverviewDtoOutputDefault _build() {
    final _$result = _$v ??
        _$CommissionOverviewDtoOutputDefault._(
          rateBps: BuiltValueNullFieldError.checkNotNull(
              rateBps, r'CommissionOverviewDtoOutputDefault', 'rateBps'),
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(effectiveFrom,
              r'CommissionOverviewDtoOutputDefault', 'effectiveFrom'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
