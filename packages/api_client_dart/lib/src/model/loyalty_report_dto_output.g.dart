// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoyaltyReportDtoOutputTierEnum _$loyaltyReportDtoOutputTierEnum_BRONZE =
    const LoyaltyReportDtoOutputTierEnum._('BRONZE');
const LoyaltyReportDtoOutputTierEnum _$loyaltyReportDtoOutputTierEnum_SILVER =
    const LoyaltyReportDtoOutputTierEnum._('SILVER');
const LoyaltyReportDtoOutputTierEnum _$loyaltyReportDtoOutputTierEnum_GOLD =
    const LoyaltyReportDtoOutputTierEnum._('GOLD');
const LoyaltyReportDtoOutputTierEnum _$loyaltyReportDtoOutputTierEnum_PLATINUM =
    const LoyaltyReportDtoOutputTierEnum._('PLATINUM');

LoyaltyReportDtoOutputTierEnum _$loyaltyReportDtoOutputTierEnumValueOf(
    String name) {
  switch (name) {
    case 'BRONZE':
      return _$loyaltyReportDtoOutputTierEnum_BRONZE;
    case 'SILVER':
      return _$loyaltyReportDtoOutputTierEnum_SILVER;
    case 'GOLD':
      return _$loyaltyReportDtoOutputTierEnum_GOLD;
    case 'PLATINUM':
      return _$loyaltyReportDtoOutputTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoyaltyReportDtoOutputTierEnum>
    _$loyaltyReportDtoOutputTierEnumValues = BuiltSet<
        LoyaltyReportDtoOutputTierEnum>(const <LoyaltyReportDtoOutputTierEnum>[
  _$loyaltyReportDtoOutputTierEnum_BRONZE,
  _$loyaltyReportDtoOutputTierEnum_SILVER,
  _$loyaltyReportDtoOutputTierEnum_GOLD,
  _$loyaltyReportDtoOutputTierEnum_PLATINUM,
]);

Serializer<LoyaltyReportDtoOutputTierEnum>
    _$loyaltyReportDtoOutputTierEnumSerializer =
    _$LoyaltyReportDtoOutputTierEnumSerializer();

class _$LoyaltyReportDtoOutputTierEnumSerializer
    implements PrimitiveSerializer<LoyaltyReportDtoOutputTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };

  @override
  final Iterable<Type> types = const <Type>[LoyaltyReportDtoOutputTierEnum];
  @override
  final String wireName = 'LoyaltyReportDtoOutputTierEnum';

  @override
  Object serialize(
          Serializers serializers, LoyaltyReportDtoOutputTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoyaltyReportDtoOutputTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoyaltyReportDtoOutputTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoyaltyReportDtoOutput extends LoyaltyReportDtoOutput {
  @override
  final int year;
  @override
  final int quarter;
  @override
  final LoyaltyReportDtoOutputTierEnum? tier;
  @override
  final BuiltList<LoyaltyReportDtoOutputMonthsInner> months;
  @override
  final LoyaltyReportDtoOutputTotals totals;

  factory _$LoyaltyReportDtoOutput(
          [void Function(LoyaltyReportDtoOutputBuilder)? updates]) =>
      (LoyaltyReportDtoOutputBuilder()..update(updates))._build();

  _$LoyaltyReportDtoOutput._(
      {required this.year,
      required this.quarter,
      this.tier,
      required this.months,
      required this.totals})
      : super._();
  @override
  LoyaltyReportDtoOutput rebuild(
          void Function(LoyaltyReportDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyReportDtoOutputBuilder toBuilder() =>
      LoyaltyReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyReportDtoOutput &&
        year == other.year &&
        quarter == other.quarter &&
        tier == other.tier &&
        months == other.months &&
        totals == other.totals;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, year.hashCode);
    _$hash = $jc(_$hash, quarter.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, months.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyReportDtoOutput')
          ..add('year', year)
          ..add('quarter', quarter)
          ..add('tier', tier)
          ..add('months', months)
          ..add('totals', totals))
        .toString();
  }
}

class LoyaltyReportDtoOutputBuilder
    implements Builder<LoyaltyReportDtoOutput, LoyaltyReportDtoOutputBuilder> {
  _$LoyaltyReportDtoOutput? _$v;

  int? _year;
  int? get year => _$this._year;
  set year(int? year) => _$this._year = year;

  int? _quarter;
  int? get quarter => _$this._quarter;
  set quarter(int? quarter) => _$this._quarter = quarter;

  LoyaltyReportDtoOutputTierEnum? _tier;
  LoyaltyReportDtoOutputTierEnum? get tier => _$this._tier;
  set tier(LoyaltyReportDtoOutputTierEnum? tier) => _$this._tier = tier;

  ListBuilder<LoyaltyReportDtoOutputMonthsInner>? _months;
  ListBuilder<LoyaltyReportDtoOutputMonthsInner> get months =>
      _$this._months ??= ListBuilder<LoyaltyReportDtoOutputMonthsInner>();
  set months(ListBuilder<LoyaltyReportDtoOutputMonthsInner>? months) =>
      _$this._months = months;

  LoyaltyReportDtoOutputTotalsBuilder? _totals;
  LoyaltyReportDtoOutputTotalsBuilder get totals =>
      _$this._totals ??= LoyaltyReportDtoOutputTotalsBuilder();
  set totals(LoyaltyReportDtoOutputTotalsBuilder? totals) =>
      _$this._totals = totals;

  LoyaltyReportDtoOutputBuilder() {
    LoyaltyReportDtoOutput._defaults(this);
  }

  LoyaltyReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _year = $v.year;
      _quarter = $v.quarter;
      _tier = $v.tier;
      _months = $v.months.toBuilder();
      _totals = $v.totals.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyReportDtoOutput other) {
    _$v = other as _$LoyaltyReportDtoOutput;
  }

  @override
  void update(void Function(LoyaltyReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyReportDtoOutput build() => _build();

  _$LoyaltyReportDtoOutput _build() {
    _$LoyaltyReportDtoOutput _$result;
    try {
      _$result = _$v ??
          _$LoyaltyReportDtoOutput._(
            year: BuiltValueNullFieldError.checkNotNull(
                year, r'LoyaltyReportDtoOutput', 'year'),
            quarter: BuiltValueNullFieldError.checkNotNull(
                quarter, r'LoyaltyReportDtoOutput', 'quarter'),
            tier: tier,
            months: months.build(),
            totals: totals.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'months';
        months.build();
        _$failedField = 'totals';
        totals.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LoyaltyReportDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
