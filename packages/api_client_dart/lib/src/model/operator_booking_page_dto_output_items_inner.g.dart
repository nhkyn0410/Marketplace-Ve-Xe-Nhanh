// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_booking_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_PAYMENT =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('PENDING_PAYMENT');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_CONFIRMATION =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._(
        'PENDING_CONFIRMATION');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PAID =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('PAID');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CONFIRMED =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('CONFIRMED');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PARTIALLY_CANCELLED =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._(
        'PARTIALLY_CANCELLED');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CANCELLED =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('CANCELLED');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_EXPIRED =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('EXPIRED');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_PENDING =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('REFUND_PENDING');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUNDED =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('REFUNDED');
const OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_FAILED =
    const OperatorBookingPageDtoOutputItemsInnerStatusEnum._('REFUND_FAILED');

OperatorBookingPageDtoOutputItemsInnerStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING_PAYMENT':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_PAYMENT;
    case 'PENDING_CONFIRMATION':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_CONFIRMATION;
    case 'PAID':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PAID;
    case 'CONFIRMED':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CONFIRMED;
    case 'PARTIALLY_CANCELLED':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PARTIALLY_CANCELLED;
    case 'CANCELLED':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CANCELLED;
    case 'EXPIRED':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_EXPIRED;
    case 'REFUND_PENDING':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_PENDING;
    case 'REFUNDED':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUNDED;
    case 'REFUND_FAILED':
      return _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorBookingPageDtoOutputItemsInnerStatusEnum>
    _$operatorBookingPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        OperatorBookingPageDtoOutputItemsInnerStatusEnum>(const <OperatorBookingPageDtoOutputItemsInnerStatusEnum>[
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_PAYMENT,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_CONFIRMATION,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PAID,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CONFIRMED,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PARTIALLY_CANCELLED,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CANCELLED,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_EXPIRED,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_PENDING,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUNDED,
  _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_FAILED,
]);

Serializer<OperatorBookingPageDtoOutputItemsInnerStatusEnum>
    _$operatorBookingPageDtoOutputItemsInnerStatusEnumSerializer =
    _$OperatorBookingPageDtoOutputItemsInnerStatusEnumSerializer();

class _$OperatorBookingPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<OperatorBookingPageDtoOutputItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    OperatorBookingPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'OperatorBookingPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorBookingPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorBookingPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorBookingPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorBookingPageDtoOutputItemsInner
    extends OperatorBookingPageDtoOutputItemsInner {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final OperatorBookingPageDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final String contactName;
  @override
  final String contactPhoneMasked;
  @override
  final bool guest;
  @override
  final OperatorBookingPageDtoOutputItemsInnerTrip trip;
  @override
  final BuiltList<String> seatCodes;
  @override
  final int cancelledTicketCount;
  @override
  final int total;
  @override
  final OperatorBookingPageDtoOutputItemsInnerPayment? payment;

  factory _$OperatorBookingPageDtoOutputItemsInner(
          [void Function(OperatorBookingPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (OperatorBookingPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$OperatorBookingPageDtoOutputItemsInner._(
      {required this.bookingId,
      required this.bookingCode,
      required this.status,
      required this.createdAt,
      required this.contactName,
      required this.contactPhoneMasked,
      required this.guest,
      required this.trip,
      required this.seatCodes,
      required this.cancelledTicketCount,
      required this.total,
      this.payment})
      : super._();
  @override
  OperatorBookingPageDtoOutputItemsInner rebuild(
          void Function(OperatorBookingPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorBookingPageDtoOutputItemsInnerBuilder toBuilder() =>
      OperatorBookingPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorBookingPageDtoOutputItemsInner &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        status == other.status &&
        createdAt == other.createdAt &&
        contactName == other.contactName &&
        contactPhoneMasked == other.contactPhoneMasked &&
        guest == other.guest &&
        trip == other.trip &&
        seatCodes == other.seatCodes &&
        cancelledTicketCount == other.cancelledTicketCount &&
        total == other.total &&
        payment == other.payment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactPhoneMasked.hashCode);
    _$hash = $jc(_$hash, guest.hashCode);
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, seatCodes.hashCode);
    _$hash = $jc(_$hash, cancelledTicketCount.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorBookingPageDtoOutputItemsInner')
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('contactName', contactName)
          ..add('contactPhoneMasked', contactPhoneMasked)
          ..add('guest', guest)
          ..add('trip', trip)
          ..add('seatCodes', seatCodes)
          ..add('cancelledTicketCount', cancelledTicketCount)
          ..add('total', total)
          ..add('payment', payment))
        .toString();
  }
}

class OperatorBookingPageDtoOutputItemsInnerBuilder
    implements
        Builder<OperatorBookingPageDtoOutputItemsInner,
            OperatorBookingPageDtoOutputItemsInnerBuilder> {
  _$OperatorBookingPageDtoOutputItemsInner? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  OperatorBookingPageDtoOutputItemsInnerStatusEnum? _status;
  OperatorBookingPageDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(OperatorBookingPageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _contactPhoneMasked;
  String? get contactPhoneMasked => _$this._contactPhoneMasked;
  set contactPhoneMasked(String? contactPhoneMasked) =>
      _$this._contactPhoneMasked = contactPhoneMasked;

  bool? _guest;
  bool? get guest => _$this._guest;
  set guest(bool? guest) => _$this._guest = guest;

  OperatorBookingPageDtoOutputItemsInnerTripBuilder? _trip;
  OperatorBookingPageDtoOutputItemsInnerTripBuilder get trip =>
      _$this._trip ??= OperatorBookingPageDtoOutputItemsInnerTripBuilder();
  set trip(OperatorBookingPageDtoOutputItemsInnerTripBuilder? trip) =>
      _$this._trip = trip;

  ListBuilder<String>? _seatCodes;
  ListBuilder<String> get seatCodes =>
      _$this._seatCodes ??= ListBuilder<String>();
  set seatCodes(ListBuilder<String>? seatCodes) =>
      _$this._seatCodes = seatCodes;

  int? _cancelledTicketCount;
  int? get cancelledTicketCount => _$this._cancelledTicketCount;
  set cancelledTicketCount(int? cancelledTicketCount) =>
      _$this._cancelledTicketCount = cancelledTicketCount;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  OperatorBookingPageDtoOutputItemsInnerPaymentBuilder? _payment;
  OperatorBookingPageDtoOutputItemsInnerPaymentBuilder get payment =>
      _$this._payment ??=
          OperatorBookingPageDtoOutputItemsInnerPaymentBuilder();
  set payment(OperatorBookingPageDtoOutputItemsInnerPaymentBuilder? payment) =>
      _$this._payment = payment;

  OperatorBookingPageDtoOutputItemsInnerBuilder() {
    OperatorBookingPageDtoOutputItemsInner._defaults(this);
  }

  OperatorBookingPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _contactName = $v.contactName;
      _contactPhoneMasked = $v.contactPhoneMasked;
      _guest = $v.guest;
      _trip = $v.trip.toBuilder();
      _seatCodes = $v.seatCodes.toBuilder();
      _cancelledTicketCount = $v.cancelledTicketCount;
      _total = $v.total;
      _payment = $v.payment?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorBookingPageDtoOutputItemsInner other) {
    _$v = other as _$OperatorBookingPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(OperatorBookingPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorBookingPageDtoOutputItemsInner build() => _build();

  _$OperatorBookingPageDtoOutputItemsInner _build() {
    _$OperatorBookingPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$OperatorBookingPageDtoOutputItemsInner._(
            bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
                r'OperatorBookingPageDtoOutputItemsInner', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
                r'OperatorBookingPageDtoOutputItemsInner', 'bookingCode'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'OperatorBookingPageDtoOutputItemsInner', 'status'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'OperatorBookingPageDtoOutputItemsInner', 'createdAt'),
            contactName: BuiltValueNullFieldError.checkNotNull(contactName,
                r'OperatorBookingPageDtoOutputItemsInner', 'contactName'),
            contactPhoneMasked: BuiltValueNullFieldError.checkNotNull(
                contactPhoneMasked,
                r'OperatorBookingPageDtoOutputItemsInner',
                'contactPhoneMasked'),
            guest: BuiltValueNullFieldError.checkNotNull(
                guest, r'OperatorBookingPageDtoOutputItemsInner', 'guest'),
            trip: trip.build(),
            seatCodes: seatCodes.build(),
            cancelledTicketCount: BuiltValueNullFieldError.checkNotNull(
                cancelledTicketCount,
                r'OperatorBookingPageDtoOutputItemsInner',
                'cancelledTicketCount'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'OperatorBookingPageDtoOutputItemsInner', 'total'),
            payment: _payment?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trip';
        trip.build();
        _$failedField = 'seatCodes';
        seatCodes.build();

        _$failedField = 'payment';
        _payment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OperatorBookingPageDtoOutputItemsInner',
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
