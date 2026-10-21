// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_detail_dto_output_booking.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_PAYMENT =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('PENDING_PAYMENT');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_CONFIRMATION =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._(
        'PENDING_CONFIRMATION');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_PAID =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('PAID');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_CONFIRMED =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('CONFIRMED');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_PARTIALLY_CANCELLED =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('PARTIALLY_CANCELLED');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_CANCELLED =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('CANCELLED');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_EXPIRED =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('EXPIRED');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_PENDING =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('REFUND_PENDING');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUNDED =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('REFUNDED');
const AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_FAILED =
    const AdminPaymentDetailDtoOutputBookingStatusEnum._('REFUND_FAILED');

AdminPaymentDetailDtoOutputBookingStatusEnum
    _$adminPaymentDetailDtoOutputBookingStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING_PAYMENT':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_PAYMENT;
    case 'PENDING_CONFIRMATION':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_CONFIRMATION;
    case 'PAID':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_PAID;
    case 'CONFIRMED':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_CONFIRMED;
    case 'PARTIALLY_CANCELLED':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_PARTIALLY_CANCELLED;
    case 'CANCELLED':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_CANCELLED;
    case 'EXPIRED':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_EXPIRED;
    case 'REFUND_PENDING':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_PENDING;
    case 'REFUNDED':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUNDED;
    case 'REFUND_FAILED':
      return _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentDetailDtoOutputBookingStatusEnum>
    _$adminPaymentDetailDtoOutputBookingStatusEnumValues = BuiltSet<
        AdminPaymentDetailDtoOutputBookingStatusEnum>(const <AdminPaymentDetailDtoOutputBookingStatusEnum>[
  _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_PAYMENT,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_CONFIRMATION,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_PAID,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_CONFIRMED,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_PARTIALLY_CANCELLED,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_CANCELLED,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_EXPIRED,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_PENDING,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUNDED,
  _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_FAILED,
]);

Serializer<AdminPaymentDetailDtoOutputBookingStatusEnum>
    _$adminPaymentDetailDtoOutputBookingStatusEnumSerializer =
    _$AdminPaymentDetailDtoOutputBookingStatusEnumSerializer();

class _$AdminPaymentDetailDtoOutputBookingStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminPaymentDetailDtoOutputBookingStatusEnum> {
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
    AdminPaymentDetailDtoOutputBookingStatusEnum
  ];
  @override
  final String wireName = 'AdminPaymentDetailDtoOutputBookingStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentDetailDtoOutputBookingStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentDetailDtoOutputBookingStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentDetailDtoOutputBookingStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentDetailDtoOutputBooking
    extends AdminPaymentDetailDtoOutputBooking {
  @override
  final AdminPaymentDetailDtoOutputBookingStatusEnum status;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final String contactName;
  @override
  final BuiltList<String> seatCodes;
  @override
  final int subtotal;
  @override
  final int serviceFee;
  @override
  final int discount;
  @override
  final int total;
  @override
  final DateTime createdAt;

  factory _$AdminPaymentDetailDtoOutputBooking(
          [void Function(AdminPaymentDetailDtoOutputBookingBuilder)?
              updates]) =>
      (AdminPaymentDetailDtoOutputBookingBuilder()..update(updates))._build();

  _$AdminPaymentDetailDtoOutputBooking._(
      {required this.status,
      required this.routeName,
      required this.departureAt,
      required this.contactName,
      required this.seatCodes,
      required this.subtotal,
      required this.serviceFee,
      required this.discount,
      required this.total,
      required this.createdAt})
      : super._();
  @override
  AdminPaymentDetailDtoOutputBooking rebuild(
          void Function(AdminPaymentDetailDtoOutputBookingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentDetailDtoOutputBookingBuilder toBuilder() =>
      AdminPaymentDetailDtoOutputBookingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentDetailDtoOutputBooking &&
        status == other.status &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        contactName == other.contactName &&
        seatCodes == other.seatCodes &&
        subtotal == other.subtotal &&
        serviceFee == other.serviceFee &&
        discount == other.discount &&
        total == other.total &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, seatCodes.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, serviceFee.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPaymentDetailDtoOutputBooking')
          ..add('status', status)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('contactName', contactName)
          ..add('seatCodes', seatCodes)
          ..add('subtotal', subtotal)
          ..add('serviceFee', serviceFee)
          ..add('discount', discount)
          ..add('total', total)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminPaymentDetailDtoOutputBookingBuilder
    implements
        Builder<AdminPaymentDetailDtoOutputBooking,
            AdminPaymentDetailDtoOutputBookingBuilder> {
  _$AdminPaymentDetailDtoOutputBooking? _$v;

  AdminPaymentDetailDtoOutputBookingStatusEnum? _status;
  AdminPaymentDetailDtoOutputBookingStatusEnum? get status => _$this._status;
  set status(AdminPaymentDetailDtoOutputBookingStatusEnum? status) =>
      _$this._status = status;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  ListBuilder<String>? _seatCodes;
  ListBuilder<String> get seatCodes =>
      _$this._seatCodes ??= ListBuilder<String>();
  set seatCodes(ListBuilder<String>? seatCodes) =>
      _$this._seatCodes = seatCodes;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminPaymentDetailDtoOutputBookingBuilder() {
    AdminPaymentDetailDtoOutputBooking._defaults(this);
  }

  AdminPaymentDetailDtoOutputBookingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _contactName = $v.contactName;
      _seatCodes = $v.seatCodes.toBuilder();
      _subtotal = $v.subtotal;
      _serviceFee = $v.serviceFee;
      _discount = $v.discount;
      _total = $v.total;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentDetailDtoOutputBooking other) {
    _$v = other as _$AdminPaymentDetailDtoOutputBooking;
  }

  @override
  void update(
      void Function(AdminPaymentDetailDtoOutputBookingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentDetailDtoOutputBooking build() => _build();

  _$AdminPaymentDetailDtoOutputBooking _build() {
    _$AdminPaymentDetailDtoOutputBooking _$result;
    try {
      _$result = _$v ??
          _$AdminPaymentDetailDtoOutputBooking._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminPaymentDetailDtoOutputBooking', 'status'),
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'AdminPaymentDetailDtoOutputBooking', 'routeName'),
            departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
                r'AdminPaymentDetailDtoOutputBooking', 'departureAt'),
            contactName: BuiltValueNullFieldError.checkNotNull(contactName,
                r'AdminPaymentDetailDtoOutputBooking', 'contactName'),
            seatCodes: seatCodes.build(),
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'AdminPaymentDetailDtoOutputBooking', 'subtotal'),
            serviceFee: BuiltValueNullFieldError.checkNotNull(serviceFee,
                r'AdminPaymentDetailDtoOutputBooking', 'serviceFee'),
            discount: BuiltValueNullFieldError.checkNotNull(
                discount, r'AdminPaymentDetailDtoOutputBooking', 'discount'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminPaymentDetailDtoOutputBooking', 'total'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminPaymentDetailDtoOutputBooking', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'seatCodes';
        seatCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPaymentDetailDtoOutputBooking', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
