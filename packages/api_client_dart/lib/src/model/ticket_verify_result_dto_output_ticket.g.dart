// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_verify_result_dto_output_ticket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnum_VALID =
    const TicketVerifyResultDtoOutputTicketStatusEnum._('VALID');
const TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnum_CANCELLED =
    const TicketVerifyResultDtoOutputTicketStatusEnum._('CANCELLED');
const TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnum_CHECKED_IN =
    const TicketVerifyResultDtoOutputTicketStatusEnum._('CHECKED_IN');
const TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnum_NO_SHOW =
    const TicketVerifyResultDtoOutputTicketStatusEnum._('NO_SHOW');
const TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnum_USED =
    const TicketVerifyResultDtoOutputTicketStatusEnum._('USED');
const TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnum_REFUNDED =
    const TicketVerifyResultDtoOutputTicketStatusEnum._('REFUNDED');

TicketVerifyResultDtoOutputTicketStatusEnum
    _$ticketVerifyResultDtoOutputTicketStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$ticketVerifyResultDtoOutputTicketStatusEnum_VALID;
    case 'CANCELLED':
      return _$ticketVerifyResultDtoOutputTicketStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$ticketVerifyResultDtoOutputTicketStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$ticketVerifyResultDtoOutputTicketStatusEnum_NO_SHOW;
    case 'USED':
      return _$ticketVerifyResultDtoOutputTicketStatusEnum_USED;
    case 'REFUNDED':
      return _$ticketVerifyResultDtoOutputTicketStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketVerifyResultDtoOutputTicketStatusEnum>
    _$ticketVerifyResultDtoOutputTicketStatusEnumValues = BuiltSet<
        TicketVerifyResultDtoOutputTicketStatusEnum>(const <TicketVerifyResultDtoOutputTicketStatusEnum>[
  _$ticketVerifyResultDtoOutputTicketStatusEnum_VALID,
  _$ticketVerifyResultDtoOutputTicketStatusEnum_CANCELLED,
  _$ticketVerifyResultDtoOutputTicketStatusEnum_CHECKED_IN,
  _$ticketVerifyResultDtoOutputTicketStatusEnum_NO_SHOW,
  _$ticketVerifyResultDtoOutputTicketStatusEnum_USED,
  _$ticketVerifyResultDtoOutputTicketStatusEnum_REFUNDED,
]);

Serializer<TicketVerifyResultDtoOutputTicketStatusEnum>
    _$ticketVerifyResultDtoOutputTicketStatusEnumSerializer =
    _$TicketVerifyResultDtoOutputTicketStatusEnumSerializer();

class _$TicketVerifyResultDtoOutputTicketStatusEnumSerializer
    implements
        PrimitiveSerializer<TicketVerifyResultDtoOutputTicketStatusEnum> {
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
    TicketVerifyResultDtoOutputTicketStatusEnum
  ];
  @override
  final String wireName = 'TicketVerifyResultDtoOutputTicketStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TicketVerifyResultDtoOutputTicketStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketVerifyResultDtoOutputTicketStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketVerifyResultDtoOutputTicketStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketVerifyResultDtoOutputTicket
    extends TicketVerifyResultDtoOutputTicket {
  @override
  final String ticketId;
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final String passengerName;
  @override
  final String phoneMasked;
  @override
  final TripSalesDtoOutputChangesInnerBeforeStopsInner pickup;
  @override
  final TripSalesDtoOutputChangesInnerBeforeStopsInner dropoff;
  @override
  final TicketVerifyResultDtoOutputTicketStatusEnum status;
  @override
  final DateTime? checkedInAt;

  factory _$TicketVerifyResultDtoOutputTicket(
          [void Function(TicketVerifyResultDtoOutputTicketBuilder)? updates]) =>
      (TicketVerifyResultDtoOutputTicketBuilder()..update(updates))._build();

  _$TicketVerifyResultDtoOutputTicket._(
      {required this.ticketId,
      required this.ticketCode,
      required this.seatCode,
      required this.passengerName,
      required this.phoneMasked,
      required this.pickup,
      required this.dropoff,
      required this.status,
      this.checkedInAt})
      : super._();
  @override
  TicketVerifyResultDtoOutputTicket rebuild(
          void Function(TicketVerifyResultDtoOutputTicketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketVerifyResultDtoOutputTicketBuilder toBuilder() =>
      TicketVerifyResultDtoOutputTicketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketVerifyResultDtoOutputTicket &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        phoneMasked == other.phoneMasked &&
        pickup == other.pickup &&
        dropoff == other.dropoff &&
        status == other.status &&
        checkedInAt == other.checkedInAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, passengerName.hashCode);
    _$hash = $jc(_$hash, phoneMasked.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, dropoff.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, checkedInAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketVerifyResultDtoOutputTicket')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('phoneMasked', phoneMasked)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('status', status)
          ..add('checkedInAt', checkedInAt))
        .toString();
  }
}

class TicketVerifyResultDtoOutputTicketBuilder
    implements
        Builder<TicketVerifyResultDtoOutputTicket,
            TicketVerifyResultDtoOutputTicketBuilder> {
  _$TicketVerifyResultDtoOutputTicket? _$v;

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

  String? _phoneMasked;
  String? get phoneMasked => _$this._phoneMasked;
  set phoneMasked(String? phoneMasked) => _$this._phoneMasked = phoneMasked;

  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder? _pickup;
  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder get pickup =>
      _$this._pickup ??=
          TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder();
  set pickup(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder? pickup) =>
      _$this._pickup = pickup;

  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder? _dropoff;
  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder get dropoff =>
      _$this._dropoff ??=
          TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder();
  set dropoff(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  TicketVerifyResultDtoOutputTicketStatusEnum? _status;
  TicketVerifyResultDtoOutputTicketStatusEnum? get status => _$this._status;
  set status(TicketVerifyResultDtoOutputTicketStatusEnum? status) =>
      _$this._status = status;

  DateTime? _checkedInAt;
  DateTime? get checkedInAt => _$this._checkedInAt;
  set checkedInAt(DateTime? checkedInAt) => _$this._checkedInAt = checkedInAt;

  TicketVerifyResultDtoOutputTicketBuilder() {
    TicketVerifyResultDtoOutputTicket._defaults(this);
  }

  TicketVerifyResultDtoOutputTicketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _phoneMasked = $v.phoneMasked;
      _pickup = $v.pickup.toBuilder();
      _dropoff = $v.dropoff.toBuilder();
      _status = $v.status;
      _checkedInAt = $v.checkedInAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketVerifyResultDtoOutputTicket other) {
    _$v = other as _$TicketVerifyResultDtoOutputTicket;
  }

  @override
  void update(
      void Function(TicketVerifyResultDtoOutputTicketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketVerifyResultDtoOutputTicket build() => _build();

  _$TicketVerifyResultDtoOutputTicket _build() {
    _$TicketVerifyResultDtoOutputTicket _$result;
    try {
      _$result = _$v ??
          _$TicketVerifyResultDtoOutputTicket._(
            ticketId: BuiltValueNullFieldError.checkNotNull(
                ticketId, r'TicketVerifyResultDtoOutputTicket', 'ticketId'),
            ticketCode: BuiltValueNullFieldError.checkNotNull(
                ticketCode, r'TicketVerifyResultDtoOutputTicket', 'ticketCode'),
            seatCode: BuiltValueNullFieldError.checkNotNull(
                seatCode, r'TicketVerifyResultDtoOutputTicket', 'seatCode'),
            passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
                r'TicketVerifyResultDtoOutputTicket', 'passengerName'),
            phoneMasked: BuiltValueNullFieldError.checkNotNull(phoneMasked,
                r'TicketVerifyResultDtoOutputTicket', 'phoneMasked'),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'TicketVerifyResultDtoOutputTicket', 'status'),
            checkedInAt: checkedInAt,
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
            r'TicketVerifyResultDtoOutputTicket', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
