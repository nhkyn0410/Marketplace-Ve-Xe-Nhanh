// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_route_page_dto_output_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRoutePageDtoOutputPeriod extends AdminRoutePageDtoOutputPeriod {
  @override
  final Date from;
  @override
  final Date to;

  factory _$AdminRoutePageDtoOutputPeriod(
          [void Function(AdminRoutePageDtoOutputPeriodBuilder)? updates]) =>
      (AdminRoutePageDtoOutputPeriodBuilder()..update(updates))._build();

  _$AdminRoutePageDtoOutputPeriod._({required this.from, required this.to})
      : super._();
  @override
  AdminRoutePageDtoOutputPeriod rebuild(
          void Function(AdminRoutePageDtoOutputPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRoutePageDtoOutputPeriodBuilder toBuilder() =>
      AdminRoutePageDtoOutputPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRoutePageDtoOutputPeriod &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRoutePageDtoOutputPeriod')
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class AdminRoutePageDtoOutputPeriodBuilder
    implements
        Builder<AdminRoutePageDtoOutputPeriod,
            AdminRoutePageDtoOutputPeriodBuilder> {
  _$AdminRoutePageDtoOutputPeriod? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  AdminRoutePageDtoOutputPeriodBuilder() {
    AdminRoutePageDtoOutputPeriod._defaults(this);
  }

  AdminRoutePageDtoOutputPeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRoutePageDtoOutputPeriod other) {
    _$v = other as _$AdminRoutePageDtoOutputPeriod;
  }

  @override
  void update(void Function(AdminRoutePageDtoOutputPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRoutePageDtoOutputPeriod build() => _build();

  _$AdminRoutePageDtoOutputPeriod _build() {
    final _$result = _$v ??
        _$AdminRoutePageDtoOutputPeriod._(
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'AdminRoutePageDtoOutputPeriod', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'AdminRoutePageDtoOutputPeriod', 'to'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
