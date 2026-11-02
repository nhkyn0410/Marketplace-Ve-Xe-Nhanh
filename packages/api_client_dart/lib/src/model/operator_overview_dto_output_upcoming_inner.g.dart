// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_overview_dto_output_upcoming_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DRAFT =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('DRAFT');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_OPEN_FOR_SALE =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('OPEN_FOR_SALE');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_SOLD_OUT =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('SOLD_OUT');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_LOCKED =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('LOCKED');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_BOARDING =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('BOARDING');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DEPARTED =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('DEPARTED');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_IN_PROGRESS =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('IN_PROGRESS');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_COMPLETED =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('COMPLETED');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_CANCELLED =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('CANCELLED');
const OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_INCIDENT =
    const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._('INCIDENT');

OperatorOverviewDtoOutputUpcomingInnerStatusEnum
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_OPEN_FOR_SALE;
    case 'SOLD_OUT':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_SOLD_OUT;
    case 'LOCKED':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_LOCKED;
    case 'BOARDING':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_CANCELLED;
    case 'INCIDENT':
      return _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_INCIDENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorOverviewDtoOutputUpcomingInnerStatusEnum>
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnumValues = BuiltSet<
        OperatorOverviewDtoOutputUpcomingInnerStatusEnum>(const <OperatorOverviewDtoOutputUpcomingInnerStatusEnum>[
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DRAFT,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_OPEN_FOR_SALE,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_SOLD_OUT,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_LOCKED,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_BOARDING,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DEPARTED,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_IN_PROGRESS,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_COMPLETED,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_CANCELLED,
  _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_INCIDENT,
]);

Serializer<OperatorOverviewDtoOutputUpcomingInnerStatusEnum>
    _$operatorOverviewDtoOutputUpcomingInnerStatusEnumSerializer =
    _$OperatorOverviewDtoOutputUpcomingInnerStatusEnumSerializer();

class _$OperatorOverviewDtoOutputUpcomingInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<OperatorOverviewDtoOutputUpcomingInnerStatusEnum> {
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
    OperatorOverviewDtoOutputUpcomingInnerStatusEnum
  ];
  @override
  final String wireName = 'OperatorOverviewDtoOutputUpcomingInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorOverviewDtoOutputUpcomingInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorOverviewDtoOutputUpcomingInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorOverviewDtoOutputUpcomingInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorOverviewDtoOutputUpcomingInner
    extends OperatorOverviewDtoOutputUpcomingInner {
  @override
  final String tripId;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final OperatorOverviewDtoOutputUpcomingInnerStatusEnum status;
  @override
  final String? vehiclePlateNumber;
  @override
  final int ticketsSold;
  @override
  final int seats;
  @override
  final String? driverName;

  factory _$OperatorOverviewDtoOutputUpcomingInner(
          [void Function(OperatorOverviewDtoOutputUpcomingInnerBuilder)?
              updates]) =>
      (OperatorOverviewDtoOutputUpcomingInnerBuilder()..update(updates))
          ._build();

  _$OperatorOverviewDtoOutputUpcomingInner._(
      {required this.tripId,
      required this.routeName,
      required this.departureAt,
      required this.status,
      this.vehiclePlateNumber,
      required this.ticketsSold,
      required this.seats,
      this.driverName})
      : super._();
  @override
  OperatorOverviewDtoOutputUpcomingInner rebuild(
          void Function(OperatorOverviewDtoOutputUpcomingInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorOverviewDtoOutputUpcomingInnerBuilder toBuilder() =>
      OperatorOverviewDtoOutputUpcomingInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorOverviewDtoOutputUpcomingInner &&
        tripId == other.tripId &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        status == other.status &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        ticketsSold == other.ticketsSold &&
        seats == other.seats &&
        driverName == other.driverName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, driverName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorOverviewDtoOutputUpcomingInner')
          ..add('tripId', tripId)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('status', status)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('ticketsSold', ticketsSold)
          ..add('seats', seats)
          ..add('driverName', driverName))
        .toString();
  }
}

class OperatorOverviewDtoOutputUpcomingInnerBuilder
    implements
        Builder<OperatorOverviewDtoOutputUpcomingInner,
            OperatorOverviewDtoOutputUpcomingInnerBuilder> {
  _$OperatorOverviewDtoOutputUpcomingInner? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  OperatorOverviewDtoOutputUpcomingInnerStatusEnum? _status;
  OperatorOverviewDtoOutputUpcomingInnerStatusEnum? get status =>
      _$this._status;
  set status(OperatorOverviewDtoOutputUpcomingInnerStatusEnum? status) =>
      _$this._status = status;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  String? _driverName;
  String? get driverName => _$this._driverName;
  set driverName(String? driverName) => _$this._driverName = driverName;

  OperatorOverviewDtoOutputUpcomingInnerBuilder() {
    OperatorOverviewDtoOutputUpcomingInner._defaults(this);
  }

  OperatorOverviewDtoOutputUpcomingInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _status = $v.status;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _ticketsSold = $v.ticketsSold;
      _seats = $v.seats;
      _driverName = $v.driverName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorOverviewDtoOutputUpcomingInner other) {
    _$v = other as _$OperatorOverviewDtoOutputUpcomingInner;
  }

  @override
  void update(
      void Function(OperatorOverviewDtoOutputUpcomingInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorOverviewDtoOutputUpcomingInner build() => _build();

  _$OperatorOverviewDtoOutputUpcomingInner _build() {
    final _$result = _$v ??
        _$OperatorOverviewDtoOutputUpcomingInner._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'OperatorOverviewDtoOutputUpcomingInner', 'tripId'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'OperatorOverviewDtoOutputUpcomingInner', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'OperatorOverviewDtoOutputUpcomingInner', 'departureAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'OperatorOverviewDtoOutputUpcomingInner', 'status'),
          vehiclePlateNumber: vehiclePlateNumber,
          ticketsSold: BuiltValueNullFieldError.checkNotNull(ticketsSold,
              r'OperatorOverviewDtoOutputUpcomingInner', 'ticketsSold'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'OperatorOverviewDtoOutputUpcomingInner', 'seats'),
          driverName: driverName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
