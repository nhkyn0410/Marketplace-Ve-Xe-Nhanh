// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_assignment_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeAssignmentDtoOutputRoleEnum
    _$employeeAssignmentDtoOutputRoleEnum_DRIVER =
    const EmployeeAssignmentDtoOutputRoleEnum._('DRIVER');
const EmployeeAssignmentDtoOutputRoleEnum
    _$employeeAssignmentDtoOutputRoleEnum_TICKET_STAFF =
    const EmployeeAssignmentDtoOutputRoleEnum._('TICKET_STAFF');
const EmployeeAssignmentDtoOutputRoleEnum
    _$employeeAssignmentDtoOutputRoleEnum_SUPPORT_STAFF =
    const EmployeeAssignmentDtoOutputRoleEnum._('SUPPORT_STAFF');

EmployeeAssignmentDtoOutputRoleEnum
    _$employeeAssignmentDtoOutputRoleEnumValueOf(String name) {
  switch (name) {
    case 'DRIVER':
      return _$employeeAssignmentDtoOutputRoleEnum_DRIVER;
    case 'TICKET_STAFF':
      return _$employeeAssignmentDtoOutputRoleEnum_TICKET_STAFF;
    case 'SUPPORT_STAFF':
      return _$employeeAssignmentDtoOutputRoleEnum_SUPPORT_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeAssignmentDtoOutputRoleEnum>
    _$employeeAssignmentDtoOutputRoleEnumValues = BuiltSet<
        EmployeeAssignmentDtoOutputRoleEnum>(const <EmployeeAssignmentDtoOutputRoleEnum>[
  _$employeeAssignmentDtoOutputRoleEnum_DRIVER,
  _$employeeAssignmentDtoOutputRoleEnum_TICKET_STAFF,
  _$employeeAssignmentDtoOutputRoleEnum_SUPPORT_STAFF,
]);

const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_DRAFT =
    const EmployeeAssignmentDtoOutputStatusEnum._('DRAFT');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE =
    const EmployeeAssignmentDtoOutputStatusEnum._('OPEN_FOR_SALE');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_SOLD_OUT =
    const EmployeeAssignmentDtoOutputStatusEnum._('SOLD_OUT');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_LOCKED =
    const EmployeeAssignmentDtoOutputStatusEnum._('LOCKED');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_BOARDING =
    const EmployeeAssignmentDtoOutputStatusEnum._('BOARDING');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_DEPARTED =
    const EmployeeAssignmentDtoOutputStatusEnum._('DEPARTED');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_IN_PROGRESS =
    const EmployeeAssignmentDtoOutputStatusEnum._('IN_PROGRESS');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_COMPLETED =
    const EmployeeAssignmentDtoOutputStatusEnum._('COMPLETED');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_CANCELLED =
    const EmployeeAssignmentDtoOutputStatusEnum._('CANCELLED');
const EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnum_INCIDENT =
    const EmployeeAssignmentDtoOutputStatusEnum._('INCIDENT');

EmployeeAssignmentDtoOutputStatusEnum
    _$employeeAssignmentDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$employeeAssignmentDtoOutputStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$employeeAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE;
    case 'SOLD_OUT':
      return _$employeeAssignmentDtoOutputStatusEnum_SOLD_OUT;
    case 'LOCKED':
      return _$employeeAssignmentDtoOutputStatusEnum_LOCKED;
    case 'BOARDING':
      return _$employeeAssignmentDtoOutputStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$employeeAssignmentDtoOutputStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$employeeAssignmentDtoOutputStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$employeeAssignmentDtoOutputStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$employeeAssignmentDtoOutputStatusEnum_CANCELLED;
    case 'INCIDENT':
      return _$employeeAssignmentDtoOutputStatusEnum_INCIDENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeAssignmentDtoOutputStatusEnum>
    _$employeeAssignmentDtoOutputStatusEnumValues = BuiltSet<
        EmployeeAssignmentDtoOutputStatusEnum>(const <EmployeeAssignmentDtoOutputStatusEnum>[
  _$employeeAssignmentDtoOutputStatusEnum_DRAFT,
  _$employeeAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE,
  _$employeeAssignmentDtoOutputStatusEnum_SOLD_OUT,
  _$employeeAssignmentDtoOutputStatusEnum_LOCKED,
  _$employeeAssignmentDtoOutputStatusEnum_BOARDING,
  _$employeeAssignmentDtoOutputStatusEnum_DEPARTED,
  _$employeeAssignmentDtoOutputStatusEnum_IN_PROGRESS,
  _$employeeAssignmentDtoOutputStatusEnum_COMPLETED,
  _$employeeAssignmentDtoOutputStatusEnum_CANCELLED,
  _$employeeAssignmentDtoOutputStatusEnum_INCIDENT,
]);

Serializer<EmployeeAssignmentDtoOutputRoleEnum>
    _$employeeAssignmentDtoOutputRoleEnumSerializer =
    _$EmployeeAssignmentDtoOutputRoleEnumSerializer();
Serializer<EmployeeAssignmentDtoOutputStatusEnum>
    _$employeeAssignmentDtoOutputStatusEnumSerializer =
    _$EmployeeAssignmentDtoOutputStatusEnumSerializer();

class _$EmployeeAssignmentDtoOutputRoleEnumSerializer
    implements PrimitiveSerializer<EmployeeAssignmentDtoOutputRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRIVER': 'DRIVER',
    'TICKET_STAFF': 'TICKET_STAFF',
    'SUPPORT_STAFF': 'SUPPORT_STAFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRIVER': 'DRIVER',
    'TICKET_STAFF': 'TICKET_STAFF',
    'SUPPORT_STAFF': 'SUPPORT_STAFF',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EmployeeAssignmentDtoOutputRoleEnum
  ];
  @override
  final String wireName = 'EmployeeAssignmentDtoOutputRoleEnum';

  @override
  Object serialize(
          Serializers serializers, EmployeeAssignmentDtoOutputRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EmployeeAssignmentDtoOutputRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EmployeeAssignmentDtoOutputRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EmployeeAssignmentDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<EmployeeAssignmentDtoOutputStatusEnum> {
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
    EmployeeAssignmentDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'EmployeeAssignmentDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, EmployeeAssignmentDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EmployeeAssignmentDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EmployeeAssignmentDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EmployeeAssignmentDtoOutput extends EmployeeAssignmentDtoOutput {
  @override
  final String tripId;
  @override
  final EmployeeAssignmentDtoOutputRoleEnum role;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final EmployeeAssignmentDtoOutputStatusEnum status;
  @override
  final String? vehiclePlateNumber;
  @override
  final String origin;
  @override
  final String destination;
  @override
  final int ticketCount;
  @override
  final int checkedInCount;

  factory _$EmployeeAssignmentDtoOutput(
          [void Function(EmployeeAssignmentDtoOutputBuilder)? updates]) =>
      (EmployeeAssignmentDtoOutputBuilder()..update(updates))._build();

  _$EmployeeAssignmentDtoOutput._(
      {required this.tripId,
      required this.role,
      required this.routeName,
      required this.departureAt,
      required this.arrivalAt,
      required this.status,
      this.vehiclePlateNumber,
      required this.origin,
      required this.destination,
      required this.ticketCount,
      required this.checkedInCount})
      : super._();
  @override
  EmployeeAssignmentDtoOutput rebuild(
          void Function(EmployeeAssignmentDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeAssignmentDtoOutputBuilder toBuilder() =>
      EmployeeAssignmentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeAssignmentDtoOutput &&
        tripId == other.tripId &&
        role == other.role &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        status == other.status &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        origin == other.origin &&
        destination == other.destination &&
        ticketCount == other.ticketCount &&
        checkedInCount == other.checkedInCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, ticketCount.hashCode);
    _$hash = $jc(_$hash, checkedInCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeAssignmentDtoOutput')
          ..add('tripId', tripId)
          ..add('role', role)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('status', status)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('origin', origin)
          ..add('destination', destination)
          ..add('ticketCount', ticketCount)
          ..add('checkedInCount', checkedInCount))
        .toString();
  }
}

class EmployeeAssignmentDtoOutputBuilder
    implements
        Builder<EmployeeAssignmentDtoOutput,
            EmployeeAssignmentDtoOutputBuilder> {
  _$EmployeeAssignmentDtoOutput? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  EmployeeAssignmentDtoOutputRoleEnum? _role;
  EmployeeAssignmentDtoOutputRoleEnum? get role => _$this._role;
  set role(EmployeeAssignmentDtoOutputRoleEnum? role) => _$this._role = role;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  EmployeeAssignmentDtoOutputStatusEnum? _status;
  EmployeeAssignmentDtoOutputStatusEnum? get status => _$this._status;
  set status(EmployeeAssignmentDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  String? _destination;
  String? get destination => _$this._destination;
  set destination(String? destination) => _$this._destination = destination;

  int? _ticketCount;
  int? get ticketCount => _$this._ticketCount;
  set ticketCount(int? ticketCount) => _$this._ticketCount = ticketCount;

  int? _checkedInCount;
  int? get checkedInCount => _$this._checkedInCount;
  set checkedInCount(int? checkedInCount) =>
      _$this._checkedInCount = checkedInCount;

  EmployeeAssignmentDtoOutputBuilder() {
    EmployeeAssignmentDtoOutput._defaults(this);
  }

  EmployeeAssignmentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _role = $v.role;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _status = $v.status;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _origin = $v.origin;
      _destination = $v.destination;
      _ticketCount = $v.ticketCount;
      _checkedInCount = $v.checkedInCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeAssignmentDtoOutput other) {
    _$v = other as _$EmployeeAssignmentDtoOutput;
  }

  @override
  void update(void Function(EmployeeAssignmentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeAssignmentDtoOutput build() => _build();

  _$EmployeeAssignmentDtoOutput _build() {
    final _$result = _$v ??
        _$EmployeeAssignmentDtoOutput._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'EmployeeAssignmentDtoOutput', 'tripId'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'EmployeeAssignmentDtoOutput', 'role'),
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'EmployeeAssignmentDtoOutput', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(
              departureAt, r'EmployeeAssignmentDtoOutput', 'departureAt'),
          arrivalAt: BuiltValueNullFieldError.checkNotNull(
              arrivalAt, r'EmployeeAssignmentDtoOutput', 'arrivalAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'EmployeeAssignmentDtoOutput', 'status'),
          vehiclePlateNumber: vehiclePlateNumber,
          origin: BuiltValueNullFieldError.checkNotNull(
              origin, r'EmployeeAssignmentDtoOutput', 'origin'),
          destination: BuiltValueNullFieldError.checkNotNull(
              destination, r'EmployeeAssignmentDtoOutput', 'destination'),
          ticketCount: BuiltValueNullFieldError.checkNotNull(
              ticketCount, r'EmployeeAssignmentDtoOutput', 'ticketCount'),
          checkedInCount: BuiltValueNullFieldError.checkNotNull(
              checkedInCount, r'EmployeeAssignmentDtoOutput', 'checkedInCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
