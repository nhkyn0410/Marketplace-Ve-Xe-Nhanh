// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_manifest_dto_output_passengers_inner_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripManifestDtoOutputPassengersInnerPickup
    extends TripManifestDtoOutputPassengersInnerPickup {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final DateTime? pickupWindowStart;
  @override
  final DateTime? pickupWindowEnd;

  factory _$TripManifestDtoOutputPassengersInnerPickup(
          [void Function(TripManifestDtoOutputPassengersInnerPickupBuilder)?
              updates]) =>
      (TripManifestDtoOutputPassengersInnerPickupBuilder()..update(updates))
          ._build();

  _$TripManifestDtoOutputPassengersInnerPickup._(
      {required this.sequence,
      required this.name,
      this.pickupWindowStart,
      this.pickupWindowEnd})
      : super._();
  @override
  TripManifestDtoOutputPassengersInnerPickup rebuild(
          void Function(TripManifestDtoOutputPassengersInnerPickupBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripManifestDtoOutputPassengersInnerPickupBuilder toBuilder() =>
      TripManifestDtoOutputPassengersInnerPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripManifestDtoOutputPassengersInnerPickup &&
        sequence == other.sequence &&
        name == other.name &&
        pickupWindowStart == other.pickupWindowStart &&
        pickupWindowEnd == other.pickupWindowEnd;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, pickupWindowStart.hashCode);
    _$hash = $jc(_$hash, pickupWindowEnd.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripManifestDtoOutputPassengersInnerPickup')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('pickupWindowStart', pickupWindowStart)
          ..add('pickupWindowEnd', pickupWindowEnd))
        .toString();
  }
}

class TripManifestDtoOutputPassengersInnerPickupBuilder
    implements
        Builder<TripManifestDtoOutputPassengersInnerPickup,
            TripManifestDtoOutputPassengersInnerPickupBuilder> {
  _$TripManifestDtoOutputPassengersInnerPickup? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _pickupWindowStart;
  DateTime? get pickupWindowStart => _$this._pickupWindowStart;
  set pickupWindowStart(DateTime? pickupWindowStart) =>
      _$this._pickupWindowStart = pickupWindowStart;

  DateTime? _pickupWindowEnd;
  DateTime? get pickupWindowEnd => _$this._pickupWindowEnd;
  set pickupWindowEnd(DateTime? pickupWindowEnd) =>
      _$this._pickupWindowEnd = pickupWindowEnd;

  TripManifestDtoOutputPassengersInnerPickupBuilder() {
    TripManifestDtoOutputPassengersInnerPickup._defaults(this);
  }

  TripManifestDtoOutputPassengersInnerPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _pickupWindowStart = $v.pickupWindowStart;
      _pickupWindowEnd = $v.pickupWindowEnd;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripManifestDtoOutputPassengersInnerPickup other) {
    _$v = other as _$TripManifestDtoOutputPassengersInnerPickup;
  }

  @override
  void update(
      void Function(TripManifestDtoOutputPassengersInnerPickupBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripManifestDtoOutputPassengersInnerPickup build() => _build();

  _$TripManifestDtoOutputPassengersInnerPickup _build() {
    final _$result = _$v ??
        _$TripManifestDtoOutputPassengersInnerPickup._(
          sequence: BuiltValueNullFieldError.checkNotNull(sequence,
              r'TripManifestDtoOutputPassengersInnerPickup', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripManifestDtoOutputPassengersInnerPickup', 'name'),
          pickupWindowStart: pickupWindowStart,
          pickupWindowEnd: pickupWindowEnd,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
