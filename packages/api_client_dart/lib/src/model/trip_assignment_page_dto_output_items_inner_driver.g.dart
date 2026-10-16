// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_assignment_page_dto_output_items_inner_driver.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_ACTIVE =
    const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum._('ACTIVE');
const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_LOCKED =
    const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum._('LOCKED');
const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_DISABLED =
    const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum._('DISABLED');

TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum
    _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_LOCKED;
    case 'DISABLED':
      return _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum>
    _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnumValues = BuiltSet<
        TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum>(const <TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum>[
  _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_ACTIVE,
  _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_LOCKED,
  _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_DISABLED,
]);

Serializer<TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum>
    _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnumSerializer =
    _$TripAssignmentPageDtoOutputItemsInnerDriverStatusEnumSerializer();

class _$TripAssignmentPageDtoOutputItemsInnerDriverStatusEnumSerializer
    implements
        PrimitiveSerializer<
            TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
    'DISABLED': 'DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
    'DISABLED': 'DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum
  ];
  @override
  final String wireName =
      'TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripAssignmentPageDtoOutputItemsInnerDriver
    extends TripAssignmentPageDtoOutputItemsInnerDriver {
  @override
  final String employeeId;
  @override
  final String username;
  @override
  final TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum status;

  factory _$TripAssignmentPageDtoOutputItemsInnerDriver(
          [void Function(TripAssignmentPageDtoOutputItemsInnerDriverBuilder)?
              updates]) =>
      (TripAssignmentPageDtoOutputItemsInnerDriverBuilder()..update(updates))
          ._build();

  _$TripAssignmentPageDtoOutputItemsInnerDriver._(
      {required this.employeeId, required this.username, required this.status})
      : super._();
  @override
  TripAssignmentPageDtoOutputItemsInnerDriver rebuild(
          void Function(TripAssignmentPageDtoOutputItemsInnerDriverBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripAssignmentPageDtoOutputItemsInnerDriverBuilder toBuilder() =>
      TripAssignmentPageDtoOutputItemsInnerDriverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripAssignmentPageDtoOutputItemsInnerDriver &&
        employeeId == other.employeeId &&
        username == other.username &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripAssignmentPageDtoOutputItemsInnerDriver')
          ..add('employeeId', employeeId)
          ..add('username', username)
          ..add('status', status))
        .toString();
  }
}

class TripAssignmentPageDtoOutputItemsInnerDriverBuilder
    implements
        Builder<TripAssignmentPageDtoOutputItemsInnerDriver,
            TripAssignmentPageDtoOutputItemsInnerDriverBuilder> {
  _$TripAssignmentPageDtoOutputItemsInnerDriver? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum? _status;
  TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum? get status =>
      _$this._status;
  set status(TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum? status) =>
      _$this._status = status;

  TripAssignmentPageDtoOutputItemsInnerDriverBuilder() {
    TripAssignmentPageDtoOutputItemsInnerDriver._defaults(this);
  }

  TripAssignmentPageDtoOutputItemsInnerDriverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeId = $v.employeeId;
      _username = $v.username;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripAssignmentPageDtoOutputItemsInnerDriver other) {
    _$v = other as _$TripAssignmentPageDtoOutputItemsInnerDriver;
  }

  @override
  void update(
      void Function(TripAssignmentPageDtoOutputItemsInnerDriverBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripAssignmentPageDtoOutputItemsInnerDriver build() => _build();

  _$TripAssignmentPageDtoOutputItemsInnerDriver _build() {
    final _$result = _$v ??
        _$TripAssignmentPageDtoOutputItemsInnerDriver._(
          employeeId: BuiltValueNullFieldError.checkNotNull(employeeId,
              r'TripAssignmentPageDtoOutputItemsInnerDriver', 'employeeId'),
          username: BuiltValueNullFieldError.checkNotNull(username,
              r'TripAssignmentPageDtoOutputItemsInnerDriver', 'username'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TripAssignmentPageDtoOutputItemsInnerDriver', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
