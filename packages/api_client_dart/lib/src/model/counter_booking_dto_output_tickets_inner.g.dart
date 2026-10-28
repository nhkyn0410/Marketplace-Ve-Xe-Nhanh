// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingDtoOutputTicketsInner
    extends CounterBookingDtoOutputTicketsInner {
  @override
  final String ticketId;
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final String passengerName;
  @override
  final String status;
  @override
  final String qrToken;

  factory _$CounterBookingDtoOutputTicketsInner(
          [void Function(CounterBookingDtoOutputTicketsInnerBuilder)?
              updates]) =>
      (CounterBookingDtoOutputTicketsInnerBuilder()..update(updates))._build();

  _$CounterBookingDtoOutputTicketsInner._(
      {required this.ticketId,
      required this.ticketCode,
      required this.seatCode,
      required this.passengerName,
      required this.status,
      required this.qrToken})
      : super._();
  @override
  CounterBookingDtoOutputTicketsInner rebuild(
          void Function(CounterBookingDtoOutputTicketsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingDtoOutputTicketsInnerBuilder toBuilder() =>
      CounterBookingDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingDtoOutputTicketsInner &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        status == other.status &&
        qrToken == other.qrToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, passengerName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, qrToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterBookingDtoOutputTicketsInner')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('status', status)
          ..add('qrToken', qrToken))
        .toString();
  }
}

class CounterBookingDtoOutputTicketsInnerBuilder
    implements
        Builder<CounterBookingDtoOutputTicketsInner,
            CounterBookingDtoOutputTicketsInnerBuilder> {
  _$CounterBookingDtoOutputTicketsInner? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _passengerName;
  String? get passengerName => _$this._passengerName;
  set passengerName(String? passengerName) =>
      _$this._passengerName = passengerName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _qrToken;
  String? get qrToken => _$this._qrToken;
  set qrToken(String? qrToken) => _$this._qrToken = qrToken;

  CounterBookingDtoOutputTicketsInnerBuilder() {
    CounterBookingDtoOutputTicketsInner._defaults(this);
  }

  CounterBookingDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _status = $v.status;
      _qrToken = $v.qrToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingDtoOutputTicketsInner other) {
    _$v = other as _$CounterBookingDtoOutputTicketsInner;
  }

  @override
  void update(
      void Function(CounterBookingDtoOutputTicketsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingDtoOutputTicketsInner build() => _build();

  _$CounterBookingDtoOutputTicketsInner _build() {
    final _$result = _$v ??
        _$CounterBookingDtoOutputTicketsInner._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
              ticketId, r'CounterBookingDtoOutputTicketsInner', 'ticketId'),
          ticketCode: BuiltValueNullFieldError.checkNotNull(
              ticketCode, r'CounterBookingDtoOutputTicketsInner', 'ticketCode'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'CounterBookingDtoOutputTicketsInner', 'seatCode'),
          passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
              r'CounterBookingDtoOutputTicketsInner', 'passengerName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CounterBookingDtoOutputTicketsInner', 'status'),
          qrToken: BuiltValueNullFieldError.checkNotNull(
              qrToken, r'CounterBookingDtoOutputTicketsInner', 'qrToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
