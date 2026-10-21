// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_dto_output_bookings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewDtoOutputBookings extends AdminOverviewDtoOutputBookings {
  @override
  final int total;
  @override
  final int confirmed;
  @override
  final int cancelledOrExpired;

  factory _$AdminOverviewDtoOutputBookings(
          [void Function(AdminOverviewDtoOutputBookingsBuilder)? updates]) =>
      (AdminOverviewDtoOutputBookingsBuilder()..update(updates))._build();

  _$AdminOverviewDtoOutputBookings._(
      {required this.total,
      required this.confirmed,
      required this.cancelledOrExpired})
      : super._();
  @override
  AdminOverviewDtoOutputBookings rebuild(
          void Function(AdminOverviewDtoOutputBookingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewDtoOutputBookingsBuilder toBuilder() =>
      AdminOverviewDtoOutputBookingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewDtoOutputBookings &&
        total == other.total &&
        confirmed == other.confirmed &&
        cancelledOrExpired == other.cancelledOrExpired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, confirmed.hashCode);
    _$hash = $jc(_$hash, cancelledOrExpired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewDtoOutputBookings')
          ..add('total', total)
          ..add('confirmed', confirmed)
          ..add('cancelledOrExpired', cancelledOrExpired))
        .toString();
  }
}

class AdminOverviewDtoOutputBookingsBuilder
    implements
        Builder<AdminOverviewDtoOutputBookings,
            AdminOverviewDtoOutputBookingsBuilder> {
  _$AdminOverviewDtoOutputBookings? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _confirmed;
  int? get confirmed => _$this._confirmed;
  set confirmed(int? confirmed) => _$this._confirmed = confirmed;

  int? _cancelledOrExpired;
  int? get cancelledOrExpired => _$this._cancelledOrExpired;
  set cancelledOrExpired(int? cancelledOrExpired) =>
      _$this._cancelledOrExpired = cancelledOrExpired;

  AdminOverviewDtoOutputBookingsBuilder() {
    AdminOverviewDtoOutputBookings._defaults(this);
  }

  AdminOverviewDtoOutputBookingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _confirmed = $v.confirmed;
      _cancelledOrExpired = $v.cancelledOrExpired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewDtoOutputBookings other) {
    _$v = other as _$AdminOverviewDtoOutputBookings;
  }

  @override
  void update(void Function(AdminOverviewDtoOutputBookingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewDtoOutputBookings build() => _build();

  _$AdminOverviewDtoOutputBookings _build() {
    final _$result = _$v ??
        _$AdminOverviewDtoOutputBookings._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'AdminOverviewDtoOutputBookings', 'total'),
          confirmed: BuiltValueNullFieldError.checkNotNull(
              confirmed, r'AdminOverviewDtoOutputBookings', 'confirmed'),
          cancelledOrExpired: BuiltValueNullFieldError.checkNotNull(
              cancelledOrExpired,
              r'AdminOverviewDtoOutputBookings',
              'cancelledOrExpired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
