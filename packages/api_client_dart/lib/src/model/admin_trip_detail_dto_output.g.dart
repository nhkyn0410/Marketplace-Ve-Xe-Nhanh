// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_DRAFT =
    const AdminTripDetailDtoOutputStatusEnum._('DRAFT');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_OPEN_FOR_SALE =
    const AdminTripDetailDtoOutputStatusEnum._('OPEN_FOR_SALE');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_SOLD_OUT =
    const AdminTripDetailDtoOutputStatusEnum._('SOLD_OUT');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_LOCKED =
    const AdminTripDetailDtoOutputStatusEnum._('LOCKED');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_BOARDING =
    const AdminTripDetailDtoOutputStatusEnum._('BOARDING');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_DEPARTED =
    const AdminTripDetailDtoOutputStatusEnum._('DEPARTED');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_IN_PROGRESS =
    const AdminTripDetailDtoOutputStatusEnum._('IN_PROGRESS');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_COMPLETED =
    const AdminTripDetailDtoOutputStatusEnum._('COMPLETED');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_CANCELLED =
    const AdminTripDetailDtoOutputStatusEnum._('CANCELLED');
const AdminTripDetailDtoOutputStatusEnum
    _$adminTripDetailDtoOutputStatusEnum_INCIDENT =
    const AdminTripDetailDtoOutputStatusEnum._('INCIDENT');

AdminTripDetailDtoOutputStatusEnum _$adminTripDetailDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$adminTripDetailDtoOutputStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$adminTripDetailDtoOutputStatusEnum_OPEN_FOR_SALE;
    case 'SOLD_OUT':
      return _$adminTripDetailDtoOutputStatusEnum_SOLD_OUT;
    case 'LOCKED':
      return _$adminTripDetailDtoOutputStatusEnum_LOCKED;
    case 'BOARDING':
      return _$adminTripDetailDtoOutputStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$adminTripDetailDtoOutputStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$adminTripDetailDtoOutputStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$adminTripDetailDtoOutputStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$adminTripDetailDtoOutputStatusEnum_CANCELLED;
    case 'INCIDENT':
      return _$adminTripDetailDtoOutputStatusEnum_INCIDENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTripDetailDtoOutputStatusEnum>
    _$adminTripDetailDtoOutputStatusEnumValues = BuiltSet<
        AdminTripDetailDtoOutputStatusEnum>(const <AdminTripDetailDtoOutputStatusEnum>[
  _$adminTripDetailDtoOutputStatusEnum_DRAFT,
  _$adminTripDetailDtoOutputStatusEnum_OPEN_FOR_SALE,
  _$adminTripDetailDtoOutputStatusEnum_SOLD_OUT,
  _$adminTripDetailDtoOutputStatusEnum_LOCKED,
  _$adminTripDetailDtoOutputStatusEnum_BOARDING,
  _$adminTripDetailDtoOutputStatusEnum_DEPARTED,
  _$adminTripDetailDtoOutputStatusEnum_IN_PROGRESS,
  _$adminTripDetailDtoOutputStatusEnum_COMPLETED,
  _$adminTripDetailDtoOutputStatusEnum_CANCELLED,
  _$adminTripDetailDtoOutputStatusEnum_INCIDENT,
]);

Serializer<AdminTripDetailDtoOutputStatusEnum>
    _$adminTripDetailDtoOutputStatusEnumSerializer =
    _$AdminTripDetailDtoOutputStatusEnumSerializer();

class _$AdminTripDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminTripDetailDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminTripDetailDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminTripDetailDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminTripDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminTripDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminTripDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminTripDetailDtoOutput extends AdminTripDetailDtoOutput {
  @override
  final String id;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final AdminTripDetailDtoOutputStatusEnum status;
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
  @override
  final String? statusReason;
  @override
  final DateTime? departedAt;
  @override
  final DateTime? completedAt;
  @override
  final int onlineSaleCutoffMinutes;
  @override
  final String? vehicleTypeName;
  @override
  final BuiltList<AdminTripDetailDtoOutputStopsInner> stops;
  @override
  final AdminTripDetailDtoOutputSeatSummary seatSummary;
  @override
  final BuiltList<AdminTripDetailDtoOutputStaffInner> staff;
  @override
  final int bookingCount;
  @override
  final int? ticketRevenue;
  @override
  final BuiltList<AdminTripDetailDtoOutputManifestInner> manifest;

  factory _$AdminTripDetailDtoOutput(
          [void Function(AdminTripDetailDtoOutputBuilder)? updates]) =>
      (AdminTripDetailDtoOutputBuilder()..update(updates))._build();

  _$AdminTripDetailDtoOutput._(
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
      required this.ticketsSold,
      this.statusReason,
      this.departedAt,
      this.completedAt,
      required this.onlineSaleCutoffMinutes,
      this.vehicleTypeName,
      required this.stops,
      required this.seatSummary,
      required this.staff,
      required this.bookingCount,
      this.ticketRevenue,
      required this.manifest})
      : super._();
  @override
  AdminTripDetailDtoOutput rebuild(
          void Function(AdminTripDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripDetailDtoOutputBuilder toBuilder() =>
      AdminTripDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripDetailDtoOutput &&
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
        ticketsSold == other.ticketsSold &&
        statusReason == other.statusReason &&
        departedAt == other.departedAt &&
        completedAt == other.completedAt &&
        onlineSaleCutoffMinutes == other.onlineSaleCutoffMinutes &&
        vehicleTypeName == other.vehicleTypeName &&
        stops == other.stops &&
        seatSummary == other.seatSummary &&
        staff == other.staff &&
        bookingCount == other.bookingCount &&
        ticketRevenue == other.ticketRevenue &&
        manifest == other.manifest;
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
    _$hash = $jc(_$hash, statusReason.hashCode);
    _$hash = $jc(_$hash, departedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, onlineSaleCutoffMinutes.hashCode);
    _$hash = $jc(_$hash, vehicleTypeName.hashCode);
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jc(_$hash, seatSummary.hashCode);
    _$hash = $jc(_$hash, staff.hashCode);
    _$hash = $jc(_$hash, bookingCount.hashCode);
    _$hash = $jc(_$hash, ticketRevenue.hashCode);
    _$hash = $jc(_$hash, manifest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTripDetailDtoOutput')
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
          ..add('ticketsSold', ticketsSold)
          ..add('statusReason', statusReason)
          ..add('departedAt', departedAt)
          ..add('completedAt', completedAt)
          ..add('onlineSaleCutoffMinutes', onlineSaleCutoffMinutes)
          ..add('vehicleTypeName', vehicleTypeName)
          ..add('stops', stops)
          ..add('seatSummary', seatSummary)
          ..add('staff', staff)
          ..add('bookingCount', bookingCount)
          ..add('ticketRevenue', ticketRevenue)
          ..add('manifest', manifest))
        .toString();
  }
}

class AdminTripDetailDtoOutputBuilder
    implements
        Builder<AdminTripDetailDtoOutput, AdminTripDetailDtoOutputBuilder> {
  _$AdminTripDetailDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  AdminTripDetailDtoOutputStatusEnum? _status;
  AdminTripDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminTripDetailDtoOutputStatusEnum? status) =>
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

  String? _statusReason;
  String? get statusReason => _$this._statusReason;
  set statusReason(String? statusReason) => _$this._statusReason = statusReason;

  DateTime? _departedAt;
  DateTime? get departedAt => _$this._departedAt;
  set departedAt(DateTime? departedAt) => _$this._departedAt = departedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  int? _onlineSaleCutoffMinutes;
  int? get onlineSaleCutoffMinutes => _$this._onlineSaleCutoffMinutes;
  set onlineSaleCutoffMinutes(int? onlineSaleCutoffMinutes) =>
      _$this._onlineSaleCutoffMinutes = onlineSaleCutoffMinutes;

  String? _vehicleTypeName;
  String? get vehicleTypeName => _$this._vehicleTypeName;
  set vehicleTypeName(String? vehicleTypeName) =>
      _$this._vehicleTypeName = vehicleTypeName;

  ListBuilder<AdminTripDetailDtoOutputStopsInner>? _stops;
  ListBuilder<AdminTripDetailDtoOutputStopsInner> get stops =>
      _$this._stops ??= ListBuilder<AdminTripDetailDtoOutputStopsInner>();
  set stops(ListBuilder<AdminTripDetailDtoOutputStopsInner>? stops) =>
      _$this._stops = stops;

  AdminTripDetailDtoOutputSeatSummaryBuilder? _seatSummary;
  AdminTripDetailDtoOutputSeatSummaryBuilder get seatSummary =>
      _$this._seatSummary ??= AdminTripDetailDtoOutputSeatSummaryBuilder();
  set seatSummary(AdminTripDetailDtoOutputSeatSummaryBuilder? seatSummary) =>
      _$this._seatSummary = seatSummary;

  ListBuilder<AdminTripDetailDtoOutputStaffInner>? _staff;
  ListBuilder<AdminTripDetailDtoOutputStaffInner> get staff =>
      _$this._staff ??= ListBuilder<AdminTripDetailDtoOutputStaffInner>();
  set staff(ListBuilder<AdminTripDetailDtoOutputStaffInner>? staff) =>
      _$this._staff = staff;

  int? _bookingCount;
  int? get bookingCount => _$this._bookingCount;
  set bookingCount(int? bookingCount) => _$this._bookingCount = bookingCount;

  int? _ticketRevenue;
  int? get ticketRevenue => _$this._ticketRevenue;
  set ticketRevenue(int? ticketRevenue) =>
      _$this._ticketRevenue = ticketRevenue;

  ListBuilder<AdminTripDetailDtoOutputManifestInner>? _manifest;
  ListBuilder<AdminTripDetailDtoOutputManifestInner> get manifest =>
      _$this._manifest ??= ListBuilder<AdminTripDetailDtoOutputManifestInner>();
  set manifest(ListBuilder<AdminTripDetailDtoOutputManifestInner>? manifest) =>
      _$this._manifest = manifest;

  AdminTripDetailDtoOutputBuilder() {
    AdminTripDetailDtoOutput._defaults(this);
  }

  AdminTripDetailDtoOutputBuilder get _$this {
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
      _statusReason = $v.statusReason;
      _departedAt = $v.departedAt;
      _completedAt = $v.completedAt;
      _onlineSaleCutoffMinutes = $v.onlineSaleCutoffMinutes;
      _vehicleTypeName = $v.vehicleTypeName;
      _stops = $v.stops.toBuilder();
      _seatSummary = $v.seatSummary.toBuilder();
      _staff = $v.staff.toBuilder();
      _bookingCount = $v.bookingCount;
      _ticketRevenue = $v.ticketRevenue;
      _manifest = $v.manifest.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTripDetailDtoOutput other) {
    _$v = other as _$AdminTripDetailDtoOutput;
  }

  @override
  void update(void Function(AdminTripDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripDetailDtoOutput build() => _build();

  _$AdminTripDetailDtoOutput _build() {
    _$AdminTripDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminTripDetailDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminTripDetailDtoOutput', 'id'),
            departureAt: BuiltValueNullFieldError.checkNotNull(
                departureAt, r'AdminTripDetailDtoOutput', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(
                arrivalAt, r'AdminTripDetailDtoOutput', 'arrivalAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminTripDetailDtoOutput', 'status'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'AdminTripDetailDtoOutput', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'AdminTripDetailDtoOutput', 'operatorName'),
            routeId: BuiltValueNullFieldError.checkNotNull(
                routeId, r'AdminTripDetailDtoOutput', 'routeId'),
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'AdminTripDetailDtoOutput', 'routeName'),
            vehiclePlate: vehiclePlate,
            seats: BuiltValueNullFieldError.checkNotNull(
                seats, r'AdminTripDetailDtoOutput', 'seats'),
            ticketsSold: BuiltValueNullFieldError.checkNotNull(
                ticketsSold, r'AdminTripDetailDtoOutput', 'ticketsSold'),
            statusReason: statusReason,
            departedAt: departedAt,
            completedAt: completedAt,
            onlineSaleCutoffMinutes: BuiltValueNullFieldError.checkNotNull(
                onlineSaleCutoffMinutes,
                r'AdminTripDetailDtoOutput',
                'onlineSaleCutoffMinutes'),
            vehicleTypeName: vehicleTypeName,
            stops: stops.build(),
            seatSummary: seatSummary.build(),
            staff: staff.build(),
            bookingCount: BuiltValueNullFieldError.checkNotNull(
                bookingCount, r'AdminTripDetailDtoOutput', 'bookingCount'),
            ticketRevenue: ticketRevenue,
            manifest: manifest.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stops';
        stops.build();
        _$failedField = 'seatSummary';
        seatSummary.build();
        _$failedField = 'staff';
        staff.build();

        _$failedField = 'manifest';
        manifest.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminTripDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
