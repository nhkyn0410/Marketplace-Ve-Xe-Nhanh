// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_hold_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterHoldDtoOutput extends CounterHoldDtoOutput {
  @override
  final String holdId;
  @override
  final String officeId;
  @override
  final String tripId;
  @override
  final CounterHoldDtoOutputPickup pickup;
  @override
  final CounterHoldDtoOutputPickup dropoff;
  @override
  final BuiltList<CounterHoldDtoOutputSeatsInner> seats;
  @override
  final String subtotal;
  @override
  final DateTime expiresAt;

  factory _$CounterHoldDtoOutput(
          [void Function(CounterHoldDtoOutputBuilder)? updates]) =>
      (CounterHoldDtoOutputBuilder()..update(updates))._build();

  _$CounterHoldDtoOutput._(
      {required this.holdId,
      required this.officeId,
      required this.tripId,
      required this.pickup,
      required this.dropoff,
      required this.seats,
      required this.subtotal,
      required this.expiresAt})
      : super._();
  @override
  CounterHoldDtoOutput rebuild(
          void Function(CounterHoldDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterHoldDtoOutputBuilder toBuilder() =>
      CounterHoldDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterHoldDtoOutput &&
        holdId == other.holdId &&
        officeId == other.officeId &&
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
    _$hash = $jc(_$hash, officeId.hashCode);
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
    return (newBuiltValueToStringHelper(r'CounterHoldDtoOutput')
          ..add('holdId', holdId)
          ..add('officeId', officeId)
          ..add('tripId', tripId)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('seats', seats)
          ..add('subtotal', subtotal)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class CounterHoldDtoOutputBuilder
    implements Builder<CounterHoldDtoOutput, CounterHoldDtoOutputBuilder> {
  _$CounterHoldDtoOutput? _$v;

  String? _holdId;
  String? get holdId => _$this._holdId;
  set holdId(String? holdId) => _$this._holdId = holdId;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  CounterHoldDtoOutputPickupBuilder? _pickup;
  CounterHoldDtoOutputPickupBuilder get pickup =>
      _$this._pickup ??= CounterHoldDtoOutputPickupBuilder();
  set pickup(CounterHoldDtoOutputPickupBuilder? pickup) =>
      _$this._pickup = pickup;

  CounterHoldDtoOutputPickupBuilder? _dropoff;
  CounterHoldDtoOutputPickupBuilder get dropoff =>
      _$this._dropoff ??= CounterHoldDtoOutputPickupBuilder();
  set dropoff(CounterHoldDtoOutputPickupBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  ListBuilder<CounterHoldDtoOutputSeatsInner>? _seats;
  ListBuilder<CounterHoldDtoOutputSeatsInner> get seats =>
      _$this._seats ??= ListBuilder<CounterHoldDtoOutputSeatsInner>();
  set seats(ListBuilder<CounterHoldDtoOutputSeatsInner>? seats) =>
      _$this._seats = seats;

  String? _subtotal;
  String? get subtotal => _$this._subtotal;
  set subtotal(String? subtotal) => _$this._subtotal = subtotal;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CounterHoldDtoOutputBuilder() {
    CounterHoldDtoOutput._defaults(this);
  }

  CounterHoldDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _holdId = $v.holdId;
      _officeId = $v.officeId;
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
  void replace(CounterHoldDtoOutput other) {
    _$v = other as _$CounterHoldDtoOutput;
  }

  @override
  void update(void Function(CounterHoldDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterHoldDtoOutput build() => _build();

  _$CounterHoldDtoOutput _build() {
    _$CounterHoldDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CounterHoldDtoOutput._(
            holdId: BuiltValueNullFieldError.checkNotNull(
                holdId, r'CounterHoldDtoOutput', 'holdId'),
            officeId: BuiltValueNullFieldError.checkNotNull(
                officeId, r'CounterHoldDtoOutput', 'officeId'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'CounterHoldDtoOutput', 'tripId'),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            seats: seats.build(),
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'CounterHoldDtoOutput', 'subtotal'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'CounterHoldDtoOutput', 'expiresAt'),
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
            r'CounterHoldDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
