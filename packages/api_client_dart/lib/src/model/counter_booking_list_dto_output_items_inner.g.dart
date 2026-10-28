// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingListDtoOutputItemsInner
    extends CounterBookingListDtoOutputItemsInner {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String officeId;
  @override
  final String seller;
  @override
  final String status;
  @override
  final String tripId;
  @override
  final CounterBookingDtoOutputTrip trip;
  @override
  final CounterBookingDtoOutputContact contact;
  @override
  final BuiltList<CounterBookingDtoOutputPassengersInner> passengers;
  @override
  final String total;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<CounterBookingDtoOutputTicketsInner> tickets;
  @override
  final BuiltList<CounterBookingDtoOutputReceiptsInner> receipts;

  factory _$CounterBookingListDtoOutputItemsInner(
          [void Function(CounterBookingListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (CounterBookingListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$CounterBookingListDtoOutputItemsInner._(
      {required this.bookingId,
      required this.bookingCode,
      required this.officeId,
      required this.seller,
      required this.status,
      required this.tripId,
      required this.trip,
      required this.contact,
      required this.passengers,
      required this.total,
      required this.expiresAt,
      required this.createdAt,
      required this.tickets,
      required this.receipts})
      : super._();
  @override
  CounterBookingListDtoOutputItemsInner rebuild(
          void Function(CounterBookingListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingListDtoOutputItemsInnerBuilder toBuilder() =>
      CounterBookingListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingListDtoOutputItemsInner &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        officeId == other.officeId &&
        seller == other.seller &&
        status == other.status &&
        tripId == other.tripId &&
        trip == other.trip &&
        contact == other.contact &&
        passengers == other.passengers &&
        total == other.total &&
        expiresAt == other.expiresAt &&
        createdAt == other.createdAt &&
        tickets == other.tickets &&
        receipts == other.receipts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, officeId.hashCode);
    _$hash = $jc(_$hash, seller.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, contact.hashCode);
    _$hash = $jc(_$hash, passengers.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, receipts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterBookingListDtoOutputItemsInner')
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('officeId', officeId)
          ..add('seller', seller)
          ..add('status', status)
          ..add('tripId', tripId)
          ..add('trip', trip)
          ..add('contact', contact)
          ..add('passengers', passengers)
          ..add('total', total)
          ..add('expiresAt', expiresAt)
          ..add('createdAt', createdAt)
          ..add('tickets', tickets)
          ..add('receipts', receipts))
        .toString();
  }
}

class CounterBookingListDtoOutputItemsInnerBuilder
    implements
        Builder<CounterBookingListDtoOutputItemsInner,
            CounterBookingListDtoOutputItemsInnerBuilder> {
  _$CounterBookingListDtoOutputItemsInner? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

  String? _seller;
  String? get seller => _$this._seller;
  set seller(String? seller) => _$this._seller = seller;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  CounterBookingDtoOutputTripBuilder? _trip;
  CounterBookingDtoOutputTripBuilder get trip =>
      _$this._trip ??= CounterBookingDtoOutputTripBuilder();
  set trip(CounterBookingDtoOutputTripBuilder? trip) => _$this._trip = trip;

  CounterBookingDtoOutputContactBuilder? _contact;
  CounterBookingDtoOutputContactBuilder get contact =>
      _$this._contact ??= CounterBookingDtoOutputContactBuilder();
  set contact(CounterBookingDtoOutputContactBuilder? contact) =>
      _$this._contact = contact;

  ListBuilder<CounterBookingDtoOutputPassengersInner>? _passengers;
  ListBuilder<CounterBookingDtoOutputPassengersInner> get passengers =>
      _$this._passengers ??=
          ListBuilder<CounterBookingDtoOutputPassengersInner>();
  set passengers(
          ListBuilder<CounterBookingDtoOutputPassengersInner>? passengers) =>
      _$this._passengers = passengers;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<CounterBookingDtoOutputTicketsInner>? _tickets;
  ListBuilder<CounterBookingDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??= ListBuilder<CounterBookingDtoOutputTicketsInner>();
  set tickets(ListBuilder<CounterBookingDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  ListBuilder<CounterBookingDtoOutputReceiptsInner>? _receipts;
  ListBuilder<CounterBookingDtoOutputReceiptsInner> get receipts =>
      _$this._receipts ??= ListBuilder<CounterBookingDtoOutputReceiptsInner>();
  set receipts(ListBuilder<CounterBookingDtoOutputReceiptsInner>? receipts) =>
      _$this._receipts = receipts;

  CounterBookingListDtoOutputItemsInnerBuilder() {
    CounterBookingListDtoOutputItemsInner._defaults(this);
  }

  CounterBookingListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _officeId = $v.officeId;
      _seller = $v.seller;
      _status = $v.status;
      _tripId = $v.tripId;
      _trip = $v.trip.toBuilder();
      _contact = $v.contact.toBuilder();
      _passengers = $v.passengers.toBuilder();
      _total = $v.total;
      _expiresAt = $v.expiresAt;
      _createdAt = $v.createdAt;
      _tickets = $v.tickets.toBuilder();
      _receipts = $v.receipts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingListDtoOutputItemsInner other) {
    _$v = other as _$CounterBookingListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(CounterBookingListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingListDtoOutputItemsInner build() => _build();

  _$CounterBookingListDtoOutputItemsInner _build() {
    _$CounterBookingListDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$CounterBookingListDtoOutputItemsInner._(
            bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
                r'CounterBookingListDtoOutputItemsInner', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
                r'CounterBookingListDtoOutputItemsInner', 'bookingCode'),
            officeId: BuiltValueNullFieldError.checkNotNull(
                officeId, r'CounterBookingListDtoOutputItemsInner', 'officeId'),
            seller: BuiltValueNullFieldError.checkNotNull(
                seller, r'CounterBookingListDtoOutputItemsInner', 'seller'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CounterBookingListDtoOutputItemsInner', 'status'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'CounterBookingListDtoOutputItemsInner', 'tripId'),
            trip: trip.build(),
            contact: contact.build(),
            passengers: passengers.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'CounterBookingListDtoOutputItemsInner', 'total'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(expiresAt,
                r'CounterBookingListDtoOutputItemsInner', 'expiresAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'CounterBookingListDtoOutputItemsInner', 'createdAt'),
            tickets: tickets.build(),
            receipts: receipts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trip';
        trip.build();
        _$failedField = 'contact';
        contact.build();
        _$failedField = 'passengers';
        passengers.build();

        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'receipts';
        receipts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterBookingListDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
