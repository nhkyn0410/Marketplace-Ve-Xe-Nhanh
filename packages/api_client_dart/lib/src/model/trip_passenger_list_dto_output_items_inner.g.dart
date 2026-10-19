// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_passenger_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_VALID =
    const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._('VALID');
const TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CANCELLED =
    const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._('CANCELLED');
const TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CHECKED_IN =
    const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._('CHECKED_IN');
const TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_NO_SHOW =
    const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._('NO_SHOW');
const TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_USED =
    const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._('USED');
const TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_REFUNDED =
    const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._('REFUNDED');

TripPassengerListDtoOutputItemsInnerTicketStatusEnum
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_VALID;
    case 'CANCELLED':
      return _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_NO_SHOW;
    case 'USED':
      return _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_USED;
    case 'REFUNDED':
      return _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripPassengerListDtoOutputItemsInnerTicketStatusEnum>
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnumValues = BuiltSet<
        TripPassengerListDtoOutputItemsInnerTicketStatusEnum>(const <TripPassengerListDtoOutputItemsInnerTicketStatusEnum>[
  _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_VALID,
  _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CANCELLED,
  _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CHECKED_IN,
  _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_NO_SHOW,
  _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_USED,
  _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_REFUNDED,
]);

Serializer<TripPassengerListDtoOutputItemsInnerTicketStatusEnum>
    _$tripPassengerListDtoOutputItemsInnerTicketStatusEnumSerializer =
    _$TripPassengerListDtoOutputItemsInnerTicketStatusEnumSerializer();

class _$TripPassengerListDtoOutputItemsInnerTicketStatusEnumSerializer
    implements
        PrimitiveSerializer<
            TripPassengerListDtoOutputItemsInnerTicketStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'CANCELLED': 'CANCELLED',
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
    'REFUNDED': 'REFUNDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'CANCELLED': 'CANCELLED',
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
    'REFUNDED': 'REFUNDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripPassengerListDtoOutputItemsInnerTicketStatusEnum
  ];
  @override
  final String wireName =
      'TripPassengerListDtoOutputItemsInnerTicketStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TripPassengerListDtoOutputItemsInnerTicketStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripPassengerListDtoOutputItemsInnerTicketStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripPassengerListDtoOutputItemsInnerTicketStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripPassengerListDtoOutputItemsInner
    extends TripPassengerListDtoOutputItemsInner {
  @override
  final String seatCode;
  @override
  final String passengerName;
  @override
  final String? phoneMasked;
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final bool guest;
  @override
  final TripPassengerListDtoOutputPickupsInner pickup;
  @override
  final TripPassengerListDtoOutputPickupsInner dropoff;
  @override
  final String ticketCode;
  @override
  final TripPassengerListDtoOutputItemsInnerTicketStatusEnum ticketStatus;

  factory _$TripPassengerListDtoOutputItemsInner(
          [void Function(TripPassengerListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (TripPassengerListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$TripPassengerListDtoOutputItemsInner._(
      {required this.seatCode,
      required this.passengerName,
      this.phoneMasked,
      required this.bookingId,
      required this.bookingCode,
      required this.guest,
      required this.pickup,
      required this.dropoff,
      required this.ticketCode,
      required this.ticketStatus})
      : super._();
  @override
  TripPassengerListDtoOutputItemsInner rebuild(
          void Function(TripPassengerListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripPassengerListDtoOutputItemsInnerBuilder toBuilder() =>
      TripPassengerListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripPassengerListDtoOutputItemsInner &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        phoneMasked == other.phoneMasked &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        guest == other.guest &&
        pickup == other.pickup &&
        dropoff == other.dropoff &&
        ticketCode == other.ticketCode &&
        ticketStatus == other.ticketStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, passengerName.hashCode);
    _$hash = $jc(_$hash, phoneMasked.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, guest.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, dropoff.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, ticketStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripPassengerListDtoOutputItemsInner')
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('phoneMasked', phoneMasked)
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('guest', guest)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('ticketCode', ticketCode)
          ..add('ticketStatus', ticketStatus))
        .toString();
  }
}

class TripPassengerListDtoOutputItemsInnerBuilder
    implements
        Builder<TripPassengerListDtoOutputItemsInner,
            TripPassengerListDtoOutputItemsInnerBuilder> {
  _$TripPassengerListDtoOutputItemsInner? _$v;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _passengerName;
  String? get passengerName => _$this._passengerName;
  set passengerName(String? passengerName) =>
      _$this._passengerName = passengerName;

  String? _phoneMasked;
  String? get phoneMasked => _$this._phoneMasked;
  set phoneMasked(String? phoneMasked) => _$this._phoneMasked = phoneMasked;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  bool? _guest;
  bool? get guest => _$this._guest;
  set guest(bool? guest) => _$this._guest = guest;

  TripPassengerListDtoOutputPickupsInnerBuilder? _pickup;
  TripPassengerListDtoOutputPickupsInnerBuilder get pickup =>
      _$this._pickup ??= TripPassengerListDtoOutputPickupsInnerBuilder();
  set pickup(TripPassengerListDtoOutputPickupsInnerBuilder? pickup) =>
      _$this._pickup = pickup;

  TripPassengerListDtoOutputPickupsInnerBuilder? _dropoff;
  TripPassengerListDtoOutputPickupsInnerBuilder get dropoff =>
      _$this._dropoff ??= TripPassengerListDtoOutputPickupsInnerBuilder();
  set dropoff(TripPassengerListDtoOutputPickupsInnerBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  TripPassengerListDtoOutputItemsInnerTicketStatusEnum? _ticketStatus;
  TripPassengerListDtoOutputItemsInnerTicketStatusEnum? get ticketStatus =>
      _$this._ticketStatus;
  set ticketStatus(
          TripPassengerListDtoOutputItemsInnerTicketStatusEnum? ticketStatus) =>
      _$this._ticketStatus = ticketStatus;

  TripPassengerListDtoOutputItemsInnerBuilder() {
    TripPassengerListDtoOutputItemsInner._defaults(this);
  }

  TripPassengerListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _phoneMasked = $v.phoneMasked;
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _guest = $v.guest;
      _pickup = $v.pickup.toBuilder();
      _dropoff = $v.dropoff.toBuilder();
      _ticketCode = $v.ticketCode;
      _ticketStatus = $v.ticketStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripPassengerListDtoOutputItemsInner other) {
    _$v = other as _$TripPassengerListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(TripPassengerListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripPassengerListDtoOutputItemsInner build() => _build();

  _$TripPassengerListDtoOutputItemsInner _build() {
    _$TripPassengerListDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$TripPassengerListDtoOutputItemsInner._(
            seatCode: BuiltValueNullFieldError.checkNotNull(
                seatCode, r'TripPassengerListDtoOutputItemsInner', 'seatCode'),
            passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
                r'TripPassengerListDtoOutputItemsInner', 'passengerName'),
            phoneMasked: phoneMasked,
            bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
                r'TripPassengerListDtoOutputItemsInner', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
                r'TripPassengerListDtoOutputItemsInner', 'bookingCode'),
            guest: BuiltValueNullFieldError.checkNotNull(
                guest, r'TripPassengerListDtoOutputItemsInner', 'guest'),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
                r'TripPassengerListDtoOutputItemsInner', 'ticketCode'),
            ticketStatus: BuiltValueNullFieldError.checkNotNull(ticketStatus,
                r'TripPassengerListDtoOutputItemsInner', 'ticketStatus'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pickup';
        pickup.build();
        _$failedField = 'dropoff';
        dropoff.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripPassengerListDtoOutputItemsInner',
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
