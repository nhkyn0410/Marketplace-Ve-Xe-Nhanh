// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_passenger_list_dto_output_pickups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripPassengerListDtoOutputPickupsInner
    extends TripPassengerListDtoOutputPickupsInner {
  @override
  final int sequence;
  @override
  final String name;

  factory _$TripPassengerListDtoOutputPickupsInner(
          [void Function(TripPassengerListDtoOutputPickupsInnerBuilder)?
              updates]) =>
      (TripPassengerListDtoOutputPickupsInnerBuilder()..update(updates))
          ._build();

  _$TripPassengerListDtoOutputPickupsInner._(
      {required this.sequence, required this.name})
      : super._();
  @override
  TripPassengerListDtoOutputPickupsInner rebuild(
          void Function(TripPassengerListDtoOutputPickupsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripPassengerListDtoOutputPickupsInnerBuilder toBuilder() =>
      TripPassengerListDtoOutputPickupsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripPassengerListDtoOutputPickupsInner &&
        sequence == other.sequence &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripPassengerListDtoOutputPickupsInner')
          ..add('sequence', sequence)
          ..add('name', name))
        .toString();
  }
}

class TripPassengerListDtoOutputPickupsInnerBuilder
    implements
        Builder<TripPassengerListDtoOutputPickupsInner,
            TripPassengerListDtoOutputPickupsInnerBuilder> {
  _$TripPassengerListDtoOutputPickupsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  TripPassengerListDtoOutputPickupsInnerBuilder() {
    TripPassengerListDtoOutputPickupsInner._defaults(this);
  }

  TripPassengerListDtoOutputPickupsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripPassengerListDtoOutputPickupsInner other) {
    _$v = other as _$TripPassengerListDtoOutputPickupsInner;
  }

  @override
  void update(
      void Function(TripPassengerListDtoOutputPickupsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripPassengerListDtoOutputPickupsInner build() => _build();

  _$TripPassengerListDtoOutputPickupsInner _build() {
    final _$result = _$v ??
        _$TripPassengerListDtoOutputPickupsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'TripPassengerListDtoOutputPickupsInner', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripPassengerListDtoOutputPickupsInner', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
