// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminOperatorPageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminOperatorPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerStatusEnum_SUSPENDED =
    const AdminOperatorPageDtoOutputItemsInnerStatusEnum._('SUSPENDED');

AdminOperatorPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorPageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$adminOperatorPageDtoOutputItemsInnerStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorPageDtoOutputItemsInnerStatusEnum>
    _$adminOperatorPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminOperatorPageDtoOutputItemsInnerStatusEnum>(const <AdminOperatorPageDtoOutputItemsInnerStatusEnum>[
  _$adminOperatorPageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminOperatorPageDtoOutputItemsInnerStatusEnum_SUSPENDED,
]);

Serializer<AdminOperatorPageDtoOutputItemsInnerStatusEnum>
    _$adminOperatorPageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminOperatorPageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminOperatorPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminOperatorPageDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOperatorPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminOperatorPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorPageDtoOutputItemsInner
    extends AdminOperatorPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final AdminOperatorPageDtoOutputItemsInnerStatusEnum status;
  @override
  final String? suspendedReason;
  @override
  final DateTime? suspendedAt;
  @override
  final DateTime approvedAt;
  @override
  final String? applicationId;
  @override
  final AdminOperatorPageDtoOutputItemsInnerOwner? owner;
  @override
  final int routeCount;
  @override
  final int openTripCount;
  @override
  final bool bankChangePending;

  factory _$AdminOperatorPageDtoOutputItemsInner(
          [void Function(AdminOperatorPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminOperatorPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminOperatorPageDtoOutputItemsInner._(
      {required this.id,
      required this.name,
      required this.slug,
      required this.status,
      this.suspendedReason,
      this.suspendedAt,
      required this.approvedAt,
      this.applicationId,
      this.owner,
      required this.routeCount,
      required this.openTripCount,
      required this.bankChangePending})
      : super._();
  @override
  AdminOperatorPageDtoOutputItemsInner rebuild(
          void Function(AdminOperatorPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminOperatorPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorPageDtoOutputItemsInner &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        status == other.status &&
        suspendedReason == other.suspendedReason &&
        suspendedAt == other.suspendedAt &&
        approvedAt == other.approvedAt &&
        applicationId == other.applicationId &&
        owner == other.owner &&
        routeCount == other.routeCount &&
        openTripCount == other.openTripCount &&
        bankChangePending == other.bankChangePending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, suspendedReason.hashCode);
    _$hash = $jc(_$hash, suspendedAt.hashCode);
    _$hash = $jc(_$hash, approvedAt.hashCode);
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jc(_$hash, routeCount.hashCode);
    _$hash = $jc(_$hash, openTripCount.hashCode);
    _$hash = $jc(_$hash, bankChangePending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOperatorPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug)
          ..add('status', status)
          ..add('suspendedReason', suspendedReason)
          ..add('suspendedAt', suspendedAt)
          ..add('approvedAt', approvedAt)
          ..add('applicationId', applicationId)
          ..add('owner', owner)
          ..add('routeCount', routeCount)
          ..add('openTripCount', openTripCount)
          ..add('bankChangePending', bankChangePending))
        .toString();
  }
}

class AdminOperatorPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminOperatorPageDtoOutputItemsInner,
            AdminOperatorPageDtoOutputItemsInnerBuilder> {
  _$AdminOperatorPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  AdminOperatorPageDtoOutputItemsInnerStatusEnum? _status;
  AdminOperatorPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminOperatorPageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _suspendedReason;
  String? get suspendedReason => _$this._suspendedReason;
  set suspendedReason(String? suspendedReason) =>
      _$this._suspendedReason = suspendedReason;

  DateTime? _suspendedAt;
  DateTime? get suspendedAt => _$this._suspendedAt;
  set suspendedAt(DateTime? suspendedAt) => _$this._suspendedAt = suspendedAt;

  DateTime? _approvedAt;
  DateTime? get approvedAt => _$this._approvedAt;
  set approvedAt(DateTime? approvedAt) => _$this._approvedAt = approvedAt;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  AdminOperatorPageDtoOutputItemsInnerOwnerBuilder? _owner;
  AdminOperatorPageDtoOutputItemsInnerOwnerBuilder get owner =>
      _$this._owner ??= AdminOperatorPageDtoOutputItemsInnerOwnerBuilder();
  set owner(AdminOperatorPageDtoOutputItemsInnerOwnerBuilder? owner) =>
      _$this._owner = owner;

  int? _routeCount;
  int? get routeCount => _$this._routeCount;
  set routeCount(int? routeCount) => _$this._routeCount = routeCount;

  int? _openTripCount;
  int? get openTripCount => _$this._openTripCount;
  set openTripCount(int? openTripCount) =>
      _$this._openTripCount = openTripCount;

  bool? _bankChangePending;
  bool? get bankChangePending => _$this._bankChangePending;
  set bankChangePending(bool? bankChangePending) =>
      _$this._bankChangePending = bankChangePending;

  AdminOperatorPageDtoOutputItemsInnerBuilder() {
    AdminOperatorPageDtoOutputItemsInner._defaults(this);
  }

  AdminOperatorPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _slug = $v.slug;
      _status = $v.status;
      _suspendedReason = $v.suspendedReason;
      _suspendedAt = $v.suspendedAt;
      _approvedAt = $v.approvedAt;
      _applicationId = $v.applicationId;
      _owner = $v.owner?.toBuilder();
      _routeCount = $v.routeCount;
      _openTripCount = $v.openTripCount;
      _bankChangePending = $v.bankChangePending;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorPageDtoOutputItemsInner other) {
    _$v = other as _$AdminOperatorPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminOperatorPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorPageDtoOutputItemsInner build() => _build();

  _$AdminOperatorPageDtoOutputItemsInner _build() {
    _$AdminOperatorPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminOperatorPageDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminOperatorPageDtoOutputItemsInner', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AdminOperatorPageDtoOutputItemsInner', 'name'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'AdminOperatorPageDtoOutputItemsInner', 'slug'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminOperatorPageDtoOutputItemsInner', 'status'),
            suspendedReason: suspendedReason,
            suspendedAt: suspendedAt,
            approvedAt: BuiltValueNullFieldError.checkNotNull(approvedAt,
                r'AdminOperatorPageDtoOutputItemsInner', 'approvedAt'),
            applicationId: applicationId,
            owner: _owner?.build(),
            routeCount: BuiltValueNullFieldError.checkNotNull(routeCount,
                r'AdminOperatorPageDtoOutputItemsInner', 'routeCount'),
            openTripCount: BuiltValueNullFieldError.checkNotNull(openTripCount,
                r'AdminOperatorPageDtoOutputItemsInner', 'openTripCount'),
            bankChangePending: BuiltValueNullFieldError.checkNotNull(
                bankChangePending,
                r'AdminOperatorPageDtoOutputItemsInner',
                'bankChangePending'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        _owner?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminOperatorPageDtoOutputItemsInner',
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
