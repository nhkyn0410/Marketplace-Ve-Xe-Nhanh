// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_assignment_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_DRAFT =
    const TripAssignmentDtoOutputStatusEnum._('DRAFT');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE =
    const TripAssignmentDtoOutputStatusEnum._('OPEN_FOR_SALE');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_SOLD_OUT =
    const TripAssignmentDtoOutputStatusEnum._('SOLD_OUT');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_LOCKED =
    const TripAssignmentDtoOutputStatusEnum._('LOCKED');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_BOARDING =
    const TripAssignmentDtoOutputStatusEnum._('BOARDING');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_DEPARTED =
    const TripAssignmentDtoOutputStatusEnum._('DEPARTED');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_IN_PROGRESS =
    const TripAssignmentDtoOutputStatusEnum._('IN_PROGRESS');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_COMPLETED =
    const TripAssignmentDtoOutputStatusEnum._('COMPLETED');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_CANCELLED =
    const TripAssignmentDtoOutputStatusEnum._('CANCELLED');
const TripAssignmentDtoOutputStatusEnum
    _$tripAssignmentDtoOutputStatusEnum_INCIDENT =
    const TripAssignmentDtoOutputStatusEnum._('INCIDENT');

TripAssignmentDtoOutputStatusEnum _$tripAssignmentDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$tripAssignmentDtoOutputStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$tripAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE;
    case 'SOLD_OUT':
      return _$tripAssignmentDtoOutputStatusEnum_SOLD_OUT;
    case 'LOCKED':
      return _$tripAssignmentDtoOutputStatusEnum_LOCKED;
    case 'BOARDING':
      return _$tripAssignmentDtoOutputStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$tripAssignmentDtoOutputStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$tripAssignmentDtoOutputStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$tripAssignmentDtoOutputStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$tripAssignmentDtoOutputStatusEnum_CANCELLED;
    case 'INCIDENT':
      return _$tripAssignmentDtoOutputStatusEnum_INCIDENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripAssignmentDtoOutputStatusEnum>
    _$tripAssignmentDtoOutputStatusEnumValues = BuiltSet<
        TripAssignmentDtoOutputStatusEnum>(const <TripAssignmentDtoOutputStatusEnum>[
  _$tripAssignmentDtoOutputStatusEnum_DRAFT,
  _$tripAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE,
  _$tripAssignmentDtoOutputStatusEnum_SOLD_OUT,
  _$tripAssignmentDtoOutputStatusEnum_LOCKED,
  _$tripAssignmentDtoOutputStatusEnum_BOARDING,
  _$tripAssignmentDtoOutputStatusEnum_DEPARTED,
  _$tripAssignmentDtoOutputStatusEnum_IN_PROGRESS,
  _$tripAssignmentDtoOutputStatusEnum_COMPLETED,
  _$tripAssignmentDtoOutputStatusEnum_CANCELLED,
  _$tripAssignmentDtoOutputStatusEnum_INCIDENT,
]);

Serializer<TripAssignmentDtoOutputStatusEnum>
    _$tripAssignmentDtoOutputStatusEnumSerializer =
    _$TripAssignmentDtoOutputStatusEnumSerializer();

class _$TripAssignmentDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<TripAssignmentDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[TripAssignmentDtoOutputStatusEnum];
  @override
  final String wireName = 'TripAssignmentDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, TripAssignmentDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripAssignmentDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripAssignmentDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripAssignmentDtoOutput extends TripAssignmentDtoOutput {
  @override
  final String tripId;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final TripAssignmentDtoOutputStatusEnum status;
  @override
  final String routeName;
  @override
  final String? vehiclePlateNumber;
  @override
  final TripAssignmentPageDtoOutputItemsInnerDriver? driver;
  @override
  final TripAssignmentPageDtoOutputItemsInnerConflict? conflict;
  @override
  final bool reasonRequired;
  @override
  final bool editable;

  factory _$TripAssignmentDtoOutput(
          [void Function(TripAssignmentDtoOutputBuilder)? updates]) =>
      (TripAssignmentDtoOutputBuilder()..update(updates))._build();

  _$TripAssignmentDtoOutput._(
      {required this.tripId,
      required this.departureAt,
      required this.arrivalAt,
      required this.status,
      required this.routeName,
      this.vehiclePlateNumber,
      this.driver,
      this.conflict,
      required this.reasonRequired,
      required this.editable})
      : super._();
  @override
  TripAssignmentDtoOutput rebuild(
          void Function(TripAssignmentDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripAssignmentDtoOutputBuilder toBuilder() =>
      TripAssignmentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripAssignmentDtoOutput &&
        tripId == other.tripId &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        status == other.status &&
        routeName == other.routeName &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        driver == other.driver &&
        conflict == other.conflict &&
        reasonRequired == other.reasonRequired &&
        editable == other.editable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, driver.hashCode);
    _$hash = $jc(_$hash, conflict.hashCode);
    _$hash = $jc(_$hash, reasonRequired.hashCode);
    _$hash = $jc(_$hash, editable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripAssignmentDtoOutput')
          ..add('tripId', tripId)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('status', status)
          ..add('routeName', routeName)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('driver', driver)
          ..add('conflict', conflict)
          ..add('reasonRequired', reasonRequired)
          ..add('editable', editable))
        .toString();
  }
}

class TripAssignmentDtoOutputBuilder
    implements
        Builder<TripAssignmentDtoOutput, TripAssignmentDtoOutputBuilder> {
  _$TripAssignmentDtoOutput? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  TripAssignmentDtoOutputStatusEnum? _status;
  TripAssignmentDtoOutputStatusEnum? get status => _$this._status;
  set status(TripAssignmentDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  TripAssignmentPageDtoOutputItemsInnerDriverBuilder? _driver;
  TripAssignmentPageDtoOutputItemsInnerDriverBuilder get driver =>
      _$this._driver ??= TripAssignmentPageDtoOutputItemsInnerDriverBuilder();
  set driver(TripAssignmentPageDtoOutputItemsInnerDriverBuilder? driver) =>
      _$this._driver = driver;

  TripAssignmentPageDtoOutputItemsInnerConflictBuilder? _conflict;
  TripAssignmentPageDtoOutputItemsInnerConflictBuilder get conflict =>
      _$this._conflict ??=
          TripAssignmentPageDtoOutputItemsInnerConflictBuilder();
  set conflict(
          TripAssignmentPageDtoOutputItemsInnerConflictBuilder? conflict) =>
      _$this._conflict = conflict;

  bool? _reasonRequired;
  bool? get reasonRequired => _$this._reasonRequired;
  set reasonRequired(bool? reasonRequired) =>
      _$this._reasonRequired = reasonRequired;

  bool? _editable;
  bool? get editable => _$this._editable;
  set editable(bool? editable) => _$this._editable = editable;

  TripAssignmentDtoOutputBuilder() {
    TripAssignmentDtoOutput._defaults(this);
  }

  TripAssignmentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _status = $v.status;
      _routeName = $v.routeName;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _driver = $v.driver?.toBuilder();
      _conflict = $v.conflict?.toBuilder();
      _reasonRequired = $v.reasonRequired;
      _editable = $v.editable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripAssignmentDtoOutput other) {
    _$v = other as _$TripAssignmentDtoOutput;
  }

  @override
  void update(void Function(TripAssignmentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripAssignmentDtoOutput build() => _build();

  _$TripAssignmentDtoOutput _build() {
    _$TripAssignmentDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripAssignmentDtoOutput._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'TripAssignmentDtoOutput', 'tripId'),
            departureAt: BuiltValueNullFieldError.checkNotNull(
                departureAt, r'TripAssignmentDtoOutput', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(
                arrivalAt, r'TripAssignmentDtoOutput', 'arrivalAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'TripAssignmentDtoOutput', 'status'),
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'TripAssignmentDtoOutput', 'routeName'),
            vehiclePlateNumber: vehiclePlateNumber,
            driver: _driver?.build(),
            conflict: _conflict?.build(),
            reasonRequired: BuiltValueNullFieldError.checkNotNull(
                reasonRequired, r'TripAssignmentDtoOutput', 'reasonRequired'),
            editable: BuiltValueNullFieldError.checkNotNull(
                editable, r'TripAssignmentDtoOutput', 'editable'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'driver';
        _driver?.build();
        _$failedField = 'conflict';
        _conflict?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripAssignmentDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
