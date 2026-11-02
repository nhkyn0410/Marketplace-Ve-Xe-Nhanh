// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_refund_detail_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_VALID =
    const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._('VALID');
const AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CANCELLED =
    const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._('CANCELLED');
const AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN =
    const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._('CHECKED_IN');
const AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW =
    const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._('NO_SHOW');
const AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_USED =
    const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._('USED');
const AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_REFUNDED =
    const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._('REFUNDED');

AdminRefundDetailDtoOutputTicketsInnerStatusEnum
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_VALID;
    case 'CANCELLED':
      return _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW;
    case 'USED':
      return _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_USED;
    case 'REFUNDED':
      return _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRefundDetailDtoOutputTicketsInnerStatusEnum>
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnumValues = BuiltSet<
        AdminRefundDetailDtoOutputTicketsInnerStatusEnum>(const <AdminRefundDetailDtoOutputTicketsInnerStatusEnum>[
  _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_VALID,
  _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CANCELLED,
  _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN,
  _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW,
  _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_USED,
  _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_REFUNDED,
]);

Serializer<AdminRefundDetailDtoOutputTicketsInnerStatusEnum>
    _$adminRefundDetailDtoOutputTicketsInnerStatusEnumSerializer =
    _$AdminRefundDetailDtoOutputTicketsInnerStatusEnumSerializer();

class _$AdminRefundDetailDtoOutputTicketsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminRefundDetailDtoOutputTicketsInnerStatusEnum> {
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
    AdminRefundDetailDtoOutputTicketsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminRefundDetailDtoOutputTicketsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminRefundDetailDtoOutputTicketsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRefundDetailDtoOutputTicketsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRefundDetailDtoOutputTicketsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRefundDetailDtoOutputTicketsInner
    extends AdminRefundDetailDtoOutputTicketsInner {
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final AdminRefundDetailDtoOutputTicketsInnerStatusEnum status;

  factory _$AdminRefundDetailDtoOutputTicketsInner(
          [void Function(AdminRefundDetailDtoOutputTicketsInnerBuilder)?
              updates]) =>
      (AdminRefundDetailDtoOutputTicketsInnerBuilder()..update(updates))
          ._build();

  _$AdminRefundDetailDtoOutputTicketsInner._(
      {required this.ticketCode, required this.seatCode, required this.status})
      : super._();
  @override
  AdminRefundDetailDtoOutputTicketsInner rebuild(
          void Function(AdminRefundDetailDtoOutputTicketsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRefundDetailDtoOutputTicketsInnerBuilder toBuilder() =>
      AdminRefundDetailDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRefundDetailDtoOutputTicketsInner &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRefundDetailDtoOutputTicketsInner')
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('status', status))
        .toString();
  }
}

class AdminRefundDetailDtoOutputTicketsInnerBuilder
    implements
        Builder<AdminRefundDetailDtoOutputTicketsInner,
            AdminRefundDetailDtoOutputTicketsInnerBuilder> {
  _$AdminRefundDetailDtoOutputTicketsInner? _$v;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  AdminRefundDetailDtoOutputTicketsInnerStatusEnum? _status;
  AdminRefundDetailDtoOutputTicketsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminRefundDetailDtoOutputTicketsInnerStatusEnum? status) =>
      _$this._status = status;

  AdminRefundDetailDtoOutputTicketsInnerBuilder() {
    AdminRefundDetailDtoOutputTicketsInner._defaults(this);
  }

  AdminRefundDetailDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRefundDetailDtoOutputTicketsInner other) {
    _$v = other as _$AdminRefundDetailDtoOutputTicketsInner;
  }

  @override
  void update(
      void Function(AdminRefundDetailDtoOutputTicketsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRefundDetailDtoOutputTicketsInner build() => _build();

  _$AdminRefundDetailDtoOutputTicketsInner _build() {
    final _$result = _$v ??
        _$AdminRefundDetailDtoOutputTicketsInner._(
          ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
              r'AdminRefundDetailDtoOutputTicketsInner', 'ticketCode'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'AdminRefundDetailDtoOutputTicketsInner', 'seatCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminRefundDetailDtoOutputTicketsInner', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
