// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_assignments_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum
    _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_ACTIVE =
    const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum._('ACTIVE');
const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum
    _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_LOCKED =
    const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum._('LOCKED');
const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum
    _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_DISABLED =
    const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum._('DISABLED');

SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum
    _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum>
    _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum>(const <SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum>[
  _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_LOCKED,
  _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum>
    _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnumSerializer =
    _$SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnumSerializer();

class _$SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum> {
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
    SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SalesOfficeAssignmentsDtoOutputItemsInner
    extends SalesOfficeAssignmentsDtoOutputItemsInner {
  @override
  final String employeeId;
  @override
  final String username;
  @override
  final SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum status;

  factory _$SalesOfficeAssignmentsDtoOutputItemsInner(
          [void Function(SalesOfficeAssignmentsDtoOutputItemsInnerBuilder)?
              updates]) =>
      (SalesOfficeAssignmentsDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$SalesOfficeAssignmentsDtoOutputItemsInner._(
      {required this.employeeId, required this.username, required this.status})
      : super._();
  @override
  SalesOfficeAssignmentsDtoOutputItemsInner rebuild(
          void Function(SalesOfficeAssignmentsDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeAssignmentsDtoOutputItemsInnerBuilder toBuilder() =>
      SalesOfficeAssignmentsDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeAssignmentsDtoOutputItemsInner &&
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
            r'SalesOfficeAssignmentsDtoOutputItemsInner')
          ..add('employeeId', employeeId)
          ..add('username', username)
          ..add('status', status))
        .toString();
  }
}

class SalesOfficeAssignmentsDtoOutputItemsInnerBuilder
    implements
        Builder<SalesOfficeAssignmentsDtoOutputItemsInner,
            SalesOfficeAssignmentsDtoOutputItemsInnerBuilder> {
  _$SalesOfficeAssignmentsDtoOutputItemsInner? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum? _status;
  SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  SalesOfficeAssignmentsDtoOutputItemsInnerBuilder() {
    SalesOfficeAssignmentsDtoOutputItemsInner._defaults(this);
  }

  SalesOfficeAssignmentsDtoOutputItemsInnerBuilder get _$this {
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
  void replace(SalesOfficeAssignmentsDtoOutputItemsInner other) {
    _$v = other as _$SalesOfficeAssignmentsDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(SalesOfficeAssignmentsDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeAssignmentsDtoOutputItemsInner build() => _build();

  _$SalesOfficeAssignmentsDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$SalesOfficeAssignmentsDtoOutputItemsInner._(
          employeeId: BuiltValueNullFieldError.checkNotNull(employeeId,
              r'SalesOfficeAssignmentsDtoOutputItemsInner', 'employeeId'),
          username: BuiltValueNullFieldError.checkNotNull(username,
              r'SalesOfficeAssignmentsDtoOutputItemsInner', 'username'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SalesOfficeAssignmentsDtoOutputItemsInner', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
