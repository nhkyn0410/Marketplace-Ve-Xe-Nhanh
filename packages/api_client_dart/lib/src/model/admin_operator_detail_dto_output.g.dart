// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorDetailDtoOutputStatusEnum
    _$adminOperatorDetailDtoOutputStatusEnum_ACTIVE =
    const AdminOperatorDetailDtoOutputStatusEnum._('ACTIVE');
const AdminOperatorDetailDtoOutputStatusEnum
    _$adminOperatorDetailDtoOutputStatusEnum_SUSPENDED =
    const AdminOperatorDetailDtoOutputStatusEnum._('SUSPENDED');

AdminOperatorDetailDtoOutputStatusEnum
    _$adminOperatorDetailDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorDetailDtoOutputStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$adminOperatorDetailDtoOutputStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorDetailDtoOutputStatusEnum>
    _$adminOperatorDetailDtoOutputStatusEnumValues = BuiltSet<
        AdminOperatorDetailDtoOutputStatusEnum>(const <AdminOperatorDetailDtoOutputStatusEnum>[
  _$adminOperatorDetailDtoOutputStatusEnum_ACTIVE,
  _$adminOperatorDetailDtoOutputStatusEnum_SUSPENDED,
]);

Serializer<AdminOperatorDetailDtoOutputStatusEnum>
    _$adminOperatorDetailDtoOutputStatusEnumSerializer =
    _$AdminOperatorDetailDtoOutputStatusEnumSerializer();

class _$AdminOperatorDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminOperatorDetailDtoOutputStatusEnum> {
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
    AdminOperatorDetailDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminOperatorDetailDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorDetailDtoOutput extends AdminOperatorDetailDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final AdminOperatorDetailDtoOutputStatusEnum status;
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
  @override
  final String? legalName;
  @override
  final String? taxCode;
  @override
  final String? hotline;
  @override
  final String? publicEmail;
  @override
  final String? address;
  @override
  final String? description;
  @override
  final AdminOperatorDetailDtoOutputBankAccount? bankAccount;
  @override
  final int vehicleCount;
  @override
  final int employeeCount;
  @override
  final AdminOperatorDetailDtoOutputStats stats;

  factory _$AdminOperatorDetailDtoOutput(
          [void Function(AdminOperatorDetailDtoOutputBuilder)? updates]) =>
      (AdminOperatorDetailDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorDetailDtoOutput._(
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
      required this.bankChangePending,
      this.legalName,
      this.taxCode,
      this.hotline,
      this.publicEmail,
      this.address,
      this.description,
      this.bankAccount,
      required this.vehicleCount,
      required this.employeeCount,
      required this.stats})
      : super._();
  @override
  AdminOperatorDetailDtoOutput rebuild(
          void Function(AdminOperatorDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorDetailDtoOutputBuilder toBuilder() =>
      AdminOperatorDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorDetailDtoOutput &&
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
        bankChangePending == other.bankChangePending &&
        legalName == other.legalName &&
        taxCode == other.taxCode &&
        hotline == other.hotline &&
        publicEmail == other.publicEmail &&
        address == other.address &&
        description == other.description &&
        bankAccount == other.bankAccount &&
        vehicleCount == other.vehicleCount &&
        employeeCount == other.employeeCount &&
        stats == other.stats;
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
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, bankAccount.hashCode);
    _$hash = $jc(_$hash, vehicleCount.hashCode);
    _$hash = $jc(_$hash, employeeCount.hashCode);
    _$hash = $jc(_$hash, stats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOperatorDetailDtoOutput')
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
          ..add('bankChangePending', bankChangePending)
          ..add('legalName', legalName)
          ..add('taxCode', taxCode)
          ..add('hotline', hotline)
          ..add('publicEmail', publicEmail)
          ..add('address', address)
          ..add('description', description)
          ..add('bankAccount', bankAccount)
          ..add('vehicleCount', vehicleCount)
          ..add('employeeCount', employeeCount)
          ..add('stats', stats))
        .toString();
  }
}

class AdminOperatorDetailDtoOutputBuilder
    implements
        Builder<AdminOperatorDetailDtoOutput,
            AdminOperatorDetailDtoOutputBuilder> {
  _$AdminOperatorDetailDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  AdminOperatorDetailDtoOutputStatusEnum? _status;
  AdminOperatorDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminOperatorDetailDtoOutputStatusEnum? status) =>
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

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _taxCode;
  String? get taxCode => _$this._taxCode;
  set taxCode(String? taxCode) => _$this._taxCode = taxCode;

  String? _hotline;
  String? get hotline => _$this._hotline;
  set hotline(String? hotline) => _$this._hotline = hotline;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminOperatorDetailDtoOutputBankAccountBuilder? _bankAccount;
  AdminOperatorDetailDtoOutputBankAccountBuilder get bankAccount =>
      _$this._bankAccount ??= AdminOperatorDetailDtoOutputBankAccountBuilder();
  set bankAccount(
          AdminOperatorDetailDtoOutputBankAccountBuilder? bankAccount) =>
      _$this._bankAccount = bankAccount;

  int? _vehicleCount;
  int? get vehicleCount => _$this._vehicleCount;
  set vehicleCount(int? vehicleCount) => _$this._vehicleCount = vehicleCount;

  int? _employeeCount;
  int? get employeeCount => _$this._employeeCount;
  set employeeCount(int? employeeCount) =>
      _$this._employeeCount = employeeCount;

  AdminOperatorDetailDtoOutputStatsBuilder? _stats;
  AdminOperatorDetailDtoOutputStatsBuilder get stats =>
      _$this._stats ??= AdminOperatorDetailDtoOutputStatsBuilder();
  set stats(AdminOperatorDetailDtoOutputStatsBuilder? stats) =>
      _$this._stats = stats;

  AdminOperatorDetailDtoOutputBuilder() {
    AdminOperatorDetailDtoOutput._defaults(this);
  }

  AdminOperatorDetailDtoOutputBuilder get _$this {
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
      _legalName = $v.legalName;
      _taxCode = $v.taxCode;
      _hotline = $v.hotline;
      _publicEmail = $v.publicEmail;
      _address = $v.address;
      _description = $v.description;
      _bankAccount = $v.bankAccount?.toBuilder();
      _vehicleCount = $v.vehicleCount;
      _employeeCount = $v.employeeCount;
      _stats = $v.stats.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorDetailDtoOutput other) {
    _$v = other as _$AdminOperatorDetailDtoOutput;
  }

  @override
  void update(void Function(AdminOperatorDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorDetailDtoOutput build() => _build();

  _$AdminOperatorDetailDtoOutput _build() {
    _$AdminOperatorDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminOperatorDetailDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminOperatorDetailDtoOutput', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AdminOperatorDetailDtoOutput', 'name'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'AdminOperatorDetailDtoOutput', 'slug'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminOperatorDetailDtoOutput', 'status'),
            suspendedReason: suspendedReason,
            suspendedAt: suspendedAt,
            approvedAt: BuiltValueNullFieldError.checkNotNull(
                approvedAt, r'AdminOperatorDetailDtoOutput', 'approvedAt'),
            applicationId: applicationId,
            owner: _owner?.build(),
            routeCount: BuiltValueNullFieldError.checkNotNull(
                routeCount, r'AdminOperatorDetailDtoOutput', 'routeCount'),
            openTripCount: BuiltValueNullFieldError.checkNotNull(openTripCount,
                r'AdminOperatorDetailDtoOutput', 'openTripCount'),
            bankChangePending: BuiltValueNullFieldError.checkNotNull(
                bankChangePending,
                r'AdminOperatorDetailDtoOutput',
                'bankChangePending'),
            legalName: legalName,
            taxCode: taxCode,
            hotline: hotline,
            publicEmail: publicEmail,
            address: address,
            description: description,
            bankAccount: _bankAccount?.build(),
            vehicleCount: BuiltValueNullFieldError.checkNotNull(
                vehicleCount, r'AdminOperatorDetailDtoOutput', 'vehicleCount'),
            employeeCount: BuiltValueNullFieldError.checkNotNull(employeeCount,
                r'AdminOperatorDetailDtoOutput', 'employeeCount'),
            stats: stats.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        _owner?.build();

        _$failedField = 'bankAccount';
        _bankAccount?.build();

        _$failedField = 'stats';
        stats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminOperatorDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
