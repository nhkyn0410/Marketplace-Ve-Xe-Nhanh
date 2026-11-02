// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_detail_dto_output_seat_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTripDetailDtoOutputSeatSummary
    extends AdminTripDetailDtoOutputSeatSummary {
  @override
  final int available;
  @override
  final int holding;
  @override
  final int booked;
  @override
  final int checkedIn;
  @override
  final int blocked;

  factory _$AdminTripDetailDtoOutputSeatSummary(
          [void Function(AdminTripDetailDtoOutputSeatSummaryBuilder)?
              updates]) =>
      (AdminTripDetailDtoOutputSeatSummaryBuilder()..update(updates))._build();

  _$AdminTripDetailDtoOutputSeatSummary._(
      {required this.available,
      required this.holding,
      required this.booked,
      required this.checkedIn,
      required this.blocked})
      : super._();
  @override
  AdminTripDetailDtoOutputSeatSummary rebuild(
          void Function(AdminTripDetailDtoOutputSeatSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripDetailDtoOutputSeatSummaryBuilder toBuilder() =>
      AdminTripDetailDtoOutputSeatSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripDetailDtoOutputSeatSummary &&
        available == other.available &&
        holding == other.holding &&
        booked == other.booked &&
        checkedIn == other.checkedIn &&
        blocked == other.blocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, holding.hashCode);
    _$hash = $jc(_$hash, booked.hashCode);
    _$hash = $jc(_$hash, checkedIn.hashCode);
    _$hash = $jc(_$hash, blocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTripDetailDtoOutputSeatSummary')
          ..add('available', available)
          ..add('holding', holding)
          ..add('booked', booked)
          ..add('checkedIn', checkedIn)
          ..add('blocked', blocked))
        .toString();
  }
}

class AdminTripDetailDtoOutputSeatSummaryBuilder
    implements
        Builder<AdminTripDetailDtoOutputSeatSummary,
            AdminTripDetailDtoOutputSeatSummaryBuilder> {
  _$AdminTripDetailDtoOutputSeatSummary? _$v;

  int? _available;
  int? get available => _$this._available;
  set available(int? available) => _$this._available = available;

  int? _holding;
  int? get holding => _$this._holding;
  set holding(int? holding) => _$this._holding = holding;

  int? _booked;
  int? get booked => _$this._booked;
  set booked(int? booked) => _$this._booked = booked;

  int? _checkedIn;
  int? get checkedIn => _$this._checkedIn;
  set checkedIn(int? checkedIn) => _$this._checkedIn = checkedIn;

  int? _blocked;
  int? get blocked => _$this._blocked;
  set blocked(int? blocked) => _$this._blocked = blocked;

  AdminTripDetailDtoOutputSeatSummaryBuilder() {
    AdminTripDetailDtoOutputSeatSummary._defaults(this);
  }

  AdminTripDetailDtoOutputSeatSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _available = $v.available;
      _holding = $v.holding;
      _booked = $v.booked;
      _checkedIn = $v.checkedIn;
      _blocked = $v.blocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTripDetailDtoOutputSeatSummary other) {
    _$v = other as _$AdminTripDetailDtoOutputSeatSummary;
  }

  @override
  void update(
      void Function(AdminTripDetailDtoOutputSeatSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripDetailDtoOutputSeatSummary build() => _build();

  _$AdminTripDetailDtoOutputSeatSummary _build() {
    final _$result = _$v ??
        _$AdminTripDetailDtoOutputSeatSummary._(
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'AdminTripDetailDtoOutputSeatSummary', 'available'),
          holding: BuiltValueNullFieldError.checkNotNull(
              holding, r'AdminTripDetailDtoOutputSeatSummary', 'holding'),
          booked: BuiltValueNullFieldError.checkNotNull(
              booked, r'AdminTripDetailDtoOutputSeatSummary', 'booked'),
          checkedIn: BuiltValueNullFieldError.checkNotNull(
              checkedIn, r'AdminTripDetailDtoOutputSeatSummary', 'checkedIn'),
          blocked: BuiltValueNullFieldError.checkNotNull(
              blocked, r'AdminTripDetailDtoOutputSeatSummary', 'blocked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
