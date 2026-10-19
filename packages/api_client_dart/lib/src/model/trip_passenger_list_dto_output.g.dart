// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_passenger_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripPassengerListDtoOutput extends TripPassengerListDtoOutput {
  @override
  final TripPassengerListDtoOutputTrip trip;
  @override
  final TripPassengerListDtoOutputSummary summary;
  @override
  final BuiltList<TripPassengerListDtoOutputPickupsInner> pickups;
  @override
  final BuiltList<TripPassengerListDtoOutputItemsInner> items;

  factory _$TripPassengerListDtoOutput(
          [void Function(TripPassengerListDtoOutputBuilder)? updates]) =>
      (TripPassengerListDtoOutputBuilder()..update(updates))._build();

  _$TripPassengerListDtoOutput._(
      {required this.trip,
      required this.summary,
      required this.pickups,
      required this.items})
      : super._();
  @override
  TripPassengerListDtoOutput rebuild(
          void Function(TripPassengerListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripPassengerListDtoOutputBuilder toBuilder() =>
      TripPassengerListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripPassengerListDtoOutput &&
        trip == other.trip &&
        summary == other.summary &&
        pickups == other.pickups &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, pickups.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripPassengerListDtoOutput')
          ..add('trip', trip)
          ..add('summary', summary)
          ..add('pickups', pickups)
          ..add('items', items))
        .toString();
  }
}

class TripPassengerListDtoOutputBuilder
    implements
        Builder<TripPassengerListDtoOutput, TripPassengerListDtoOutputBuilder> {
  _$TripPassengerListDtoOutput? _$v;

  TripPassengerListDtoOutputTripBuilder? _trip;
  TripPassengerListDtoOutputTripBuilder get trip =>
      _$this._trip ??= TripPassengerListDtoOutputTripBuilder();
  set trip(TripPassengerListDtoOutputTripBuilder? trip) => _$this._trip = trip;

  TripPassengerListDtoOutputSummaryBuilder? _summary;
  TripPassengerListDtoOutputSummaryBuilder get summary =>
      _$this._summary ??= TripPassengerListDtoOutputSummaryBuilder();
  set summary(TripPassengerListDtoOutputSummaryBuilder? summary) =>
      _$this._summary = summary;

  ListBuilder<TripPassengerListDtoOutputPickupsInner>? _pickups;
  ListBuilder<TripPassengerListDtoOutputPickupsInner> get pickups =>
      _$this._pickups ??= ListBuilder<TripPassengerListDtoOutputPickupsInner>();
  set pickups(ListBuilder<TripPassengerListDtoOutputPickupsInner>? pickups) =>
      _$this._pickups = pickups;

  ListBuilder<TripPassengerListDtoOutputItemsInner>? _items;
  ListBuilder<TripPassengerListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<TripPassengerListDtoOutputItemsInner>();
  set items(ListBuilder<TripPassengerListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  TripPassengerListDtoOutputBuilder() {
    TripPassengerListDtoOutput._defaults(this);
  }

  TripPassengerListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trip = $v.trip.toBuilder();
      _summary = $v.summary.toBuilder();
      _pickups = $v.pickups.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripPassengerListDtoOutput other) {
    _$v = other as _$TripPassengerListDtoOutput;
  }

  @override
  void update(void Function(TripPassengerListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripPassengerListDtoOutput build() => _build();

  _$TripPassengerListDtoOutput _build() {
    _$TripPassengerListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripPassengerListDtoOutput._(
            trip: trip.build(),
            summary: summary.build(),
            pickups: pickups.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trip';
        trip.build();
        _$failedField = 'summary';
        summary.build();
        _$failedField = 'pickups';
        pickups.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripPassengerListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
