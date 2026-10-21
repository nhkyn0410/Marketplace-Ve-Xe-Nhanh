// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_platform_account_create_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPlatformAccountCreateDtoRoleEnum
    _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_ADMIN =
    const AdminPlatformAccountCreateDtoRoleEnum._('PLATFORM_ADMIN');
const AdminPlatformAccountCreateDtoRoleEnum
    _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_SUPPORT =
    const AdminPlatformAccountCreateDtoRoleEnum._('PLATFORM_SUPPORT');

AdminPlatformAccountCreateDtoRoleEnum
    _$adminPlatformAccountCreateDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'PLATFORM_ADMIN':
      return _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_ADMIN;
    case 'PLATFORM_SUPPORT':
      return _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_SUPPORT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPlatformAccountCreateDtoRoleEnum>
    _$adminPlatformAccountCreateDtoRoleEnumValues = BuiltSet<
        AdminPlatformAccountCreateDtoRoleEnum>(const <AdminPlatformAccountCreateDtoRoleEnum>[
  _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_ADMIN,
  _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_SUPPORT,
]);

Serializer<AdminPlatformAccountCreateDtoRoleEnum>
    _$adminPlatformAccountCreateDtoRoleEnumSerializer =
    _$AdminPlatformAccountCreateDtoRoleEnumSerializer();

class _$AdminPlatformAccountCreateDtoRoleEnumSerializer
    implements PrimitiveSerializer<AdminPlatformAccountCreateDtoRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PLATFORM_ADMIN': 'PLATFORM_ADMIN',
    'PLATFORM_SUPPORT': 'PLATFORM_SUPPORT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PLATFORM_ADMIN': 'PLATFORM_ADMIN',
    'PLATFORM_SUPPORT': 'PLATFORM_SUPPORT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPlatformAccountCreateDtoRoleEnum
  ];
  @override
  final String wireName = 'AdminPlatformAccountCreateDtoRoleEnum';

  @override
  Object serialize(
          Serializers serializers, AdminPlatformAccountCreateDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPlatformAccountCreateDtoRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPlatformAccountCreateDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPlatformAccountCreateDto extends AdminPlatformAccountCreateDto {
  @override
  final String username;
  @override
  final String email;
  @override
  final AdminPlatformAccountCreateDtoRoleEnum role;

  factory _$AdminPlatformAccountCreateDto(
          [void Function(AdminPlatformAccountCreateDtoBuilder)? updates]) =>
      (AdminPlatformAccountCreateDtoBuilder()..update(updates))._build();

  _$AdminPlatformAccountCreateDto._(
      {required this.username, required this.email, required this.role})
      : super._();
  @override
  AdminPlatformAccountCreateDto rebuild(
          void Function(AdminPlatformAccountCreateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPlatformAccountCreateDtoBuilder toBuilder() =>
      AdminPlatformAccountCreateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPlatformAccountCreateDto &&
        username == other.username &&
        email == other.email &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPlatformAccountCreateDto')
          ..add('username', username)
          ..add('email', email)
          ..add('role', role))
        .toString();
  }
}

class AdminPlatformAccountCreateDtoBuilder
    implements
        Builder<AdminPlatformAccountCreateDto,
            AdminPlatformAccountCreateDtoBuilder> {
  _$AdminPlatformAccountCreateDto? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AdminPlatformAccountCreateDtoRoleEnum? _role;
  AdminPlatformAccountCreateDtoRoleEnum? get role => _$this._role;
  set role(AdminPlatformAccountCreateDtoRoleEnum? role) => _$this._role = role;

  AdminPlatformAccountCreateDtoBuilder() {
    AdminPlatformAccountCreateDto._defaults(this);
  }

  AdminPlatformAccountCreateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _email = $v.email;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPlatformAccountCreateDto other) {
    _$v = other as _$AdminPlatformAccountCreateDto;
  }

  @override
  void update(void Function(AdminPlatformAccountCreateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPlatformAccountCreateDto build() => _build();

  _$AdminPlatformAccountCreateDto _build() {
    final _$result = _$v ??
        _$AdminPlatformAccountCreateDto._(
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AdminPlatformAccountCreateDto', 'username'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AdminPlatformAccountCreateDto', 'email'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminPlatformAccountCreateDto', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
