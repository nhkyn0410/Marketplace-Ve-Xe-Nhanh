// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_manifest_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripManifestDtoOutput extends TripManifestDtoOutput {
  @override
  final EmployeeAssignmentListDtoOutputItemsInner trip;
  @override
  final BuiltList<TripManifestDtoOutputPassengersInner> passengers;

  factory _$TripManifestDtoOutput(
          [void Function(TripManifestDtoOutputBuilder)? updates]) =>
      (TripManifestDtoOutputBuilder()..update(updates))._build();

  _$TripManifestDtoOutput._({required this.trip, required this.passengers})
      : super._();
  @override
  TripManifestDtoOutput rebuild(
          void Function(TripManifestDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripManifestDtoOutputBuilder toBuilder() =>
      TripManifestDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripManifestDtoOutput &&
        trip == other.trip &&
        passengers == other.passengers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, passengers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripManifestDtoOutput')
          ..add('trip', trip)
          ..add('passengers', passengers))
        .toString();
  }
}

class TripManifestDtoOutputBuilder
    implements Builder<TripManifestDtoOutput, TripManifestDtoOutputBuilder> {
  _$TripManifestDtoOutput? _$v;

  EmployeeAssignmentListDtoOutputItemsInnerBuilder? _trip;
  EmployeeAssignmentListDtoOutputItemsInnerBuilder get trip =>
      _$this._trip ??= EmployeeAssignmentListDtoOutputItemsInnerBuilder();
  set trip(EmployeeAssignmentListDtoOutputItemsInnerBuilder? trip) =>
      _$this._trip = trip;

  ListBuilder<TripManifestDtoOutputPassengersInner>? _passengers;
  ListBuilder<TripManifestDtoOutputPassengersInner> get passengers =>
      _$this._passengers ??=
          ListBuilder<TripManifestDtoOutputPassengersInner>();
  set passengers(
          ListBuilder<TripManifestDtoOutputPassengersInner>? passengers) =>
      _$this._passengers = passengers;

  TripManifestDtoOutputBuilder() {
    TripManifestDtoOutput._defaults(this);
  }

  TripManifestDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trip = $v.trip.toBuilder();
      _passengers = $v.passengers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripManifestDtoOutput other) {
    _$v = other as _$TripManifestDtoOutput;
  }

  @override
  void update(void Function(TripManifestDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripManifestDtoOutput build() => _build();

  _$TripManifestDtoOutput _build() {
    _$TripManifestDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripManifestDtoOutput._(
            trip: trip.build(),
            passengers: passengers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trip';
        trip.build();
        _$failedField = 'passengers';
        passengers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripManifestDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
