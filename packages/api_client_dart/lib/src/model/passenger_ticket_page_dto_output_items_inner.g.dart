// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_ticket_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerTicketPageDtoOutputItemsInner
    extends PassengerTicketPageDtoOutputItemsInner {
  @override
  final String ticketId;
  @override
  final String ticketCode;
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String operatorName;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final String seatCode;
  @override
  final String passengerName;
  @override
  final String status;
  @override
  final DateTime issuedAt;

  factory _$PassengerTicketPageDtoOutputItemsInner(
          [void Function(PassengerTicketPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PassengerTicketPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PassengerTicketPageDtoOutputItemsInner._(
      {required this.ticketId,
      required this.ticketCode,
      required this.bookingId,
      required this.bookingCode,
      required this.operatorName,
      required this.routeName,
      required this.departureAt,
      required this.seatCode,
      required this.passengerName,
      required this.status,
      required this.issuedAt})
      : super._();
  @override
  PassengerTicketPageDtoOutputItemsInner rebuild(
          void Function(PassengerTicketPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerTicketPageDtoOutputItemsInnerBuilder toBuilder() =>
      PassengerTicketPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerTicketPageDtoOutputItemsInner &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        operatorName == other.operatorName &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        status == other.status &&
        issuedAt == other.issuedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, passengerName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerTicketPageDtoOutputItemsInner')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('operatorName', operatorName)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('status', status)
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class PassengerTicketPageDtoOutputItemsInnerBuilder
    implements
        Builder<PassengerTicketPageDtoOutputItemsInner,
            PassengerTicketPageDtoOutputItemsInnerBuilder> {
  _$PassengerTicketPageDtoOutputItemsInner? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

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

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  PassengerTicketPageDtoOutputItemsInnerBuilder() {
    PassengerTicketPageDtoOutputItemsInner._defaults(this);
  }

  PassengerTicketPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _operatorName = $v.operatorName;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _status = $v.status;
      _issuedAt = $v.issuedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerTicketPageDtoOutputItemsInner other) {
    _$v = other as _$PassengerTicketPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PassengerTicketPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerTicketPageDtoOutputItemsInner build() => _build();

  _$PassengerTicketPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PassengerTicketPageDtoOutputItemsInner._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
              ticketId, r'PassengerTicketPageDtoOutputItemsInner', 'ticketId'),
          ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
              r'PassengerTicketPageDtoOutputItemsInner', 'ticketCode'),
          bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
              r'PassengerTicketPageDtoOutputItemsInner', 'bookingId'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'PassengerTicketPageDtoOutputItemsInner', 'bookingCode'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'PassengerTicketPageDtoOutputItemsInner', 'operatorName'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'PassengerTicketPageDtoOutputItemsInner', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'PassengerTicketPageDtoOutputItemsInner', 'departureAt'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'PassengerTicketPageDtoOutputItemsInner', 'seatCode'),
          passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
              r'PassengerTicketPageDtoOutputItemsInner', 'passengerName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PassengerTicketPageDtoOutputItemsInner', 'status'),
          issuedAt: BuiltValueNullFieldError.checkNotNull(
              issuedAt, r'PassengerTicketPageDtoOutputItemsInner', 'issuedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
