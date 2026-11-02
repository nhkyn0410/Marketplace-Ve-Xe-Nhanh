// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_DRAFT =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('DRAFT');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('OPEN_FOR_SALE');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_SOLD_OUT =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('SOLD_OUT');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_LOCKED =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('LOCKED');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_BOARDING =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('BOARDING');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_DEPARTED =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('DEPARTED');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('IN_PROGRESS');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_COMPLETED =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('COMPLETED');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_CANCELLED =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('CANCELLED');
const AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnum_INCIDENT =
    const AdminTripPageDtoOutputItemsInnerStatusEnum._('INCIDENT');

AdminTripPageDtoOutputItemsInnerStatusEnum
    _$adminTripPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
    case 'SOLD_OUT':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_SOLD_OUT;
    case 'LOCKED':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'BOARDING':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_CANCELLED;
    case 'INCIDENT':
      return _$adminTripPageDtoOutputItemsInnerStatusEnum_INCIDENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTripPageDtoOutputItemsInnerStatusEnum>
    _$adminTripPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminTripPageDtoOutputItemsInnerStatusEnum>(const <AdminTripPageDtoOutputItemsInnerStatusEnum>[
  _$adminTripPageDtoOutputItemsInnerStatusEnum_DRAFT,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_SOLD_OUT,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_LOCKED,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_BOARDING,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_DEPARTED,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_COMPLETED,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_CANCELLED,
  _$adminTripPageDtoOutputItemsInnerStatusEnum_INCIDENT,
]);

Serializer<AdminTripPageDtoOutputItemsInnerStatusEnum>
    _$adminTripPageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminTripPageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminTripPageDtoOutputItemsInnerStatusEnumSerializer
    implements PrimitiveSerializer<AdminTripPageDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'OPEN_FOR_SALE': 'OPEN_FOR_SALE',
    'SOLD_OUT': 'SOLD_OUT',
    'LOCKED': 'LOCKED',
    'BOARDING': 'BOARDING',
    'DEPARTED': 'DEPARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
    'CANCELLED': 'CANCELLED',
    'INCIDENT': 'INCIDENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'OPEN_FOR_SALE': 'OPEN_FOR_SALE',
    'SOLD_OUT': 'SOLD_OUT',
    'LOCKED': 'LOCKED',
    'BOARDING': 'BOARDING',
    'DEPARTED': 'DEPARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
    'CANCELLED': 'CANCELLED',
    'INCIDENT': 'INCIDENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTripPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminTripPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminTripPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminTripPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminTripPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminTripPageDtoOutputItemsInner
    extends AdminTripPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final AdminTripPageDtoOutputItemsInnerStatusEnum status;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String routeId;
  @override
  final String routeName;
  @override
  final String? vehiclePlate;
  @override
  final int seats;
  @override
  final int ticketsSold;

  factory _$AdminTripPageDtoOutputItemsInner(
          [void Function(AdminTripPageDtoOutputItemsInnerBuilder)? updates]) =>
      (AdminTripPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminTripPageDtoOutputItemsInner._(
      {required this.id,
      required this.departureAt,
      required this.arrivalAt,
      required this.status,
      required this.operatorId,
      required this.operatorName,
      required this.routeId,
      required this.routeName,
      this.vehiclePlate,
      required this.seats,
      required this.ticketsSold})
      : super._();
  @override
  AdminTripPageDtoOutputItemsInner rebuild(
          void Function(AdminTripPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminTripPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripPageDtoOutputItemsInner &&
        id == other.id &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        status == other.status &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        routeId == other.routeId &&
        routeName == other.routeName &&
        vehiclePlate == other.vehiclePlate &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehiclePlate.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTripPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('status', status)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('routeId', routeId)
          ..add('routeName', routeName)
          ..add('vehiclePlate', vehiclePlate)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold))
        .toString();
  }
}

class AdminTripPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminTripPageDtoOutputItemsInner,
            AdminTripPageDtoOutputItemsInnerBuilder> {
  _$AdminTripPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  AdminTripPageDtoOutputItemsInnerStatusEnum? _status;
  AdminTripPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminTripPageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _vehiclePlate;
  String? get vehiclePlate => _$this._vehiclePlate;
  set vehiclePlate(String? vehiclePlate) => _$this._vehiclePlate = vehiclePlate;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  AdminTripPageDtoOutputItemsInnerBuilder() {
    AdminTripPageDtoOutputItemsInner._defaults(this);
  }

  AdminTripPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _status = $v.status;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _routeId = $v.routeId;
      _routeName = $v.routeName;
      _vehiclePlate = $v.vehiclePlate;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTripPageDtoOutputItemsInner other) {
    _$v = other as _$AdminTripPageDtoOutputItemsInner;
  }

  @override
  void update(void Function(AdminTripPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripPageDtoOutputItemsInner build() => _build();

  _$AdminTripPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminTripPageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminTripPageDtoOutputItemsInner', 'id'),
          departureAt: BuiltValueNullFieldError.checkNotNull(
              departureAt, r'AdminTripPageDtoOutputItemsInner', 'departureAt'),
          arrivalAt: BuiltValueNullFieldError.checkNotNull(
              arrivalAt, r'AdminTripPageDtoOutputItemsInner', 'arrivalAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminTripPageDtoOutputItemsInner', 'status'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'AdminTripPageDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminTripPageDtoOutputItemsInner', 'operatorName'),
          routeId: BuiltValueNullFieldError.checkNotNull(
              routeId, r'AdminTripPageDtoOutputItemsInner', 'routeId'),
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'AdminTripPageDtoOutputItemsInner', 'routeName'),
          vehiclePlate: vehiclePlate,
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminTripPageDtoOutputItemsInner', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'AdminTripPageDtoOutputItemsInner', 'ticketsSold'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
