// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_passenger_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPassengerDetailDtoOutputStatusEnum
    _$adminPassengerDetailDtoOutputStatusEnum_ACTIVE =
    const AdminPassengerDetailDtoOutputStatusEnum._('ACTIVE');
const AdminPassengerDetailDtoOutputStatusEnum
    _$adminPassengerDetailDtoOutputStatusEnum_LOCKED =
    const AdminPassengerDetailDtoOutputStatusEnum._('LOCKED');
const AdminPassengerDetailDtoOutputStatusEnum
    _$adminPassengerDetailDtoOutputStatusEnum_DISABLED =
    const AdminPassengerDetailDtoOutputStatusEnum._('DISABLED');

AdminPassengerDetailDtoOutputStatusEnum
    _$adminPassengerDetailDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminPassengerDetailDtoOutputStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminPassengerDetailDtoOutputStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminPassengerDetailDtoOutputStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPassengerDetailDtoOutputStatusEnum>
    _$adminPassengerDetailDtoOutputStatusEnumValues = BuiltSet<
        AdminPassengerDetailDtoOutputStatusEnum>(const <AdminPassengerDetailDtoOutputStatusEnum>[
  _$adminPassengerDetailDtoOutputStatusEnum_ACTIVE,
  _$adminPassengerDetailDtoOutputStatusEnum_LOCKED,
  _$adminPassengerDetailDtoOutputStatusEnum_DISABLED,
]);

Serializer<AdminPassengerDetailDtoOutputStatusEnum>
    _$adminPassengerDetailDtoOutputStatusEnumSerializer =
    _$AdminPassengerDetailDtoOutputStatusEnumSerializer();

class _$AdminPassengerDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminPassengerDetailDtoOutputStatusEnum> {
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
    AdminPassengerDetailDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminPassengerDetailDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPassengerDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPassengerDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPassengerDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPassengerDetailDtoOutput extends AdminPassengerDetailDtoOutput {
  @override
  final String id;
  @override
  final String? name;
  @override
  final String email;
  @override
  final BuiltList<String> providers;
  @override
  final AdminPassengerDetailDtoOutputStatusEnum status;
  @override
  final String? lockedReason;
  @override
  final DateTime? lockedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLoginAt;
  @override
  final bool emailVerified;
  @override
  final String? phone;
  @override
  final int? loyaltyPoints;
  @override
  final int savedPassengerCount;
  @override
  final int bookingCount;
  @override
  final int ticketCount;
  @override
  final int supportTicketCount;
  @override
  final int? totalPaid;

  factory _$AdminPassengerDetailDtoOutput(
          [void Function(AdminPassengerDetailDtoOutputBuilder)? updates]) =>
      (AdminPassengerDetailDtoOutputBuilder()..update(updates))._build();

  _$AdminPassengerDetailDtoOutput._(
      {required this.id,
      this.name,
      required this.email,
      required this.providers,
      required this.status,
      this.lockedReason,
      this.lockedAt,
      required this.createdAt,
      this.lastLoginAt,
      required this.emailVerified,
      this.phone,
      this.loyaltyPoints,
      required this.savedPassengerCount,
      required this.bookingCount,
      required this.ticketCount,
      required this.supportTicketCount,
      this.totalPaid})
      : super._();
  @override
  AdminPassengerDetailDtoOutput rebuild(
          void Function(AdminPassengerDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPassengerDetailDtoOutputBuilder toBuilder() =>
      AdminPassengerDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPassengerDetailDtoOutput &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        providers == other.providers &&
        status == other.status &&
        lockedReason == other.lockedReason &&
        lockedAt == other.lockedAt &&
        createdAt == other.createdAt &&
        lastLoginAt == other.lastLoginAt &&
        emailVerified == other.emailVerified &&
        phone == other.phone &&
        loyaltyPoints == other.loyaltyPoints &&
        savedPassengerCount == other.savedPassengerCount &&
        bookingCount == other.bookingCount &&
        ticketCount == other.ticketCount &&
        supportTicketCount == other.supportTicketCount &&
        totalPaid == other.totalPaid;
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
    _$hash = $jc(_$hash, emailVerified.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, loyaltyPoints.hashCode);
    _$hash = $jc(_$hash, savedPassengerCount.hashCode);
    _$hash = $jc(_$hash, bookingCount.hashCode);
    _$hash = $jc(_$hash, ticketCount.hashCode);
    _$hash = $jc(_$hash, supportTicketCount.hashCode);
    _$hash = $jc(_$hash, totalPaid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPassengerDetailDtoOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('providers', providers)
          ..add('status', status)
          ..add('lockedReason', lockedReason)
          ..add('lockedAt', lockedAt)
          ..add('createdAt', createdAt)
          ..add('lastLoginAt', lastLoginAt)
          ..add('emailVerified', emailVerified)
          ..add('phone', phone)
          ..add('loyaltyPoints', loyaltyPoints)
          ..add('savedPassengerCount', savedPassengerCount)
          ..add('bookingCount', bookingCount)
          ..add('ticketCount', ticketCount)
          ..add('supportTicketCount', supportTicketCount)
          ..add('totalPaid', totalPaid))
        .toString();
  }
}

class AdminPassengerDetailDtoOutputBuilder
    implements
        Builder<AdminPassengerDetailDtoOutput,
            AdminPassengerDetailDtoOutputBuilder> {
  _$AdminPassengerDetailDtoOutput? _$v;

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

  AdminPassengerDetailDtoOutputStatusEnum? _status;
  AdminPassengerDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminPassengerDetailDtoOutputStatusEnum? status) =>
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

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  int? _loyaltyPoints;
  int? get loyaltyPoints => _$this._loyaltyPoints;
  set loyaltyPoints(int? loyaltyPoints) =>
      _$this._loyaltyPoints = loyaltyPoints;

  int? _savedPassengerCount;
  int? get savedPassengerCount => _$this._savedPassengerCount;
  set savedPassengerCount(int? savedPassengerCount) =>
      _$this._savedPassengerCount = savedPassengerCount;

  int? _bookingCount;
  int? get bookingCount => _$this._bookingCount;
  set bookingCount(int? bookingCount) => _$this._bookingCount = bookingCount;

  int? _ticketCount;
  int? get ticketCount => _$this._ticketCount;
  set ticketCount(int? ticketCount) => _$this._ticketCount = ticketCount;

  int? _supportTicketCount;
  int? get supportTicketCount => _$this._supportTicketCount;
  set supportTicketCount(int? supportTicketCount) =>
      _$this._supportTicketCount = supportTicketCount;

  int? _totalPaid;
  int? get totalPaid => _$this._totalPaid;
  set totalPaid(int? totalPaid) => _$this._totalPaid = totalPaid;

  AdminPassengerDetailDtoOutputBuilder() {
    AdminPassengerDetailDtoOutput._defaults(this);
  }

  AdminPassengerDetailDtoOutputBuilder get _$this {
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
      _emailVerified = $v.emailVerified;
      _phone = $v.phone;
      _loyaltyPoints = $v.loyaltyPoints;
      _savedPassengerCount = $v.savedPassengerCount;
      _bookingCount = $v.bookingCount;
      _ticketCount = $v.ticketCount;
      _supportTicketCount = $v.supportTicketCount;
      _totalPaid = $v.totalPaid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPassengerDetailDtoOutput other) {
    _$v = other as _$AdminPassengerDetailDtoOutput;
  }

  @override
  void update(void Function(AdminPassengerDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPassengerDetailDtoOutput build() => _build();

  _$AdminPassengerDetailDtoOutput _build() {
    _$AdminPassengerDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPassengerDetailDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminPassengerDetailDtoOutput', 'id'),
            name: name,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'AdminPassengerDetailDtoOutput', 'email'),
            providers: providers.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminPassengerDetailDtoOutput', 'status'),
            lockedReason: lockedReason,
            lockedAt: lockedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminPassengerDetailDtoOutput', 'createdAt'),
            lastLoginAt: lastLoginAt,
            emailVerified: BuiltValueNullFieldError.checkNotNull(emailVerified,
                r'AdminPassengerDetailDtoOutput', 'emailVerified'),
            phone: phone,
            loyaltyPoints: loyaltyPoints,
            savedPassengerCount: BuiltValueNullFieldError.checkNotNull(
                savedPassengerCount,
                r'AdminPassengerDetailDtoOutput',
                'savedPassengerCount'),
            bookingCount: BuiltValueNullFieldError.checkNotNull(
                bookingCount, r'AdminPassengerDetailDtoOutput', 'bookingCount'),
            ticketCount: BuiltValueNullFieldError.checkNotNull(
                ticketCount, r'AdminPassengerDetailDtoOutput', 'ticketCount'),
            supportTicketCount: BuiltValueNullFieldError.checkNotNull(
                supportTicketCount,
                r'AdminPassengerDetailDtoOutput',
                'supportTicketCount'),
            totalPaid: totalPaid,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'providers';
        providers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPassengerDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
