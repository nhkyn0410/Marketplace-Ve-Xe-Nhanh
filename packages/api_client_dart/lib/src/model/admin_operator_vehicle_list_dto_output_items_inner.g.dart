// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_vehicle_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum
    _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum
    _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_MAINTENANCE =
    const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum._(
        'MAINTENANCE');
const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum
    _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum
    _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'MAINTENANCE':
      return _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_MAINTENANCE;
    case 'INACTIVE':
      return _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum>
    _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum>(const <AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum>[
  _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_MAINTENANCE,
  _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum>
    _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminOperatorVehicleListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminOperatorVehicleListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'MAINTENANCE': 'MAINTENANCE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'MAINTENANCE': 'MAINTENANCE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorVehicleListDtoOutputItemsInner
    extends AdminOperatorVehicleListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String plateNumber;
  @override
  final String vehicleTypeName;
  @override
  final int? seatCount;
  @override
  final AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum status;
  @override
  final int upcomingTripCount;

  factory _$AdminOperatorVehicleListDtoOutputItemsInner(
          [void Function(AdminOperatorVehicleListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminOperatorVehicleListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminOperatorVehicleListDtoOutputItemsInner._(
      {required this.id,
      required this.plateNumber,
      required this.vehicleTypeName,
      this.seatCount,
      required this.status,
      required this.upcomingTripCount})
      : super._();
  @override
  AdminOperatorVehicleListDtoOutputItemsInner rebuild(
          void Function(AdminOperatorVehicleListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorVehicleListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminOperatorVehicleListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorVehicleListDtoOutputItemsInner &&
        id == other.id &&
        plateNumber == other.plateNumber &&
        vehicleTypeName == other.vehicleTypeName &&
        seatCount == other.seatCount &&
        status == other.status &&
        upcomingTripCount == other.upcomingTripCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, plateNumber.hashCode);
    _$hash = $jc(_$hash, vehicleTypeName.hashCode);
    _$hash = $jc(_$hash, seatCount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, upcomingTripCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOperatorVehicleListDtoOutputItemsInner')
          ..add('id', id)
          ..add('plateNumber', plateNumber)
          ..add('vehicleTypeName', vehicleTypeName)
          ..add('seatCount', seatCount)
          ..add('status', status)
          ..add('upcomingTripCount', upcomingTripCount))
        .toString();
  }
}

class AdminOperatorVehicleListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminOperatorVehicleListDtoOutputItemsInner,
            AdminOperatorVehicleListDtoOutputItemsInnerBuilder> {
  _$AdminOperatorVehicleListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _plateNumber;
  String? get plateNumber => _$this._plateNumber;
  set plateNumber(String? plateNumber) => _$this._plateNumber = plateNumber;

  String? _vehicleTypeName;
  String? get vehicleTypeName => _$this._vehicleTypeName;
  set vehicleTypeName(String? vehicleTypeName) =>
      _$this._vehicleTypeName = vehicleTypeName;

  int? _seatCount;
  int? get seatCount => _$this._seatCount;
  set seatCount(int? seatCount) => _$this._seatCount = seatCount;

  AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum? _status;
  AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _upcomingTripCount;
  int? get upcomingTripCount => _$this._upcomingTripCount;
  set upcomingTripCount(int? upcomingTripCount) =>
      _$this._upcomingTripCount = upcomingTripCount;

  AdminOperatorVehicleListDtoOutputItemsInnerBuilder() {
    AdminOperatorVehicleListDtoOutputItemsInner._defaults(this);
  }

  AdminOperatorVehicleListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _plateNumber = $v.plateNumber;
      _vehicleTypeName = $v.vehicleTypeName;
      _seatCount = $v.seatCount;
      _status = $v.status;
      _upcomingTripCount = $v.upcomingTripCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorVehicleListDtoOutputItemsInner other) {
    _$v = other as _$AdminOperatorVehicleListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminOperatorVehicleListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorVehicleListDtoOutputItemsInner build() => _build();

  _$AdminOperatorVehicleListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminOperatorVehicleListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminOperatorVehicleListDtoOutputItemsInner', 'id'),
          plateNumber: BuiltValueNullFieldError.checkNotNull(plateNumber,
              r'AdminOperatorVehicleListDtoOutputItemsInner', 'plateNumber'),
          vehicleTypeName: BuiltValueNullFieldError.checkNotNull(
              vehicleTypeName,
              r'AdminOperatorVehicleListDtoOutputItemsInner',
              'vehicleTypeName'),
          seatCount: seatCount,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminOperatorVehicleListDtoOutputItemsInner', 'status'),
          upcomingTripCount: BuiltValueNullFieldError.checkNotNull(
              upcomingTripCount,
              r'AdminOperatorVehicleListDtoOutputItemsInner',
              'upcomingTripCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
