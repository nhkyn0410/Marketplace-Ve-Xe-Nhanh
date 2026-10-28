// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_quote_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_VALID =
    const CancellationQuoteDtoOutputTicketsInnerStatusEnum._('VALID');
const CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CANCELLED =
    const CancellationQuoteDtoOutputTicketsInnerStatusEnum._('CANCELLED');
const CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CHECKED_IN =
    const CancellationQuoteDtoOutputTicketsInnerStatusEnum._('CHECKED_IN');
const CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_NO_SHOW =
    const CancellationQuoteDtoOutputTicketsInnerStatusEnum._('NO_SHOW');
const CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_USED =
    const CancellationQuoteDtoOutputTicketsInnerStatusEnum._('USED');
const CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_REFUNDED =
    const CancellationQuoteDtoOutputTicketsInnerStatusEnum._('REFUNDED');

CancellationQuoteDtoOutputTicketsInnerStatusEnum
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_VALID;
    case 'CANCELLED':
      return _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_NO_SHOW;
    case 'USED':
      return _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_USED;
    case 'REFUNDED':
      return _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationQuoteDtoOutputTicketsInnerStatusEnum>
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnumValues = BuiltSet<
        CancellationQuoteDtoOutputTicketsInnerStatusEnum>(const <CancellationQuoteDtoOutputTicketsInnerStatusEnum>[
  _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_VALID,
  _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CANCELLED,
  _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CHECKED_IN,
  _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_NO_SHOW,
  _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_USED,
  _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_REFUNDED,
]);

Serializer<CancellationQuoteDtoOutputTicketsInnerStatusEnum>
    _$cancellationQuoteDtoOutputTicketsInnerStatusEnumSerializer =
    _$CancellationQuoteDtoOutputTicketsInnerStatusEnumSerializer();

class _$CancellationQuoteDtoOutputTicketsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<CancellationQuoteDtoOutputTicketsInnerStatusEnum> {
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
    CancellationQuoteDtoOutputTicketsInnerStatusEnum
  ];
  @override
  final String wireName = 'CancellationQuoteDtoOutputTicketsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CancellationQuoteDtoOutputTicketsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationQuoteDtoOutputTicketsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationQuoteDtoOutputTicketsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationQuoteDtoOutputTicketsInner
    extends CancellationQuoteDtoOutputTicketsInner {
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
  final CancellationQuoteDtoOutputTicketsInnerStatusEnum status;
  @override
  final int price;
  @override
  final bool cancellable;
  @override
  final String? reason;

  factory _$CancellationQuoteDtoOutputTicketsInner(
          [void Function(CancellationQuoteDtoOutputTicketsInnerBuilder)?
              updates]) =>
      (CancellationQuoteDtoOutputTicketsInnerBuilder()..update(updates))
          ._build();

  _$CancellationQuoteDtoOutputTicketsInner._(
      {required this.ticketId,
      required this.ticketCode,
      required this.seatCode,
      required this.passengerName,
      this.companionName,
      required this.status,
      required this.price,
      required this.cancellable,
      this.reason})
      : super._();
  @override
  CancellationQuoteDtoOutputTicketsInner rebuild(
          void Function(CancellationQuoteDtoOutputTicketsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationQuoteDtoOutputTicketsInnerBuilder toBuilder() =>
      CancellationQuoteDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationQuoteDtoOutputTicketsInner &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        companionName == other.companionName &&
        status == other.status &&
        price == other.price &&
        cancellable == other.cancellable &&
        reason == other.reason;
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
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, cancellable.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CancellationQuoteDtoOutputTicketsInner')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('companionName', companionName)
          ..add('status', status)
          ..add('price', price)
          ..add('cancellable', cancellable)
          ..add('reason', reason))
        .toString();
  }
}

class CancellationQuoteDtoOutputTicketsInnerBuilder
    implements
        Builder<CancellationQuoteDtoOutputTicketsInner,
            CancellationQuoteDtoOutputTicketsInnerBuilder> {
  _$CancellationQuoteDtoOutputTicketsInner? _$v;

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

  CancellationQuoteDtoOutputTicketsInnerStatusEnum? _status;
  CancellationQuoteDtoOutputTicketsInnerStatusEnum? get status =>
      _$this._status;
  set status(CancellationQuoteDtoOutputTicketsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  bool? _cancellable;
  bool? get cancellable => _$this._cancellable;
  set cancellable(bool? cancellable) => _$this._cancellable = cancellable;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CancellationQuoteDtoOutputTicketsInnerBuilder() {
    CancellationQuoteDtoOutputTicketsInner._defaults(this);
  }

  CancellationQuoteDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _companionName = $v.companionName;
      _status = $v.status;
      _price = $v.price;
      _cancellable = $v.cancellable;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationQuoteDtoOutputTicketsInner other) {
    _$v = other as _$CancellationQuoteDtoOutputTicketsInner;
  }

  @override
  void update(
      void Function(CancellationQuoteDtoOutputTicketsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationQuoteDtoOutputTicketsInner build() => _build();

  _$CancellationQuoteDtoOutputTicketsInner _build() {
    final _$result = _$v ??
        _$CancellationQuoteDtoOutputTicketsInner._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
              ticketId, r'CancellationQuoteDtoOutputTicketsInner', 'ticketId'),
          ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
              r'CancellationQuoteDtoOutputTicketsInner', 'ticketCode'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'CancellationQuoteDtoOutputTicketsInner', 'seatCode'),
          passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
              r'CancellationQuoteDtoOutputTicketsInner', 'passengerName'),
          companionName: companionName,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CancellationQuoteDtoOutputTicketsInner', 'status'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'CancellationQuoteDtoOutputTicketsInner', 'price'),
          cancellable: BuiltValueNullFieldError.checkNotNull(cancellable,
              r'CancellationQuoteDtoOutputTicketsInner', 'cancellable'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
