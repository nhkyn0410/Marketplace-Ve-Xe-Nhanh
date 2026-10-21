// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_dto_output_daily_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewDtoOutputDailyInner
    extends AdminOverviewDtoOutputDailyInner {
  @override
  final Date date;
  @override
  final int gmv;

  factory _$AdminOverviewDtoOutputDailyInner(
          [void Function(AdminOverviewDtoOutputDailyInnerBuilder)? updates]) =>
      (AdminOverviewDtoOutputDailyInnerBuilder()..update(updates))._build();

  _$AdminOverviewDtoOutputDailyInner._({required this.date, required this.gmv})
      : super._();
  @override
  AdminOverviewDtoOutputDailyInner rebuild(
          void Function(AdminOverviewDtoOutputDailyInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewDtoOutputDailyInnerBuilder toBuilder() =>
      AdminOverviewDtoOutputDailyInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewDtoOutputDailyInner &&
        date == other.date &&
        gmv == other.gmv;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, gmv.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewDtoOutputDailyInner')
          ..add('date', date)
          ..add('gmv', gmv))
        .toString();
  }
}

class AdminOverviewDtoOutputDailyInnerBuilder
    implements
        Builder<AdminOverviewDtoOutputDailyInner,
            AdminOverviewDtoOutputDailyInnerBuilder> {
  _$AdminOverviewDtoOutputDailyInner? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _gmv;
  int? get gmv => _$this._gmv;
  set gmv(int? gmv) => _$this._gmv = gmv;

  AdminOverviewDtoOutputDailyInnerBuilder() {
    AdminOverviewDtoOutputDailyInner._defaults(this);
  }

  AdminOverviewDtoOutputDailyInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _gmv = $v.gmv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewDtoOutputDailyInner other) {
    _$v = other as _$AdminOverviewDtoOutputDailyInner;
  }

  @override
  void update(void Function(AdminOverviewDtoOutputDailyInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewDtoOutputDailyInner build() => _build();

  _$AdminOverviewDtoOutputDailyInner _build() {
    final _$result = _$v ??
        _$AdminOverviewDtoOutputDailyInner._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AdminOverviewDtoOutputDailyInner', 'date'),
          gmv: BuiltValueNullFieldError.checkNotNull(
              gmv, r'AdminOverviewDtoOutputDailyInner', 'gmv'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
