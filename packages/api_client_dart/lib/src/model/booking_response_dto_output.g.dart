// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_PENDING_PAYMENT =
    const BookingResponseDtoOutputStatusEnum._('PENDING_PAYMENT');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_PENDING_CONFIRMATION =
    const BookingResponseDtoOutputStatusEnum._('PENDING_CONFIRMATION');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_PAID =
    const BookingResponseDtoOutputStatusEnum._('PAID');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_CONFIRMED =
    const BookingResponseDtoOutputStatusEnum._('CONFIRMED');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_PARTIALLY_CANCELLED =
    const BookingResponseDtoOutputStatusEnum._('PARTIALLY_CANCELLED');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_CANCELLED =
    const BookingResponseDtoOutputStatusEnum._('CANCELLED');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_EXPIRED =
    const BookingResponseDtoOutputStatusEnum._('EXPIRED');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_REFUND_PENDING =
    const BookingResponseDtoOutputStatusEnum._('REFUND_PENDING');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_REFUNDED =
    const BookingResponseDtoOutputStatusEnum._('REFUNDED');
const BookingResponseDtoOutputStatusEnum
    _$bookingResponseDtoOutputStatusEnum_REFUND_FAILED =
    const BookingResponseDtoOutputStatusEnum._('REFUND_FAILED');

BookingResponseDtoOutputStatusEnum _$bookingResponseDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING_PAYMENT':
      return _$bookingResponseDtoOutputStatusEnum_PENDING_PAYMENT;
    case 'PENDING_CONFIRMATION':
      return _$bookingResponseDtoOutputStatusEnum_PENDING_CONFIRMATION;
    case 'PAID':
      return _$bookingResponseDtoOutputStatusEnum_PAID;
    case 'CONFIRMED':
      return _$bookingResponseDtoOutputStatusEnum_CONFIRMED;
    case 'PARTIALLY_CANCELLED':
      return _$bookingResponseDtoOutputStatusEnum_PARTIALLY_CANCELLED;
    case 'CANCELLED':
      return _$bookingResponseDtoOutputStatusEnum_CANCELLED;
    case 'EXPIRED':
      return _$bookingResponseDtoOutputStatusEnum_EXPIRED;
    case 'REFUND_PENDING':
      return _$bookingResponseDtoOutputStatusEnum_REFUND_PENDING;
    case 'REFUNDED':
      return _$bookingResponseDtoOutputStatusEnum_REFUNDED;
    case 'REFUND_FAILED':
      return _$bookingResponseDtoOutputStatusEnum_REFUND_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingResponseDtoOutputStatusEnum>
    _$bookingResponseDtoOutputStatusEnumValues = BuiltSet<
        BookingResponseDtoOutputStatusEnum>(const <BookingResponseDtoOutputStatusEnum>[
  _$bookingResponseDtoOutputStatusEnum_PENDING_PAYMENT,
  _$bookingResponseDtoOutputStatusEnum_PENDING_CONFIRMATION,
  _$bookingResponseDtoOutputStatusEnum_PAID,
  _$bookingResponseDtoOutputStatusEnum_CONFIRMED,
  _$bookingResponseDtoOutputStatusEnum_PARTIALLY_CANCELLED,
  _$bookingResponseDtoOutputStatusEnum_CANCELLED,
  _$bookingResponseDtoOutputStatusEnum_EXPIRED,
  _$bookingResponseDtoOutputStatusEnum_REFUND_PENDING,
  _$bookingResponseDtoOutputStatusEnum_REFUNDED,
  _$bookingResponseDtoOutputStatusEnum_REFUND_FAILED,
]);

Serializer<BookingResponseDtoOutputStatusEnum>
    _$bookingResponseDtoOutputStatusEnumSerializer =
    _$BookingResponseDtoOutputStatusEnumSerializer();

class _$BookingResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<BookingResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_PAYMENT': 'PENDING_PAYMENT',
    'PENDING_CONFIRMATION': 'PENDING_CONFIRMATION',
    'PAID': 'PAID',
    'CONFIRMED': 'CONFIRMED',
    'PARTIALLY_CANCELLED': 'PARTIALLY_CANCELLED',
    'CANCELLED': 'CANCELLED',
    'EXPIRED': 'EXPIRED',
    'REFUND_PENDING': 'REFUND_PENDING',
    'REFUNDED': 'REFUNDED',
    'REFUND_FAILED': 'REFUND_FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_PAYMENT': 'PENDING_PAYMENT',
    'PENDING_CONFIRMATION': 'PENDING_CONFIRMATION',
    'PAID': 'PAID',
    'CONFIRMED': 'CONFIRMED',
    'PARTIALLY_CANCELLED': 'PARTIALLY_CANCELLED',
    'CANCELLED': 'CANCELLED',
    'EXPIRED': 'EXPIRED',
    'REFUND_PENDING': 'REFUND_PENDING',
    'REFUNDED': 'REFUNDED',
    'REFUND_FAILED': 'REFUND_FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[BookingResponseDtoOutputStatusEnum];
  @override
  final String wireName = 'BookingResponseDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, BookingResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingResponseDtoOutput extends BookingResponseDtoOutput {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final BookingResponseDtoOutputStatusEnum status;
  @override
  final String tripId;
  @override
  final CreatedBookingDtoOutputTrip trip;
  @override
  final TripSearchResponseDtoOutputItemsInnerPickup pickup;
  @override
  final TripSearchResponseDtoOutputItemsInnerPickup dropoff;
  @override
  final CreatedBookingDtoOutputContact contact;
  @override
  final BuiltList<CreatedBookingDtoOutputPassengersInner> passengers;
  @override
  final String? note;
  @override
  final int subtotal;
  @override
  final int serviceFee;
  @override
  final int discount;
  @override
  final int total;
  @override
  final PublicTripDtoOutputCancellationPolicy cancellationPolicy;
  @override
  final DateTime expiresAt;
  @override
  final CreatedBookingDtoOutputPayment? payment;
  @override
  final BuiltList<CreatedBookingDtoOutputTicketsInner> tickets;
  @override
  final BuiltList<CreatedBookingDtoOutputRefundsInner> refunds;
  @override
  final BuiltList<CreatedBookingDtoOutputTripChangesInner> tripChanges;
  @override
  final DateTime createdAt;

  factory _$BookingResponseDtoOutput(
          [void Function(BookingResponseDtoOutputBuilder)? updates]) =>
      (BookingResponseDtoOutputBuilder()..update(updates))._build();

  _$BookingResponseDtoOutput._(
      {required this.bookingId,
      required this.bookingCode,
      required this.status,
      required this.tripId,
      required this.trip,
      required this.pickup,
      required this.dropoff,
      required this.contact,
      required this.passengers,
      this.note,
      required this.subtotal,
      required this.serviceFee,
      required this.discount,
      required this.total,
      required this.cancellationPolicy,
      required this.expiresAt,
      this.payment,
      required this.tickets,
      required this.refunds,
      required this.tripChanges,
      required this.createdAt})
      : super._();
  @override
  BookingResponseDtoOutput rebuild(
          void Function(BookingResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingResponseDtoOutputBuilder toBuilder() =>
      BookingResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingResponseDtoOutput &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        status == other.status &&
        tripId == other.tripId &&
        trip == other.trip &&
        pickup == other.pickup &&
        dropoff == other.dropoff &&
        contact == other.contact &&
        passengers == other.passengers &&
        note == other.note &&
        subtotal == other.subtotal &&
        serviceFee == other.serviceFee &&
        discount == other.discount &&
        total == other.total &&
        cancellationPolicy == other.cancellationPolicy &&
        expiresAt == other.expiresAt &&
        payment == other.payment &&
        tickets == other.tickets &&
        refunds == other.refunds &&
        tripChanges == other.tripChanges &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, dropoff.hashCode);
    _$hash = $jc(_$hash, contact.hashCode);
    _$hash = $jc(_$hash, passengers.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, serviceFee.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, cancellationPolicy.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, refunds.hashCode);
    _$hash = $jc(_$hash, tripChanges.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingResponseDtoOutput')
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('status', status)
          ..add('tripId', tripId)
          ..add('trip', trip)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('contact', contact)
          ..add('passengers', passengers)
          ..add('note', note)
          ..add('subtotal', subtotal)
          ..add('serviceFee', serviceFee)
          ..add('discount', discount)
          ..add('total', total)
          ..add('cancellationPolicy', cancellationPolicy)
          ..add('expiresAt', expiresAt)
          ..add('payment', payment)
          ..add('tickets', tickets)
          ..add('refunds', refunds)
          ..add('tripChanges', tripChanges)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class BookingResponseDtoOutputBuilder
    implements
        Builder<BookingResponseDtoOutput, BookingResponseDtoOutputBuilder> {
  _$BookingResponseDtoOutput? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  BookingResponseDtoOutputStatusEnum? _status;
  BookingResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(BookingResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  CreatedBookingDtoOutputTripBuilder? _trip;
  CreatedBookingDtoOutputTripBuilder get trip =>
      _$this._trip ??= CreatedBookingDtoOutputTripBuilder();
  set trip(CreatedBookingDtoOutputTripBuilder? trip) => _$this._trip = trip;

  TripSearchResponseDtoOutputItemsInnerPickupBuilder? _pickup;
  TripSearchResponseDtoOutputItemsInnerPickupBuilder get pickup =>
      _$this._pickup ??= TripSearchResponseDtoOutputItemsInnerPickupBuilder();
  set pickup(TripSearchResponseDtoOutputItemsInnerPickupBuilder? pickup) =>
      _$this._pickup = pickup;

  TripSearchResponseDtoOutputItemsInnerPickupBuilder? _dropoff;
  TripSearchResponseDtoOutputItemsInnerPickupBuilder get dropoff =>
      _$this._dropoff ??= TripSearchResponseDtoOutputItemsInnerPickupBuilder();
  set dropoff(TripSearchResponseDtoOutputItemsInnerPickupBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  CreatedBookingDtoOutputContactBuilder? _contact;
  CreatedBookingDtoOutputContactBuilder get contact =>
      _$this._contact ??= CreatedBookingDtoOutputContactBuilder();
  set contact(CreatedBookingDtoOutputContactBuilder? contact) =>
      _$this._contact = contact;

  ListBuilder<CreatedBookingDtoOutputPassengersInner>? _passengers;
  ListBuilder<CreatedBookingDtoOutputPassengersInner> get passengers =>
      _$this._passengers ??=
          ListBuilder<CreatedBookingDtoOutputPassengersInner>();
  set passengers(
          ListBuilder<CreatedBookingDtoOutputPassengersInner>? passengers) =>
      _$this._passengers = passengers;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _subtotal;
  int? get subtotal => _$this._subtotal;
  set subtotal(int? subtotal) => _$this._subtotal = subtotal;

  int? _serviceFee;
  int? get serviceFee => _$this._serviceFee;
  set serviceFee(int? serviceFee) => _$this._serviceFee = serviceFee;

  int? _discount;
  int? get discount => _$this._discount;
  set discount(int? discount) => _$this._discount = discount;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PublicTripDtoOutputCancellationPolicyBuilder? _cancellationPolicy;
  PublicTripDtoOutputCancellationPolicyBuilder get cancellationPolicy =>
      _$this._cancellationPolicy ??=
          PublicTripDtoOutputCancellationPolicyBuilder();
  set cancellationPolicy(
          PublicTripDtoOutputCancellationPolicyBuilder? cancellationPolicy) =>
      _$this._cancellationPolicy = cancellationPolicy;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CreatedBookingDtoOutputPaymentBuilder? _payment;
  CreatedBookingDtoOutputPaymentBuilder get payment =>
      _$this._payment ??= CreatedBookingDtoOutputPaymentBuilder();
  set payment(CreatedBookingDtoOutputPaymentBuilder? payment) =>
      _$this._payment = payment;

  ListBuilder<CreatedBookingDtoOutputTicketsInner>? _tickets;
  ListBuilder<CreatedBookingDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??= ListBuilder<CreatedBookingDtoOutputTicketsInner>();
  set tickets(ListBuilder<CreatedBookingDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  ListBuilder<CreatedBookingDtoOutputRefundsInner>? _refunds;
  ListBuilder<CreatedBookingDtoOutputRefundsInner> get refunds =>
      _$this._refunds ??= ListBuilder<CreatedBookingDtoOutputRefundsInner>();
  set refunds(ListBuilder<CreatedBookingDtoOutputRefundsInner>? refunds) =>
      _$this._refunds = refunds;

  ListBuilder<CreatedBookingDtoOutputTripChangesInner>? _tripChanges;
  ListBuilder<CreatedBookingDtoOutputTripChangesInner> get tripChanges =>
      _$this._tripChanges ??=
          ListBuilder<CreatedBookingDtoOutputTripChangesInner>();
  set tripChanges(
          ListBuilder<CreatedBookingDtoOutputTripChangesInner>? tripChanges) =>
      _$this._tripChanges = tripChanges;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  BookingResponseDtoOutputBuilder() {
    BookingResponseDtoOutput._defaults(this);
  }

  BookingResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _status = $v.status;
      _tripId = $v.tripId;
      _trip = $v.trip.toBuilder();
      _pickup = $v.pickup.toBuilder();
      _dropoff = $v.dropoff.toBuilder();
      _contact = $v.contact.toBuilder();
      _passengers = $v.passengers.toBuilder();
      _note = $v.note;
      _subtotal = $v.subtotal;
      _serviceFee = $v.serviceFee;
      _discount = $v.discount;
      _total = $v.total;
      _cancellationPolicy = $v.cancellationPolicy.toBuilder();
      _expiresAt = $v.expiresAt;
      _payment = $v.payment?.toBuilder();
      _tickets = $v.tickets.toBuilder();
      _refunds = $v.refunds.toBuilder();
      _tripChanges = $v.tripChanges.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingResponseDtoOutput other) {
    _$v = other as _$BookingResponseDtoOutput;
  }

  @override
  void update(void Function(BookingResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingResponseDtoOutput build() => _build();

  _$BookingResponseDtoOutput _build() {
    _$BookingResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$BookingResponseDtoOutput._(
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'BookingResponseDtoOutput', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(
                bookingCode, r'BookingResponseDtoOutput', 'bookingCode'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'BookingResponseDtoOutput', 'status'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'BookingResponseDtoOutput', 'tripId'),
            trip: trip.build(),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            contact: contact.build(),
            passengers: passengers.build(),
            note: note,
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'BookingResponseDtoOutput', 'subtotal'),
            serviceFee: BuiltValueNullFieldError.checkNotNull(
                serviceFee, r'BookingResponseDtoOutput', 'serviceFee'),
            discount: BuiltValueNullFieldError.checkNotNull(
                discount, r'BookingResponseDtoOutput', 'discount'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'BookingResponseDtoOutput', 'total'),
            cancellationPolicy: cancellationPolicy.build(),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'BookingResponseDtoOutput', 'expiresAt'),
            payment: _payment?.build(),
            tickets: tickets.build(),
            refunds: refunds.build(),
            tripChanges: tripChanges.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'BookingResponseDtoOutput', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trip';
        trip.build();
        _$failedField = 'pickup';
        pickup.build();
        _$failedField = 'dropoff';
        dropoff.build();
        _$failedField = 'contact';
        contact.build();
        _$failedField = 'passengers';
        passengers.build();

        _$failedField = 'cancellationPolicy';
        cancellationPolicy.build();

        _$failedField = 'payment';
        _payment?.build();
        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'refunds';
        refunds.build();
        _$failedField = 'tripChanges';
        tripChanges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BookingResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
