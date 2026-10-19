// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_hold_response_dto_output_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeatHoldResponseDtoOutputPickup
    extends SeatHoldResponseDtoOutputPickup {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final DateTime plannedAt;

  factory _$SeatHoldResponseDtoOutputPickup(
          [void Function(SeatHoldResponseDtoOutputPickupBuilder)? updates]) =>
      (SeatHoldResponseDtoOutputPickupBuilder()..update(updates))._build();

  _$SeatHoldResponseDtoOutputPickup._(
      {required this.sequence, required this.name, required this.plannedAt})
      : super._();
  @override
  SeatHoldResponseDtoOutputPickup rebuild(
          void Function(SeatHoldResponseDtoOutputPickupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeatHoldResponseDtoOutputPickupBuilder toBuilder() =>
      SeatHoldResponseDtoOutputPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeatHoldResponseDtoOutputPickup &&
        sequence == other.sequence &&
        name == other.name &&
        plannedAt == other.plannedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, plannedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SeatHoldResponseDtoOutputPickup')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('plannedAt', plannedAt))
        .toString();
  }
}

class SeatHoldResponseDtoOutputPickupBuilder
    implements
        Builder<SeatHoldResponseDtoOutputPickup,
            SeatHoldResponseDtoOutputPickupBuilder> {
  _$SeatHoldResponseDtoOutputPickup? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _plannedAt;
  DateTime? get plannedAt => _$this._plannedAt;
  set plannedAt(DateTime? plannedAt) => _$this._plannedAt = plannedAt;

  SeatHoldResponseDtoOutputPickupBuilder() {
    SeatHoldResponseDtoOutputPickup._defaults(this);
  }

  SeatHoldResponseDtoOutputPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _plannedAt = $v.plannedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeatHoldResponseDtoOutputPickup other) {
    _$v = other as _$SeatHoldResponseDtoOutputPickup;
  }

  @override
  void update(void Function(SeatHoldResponseDtoOutputPickupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SeatHoldResponseDtoOutputPickup build() => _build();

  _$SeatHoldResponseDtoOutputPickup _build() {
    final _$result = _$v ??
        _$SeatHoldResponseDtoOutputPickup._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'SeatHoldResponseDtoOutputPickup', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SeatHoldResponseDtoOutputPickup', 'name'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(
              plannedAt, r'SeatHoldResponseDtoOutputPickup', 'plannedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
