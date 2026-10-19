// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_PENDING_PAYMENT =
    const CreatedBookingDtoOutputStatusEnum._('PENDING_PAYMENT');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_PENDING_CONFIRMATION =
    const CreatedBookingDtoOutputStatusEnum._('PENDING_CONFIRMATION');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_PAID =
    const CreatedBookingDtoOutputStatusEnum._('PAID');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_CONFIRMED =
    const CreatedBookingDtoOutputStatusEnum._('CONFIRMED');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_PARTIALLY_CANCELLED =
    const CreatedBookingDtoOutputStatusEnum._('PARTIALLY_CANCELLED');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_CANCELLED =
    const CreatedBookingDtoOutputStatusEnum._('CANCELLED');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_EXPIRED =
    const CreatedBookingDtoOutputStatusEnum._('EXPIRED');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_REFUND_PENDING =
    const CreatedBookingDtoOutputStatusEnum._('REFUND_PENDING');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_REFUNDED =
    const CreatedBookingDtoOutputStatusEnum._('REFUNDED');
const CreatedBookingDtoOutputStatusEnum
    _$createdBookingDtoOutputStatusEnum_REFUND_FAILED =
    const CreatedBookingDtoOutputStatusEnum._('REFUND_FAILED');

CreatedBookingDtoOutputStatusEnum _$createdBookingDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING_PAYMENT':
      return _$createdBookingDtoOutputStatusEnum_PENDING_PAYMENT;
    case 'PENDING_CONFIRMATION':
      return _$createdBookingDtoOutputStatusEnum_PENDING_CONFIRMATION;
    case 'PAID':
      return _$createdBookingDtoOutputStatusEnum_PAID;
    case 'CONFIRMED':
      return _$createdBookingDtoOutputStatusEnum_CONFIRMED;
    case 'PARTIALLY_CANCELLED':
      return _$createdBookingDtoOutputStatusEnum_PARTIALLY_CANCELLED;
    case 'CANCELLED':
      return _$createdBookingDtoOutputStatusEnum_CANCELLED;
    case 'EXPIRED':
      return _$createdBookingDtoOutputStatusEnum_EXPIRED;
    case 'REFUND_PENDING':
      return _$createdBookingDtoOutputStatusEnum_REFUND_PENDING;
    case 'REFUNDED':
      return _$createdBookingDtoOutputStatusEnum_REFUNDED;
    case 'REFUND_FAILED':
      return _$createdBookingDtoOutputStatusEnum_REFUND_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputStatusEnum>
    _$createdBookingDtoOutputStatusEnumValues = BuiltSet<
        CreatedBookingDtoOutputStatusEnum>(const <CreatedBookingDtoOutputStatusEnum>[
  _$createdBookingDtoOutputStatusEnum_PENDING_PAYMENT,
  _$createdBookingDtoOutputStatusEnum_PENDING_CONFIRMATION,
  _$createdBookingDtoOutputStatusEnum_PAID,
  _$createdBookingDtoOutputStatusEnum_CONFIRMED,
  _$createdBookingDtoOutputStatusEnum_PARTIALLY_CANCELLED,
  _$createdBookingDtoOutputStatusEnum_CANCELLED,
  _$createdBookingDtoOutputStatusEnum_EXPIRED,
  _$createdBookingDtoOutputStatusEnum_REFUND_PENDING,
  _$createdBookingDtoOutputStatusEnum_REFUNDED,
  _$createdBookingDtoOutputStatusEnum_REFUND_FAILED,
]);

Serializer<CreatedBookingDtoOutputStatusEnum>
    _$createdBookingDtoOutputStatusEnumSerializer =
    _$CreatedBookingDtoOutputStatusEnumSerializer();

class _$CreatedBookingDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CreatedBookingDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[CreatedBookingDtoOutputStatusEnum];
  @override
  final String wireName = 'CreatedBookingDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CreatedBookingDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutput extends CreatedBookingDtoOutput {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final CreatedBookingDtoOutputStatusEnum status;
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
  final DateTime createdAt;
  @override
  final String accessToken;

  factory _$CreatedBookingDtoOutput(
          [void Function(CreatedBookingDtoOutputBuilder)? updates]) =>
      (CreatedBookingDtoOutputBuilder()..update(updates))._build();

  _$CreatedBookingDtoOutput._(
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
      required this.createdAt,
      required this.accessToken})
      : super._();
  @override
  CreatedBookingDtoOutput rebuild(
          void Function(CreatedBookingDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputBuilder toBuilder() =>
      CreatedBookingDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutput &&
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
        createdAt == other.createdAt &&
        accessToken == other.accessToken;
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
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatedBookingDtoOutput')
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
          ..add('createdAt', createdAt)
          ..add('accessToken', accessToken))
        .toString();
  }
}

class CreatedBookingDtoOutputBuilder
    implements
        Builder<CreatedBookingDtoOutput, CreatedBookingDtoOutputBuilder> {
  _$CreatedBookingDtoOutput? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  CreatedBookingDtoOutputStatusEnum? _status;
  CreatedBookingDtoOutputStatusEnum? get status => _$this._status;
  set status(CreatedBookingDtoOutputStatusEnum? status) =>
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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  CreatedBookingDtoOutputBuilder() {
    CreatedBookingDtoOutput._defaults(this);
  }

  CreatedBookingDtoOutputBuilder get _$this {
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
      _createdAt = $v.createdAt;
      _accessToken = $v.accessToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutput other) {
    _$v = other as _$CreatedBookingDtoOutput;
  }

  @override
  void update(void Function(CreatedBookingDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutput build() => _build();

  _$CreatedBookingDtoOutput _build() {
    _$CreatedBookingDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CreatedBookingDtoOutput._(
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'CreatedBookingDtoOutput', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(
                bookingCode, r'CreatedBookingDtoOutput', 'bookingCode'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CreatedBookingDtoOutput', 'status'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'CreatedBookingDtoOutput', 'tripId'),
            trip: trip.build(),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            contact: contact.build(),
            passengers: passengers.build(),
            note: note,
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'CreatedBookingDtoOutput', 'subtotal'),
            serviceFee: BuiltValueNullFieldError.checkNotNull(
                serviceFee, r'CreatedBookingDtoOutput', 'serviceFee'),
            discount: BuiltValueNullFieldError.checkNotNull(
                discount, r'CreatedBookingDtoOutput', 'discount'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'CreatedBookingDtoOutput', 'total'),
            cancellationPolicy: cancellationPolicy.build(),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'CreatedBookingDtoOutput', 'expiresAt'),
            payment: _payment?.build(),
            tickets: tickets.build(),
            refunds: refunds.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CreatedBookingDtoOutput', 'createdAt'),
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'CreatedBookingDtoOutput', 'accessToken'),
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
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreatedBookingDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
