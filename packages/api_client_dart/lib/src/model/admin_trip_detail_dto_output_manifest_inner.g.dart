// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_detail_dto_output_manifest_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnum_VALID =
    const AdminTripDetailDtoOutputManifestInnerStatusEnum._('VALID');
const AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnum_CANCELLED =
    const AdminTripDetailDtoOutputManifestInnerStatusEnum._('CANCELLED');
const AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnum_CHECKED_IN =
    const AdminTripDetailDtoOutputManifestInnerStatusEnum._('CHECKED_IN');
const AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnum_NO_SHOW =
    const AdminTripDetailDtoOutputManifestInnerStatusEnum._('NO_SHOW');
const AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnum_USED =
    const AdminTripDetailDtoOutputManifestInnerStatusEnum._('USED');
const AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnum_REFUNDED =
    const AdminTripDetailDtoOutputManifestInnerStatusEnum._('REFUNDED');

AdminTripDetailDtoOutputManifestInnerStatusEnum
    _$adminTripDetailDtoOutputManifestInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$adminTripDetailDtoOutputManifestInnerStatusEnum_VALID;
    case 'CANCELLED':
      return _$adminTripDetailDtoOutputManifestInnerStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$adminTripDetailDtoOutputManifestInnerStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$adminTripDetailDtoOutputManifestInnerStatusEnum_NO_SHOW;
    case 'USED':
      return _$adminTripDetailDtoOutputManifestInnerStatusEnum_USED;
    case 'REFUNDED':
      return _$adminTripDetailDtoOutputManifestInnerStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTripDetailDtoOutputManifestInnerStatusEnum>
    _$adminTripDetailDtoOutputManifestInnerStatusEnumValues = BuiltSet<
        AdminTripDetailDtoOutputManifestInnerStatusEnum>(const <AdminTripDetailDtoOutputManifestInnerStatusEnum>[
  _$adminTripDetailDtoOutputManifestInnerStatusEnum_VALID,
  _$adminTripDetailDtoOutputManifestInnerStatusEnum_CANCELLED,
  _$adminTripDetailDtoOutputManifestInnerStatusEnum_CHECKED_IN,
  _$adminTripDetailDtoOutputManifestInnerStatusEnum_NO_SHOW,
  _$adminTripDetailDtoOutputManifestInnerStatusEnum_USED,
  _$adminTripDetailDtoOutputManifestInnerStatusEnum_REFUNDED,
]);

const AdminTripDetailDtoOutputManifestInnerChannelEnum
    _$adminTripDetailDtoOutputManifestInnerChannelEnum_ONLINE =
    const AdminTripDetailDtoOutputManifestInnerChannelEnum._('ONLINE');
const AdminTripDetailDtoOutputManifestInnerChannelEnum
    _$adminTripDetailDtoOutputManifestInnerChannelEnum_COUNTER =
    const AdminTripDetailDtoOutputManifestInnerChannelEnum._('COUNTER');

AdminTripDetailDtoOutputManifestInnerChannelEnum
    _$adminTripDetailDtoOutputManifestInnerChannelEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$adminTripDetailDtoOutputManifestInnerChannelEnum_ONLINE;
    case 'COUNTER':
      return _$adminTripDetailDtoOutputManifestInnerChannelEnum_COUNTER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTripDetailDtoOutputManifestInnerChannelEnum>
    _$adminTripDetailDtoOutputManifestInnerChannelEnumValues = BuiltSet<
        AdminTripDetailDtoOutputManifestInnerChannelEnum>(const <AdminTripDetailDtoOutputManifestInnerChannelEnum>[
  _$adminTripDetailDtoOutputManifestInnerChannelEnum_ONLINE,
  _$adminTripDetailDtoOutputManifestInnerChannelEnum_COUNTER,
]);

Serializer<AdminTripDetailDtoOutputManifestInnerStatusEnum>
    _$adminTripDetailDtoOutputManifestInnerStatusEnumSerializer =
    _$AdminTripDetailDtoOutputManifestInnerStatusEnumSerializer();
Serializer<AdminTripDetailDtoOutputManifestInnerChannelEnum>
    _$adminTripDetailDtoOutputManifestInnerChannelEnumSerializer =
    _$AdminTripDetailDtoOutputManifestInnerChannelEnumSerializer();

class _$AdminTripDetailDtoOutputManifestInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminTripDetailDtoOutputManifestInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'CANCELLED': 'CANCELLED',
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
    'REFUNDED': 'REFUNDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'CANCELLED': 'CANCELLED',
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
    'REFUNDED': 'REFUNDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTripDetailDtoOutputManifestInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminTripDetailDtoOutputManifestInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminTripDetailDtoOutputManifestInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminTripDetailDtoOutputManifestInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminTripDetailDtoOutputManifestInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminTripDetailDtoOutputManifestInnerChannelEnumSerializer
    implements
        PrimitiveSerializer<AdminTripDetailDtoOutputManifestInnerChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTripDetailDtoOutputManifestInnerChannelEnum
  ];
  @override
  final String wireName = 'AdminTripDetailDtoOutputManifestInnerChannelEnum';

  @override
  Object serialize(Serializers serializers,
          AdminTripDetailDtoOutputManifestInnerChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminTripDetailDtoOutputManifestInnerChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminTripDetailDtoOutputManifestInnerChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminTripDetailDtoOutputManifestInner
    extends AdminTripDetailDtoOutputManifestInner {
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final String fullName;
  @override
  final String? companionName;
  @override
  final String? phone;
  @override
  final AdminTripDetailDtoOutputManifestInnerStatusEnum status;
  @override
  final String bookingCode;
  @override
  final AdminTripDetailDtoOutputManifestInnerChannelEnum channel;
  @override
  final bool guest;
  @override
  final String? userId;

  factory _$AdminTripDetailDtoOutputManifestInner(
          [void Function(AdminTripDetailDtoOutputManifestInnerBuilder)?
              updates]) =>
      (AdminTripDetailDtoOutputManifestInnerBuilder()..update(updates))
          ._build();

  _$AdminTripDetailDtoOutputManifestInner._(
      {required this.ticketCode,
      required this.seatCode,
      required this.fullName,
      this.companionName,
      this.phone,
      required this.status,
      required this.bookingCode,
      required this.channel,
      required this.guest,
      this.userId})
      : super._();
  @override
  AdminTripDetailDtoOutputManifestInner rebuild(
          void Function(AdminTripDetailDtoOutputManifestInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripDetailDtoOutputManifestInnerBuilder toBuilder() =>
      AdminTripDetailDtoOutputManifestInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripDetailDtoOutputManifestInner &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        fullName == other.fullName &&
        companionName == other.companionName &&
        phone == other.phone &&
        status == other.status &&
        bookingCode == other.bookingCode &&
        channel == other.channel &&
        guest == other.guest &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, companionName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, guest.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTripDetailDtoOutputManifestInner')
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('fullName', fullName)
          ..add('companionName', companionName)
          ..add('phone', phone)
          ..add('status', status)
          ..add('bookingCode', bookingCode)
          ..add('channel', channel)
          ..add('guest', guest)
          ..add('userId', userId))
        .toString();
  }
}

class AdminTripDetailDtoOutputManifestInnerBuilder
    implements
        Builder<AdminTripDetailDtoOutputManifestInner,
            AdminTripDetailDtoOutputManifestInnerBuilder> {
  _$AdminTripDetailDtoOutputManifestInner? _$v;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _companionName;
  String? get companionName => _$this._companionName;
  set companionName(String? companionName) =>
      _$this._companionName = companionName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  AdminTripDetailDtoOutputManifestInnerStatusEnum? _status;
  AdminTripDetailDtoOutputManifestInnerStatusEnum? get status => _$this._status;
  set status(AdminTripDetailDtoOutputManifestInnerStatusEnum? status) =>
      _$this._status = status;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  AdminTripDetailDtoOutputManifestInnerChannelEnum? _channel;
  AdminTripDetailDtoOutputManifestInnerChannelEnum? get channel =>
      _$this._channel;
  set channel(AdminTripDetailDtoOutputManifestInnerChannelEnum? channel) =>
      _$this._channel = channel;

  bool? _guest;
  bool? get guest => _$this._guest;
  set guest(bool? guest) => _$this._guest = guest;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  AdminTripDetailDtoOutputManifestInnerBuilder() {
    AdminTripDetailDtoOutputManifestInner._defaults(this);
  }

  AdminTripDetailDtoOutputManifestInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _fullName = $v.fullName;
      _companionName = $v.companionName;
      _phone = $v.phone;
      _status = $v.status;
      _bookingCode = $v.bookingCode;
      _channel = $v.channel;
      _guest = $v.guest;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTripDetailDtoOutputManifestInner other) {
    _$v = other as _$AdminTripDetailDtoOutputManifestInner;
  }

  @override
  void update(
      void Function(AdminTripDetailDtoOutputManifestInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripDetailDtoOutputManifestInner build() => _build();

  _$AdminTripDetailDtoOutputManifestInner _build() {
    final _$result = _$v ??
        _$AdminTripDetailDtoOutputManifestInner._(
          ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
              r'AdminTripDetailDtoOutputManifestInner', 'ticketCode'),
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'AdminTripDetailDtoOutputManifestInner', 'seatCode'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'AdminTripDetailDtoOutputManifestInner', 'fullName'),
          companionName: companionName,
          phone: phone,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminTripDetailDtoOutputManifestInner', 'status'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'AdminTripDetailDtoOutputManifestInner', 'bookingCode'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'AdminTripDetailDtoOutputManifestInner', 'channel'),
          guest: BuiltValueNullFieldError.checkNotNull(
              guest, r'AdminTripDetailDtoOutputManifestInner', 'guest'),
          userId: userId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
