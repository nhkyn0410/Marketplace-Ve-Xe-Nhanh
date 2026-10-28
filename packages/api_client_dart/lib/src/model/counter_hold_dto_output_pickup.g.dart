// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_hold_dto_output_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterHoldDtoOutputPickup extends CounterHoldDtoOutputPickup {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final DateTime plannedAt;

  factory _$CounterHoldDtoOutputPickup(
          [void Function(CounterHoldDtoOutputPickupBuilder)? updates]) =>
      (CounterHoldDtoOutputPickupBuilder()..update(updates))._build();

  _$CounterHoldDtoOutputPickup._(
      {required this.sequence, required this.name, required this.plannedAt})
      : super._();
  @override
  CounterHoldDtoOutputPickup rebuild(
          void Function(CounterHoldDtoOutputPickupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterHoldDtoOutputPickupBuilder toBuilder() =>
      CounterHoldDtoOutputPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterHoldDtoOutputPickup &&
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
    return (newBuiltValueToStringHelper(r'CounterHoldDtoOutputPickup')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('plannedAt', plannedAt))
        .toString();
  }
}

class CounterHoldDtoOutputPickupBuilder
    implements
        Builder<CounterHoldDtoOutputPickup, CounterHoldDtoOutputPickupBuilder> {
  _$CounterHoldDtoOutputPickup? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _plannedAt;
  DateTime? get plannedAt => _$this._plannedAt;
  set plannedAt(DateTime? plannedAt) => _$this._plannedAt = plannedAt;

  CounterHoldDtoOutputPickupBuilder() {
    CounterHoldDtoOutputPickup._defaults(this);
  }

  CounterHoldDtoOutputPickupBuilder get _$this {
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
  void replace(CounterHoldDtoOutputPickup other) {
    _$v = other as _$CounterHoldDtoOutputPickup;
  }

  @override
  void update(void Function(CounterHoldDtoOutputPickupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterHoldDtoOutputPickup build() => _build();

  _$CounterHoldDtoOutputPickup _build() {
    final _$result = _$v ??
        _$CounterHoldDtoOutputPickup._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'CounterHoldDtoOutputPickup', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CounterHoldDtoOutputPickup', 'name'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(
              plannedAt, r'CounterHoldDtoOutputPickup', 'plannedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
