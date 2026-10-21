// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_items_inner_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputItemsInnerPickup
    extends TripSearchResponseDtoOutputItemsInnerPickup {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final String address;
  @override
  final DateTime plannedAt;

  factory _$TripSearchResponseDtoOutputItemsInnerPickup(
          [void Function(TripSearchResponseDtoOutputItemsInnerPickupBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputItemsInnerPickupBuilder()..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputItemsInnerPickup._(
      {required this.sequence,
      required this.name,
      required this.address,
      required this.plannedAt})
      : super._();
  @override
  TripSearchResponseDtoOutputItemsInnerPickup rebuild(
          void Function(TripSearchResponseDtoOutputItemsInnerPickupBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputItemsInnerPickupBuilder toBuilder() =>
      TripSearchResponseDtoOutputItemsInnerPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputItemsInnerPickup &&
        sequence == other.sequence &&
        name == other.name &&
        address == other.address &&
        plannedAt == other.plannedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, plannedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputItemsInnerPickup')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('address', address)
          ..add('plannedAt', plannedAt))
        .toString();
  }
}

class TripSearchResponseDtoOutputItemsInnerPickupBuilder
    implements
        Builder<TripSearchResponseDtoOutputItemsInnerPickup,
            TripSearchResponseDtoOutputItemsInnerPickupBuilder> {
  _$TripSearchResponseDtoOutputItemsInnerPickup? _$v;

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

  TripSearchResponseDtoOutputItemsInnerPickupBuilder() {
    TripSearchResponseDtoOutputItemsInnerPickup._defaults(this);
  }

  TripSearchResponseDtoOutputItemsInnerPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _address = $v.address;
      _plannedAt = $v.plannedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputItemsInnerPickup other) {
    _$v = other as _$TripSearchResponseDtoOutputItemsInnerPickup;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputItemsInnerPickupBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputItemsInnerPickup build() => _build();

  _$TripSearchResponseDtoOutputItemsInnerPickup _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputItemsInnerPickup._(
          sequence: BuiltValueNullFieldError.checkNotNull(sequence,
              r'TripSearchResponseDtoOutputItemsInnerPickup', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripSearchResponseDtoOutputItemsInnerPickup', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(address,
              r'TripSearchResponseDtoOutputItemsInnerPickup', 'address'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(plannedAt,
              r'TripSearchResponseDtoOutputItemsInnerPickup', 'plannedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
