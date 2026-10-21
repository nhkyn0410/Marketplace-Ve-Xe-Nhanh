// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_hold_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeatHoldResponseDtoOutput extends SeatHoldResponseDtoOutput {
  @override
  final String holdId;
  @override
  final String tripId;
  @override
  final SeatHoldResponseDtoOutputPickup pickup;
  @override
  final SeatHoldResponseDtoOutputPickup dropoff;
  @override
  final BuiltList<SeatHoldResponseDtoOutputSeatsInner> seats;
  @override
  final int subtotal;
  @override
  final DateTime expiresAt;

  factory _$SeatHoldResponseDtoOutput(
          [void Function(SeatHoldResponseDtoOutputBuilder)? updates]) =>
      (SeatHoldResponseDtoOutputBuilder()..update(updates))._build();

  _$SeatHoldResponseDtoOutput._(
      {required this.holdId,
      required this.tripId,
      required this.pickup,
      required this.dropoff,
      required this.seats,
      required this.subtotal,
      required this.expiresAt})
      : super._();
  @override
  SeatHoldResponseDtoOutput rebuild(
          void Function(SeatHoldResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeatHoldResponseDtoOutputBuilder toBuilder() =>
      SeatHoldResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeatHoldResponseDtoOutput &&
        holdId == other.holdId &&
        tripId == other.tripId &&
        pickup == other.pickup &&
        dropoff == other.dropoff &&
        seats == other.seats &&
        subtotal == other.subtotal &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, holdId.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, dropoff.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SeatHoldResponseDtoOutput')
          ..add('holdId', holdId)
          ..add('tripId', tripId)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('seats', seats)
          ..add('subtotal', subtotal)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class SeatHoldResponseDtoOutputBuilder
    implements
        Builder<SeatHoldResponseDtoOutput, SeatHoldResponseDtoOutputBuilder> {
  _$SeatHoldResponseDtoOutput? _$v;

  String? _holdId;
  String? get holdId => _$this._holdId;
  set holdId(String? holdId) => _$this._holdId = holdId;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  SeatHoldResponseDtoOutputPickupBuilder? _pickup;
  SeatHoldResponseDtoOutputPickupBuilder get pickup =>
      _$this._pickup ??= SeatHoldResponseDtoOutputPickupBuilder();
  set pickup(SeatHoldResponseDtoOutputPickupBuilder? pickup) =>
      _$this._pickup = pickup;

  SeatHoldResponseDtoOutputPickupBuilder? _dropoff;
  SeatHoldResponseDtoOutputPickupBuilder get dropoff =>
      _$this._dropoff ??= SeatHoldResponseDtoOutputPickupBuilder();
  set dropoff(SeatHoldResponseDtoOutputPickupBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  ListBuilder<SeatHoldResponseDtoOutputSeatsInner>? _seats;
  ListBuilder<SeatHoldResponseDtoOutputSeatsInner> get seats =>
      _$this._seats ??= ListBuilder<SeatHoldResponseDtoOutputSeatsInner>();
  set seats(ListBuilder<SeatHoldResponseDtoOutputSeatsInner>? seats) =>
      _$this._seats = seats;

  int? _subtotal;
  int? get subtotal => _$this._subtotal;
  set subtotal(int? subtotal) => _$this._subtotal = subtotal;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  SeatHoldResponseDtoOutputBuilder() {
    SeatHoldResponseDtoOutput._defaults(this);
  }

  SeatHoldResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _holdId = $v.holdId;
      _tripId = $v.tripId;
      _pickup = $v.pickup.toBuilder();
      _dropoff = $v.dropoff.toBuilder();
      _seats = $v.seats.toBuilder();
      _subtotal = $v.subtotal;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeatHoldResponseDtoOutput other) {
    _$v = other as _$SeatHoldResponseDtoOutput;
  }

  @override
  void update(void Function(SeatHoldResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SeatHoldResponseDtoOutput build() => _build();

  _$SeatHoldResponseDtoOutput _build() {
    _$SeatHoldResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$SeatHoldResponseDtoOutput._(
            holdId: BuiltValueNullFieldError.checkNotNull(
                holdId, r'SeatHoldResponseDtoOutput', 'holdId'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'SeatHoldResponseDtoOutput', 'tripId'),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            seats: seats.build(),
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'SeatHoldResponseDtoOutput', 'subtotal'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'SeatHoldResponseDtoOutput', 'expiresAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pickup';
        pickup.build();
        _$failedField = 'dropoff';
        dropoff.build();
        _$failedField = 'seats';
        seats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SeatHoldResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
