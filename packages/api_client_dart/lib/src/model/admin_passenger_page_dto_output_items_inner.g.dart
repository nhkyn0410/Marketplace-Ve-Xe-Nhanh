// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_passenger_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPassengerPageDtoOutputItemsInnerStatusEnum
    _$adminPassengerPageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminPassengerPageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminPassengerPageDtoOutputItemsInnerStatusEnum
    _$adminPassengerPageDtoOutputItemsInnerStatusEnum_LOCKED =
    const AdminPassengerPageDtoOutputItemsInnerStatusEnum._('LOCKED');
const AdminPassengerPageDtoOutputItemsInnerStatusEnum
    _$adminPassengerPageDtoOutputItemsInnerStatusEnum_DISABLED =
    const AdminPassengerPageDtoOutputItemsInnerStatusEnum._('DISABLED');

AdminPassengerPageDtoOutputItemsInnerStatusEnum
    _$adminPassengerPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminPassengerPageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminPassengerPageDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminPassengerPageDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPassengerPageDtoOutputItemsInnerStatusEnum>
    _$adminPassengerPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminPassengerPageDtoOutputItemsInnerStatusEnum>(const <AdminPassengerPageDtoOutputItemsInnerStatusEnum>[
  _$adminPassengerPageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminPassengerPageDtoOutputItemsInnerStatusEnum_LOCKED,
  _$adminPassengerPageDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<AdminPassengerPageDtoOutputItemsInnerStatusEnum>
    _$adminPassengerPageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminPassengerPageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminPassengerPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminPassengerPageDtoOutputItemsInnerStatusEnum> {
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
    AdminPassengerPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminPassengerPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPassengerPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPassengerPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPassengerPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPassengerPageDtoOutputItemsInner
    extends AdminPassengerPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String? name;
  @override
  final String email;
  @override
  final BuiltList<String> providers;
  @override
  final AdminPassengerPageDtoOutputItemsInnerStatusEnum status;
  @override
  final String? lockedReason;
  @override
  final DateTime? lockedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLoginAt;

  factory _$AdminPassengerPageDtoOutputItemsInner(
          [void Function(AdminPassengerPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminPassengerPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminPassengerPageDtoOutputItemsInner._(
      {required this.id,
      this.name,
      required this.email,
      required this.providers,
      required this.status,
      this.lockedReason,
      this.lockedAt,
      required this.createdAt,
      this.lastLoginAt})
      : super._();
  @override
  AdminPassengerPageDtoOutputItemsInner rebuild(
          void Function(AdminPassengerPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPassengerPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminPassengerPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPassengerPageDtoOutputItemsInner &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        providers == other.providers &&
        status == other.status &&
        lockedReason == other.lockedReason &&
        lockedAt == other.lockedAt &&
        createdAt == other.createdAt &&
        lastLoginAt == other.lastLoginAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, providers.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lockedReason.hashCode);
    _$hash = $jc(_$hash, lockedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lastLoginAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPassengerPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('providers', providers)
          ..add('status', status)
          ..add('lockedReason', lockedReason)
          ..add('lockedAt', lockedAt)
          ..add('createdAt', createdAt)
          ..add('lastLoginAt', lastLoginAt))
        .toString();
  }
}

class AdminPassengerPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminPassengerPageDtoOutputItemsInner,
            AdminPassengerPageDtoOutputItemsInnerBuilder> {
  _$AdminPassengerPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ListBuilder<String>? _providers;
  ListBuilder<String> get providers =>
      _$this._providers ??= ListBuilder<String>();
  set providers(ListBuilder<String>? providers) =>
      _$this._providers = providers;

  AdminPassengerPageDtoOutputItemsInnerStatusEnum? _status;
  AdminPassengerPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminPassengerPageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _lockedReason;
  String? get lockedReason => _$this._lockedReason;
  set lockedReason(String? lockedReason) => _$this._lockedReason = lockedReason;

  DateTime? _lockedAt;
  DateTime? get lockedAt => _$this._lockedAt;
  set lockedAt(DateTime? lockedAt) => _$this._lockedAt = lockedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _lastLoginAt;
  DateTime? get lastLoginAt => _$this._lastLoginAt;
  set lastLoginAt(DateTime? lastLoginAt) => _$this._lastLoginAt = lastLoginAt;

  AdminPassengerPageDtoOutputItemsInnerBuilder() {
    AdminPassengerPageDtoOutputItemsInner._defaults(this);
  }

  AdminPassengerPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _providers = $v.providers.toBuilder();
      _status = $v.status;
      _lockedReason = $v.lockedReason;
      _lockedAt = $v.lockedAt;
      _createdAt = $v.createdAt;
      _lastLoginAt = $v.lastLoginAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPassengerPageDtoOutputItemsInner other) {
    _$v = other as _$AdminPassengerPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminPassengerPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPassengerPageDtoOutputItemsInner build() => _build();

  _$AdminPassengerPageDtoOutputItemsInner _build() {
    _$AdminPassengerPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminPassengerPageDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminPassengerPageDtoOutputItemsInner', 'id'),
            name: name,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'AdminPassengerPageDtoOutputItemsInner', 'email'),
            providers: providers.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminPassengerPageDtoOutputItemsInner', 'status'),
            lockedReason: lockedReason,
            lockedAt: lockedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'AdminPassengerPageDtoOutputItemsInner', 'createdAt'),
            lastLoginAt: lastLoginAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'providers';
        providers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPassengerPageDtoOutputItemsInner',
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
