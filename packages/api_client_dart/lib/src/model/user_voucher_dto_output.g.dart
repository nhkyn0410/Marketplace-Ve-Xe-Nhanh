// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_voucher_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserVoucherDtoOutputSource_Enum
    _$userVoucherDtoOutputSourceEnum_LOYALTY_REDEMPTION =
    const UserVoucherDtoOutputSource_Enum._('LOYALTY_REDEMPTION');
const UserVoucherDtoOutputSource_Enum
    _$userVoucherDtoOutputSourceEnum_SAVED_PROMOTION =
    const UserVoucherDtoOutputSource_Enum._('SAVED_PROMOTION');

UserVoucherDtoOutputSource_Enum _$userVoucherDtoOutputSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'LOYALTY_REDEMPTION':
      return _$userVoucherDtoOutputSourceEnum_LOYALTY_REDEMPTION;
    case 'SAVED_PROMOTION':
      return _$userVoucherDtoOutputSourceEnum_SAVED_PROMOTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserVoucherDtoOutputSource_Enum>
    _$userVoucherDtoOutputSourceEnumValues = BuiltSet<
        UserVoucherDtoOutputSource_Enum>(const <UserVoucherDtoOutputSource_Enum>[
  _$userVoucherDtoOutputSourceEnum_LOYALTY_REDEMPTION,
  _$userVoucherDtoOutputSourceEnum_SAVED_PROMOTION,
]);

const UserVoucherDtoOutputStatusEnum
    _$userVoucherDtoOutputStatusEnum_AVAILABLE =
    const UserVoucherDtoOutputStatusEnum._('AVAILABLE');
const UserVoucherDtoOutputStatusEnum _$userVoucherDtoOutputStatusEnum_RESERVED =
    const UserVoucherDtoOutputStatusEnum._('RESERVED');
const UserVoucherDtoOutputStatusEnum _$userVoucherDtoOutputStatusEnum_USED =
    const UserVoucherDtoOutputStatusEnum._('USED');
const UserVoucherDtoOutputStatusEnum _$userVoucherDtoOutputStatusEnum_EXPIRED =
    const UserVoucherDtoOutputStatusEnum._('EXPIRED');

UserVoucherDtoOutputStatusEnum _$userVoucherDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$userVoucherDtoOutputStatusEnum_AVAILABLE;
    case 'RESERVED':
      return _$userVoucherDtoOutputStatusEnum_RESERVED;
    case 'USED':
      return _$userVoucherDtoOutputStatusEnum_USED;
    case 'EXPIRED':
      return _$userVoucherDtoOutputStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserVoucherDtoOutputStatusEnum>
    _$userVoucherDtoOutputStatusEnumValues = BuiltSet<
        UserVoucherDtoOutputStatusEnum>(const <UserVoucherDtoOutputStatusEnum>[
  _$userVoucherDtoOutputStatusEnum_AVAILABLE,
  _$userVoucherDtoOutputStatusEnum_RESERVED,
  _$userVoucherDtoOutputStatusEnum_USED,
  _$userVoucherDtoOutputStatusEnum_EXPIRED,
]);

const UserVoucherDtoOutputDiscountTypeEnum
    _$userVoucherDtoOutputDiscountTypeEnum_PERCENT =
    const UserVoucherDtoOutputDiscountTypeEnum._('PERCENT');
const UserVoucherDtoOutputDiscountTypeEnum
    _$userVoucherDtoOutputDiscountTypeEnum_AMOUNT =
    const UserVoucherDtoOutputDiscountTypeEnum._('AMOUNT');

UserVoucherDtoOutputDiscountTypeEnum
    _$userVoucherDtoOutputDiscountTypeEnumValueOf(String name) {
  switch (name) {
    case 'PERCENT':
      return _$userVoucherDtoOutputDiscountTypeEnum_PERCENT;
    case 'AMOUNT':
      return _$userVoucherDtoOutputDiscountTypeEnum_AMOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserVoucherDtoOutputDiscountTypeEnum>
    _$userVoucherDtoOutputDiscountTypeEnumValues = BuiltSet<
        UserVoucherDtoOutputDiscountTypeEnum>(const <UserVoucherDtoOutputDiscountTypeEnum>[
  _$userVoucherDtoOutputDiscountTypeEnum_PERCENT,
  _$userVoucherDtoOutputDiscountTypeEnum_AMOUNT,
]);

Serializer<UserVoucherDtoOutputSource_Enum>
    _$userVoucherDtoOutputSourceEnumSerializer =
    _$UserVoucherDtoOutputSource_EnumSerializer();
Serializer<UserVoucherDtoOutputStatusEnum>
    _$userVoucherDtoOutputStatusEnumSerializer =
    _$UserVoucherDtoOutputStatusEnumSerializer();
Serializer<UserVoucherDtoOutputDiscountTypeEnum>
    _$userVoucherDtoOutputDiscountTypeEnumSerializer =
    _$UserVoucherDtoOutputDiscountTypeEnumSerializer();

class _$UserVoucherDtoOutputSource_EnumSerializer
    implements PrimitiveSerializer<UserVoucherDtoOutputSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LOYALTY_REDEMPTION': 'LOYALTY_REDEMPTION',
    'SAVED_PROMOTION': 'SAVED_PROMOTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LOYALTY_REDEMPTION': 'LOYALTY_REDEMPTION',
    'SAVED_PROMOTION': 'SAVED_PROMOTION',
  };

  @override
  final Iterable<Type> types = const <Type>[UserVoucherDtoOutputSource_Enum];
  @override
  final String wireName = 'UserVoucherDtoOutputSource_Enum';

  @override
  Object serialize(
          Serializers serializers, UserVoucherDtoOutputSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserVoucherDtoOutputSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserVoucherDtoOutputSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserVoucherDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<UserVoucherDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'RESERVED': 'RESERVED',
    'USED': 'USED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'RESERVED': 'RESERVED',
    'USED': 'USED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[UserVoucherDtoOutputStatusEnum];
  @override
  final String wireName = 'UserVoucherDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, UserVoucherDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserVoucherDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserVoucherDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserVoucherDtoOutputDiscountTypeEnumSerializer
    implements PrimitiveSerializer<UserVoucherDtoOutputDiscountTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UserVoucherDtoOutputDiscountTypeEnum
  ];
  @override
  final String wireName = 'UserVoucherDtoOutputDiscountTypeEnum';

  @override
  Object serialize(
          Serializers serializers, UserVoucherDtoOutputDiscountTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserVoucherDtoOutputDiscountTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserVoucherDtoOutputDiscountTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserVoucherDtoOutput extends UserVoucherDtoOutput {
  @override
  final String userVoucherId;
  @override
  final UserVoucherDtoOutputSource_Enum source_;
  @override
  final UserVoucherDtoOutputStatusEnum status;
  @override
  final String? promotionCode;
  @override
  final String name;
  @override
  final String? discountAmount;
  @override
  final UserVoucherDtoOutputDiscountTypeEnum discountType;
  @override
  final String discountValue;
  @override
  final String? maxDiscount;
  @override
  final String minOrder;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;

  factory _$UserVoucherDtoOutput(
          [void Function(UserVoucherDtoOutputBuilder)? updates]) =>
      (UserVoucherDtoOutputBuilder()..update(updates))._build();

  _$UserVoucherDtoOutput._(
      {required this.userVoucherId,
      required this.source_,
      required this.status,
      this.promotionCode,
      required this.name,
      this.discountAmount,
      required this.discountType,
      required this.discountValue,
      this.maxDiscount,
      required this.minOrder,
      required this.expiresAt,
      required this.createdAt})
      : super._();
  @override
  UserVoucherDtoOutput rebuild(
          void Function(UserVoucherDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserVoucherDtoOutputBuilder toBuilder() =>
      UserVoucherDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserVoucherDtoOutput &&
        userVoucherId == other.userVoucherId &&
        source_ == other.source_ &&
        status == other.status &&
        promotionCode == other.promotionCode &&
        name == other.name &&
        discountAmount == other.discountAmount &&
        discountType == other.discountType &&
        discountValue == other.discountValue &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        expiresAt == other.expiresAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userVoucherId.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, promotionCode.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, discountType.hashCode);
    _$hash = $jc(_$hash, discountValue.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserVoucherDtoOutput')
          ..add('userVoucherId', userVoucherId)
          ..add('source_', source_)
          ..add('status', status)
          ..add('promotionCode', promotionCode)
          ..add('name', name)
          ..add('discountAmount', discountAmount)
          ..add('discountType', discountType)
          ..add('discountValue', discountValue)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('expiresAt', expiresAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class UserVoucherDtoOutputBuilder
    implements Builder<UserVoucherDtoOutput, UserVoucherDtoOutputBuilder> {
  _$UserVoucherDtoOutput? _$v;

  String? _userVoucherId;
  String? get userVoucherId => _$this._userVoucherId;
  set userVoucherId(String? userVoucherId) =>
      _$this._userVoucherId = userVoucherId;

  UserVoucherDtoOutputSource_Enum? _source_;
  UserVoucherDtoOutputSource_Enum? get source_ => _$this._source_;
  set source_(UserVoucherDtoOutputSource_Enum? source_) =>
      _$this._source_ = source_;

  UserVoucherDtoOutputStatusEnum? _status;
  UserVoucherDtoOutputStatusEnum? get status => _$this._status;
  set status(UserVoucherDtoOutputStatusEnum? status) => _$this._status = status;

  String? _promotionCode;
  String? get promotionCode => _$this._promotionCode;
  set promotionCode(String? promotionCode) =>
      _$this._promotionCode = promotionCode;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _discountAmount;
  String? get discountAmount => _$this._discountAmount;
  set discountAmount(String? discountAmount) =>
      _$this._discountAmount = discountAmount;

  UserVoucherDtoOutputDiscountTypeEnum? _discountType;
  UserVoucherDtoOutputDiscountTypeEnum? get discountType =>
      _$this._discountType;
  set discountType(UserVoucherDtoOutputDiscountTypeEnum? discountType) =>
      _$this._discountType = discountType;

  String? _discountValue;
  String? get discountValue => _$this._discountValue;
  set discountValue(String? discountValue) =>
      _$this._discountValue = discountValue;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  String? _minOrder;
  String? get minOrder => _$this._minOrder;
  set minOrder(String? minOrder) => _$this._minOrder = minOrder;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserVoucherDtoOutputBuilder() {
    UserVoucherDtoOutput._defaults(this);
  }

  UserVoucherDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userVoucherId = $v.userVoucherId;
      _source_ = $v.source_;
      _status = $v.status;
      _promotionCode = $v.promotionCode;
      _name = $v.name;
      _discountAmount = $v.discountAmount;
      _discountType = $v.discountType;
      _discountValue = $v.discountValue;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _expiresAt = $v.expiresAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserVoucherDtoOutput other) {
    _$v = other as _$UserVoucherDtoOutput;
  }

  @override
  void update(void Function(UserVoucherDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserVoucherDtoOutput build() => _build();

  _$UserVoucherDtoOutput _build() {
    final _$result = _$v ??
        _$UserVoucherDtoOutput._(
          userVoucherId: BuiltValueNullFieldError.checkNotNull(
              userVoucherId, r'UserVoucherDtoOutput', 'userVoucherId'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'UserVoucherDtoOutput', 'source_'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'UserVoucherDtoOutput', 'status'),
          promotionCode: promotionCode,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserVoucherDtoOutput', 'name'),
          discountAmount: discountAmount,
          discountType: BuiltValueNullFieldError.checkNotNull(
              discountType, r'UserVoucherDtoOutput', 'discountType'),
          discountValue: BuiltValueNullFieldError.checkNotNull(
              discountValue, r'UserVoucherDtoOutput', 'discountValue'),
          maxDiscount: maxDiscount,
          minOrder: BuiltValueNullFieldError.checkNotNull(
              minOrder, r'UserVoucherDtoOutput', 'minOrder'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'UserVoucherDtoOutput', 'expiresAt'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'UserVoucherDtoOutput', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
