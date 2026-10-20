// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_report_dto_output_employees_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperatorReportDtoOutputEmployeesInnerRoleEnum
    _$operatorReportDtoOutputEmployeesInnerRoleEnum_DRIVER =
    const OperatorReportDtoOutputEmployeesInnerRoleEnum._('DRIVER');
const OperatorReportDtoOutputEmployeesInnerRoleEnum
    _$operatorReportDtoOutputEmployeesInnerRoleEnum_TICKET_STAFF =
    const OperatorReportDtoOutputEmployeesInnerRoleEnum._('TICKET_STAFF');
const OperatorReportDtoOutputEmployeesInnerRoleEnum
    _$operatorReportDtoOutputEmployeesInnerRoleEnum_SUPPORT_STAFF =
    const OperatorReportDtoOutputEmployeesInnerRoleEnum._('SUPPORT_STAFF');

OperatorReportDtoOutputEmployeesInnerRoleEnum
    _$operatorReportDtoOutputEmployeesInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'DRIVER':
      return _$operatorReportDtoOutputEmployeesInnerRoleEnum_DRIVER;
    case 'TICKET_STAFF':
      return _$operatorReportDtoOutputEmployeesInnerRoleEnum_TICKET_STAFF;
    case 'SUPPORT_STAFF':
      return _$operatorReportDtoOutputEmployeesInnerRoleEnum_SUPPORT_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorReportDtoOutputEmployeesInnerRoleEnum>
    _$operatorReportDtoOutputEmployeesInnerRoleEnumValues = BuiltSet<
        OperatorReportDtoOutputEmployeesInnerRoleEnum>(const <OperatorReportDtoOutputEmployeesInnerRoleEnum>[
  _$operatorReportDtoOutputEmployeesInnerRoleEnum_DRIVER,
  _$operatorReportDtoOutputEmployeesInnerRoleEnum_TICKET_STAFF,
  _$operatorReportDtoOutputEmployeesInnerRoleEnum_SUPPORT_STAFF,
]);

Serializer<OperatorReportDtoOutputEmployeesInnerRoleEnum>
    _$operatorReportDtoOutputEmployeesInnerRoleEnumSerializer =
    _$OperatorReportDtoOutputEmployeesInnerRoleEnumSerializer();

class _$OperatorReportDtoOutputEmployeesInnerRoleEnumSerializer
    implements
        PrimitiveSerializer<OperatorReportDtoOutputEmployeesInnerRoleEnum> {
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
    OperatorReportDtoOutputEmployeesInnerRoleEnum
  ];
  @override
  final String wireName = 'OperatorReportDtoOutputEmployeesInnerRoleEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorReportDtoOutputEmployeesInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorReportDtoOutputEmployeesInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorReportDtoOutputEmployeesInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorReportDtoOutputEmployeesInner
    extends OperatorReportDtoOutputEmployeesInner {
  @override
  final String employeeId;
  @override
  final String loginName;
  @override
  final OperatorReportDtoOutputEmployeesInnerRoleEnum role;
  @override
  final int assignedTrips;
  @override
  final int completedTrips;
  @override
  final int ticketsChecked;
  @override
  final int incidentsReported;

  factory _$OperatorReportDtoOutputEmployeesInner(
          [void Function(OperatorReportDtoOutputEmployeesInnerBuilder)?
              updates]) =>
      (OperatorReportDtoOutputEmployeesInnerBuilder()..update(updates))
          ._build();

  _$OperatorReportDtoOutputEmployeesInner._(
      {required this.employeeId,
      required this.loginName,
      required this.role,
      required this.assignedTrips,
      required this.completedTrips,
      required this.ticketsChecked,
      required this.incidentsReported})
      : super._();
  @override
  OperatorReportDtoOutputEmployeesInner rebuild(
          void Function(OperatorReportDtoOutputEmployeesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorReportDtoOutputEmployeesInnerBuilder toBuilder() =>
      OperatorReportDtoOutputEmployeesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorReportDtoOutputEmployeesInner &&
        employeeId == other.employeeId &&
        loginName == other.loginName &&
        role == other.role &&
        assignedTrips == other.assignedTrips &&
        completedTrips == other.completedTrips &&
        ticketsChecked == other.ticketsChecked &&
        incidentsReported == other.incidentsReported;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, loginName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, assignedTrips.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jc(_$hash, ticketsChecked.hashCode);
    _$hash = $jc(_$hash, incidentsReported.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorReportDtoOutputEmployeesInner')
          ..add('employeeId', employeeId)
          ..add('loginName', loginName)
          ..add('role', role)
          ..add('assignedTrips', assignedTrips)
          ..add('completedTrips', completedTrips)
          ..add('ticketsChecked', ticketsChecked)
          ..add('incidentsReported', incidentsReported))
        .toString();
  }
}

class OperatorReportDtoOutputEmployeesInnerBuilder
    implements
        Builder<OperatorReportDtoOutputEmployeesInner,
            OperatorReportDtoOutputEmployeesInnerBuilder> {
  _$OperatorReportDtoOutputEmployeesInner? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  String? _loginName;
  String? get loginName => _$this._loginName;
  set loginName(String? loginName) => _$this._loginName = loginName;

  OperatorReportDtoOutputEmployeesInnerRoleEnum? _role;
  OperatorReportDtoOutputEmployeesInnerRoleEnum? get role => _$this._role;
  set role(OperatorReportDtoOutputEmployeesInnerRoleEnum? role) =>
      _$this._role = role;

  int? _assignedTrips;
  int? get assignedTrips => _$this._assignedTrips;
  set assignedTrips(int? assignedTrips) =>
      _$this._assignedTrips = assignedTrips;

  int? _completedTrips;
  int? get completedTrips => _$this._completedTrips;
  set completedTrips(int? completedTrips) =>
      _$this._completedTrips = completedTrips;

  int? _ticketsChecked;
  int? get ticketsChecked => _$this._ticketsChecked;
  set ticketsChecked(int? ticketsChecked) =>
      _$this._ticketsChecked = ticketsChecked;

  int? _incidentsReported;
  int? get incidentsReported => _$this._incidentsReported;
  set incidentsReported(int? incidentsReported) =>
      _$this._incidentsReported = incidentsReported;

  OperatorReportDtoOutputEmployeesInnerBuilder() {
    OperatorReportDtoOutputEmployeesInner._defaults(this);
  }

  OperatorReportDtoOutputEmployeesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeId = $v.employeeId;
      _loginName = $v.loginName;
      _role = $v.role;
      _assignedTrips = $v.assignedTrips;
      _completedTrips = $v.completedTrips;
      _ticketsChecked = $v.ticketsChecked;
      _incidentsReported = $v.incidentsReported;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorReportDtoOutputEmployeesInner other) {
    _$v = other as _$OperatorReportDtoOutputEmployeesInner;
  }

  @override
  void update(
      void Function(OperatorReportDtoOutputEmployeesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorReportDtoOutputEmployeesInner build() => _build();

  _$OperatorReportDtoOutputEmployeesInner _build() {
    final _$result = _$v ??
        _$OperatorReportDtoOutputEmployeesInner._(
          employeeId: BuiltValueNullFieldError.checkNotNull(employeeId,
              r'OperatorReportDtoOutputEmployeesInner', 'employeeId'),
          loginName: BuiltValueNullFieldError.checkNotNull(
              loginName, r'OperatorReportDtoOutputEmployeesInner', 'loginName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'OperatorReportDtoOutputEmployeesInner', 'role'),
          assignedTrips: BuiltValueNullFieldError.checkNotNull(assignedTrips,
              r'OperatorReportDtoOutputEmployeesInner', 'assignedTrips'),
          completedTrips: BuiltValueNullFieldError.checkNotNull(completedTrips,
              r'OperatorReportDtoOutputEmployeesInner', 'completedTrips'),
          ticketsChecked: BuiltValueNullFieldError.checkNotNull(ticketsChecked,
              r'OperatorReportDtoOutputEmployeesInner', 'ticketsChecked'),
          incidentsReported: BuiltValueNullFieldError.checkNotNull(
              incidentsReported,
              r'OperatorReportDtoOutputEmployeesInner',
              'incidentsReported'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
