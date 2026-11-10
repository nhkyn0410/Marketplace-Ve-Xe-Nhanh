// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_page_dto_output_items_inner_owner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_ACTIVE =
    const AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum._('ACTIVE');
const AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_LOCKED =
    const AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum._('LOCKED');
const AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_DISABLED =
    const AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum._('DISABLED');

AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum>
    _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnumValues = BuiltSet<
        AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum>(const <AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum>[
  _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_ACTIVE,
  _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_LOCKED,
  _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnum_DISABLED,
]);

Serializer<AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum>
    _$adminOperatorPageDtoOutputItemsInnerOwnerStatusEnumSerializer =
    _$AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnumSerializer();

class _$AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum> {
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
    AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum
  ];
  @override
  final String wireName = 'AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorPageDtoOutputItemsInnerOwner
    extends AdminOperatorPageDtoOutputItemsInnerOwner {
  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;
  @override
  final AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum status;
  @override
  final bool credentialDeliveryPending;

  factory _$AdminOperatorPageDtoOutputItemsInnerOwner(
          [void Function(AdminOperatorPageDtoOutputItemsInnerOwnerBuilder)?
              updates]) =>
      (AdminOperatorPageDtoOutputItemsInnerOwnerBuilder()..update(updates))
          ._build();

  _$AdminOperatorPageDtoOutputItemsInnerOwner._(
      {required this.id,
      required this.username,
      this.email,
      required this.status,
      required this.credentialDeliveryPending})
      : super._();
  @override
  AdminOperatorPageDtoOutputItemsInnerOwner rebuild(
          void Function(AdminOperatorPageDtoOutputItemsInnerOwnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorPageDtoOutputItemsInnerOwnerBuilder toBuilder() =>
      AdminOperatorPageDtoOutputItemsInnerOwnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorPageDtoOutputItemsInnerOwner &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        status == other.status &&
        credentialDeliveryPending == other.credentialDeliveryPending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, credentialDeliveryPending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOperatorPageDtoOutputItemsInnerOwner')
          ..add('id', id)
          ..add('username', username)
          ..add('email', email)
          ..add('status', status)
          ..add('credentialDeliveryPending', credentialDeliveryPending))
        .toString();
  }
}

class AdminOperatorPageDtoOutputItemsInnerOwnerBuilder
    implements
        Builder<AdminOperatorPageDtoOutputItemsInnerOwner,
            AdminOperatorPageDtoOutputItemsInnerOwnerBuilder> {
  _$AdminOperatorPageDtoOutputItemsInnerOwner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum? _status;
  AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum? get status =>
      _$this._status;
  set status(AdminOperatorPageDtoOutputItemsInnerOwnerStatusEnum? status) =>
      _$this._status = status;

  bool? _credentialDeliveryPending;
  bool? get credentialDeliveryPending => _$this._credentialDeliveryPending;
  set credentialDeliveryPending(bool? credentialDeliveryPending) =>
      _$this._credentialDeliveryPending = credentialDeliveryPending;

  AdminOperatorPageDtoOutputItemsInnerOwnerBuilder() {
    AdminOperatorPageDtoOutputItemsInnerOwner._defaults(this);
  }

  AdminOperatorPageDtoOutputItemsInnerOwnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _email = $v.email;
      _status = $v.status;
      _credentialDeliveryPending = $v.credentialDeliveryPending;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorPageDtoOutputItemsInnerOwner other) {
    _$v = other as _$AdminOperatorPageDtoOutputItemsInnerOwner;
  }

  @override
  void update(
      void Function(AdminOperatorPageDtoOutputItemsInnerOwnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorPageDtoOutputItemsInnerOwner build() => _build();

  _$AdminOperatorPageDtoOutputItemsInnerOwner _build() {
    final _$result = _$v ??
        _$AdminOperatorPageDtoOutputItemsInnerOwner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminOperatorPageDtoOutputItemsInnerOwner', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(username,
              r'AdminOperatorPageDtoOutputItemsInnerOwner', 'username'),
          email: email,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminOperatorPageDtoOutputItemsInnerOwner', 'status'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'AdminOperatorPageDtoOutputItemsInnerOwner',
              'credentialDeliveryPending'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
