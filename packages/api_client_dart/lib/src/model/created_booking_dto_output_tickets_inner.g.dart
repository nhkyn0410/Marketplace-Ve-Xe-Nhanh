// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnum_VALID =
    const CreatedBookingDtoOutputTicketsInnerStatusEnum._('VALID');
const CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnum_CANCELLED =
    const CreatedBookingDtoOutputTicketsInnerStatusEnum._('CANCELLED');
const CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnum_CHECKED_IN =
    const CreatedBookingDtoOutputTicketsInnerStatusEnum._('CHECKED_IN');
const CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnum_NO_SHOW =
    const CreatedBookingDtoOutputTicketsInnerStatusEnum._('NO_SHOW');
const CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnum_USED =
    const CreatedBookingDtoOutputTicketsInnerStatusEnum._('USED');
const CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnum_REFUNDED =
    const CreatedBookingDtoOutputTicketsInnerStatusEnum._('REFUNDED');

CreatedBookingDtoOutputTicketsInnerStatusEnum
    _$createdBookingDtoOutputTicketsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$createdBookingDtoOutputTicketsInnerStatusEnum_VALID;
    case 'CANCELLED':
      return _$createdBookingDtoOutputTicketsInnerStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$createdBookingDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$createdBookingDtoOutputTicketsInnerStatusEnum_NO_SHOW;
    case 'USED':
      return _$createdBookingDtoOutputTicketsInnerStatusEnum_USED;
    case 'REFUNDED':
      return _$createdBookingDtoOutputTicketsInnerStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputTicketsInnerStatusEnum>
    _$createdBookingDtoOutputTicketsInnerStatusEnumValues = BuiltSet<
        CreatedBookingDtoOutputTicketsInnerStatusEnum>(const <CreatedBookingDtoOutputTicketsInnerStatusEnum>[
  _$createdBookingDtoOutputTicketsInnerStatusEnum_VALID,
  _$createdBookingDtoOutputTicketsInnerStatusEnum_CANCELLED,
  _$createdBookingDtoOutputTicketsInnerStatusEnum_CHECKED_IN,
  _$createdBookingDtoOutputTicketsInnerStatusEnum_NO_SHOW,
  _$createdBookingDtoOutputTicketsInnerStatusEnum_USED,
  _$createdBookingDtoOutputTicketsInnerStatusEnum_REFUNDED,
]);

Serializer<CreatedBookingDtoOutputTicketsInnerStatusEnum>
    _$createdBookingDtoOutputTicketsInnerStatusEnumSerializer =
    _$CreatedBookingDtoOutputTicketsInnerStatusEnumSerializer();

class _$CreatedBookingDtoOutputTicketsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<CreatedBookingDtoOutputTicketsInnerStatusEnum> {
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
    CreatedBookingDtoOutputTicketsInnerStatusEnum
  ];
  @override
  final String wireName = 'CreatedBookingDtoOutputTicketsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CreatedBookingDtoOutputTicketsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputTicketsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputTicketsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutputTicketsInner
    extends CreatedBookingDtoOutputTicketsInner {
  @override
  final String ticketId;
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final String passengerName;
  @override
  final String? companionName;
  @override
  final CreatedBookingDtoOutputTicketsInnerStatusEnum status;
  @override
  final String qrToken;

  factory _$CreatedBookingDtoOutputTicketsInner(
          [void Function(CreatedBookingDtoOutputTicketsInnerBuilder)?
              updates]) =>
      (CreatedBookingDtoOutputTicketsInnerBuilder()..update(updates))._build();

  _$CreatedBookingDtoOutputTicketsInner._(
      {required this.ticketId,
      required this.ticketCode,
      required this.seatCode,
      required this.passengerName,
      this.companionName,
      required this.status,
      required this.qrToken})
      : super._();
  @override
  CreatedBookingDtoOutputTicketsInner rebuild(
          void Function(CreatedBookingDtoOutputTicketsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputTicketsInnerBuilder toBuilder() =>
      CreatedBookingDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputTicketsInner &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        companionName == other.companionName &&
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
    _$hash = $jc(_$hash, companionName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, qrToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatedBookingDtoOutputTicketsInner')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('companionName', companionName)
          ..add('status', status)
          ..add('qrToken', qrToken))
        .toString();
  }
}

class CreatedBookingDtoOutputTicketsInnerBuilder
    implements
        Builder<CreatedBookingDtoOutputTicketsInner,
            CreatedBookingDtoOutputTicketsInnerBuilder> {
  _$CreatedBookingDtoOutputTicketsInner? _$v;

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

  String? _companionName;
  String? get companionName => _$this._companionName;
  set companionName(String? companionName) =>
      _$this._companionName = companionName;

  CreatedBookingDtoOutputTicketsInnerStatusEnum? _status;
  CreatedBookingDtoOutputTicketsInnerStatusEnum? get status => _$this._status;
  set status(CreatedBookingDtoOutputTicketsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _qrToken;
  String? get qrToken => _$this._qrToken;
  set qrToken(String? qrToken) => _$this._qrToken = qrToken;

  CreatedBookingDtoOutputTicketsInnerBuilder() {
    CreatedBookingDtoOutputTicketsInner._defaults(this);
  }

  CreatedBookingDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _companionName = $v.companionName;
      _status = $v.status;
      _qrToken = $v.qrToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutputTicketsInner other) {
    _$v = other as _$CreatedBookingDtoOutputTicketsInner;
  }

  @override
  void update(
      void Function(CreatedBookingDtoOutputTicketsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputTicketsInner build() => _build();

  _$CreatedBookingDtoOutputTicketsInner _build() {
    final _$result = _$v ??
        _$CreatedBookingDtoOutputTicketsInner._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
              ticketId, r'CreatedBookingDtoOutputTicketsInner', 'ticketId'),
          ticketCode: BuiltValueNullFieldError.checkNotNull(
              ticketCode, r'CreatedBookingDtoOutputTicketsInner', 'ticketCode'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'CreatedBookingDtoOutputTicketsInner', 'seatCode'),
          passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
              r'CreatedBookingDtoOutputTicketsInner', 'passengerName'),
          companionName: companionName,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CreatedBookingDtoOutputTicketsInner', 'status'),
          qrToken: BuiltValueNullFieldError.checkNotNull(
              qrToken, r'CreatedBookingDtoOutputTicketsInner', 'qrToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
