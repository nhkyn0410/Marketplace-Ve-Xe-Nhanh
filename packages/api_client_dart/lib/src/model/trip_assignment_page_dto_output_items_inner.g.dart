// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_assignment_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DRAFT =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('DRAFT');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('OPEN_FOR_SALE');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_SOLD_OUT =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('SOLD_OUT');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_LOCKED =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('LOCKED');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_BOARDING =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('BOARDING');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DEPARTED =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('DEPARTED');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('IN_PROGRESS');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_COMPLETED =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('COMPLETED');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_CANCELLED =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('CANCELLED');
const TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_INCIDENT =
    const TripAssignmentPageDtoOutputItemsInnerStatusEnum._('INCIDENT');

TripAssignmentPageDtoOutputItemsInnerStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
    case 'SOLD_OUT':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_SOLD_OUT;
    case 'LOCKED':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'BOARDING':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_CANCELLED;
    case 'INCIDENT':
      return _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_INCIDENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripAssignmentPageDtoOutputItemsInnerStatusEnum>
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        TripAssignmentPageDtoOutputItemsInnerStatusEnum>(const <TripAssignmentPageDtoOutputItemsInnerStatusEnum>[
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DRAFT,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_SOLD_OUT,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_LOCKED,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_BOARDING,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DEPARTED,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_COMPLETED,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_CANCELLED,
  _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_INCIDENT,
]);

Serializer<TripAssignmentPageDtoOutputItemsInnerStatusEnum>
    _$tripAssignmentPageDtoOutputItemsInnerStatusEnumSerializer =
    _$TripAssignmentPageDtoOutputItemsInnerStatusEnumSerializer();

class _$TripAssignmentPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<TripAssignmentPageDtoOutputItemsInnerStatusEnum> {
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
    TripAssignmentPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'TripAssignmentPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TripAssignmentPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripAssignmentPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripAssignmentPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripAssignmentPageDtoOutputItemsInner
    extends TripAssignmentPageDtoOutputItemsInner {
  @override
  final String tripId;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final TripAssignmentPageDtoOutputItemsInnerStatusEnum status;
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

  factory _$TripAssignmentPageDtoOutputItemsInner(
          [void Function(TripAssignmentPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (TripAssignmentPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$TripAssignmentPageDtoOutputItemsInner._(
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
  TripAssignmentPageDtoOutputItemsInner rebuild(
          void Function(TripAssignmentPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripAssignmentPageDtoOutputItemsInnerBuilder toBuilder() =>
      TripAssignmentPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripAssignmentPageDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'TripAssignmentPageDtoOutputItemsInner')
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

class TripAssignmentPageDtoOutputItemsInnerBuilder
    implements
        Builder<TripAssignmentPageDtoOutputItemsInner,
            TripAssignmentPageDtoOutputItemsInnerBuilder> {
  _$TripAssignmentPageDtoOutputItemsInner? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  TripAssignmentPageDtoOutputItemsInnerStatusEnum? _status;
  TripAssignmentPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(TripAssignmentPageDtoOutputItemsInnerStatusEnum? status) =>
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

  TripAssignmentPageDtoOutputItemsInnerBuilder() {
    TripAssignmentPageDtoOutputItemsInner._defaults(this);
  }

  TripAssignmentPageDtoOutputItemsInnerBuilder get _$this {
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
  void replace(TripAssignmentPageDtoOutputItemsInner other) {
    _$v = other as _$TripAssignmentPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(TripAssignmentPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripAssignmentPageDtoOutputItemsInner build() => _build();

  _$TripAssignmentPageDtoOutputItemsInner _build() {
    _$TripAssignmentPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$TripAssignmentPageDtoOutputItemsInner._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'TripAssignmentPageDtoOutputItemsInner', 'tripId'),
            departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
                r'TripAssignmentPageDtoOutputItemsInner', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(arrivalAt,
                r'TripAssignmentPageDtoOutputItemsInner', 'arrivalAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'TripAssignmentPageDtoOutputItemsInner', 'status'),
            routeName: BuiltValueNullFieldError.checkNotNull(routeName,
                r'TripAssignmentPageDtoOutputItemsInner', 'routeName'),
            vehiclePlateNumber: vehiclePlateNumber,
            driver: _driver?.build(),
            conflict: _conflict?.build(),
            reasonRequired: BuiltValueNullFieldError.checkNotNull(
                reasonRequired,
                r'TripAssignmentPageDtoOutputItemsInner',
                'reasonRequired'),
            editable: BuiltValueNullFieldError.checkNotNull(
                editable, r'TripAssignmentPageDtoOutputItemsInner', 'editable'),
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
            r'TripAssignmentPageDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
