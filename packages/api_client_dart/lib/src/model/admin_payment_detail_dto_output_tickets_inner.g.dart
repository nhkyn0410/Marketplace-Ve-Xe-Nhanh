// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_detail_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_VALID =
    const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._('VALID');
const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CANCELLED =
    const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._('CANCELLED');
const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN =
    const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._('CHECKED_IN');
const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW =
    const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._('NO_SHOW');
const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_USED =
    const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._('USED');
const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_REFUNDED =
    const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._('REFUNDED');

AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_VALID;
    case 'CANCELLED':
      return _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW;
    case 'USED':
      return _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_USED;
    case 'REFUNDED':
      return _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentDetailDtoOutputTicketsInnerStatusEnum>
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnumValues = BuiltSet<
        AdminPaymentDetailDtoOutputTicketsInnerStatusEnum>(const <AdminPaymentDetailDtoOutputTicketsInnerStatusEnum>[
  _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_VALID,
  _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CANCELLED,
  _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN,
  _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW,
  _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_USED,
  _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_REFUNDED,
]);

Serializer<AdminPaymentDetailDtoOutputTicketsInnerStatusEnum>
    _$adminPaymentDetailDtoOutputTicketsInnerStatusEnumSerializer =
    _$AdminPaymentDetailDtoOutputTicketsInnerStatusEnumSerializer();

class _$AdminPaymentDetailDtoOutputTicketsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminPaymentDetailDtoOutputTicketsInnerStatusEnum> {
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
    AdminPaymentDetailDtoOutputTicketsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminPaymentDetailDtoOutputTicketsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentDetailDtoOutputTicketsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentDetailDtoOutputTicketsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentDetailDtoOutputTicketsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentDetailDtoOutputTicketsInner
    extends AdminPaymentDetailDtoOutputTicketsInner {
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final AdminPaymentDetailDtoOutputTicketsInnerStatusEnum status;
  @override
  final DateTime issuedAt;

  factory _$AdminPaymentDetailDtoOutputTicketsInner(
          [void Function(AdminPaymentDetailDtoOutputTicketsInnerBuilder)?
              updates]) =>
      (AdminPaymentDetailDtoOutputTicketsInnerBuilder()..update(updates))
          ._build();

  _$AdminPaymentDetailDtoOutputTicketsInner._(
      {required this.ticketCode,
      required this.seatCode,
      required this.status,
      required this.issuedAt})
      : super._();
  @override
  AdminPaymentDetailDtoOutputTicketsInner rebuild(
          void Function(AdminPaymentDetailDtoOutputTicketsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentDetailDtoOutputTicketsInnerBuilder toBuilder() =>
      AdminPaymentDetailDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentDetailDtoOutputTicketsInner &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        status == other.status &&
        issuedAt == other.issuedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPaymentDetailDtoOutputTicketsInner')
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('status', status)
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class AdminPaymentDetailDtoOutputTicketsInnerBuilder
    implements
        Builder<AdminPaymentDetailDtoOutputTicketsInner,
            AdminPaymentDetailDtoOutputTicketsInnerBuilder> {
  _$AdminPaymentDetailDtoOutputTicketsInner? _$v;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  AdminPaymentDetailDtoOutputTicketsInnerStatusEnum? _status;
  AdminPaymentDetailDtoOutputTicketsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminPaymentDetailDtoOutputTicketsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  AdminPaymentDetailDtoOutputTicketsInnerBuilder() {
    AdminPaymentDetailDtoOutputTicketsInner._defaults(this);
  }

  AdminPaymentDetailDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _status = $v.status;
      _issuedAt = $v.issuedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentDetailDtoOutputTicketsInner other) {
    _$v = other as _$AdminPaymentDetailDtoOutputTicketsInner;
  }

  @override
  void update(
      void Function(AdminPaymentDetailDtoOutputTicketsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentDetailDtoOutputTicketsInner build() => _build();

  _$AdminPaymentDetailDtoOutputTicketsInner _build() {
    final _$result = _$v ??
        _$AdminPaymentDetailDtoOutputTicketsInner._(
          ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
              r'AdminPaymentDetailDtoOutputTicketsInner', 'ticketCode'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'AdminPaymentDetailDtoOutputTicketsInner', 'seatCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminPaymentDetailDtoOutputTicketsInner', 'status'),
          issuedAt: BuiltValueNullFieldError.checkNotNull(
              issuedAt, r'AdminPaymentDetailDtoOutputTicketsInner', 'issuedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
