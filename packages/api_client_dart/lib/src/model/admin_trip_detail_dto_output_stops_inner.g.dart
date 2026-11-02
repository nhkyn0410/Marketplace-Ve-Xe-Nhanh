// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_detail_dto_output_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTripDetailDtoOutputStopsInner
    extends AdminTripDetailDtoOutputStopsInner {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final String address;
  @override
  final DateTime plannedAt;
  @override
  final bool allowPickup;
  @override
  final bool allowDropoff;

  factory _$AdminTripDetailDtoOutputStopsInner(
          [void Function(AdminTripDetailDtoOutputStopsInnerBuilder)?
              updates]) =>
      (AdminTripDetailDtoOutputStopsInnerBuilder()..update(updates))._build();

  _$AdminTripDetailDtoOutputStopsInner._(
      {required this.sequence,
      required this.name,
      required this.address,
      required this.plannedAt,
      required this.allowPickup,
      required this.allowDropoff})
      : super._();
  @override
  AdminTripDetailDtoOutputStopsInner rebuild(
          void Function(AdminTripDetailDtoOutputStopsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripDetailDtoOutputStopsInnerBuilder toBuilder() =>
      AdminTripDetailDtoOutputStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripDetailDtoOutputStopsInner &&
        sequence == other.sequence &&
        name == other.name &&
        address == other.address &&
        plannedAt == other.plannedAt &&
        allowPickup == other.allowPickup &&
        allowDropoff == other.allowDropoff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, plannedAt.hashCode);
    _$hash = $jc(_$hash, allowPickup.hashCode);
    _$hash = $jc(_$hash, allowDropoff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTripDetailDtoOutputStopsInner')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('address', address)
          ..add('plannedAt', plannedAt)
          ..add('allowPickup', allowPickup)
          ..add('allowDropoff', allowDropoff))
        .toString();
  }
}

class AdminTripDetailDtoOutputStopsInnerBuilder
    implements
        Builder<AdminTripDetailDtoOutputStopsInner,
            AdminTripDetailDtoOutputStopsInnerBuilder> {
  _$AdminTripDetailDtoOutputStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  DateTime? _plannedAt;
  DateTime? get plannedAt => _$this._plannedAt;
  set plannedAt(DateTime? plannedAt) => _$this._plannedAt = plannedAt;

  bool? _allowPickup;
  bool? get allowPickup => _$this._allowPickup;
  set allowPickup(bool? allowPickup) => _$this._allowPickup = allowPickup;

  bool? _allowDropoff;
  bool? get allowDropoff => _$this._allowDropoff;
  set allowDropoff(bool? allowDropoff) => _$this._allowDropoff = allowDropoff;

  AdminTripDetailDtoOutputStopsInnerBuilder() {
    AdminTripDetailDtoOutputStopsInner._defaults(this);
  }

  AdminTripDetailDtoOutputStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _address = $v.address;
      _plannedAt = $v.plannedAt;
      _allowPickup = $v.allowPickup;
      _allowDropoff = $v.allowDropoff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTripDetailDtoOutputStopsInner other) {
    _$v = other as _$AdminTripDetailDtoOutputStopsInner;
  }

  @override
  void update(
      void Function(AdminTripDetailDtoOutputStopsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripDetailDtoOutputStopsInner build() => _build();

  _$AdminTripDetailDtoOutputStopsInner _build() {
    final _$result = _$v ??
        _$AdminTripDetailDtoOutputStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'AdminTripDetailDtoOutputStopsInner', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminTripDetailDtoOutputStopsInner', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'AdminTripDetailDtoOutputStopsInner', 'address'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(
              plannedAt, r'AdminTripDetailDtoOutputStopsInner', 'plannedAt'),
          allowPickup: BuiltValueNullFieldError.checkNotNull(allowPickup,
              r'AdminTripDetailDtoOutputStopsInner', 'allowPickup'),
          allowDropoff: BuiltValueNullFieldError.checkNotNull(allowDropoff,
              r'AdminTripDetailDtoOutputStopsInner', 'allowDropoff'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
