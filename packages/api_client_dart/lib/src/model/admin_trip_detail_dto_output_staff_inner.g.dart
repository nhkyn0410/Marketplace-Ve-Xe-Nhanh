// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_detail_dto_output_staff_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTripDetailDtoOutputStaffInnerRoleEnum
    _$adminTripDetailDtoOutputStaffInnerRoleEnum_DRIVER =
    const AdminTripDetailDtoOutputStaffInnerRoleEnum._('DRIVER');
const AdminTripDetailDtoOutputStaffInnerRoleEnum
    _$adminTripDetailDtoOutputStaffInnerRoleEnum_TICKET_STAFF =
    const AdminTripDetailDtoOutputStaffInnerRoleEnum._('TICKET_STAFF');
const AdminTripDetailDtoOutputStaffInnerRoleEnum
    _$adminTripDetailDtoOutputStaffInnerRoleEnum_SUPPORT_STAFF =
    const AdminTripDetailDtoOutputStaffInnerRoleEnum._('SUPPORT_STAFF');
const AdminTripDetailDtoOutputStaffInnerRoleEnum
    _$adminTripDetailDtoOutputStaffInnerRoleEnum_SALES_STAFF =
    const AdminTripDetailDtoOutputStaffInnerRoleEnum._('SALES_STAFF');

AdminTripDetailDtoOutputStaffInnerRoleEnum
    _$adminTripDetailDtoOutputStaffInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'DRIVER':
      return _$adminTripDetailDtoOutputStaffInnerRoleEnum_DRIVER;
    case 'TICKET_STAFF':
      return _$adminTripDetailDtoOutputStaffInnerRoleEnum_TICKET_STAFF;
    case 'SUPPORT_STAFF':
      return _$adminTripDetailDtoOutputStaffInnerRoleEnum_SUPPORT_STAFF;
    case 'SALES_STAFF':
      return _$adminTripDetailDtoOutputStaffInnerRoleEnum_SALES_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTripDetailDtoOutputStaffInnerRoleEnum>
    _$adminTripDetailDtoOutputStaffInnerRoleEnumValues = BuiltSet<
        AdminTripDetailDtoOutputStaffInnerRoleEnum>(const <AdminTripDetailDtoOutputStaffInnerRoleEnum>[
  _$adminTripDetailDtoOutputStaffInnerRoleEnum_DRIVER,
  _$adminTripDetailDtoOutputStaffInnerRoleEnum_TICKET_STAFF,
  _$adminTripDetailDtoOutputStaffInnerRoleEnum_SUPPORT_STAFF,
  _$adminTripDetailDtoOutputStaffInnerRoleEnum_SALES_STAFF,
]);

Serializer<AdminTripDetailDtoOutputStaffInnerRoleEnum>
    _$adminTripDetailDtoOutputStaffInnerRoleEnumSerializer =
    _$AdminTripDetailDtoOutputStaffInnerRoleEnumSerializer();

class _$AdminTripDetailDtoOutputStaffInnerRoleEnumSerializer
    implements PrimitiveSerializer<AdminTripDetailDtoOutputStaffInnerRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRIVER': 'DRIVER',
    'TICKET_STAFF': 'TICKET_STAFF',
    'SUPPORT_STAFF': 'SUPPORT_STAFF',
    'SALES_STAFF': 'SALES_STAFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRIVER': 'DRIVER',
    'TICKET_STAFF': 'TICKET_STAFF',
    'SUPPORT_STAFF': 'SUPPORT_STAFF',
    'SALES_STAFF': 'SALES_STAFF',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTripDetailDtoOutputStaffInnerRoleEnum
  ];
  @override
  final String wireName = 'AdminTripDetailDtoOutputStaffInnerRoleEnum';

  @override
  Object serialize(Serializers serializers,
          AdminTripDetailDtoOutputStaffInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminTripDetailDtoOutputStaffInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminTripDetailDtoOutputStaffInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminTripDetailDtoOutputStaffInner
    extends AdminTripDetailDtoOutputStaffInner {
  @override
  final String username;
  @override
  final AdminTripDetailDtoOutputStaffInnerRoleEnum role;

  factory _$AdminTripDetailDtoOutputStaffInner(
          [void Function(AdminTripDetailDtoOutputStaffInnerBuilder)?
              updates]) =>
      (AdminTripDetailDtoOutputStaffInnerBuilder()..update(updates))._build();

  _$AdminTripDetailDtoOutputStaffInner._(
      {required this.username, required this.role})
      : super._();
  @override
  AdminTripDetailDtoOutputStaffInner rebuild(
          void Function(AdminTripDetailDtoOutputStaffInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripDetailDtoOutputStaffInnerBuilder toBuilder() =>
      AdminTripDetailDtoOutputStaffInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripDetailDtoOutputStaffInner &&
        username == other.username &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTripDetailDtoOutputStaffInner')
          ..add('username', username)
          ..add('role', role))
        .toString();
  }
}

class AdminTripDetailDtoOutputStaffInnerBuilder
    implements
        Builder<AdminTripDetailDtoOutputStaffInner,
            AdminTripDetailDtoOutputStaffInnerBuilder> {
  _$AdminTripDetailDtoOutputStaffInner? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  AdminTripDetailDtoOutputStaffInnerRoleEnum? _role;
  AdminTripDetailDtoOutputStaffInnerRoleEnum? get role => _$this._role;
  set role(AdminTripDetailDtoOutputStaffInnerRoleEnum? role) =>
      _$this._role = role;

  AdminTripDetailDtoOutputStaffInnerBuilder() {
    AdminTripDetailDtoOutputStaffInner._defaults(this);
  }

  AdminTripDetailDtoOutputStaffInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTripDetailDtoOutputStaffInner other) {
    _$v = other as _$AdminTripDetailDtoOutputStaffInner;
  }

  @override
  void update(
      void Function(AdminTripDetailDtoOutputStaffInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripDetailDtoOutputStaffInner build() => _build();

  _$AdminTripDetailDtoOutputStaffInner _build() {
    final _$result = _$v ??
        _$AdminTripDetailDtoOutputStaffInner._(
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AdminTripDetailDtoOutputStaffInner', 'username'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminTripDetailDtoOutputStaffInner', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
