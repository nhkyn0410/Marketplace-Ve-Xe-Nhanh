// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_trip_list_dto_output_items_inner_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterTripListDtoOutputItemsInnerStopsInner
    extends CounterTripListDtoOutputItemsInnerStopsInner {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final DateTime plannedAt;
  @override
  final bool allowPickup;
  @override
  final bool allowDropoff;

  factory _$CounterTripListDtoOutputItemsInnerStopsInner(
          [void Function(CounterTripListDtoOutputItemsInnerStopsInnerBuilder)?
              updates]) =>
      (CounterTripListDtoOutputItemsInnerStopsInnerBuilder()..update(updates))
          ._build();

  _$CounterTripListDtoOutputItemsInnerStopsInner._(
      {required this.sequence,
      required this.name,
      required this.plannedAt,
      required this.allowPickup,
      required this.allowDropoff})
      : super._();
  @override
  CounterTripListDtoOutputItemsInnerStopsInner rebuild(
          void Function(CounterTripListDtoOutputItemsInnerStopsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterTripListDtoOutputItemsInnerStopsInnerBuilder toBuilder() =>
      CounterTripListDtoOutputItemsInnerStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterTripListDtoOutputItemsInnerStopsInner &&
        sequence == other.sequence &&
        name == other.name &&
        plannedAt == other.plannedAt &&
        allowPickup == other.allowPickup &&
        allowDropoff == other.allowDropoff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, plannedAt.hashCode);
    _$hash = $jc(_$hash, allowPickup.hashCode);
    _$hash = $jc(_$hash, allowDropoff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterTripListDtoOutputItemsInnerStopsInner')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('plannedAt', plannedAt)
          ..add('allowPickup', allowPickup)
          ..add('allowDropoff', allowDropoff))
        .toString();
  }
}

class CounterTripListDtoOutputItemsInnerStopsInnerBuilder
    implements
        Builder<CounterTripListDtoOutputItemsInnerStopsInner,
            CounterTripListDtoOutputItemsInnerStopsInnerBuilder> {
  _$CounterTripListDtoOutputItemsInnerStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _plannedAt;
  DateTime? get plannedAt => _$this._plannedAt;
  set plannedAt(DateTime? plannedAt) => _$this._plannedAt = plannedAt;

  bool? _allowPickup;
  bool? get allowPickup => _$this._allowPickup;
  set allowPickup(bool? allowPickup) => _$this._allowPickup = allowPickup;

  bool? _allowDropoff;
  bool? get allowDropoff => _$this._allowDropoff;
  set allowDropoff(bool? allowDropoff) => _$this._allowDropoff = allowDropoff;

  CounterTripListDtoOutputItemsInnerStopsInnerBuilder() {
    CounterTripListDtoOutputItemsInnerStopsInner._defaults(this);
  }

  CounterTripListDtoOutputItemsInnerStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _plannedAt = $v.plannedAt;
      _allowPickup = $v.allowPickup;
      _allowDropoff = $v.allowDropoff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterTripListDtoOutputItemsInnerStopsInner other) {
    _$v = other as _$CounterTripListDtoOutputItemsInnerStopsInner;
  }

  @override
  void update(
      void Function(CounterTripListDtoOutputItemsInnerStopsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterTripListDtoOutputItemsInnerStopsInner build() => _build();

  _$CounterTripListDtoOutputItemsInnerStopsInner _build() {
    final _$result = _$v ??
        _$CounterTripListDtoOutputItemsInnerStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(sequence,
              r'CounterTripListDtoOutputItemsInnerStopsInner', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CounterTripListDtoOutputItemsInnerStopsInner', 'name'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(plannedAt,
              r'CounterTripListDtoOutputItemsInnerStopsInner', 'plannedAt'),
          allowPickup: BuiltValueNullFieldError.checkNotNull(allowPickup,
              r'CounterTripListDtoOutputItemsInnerStopsInner', 'allowPickup'),
          allowDropoff: BuiltValueNullFieldError.checkNotNull(allowDropoff,
              r'CounterTripListDtoOutputItemsInnerStopsInner', 'allowDropoff'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
