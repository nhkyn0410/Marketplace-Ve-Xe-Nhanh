// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_assignment_page_dto_output_items_inner_conflict.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripAssignmentPageDtoOutputItemsInnerConflict
    extends TripAssignmentPageDtoOutputItemsInnerConflict {
  @override
  final String tripId;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;

  factory _$TripAssignmentPageDtoOutputItemsInnerConflict(
          [void Function(TripAssignmentPageDtoOutputItemsInnerConflictBuilder)?
              updates]) =>
      (TripAssignmentPageDtoOutputItemsInnerConflictBuilder()..update(updates))
          ._build();

  _$TripAssignmentPageDtoOutputItemsInnerConflict._(
      {required this.tripId,
      required this.departureAt,
      required this.arrivalAt})
      : super._();
  @override
  TripAssignmentPageDtoOutputItemsInnerConflict rebuild(
          void Function(TripAssignmentPageDtoOutputItemsInnerConflictBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripAssignmentPageDtoOutputItemsInnerConflictBuilder toBuilder() =>
      TripAssignmentPageDtoOutputItemsInnerConflictBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripAssignmentPageDtoOutputItemsInnerConflict &&
        tripId == other.tripId &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripAssignmentPageDtoOutputItemsInnerConflict')
          ..add('tripId', tripId)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt))
        .toString();
  }
}

class TripAssignmentPageDtoOutputItemsInnerConflictBuilder
    implements
        Builder<TripAssignmentPageDtoOutputItemsInnerConflict,
            TripAssignmentPageDtoOutputItemsInnerConflictBuilder> {
  _$TripAssignmentPageDtoOutputItemsInnerConflict? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  TripAssignmentPageDtoOutputItemsInnerConflictBuilder() {
    TripAssignmentPageDtoOutputItemsInnerConflict._defaults(this);
  }

  TripAssignmentPageDtoOutputItemsInnerConflictBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripAssignmentPageDtoOutputItemsInnerConflict other) {
    _$v = other as _$TripAssignmentPageDtoOutputItemsInnerConflict;
  }

  @override
  void update(
      void Function(TripAssignmentPageDtoOutputItemsInnerConflictBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripAssignmentPageDtoOutputItemsInnerConflict build() => _build();

  _$TripAssignmentPageDtoOutputItemsInnerConflict _build() {
    final _$result = _$v ??
        _$TripAssignmentPageDtoOutputItemsInnerConflict._(
          tripId: BuiltValueNullFieldError.checkNotNull(tripId,
              r'TripAssignmentPageDtoOutputItemsInnerConflict', 'tripId'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'TripAssignmentPageDtoOutputItemsInnerConflict', 'departureAt'),
          arrivalAt: BuiltValueNullFieldError.checkNotNull(arrivalAt,
              r'TripAssignmentPageDtoOutputItemsInnerConflict', 'arrivalAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
