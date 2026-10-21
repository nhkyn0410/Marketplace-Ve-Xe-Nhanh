// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_voucher_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserVoucherPageDtoOutputItemsInnerSource_Enum
    _$userVoucherPageDtoOutputItemsInnerSourceEnum_LOYALTY_REDEMPTION =
    const UserVoucherPageDtoOutputItemsInnerSource_Enum._('LOYALTY_REDEMPTION');
const UserVoucherPageDtoOutputItemsInnerSource_Enum
    _$userVoucherPageDtoOutputItemsInnerSourceEnum_SAVED_PROMOTION =
    const UserVoucherPageDtoOutputItemsInnerSource_Enum._('SAVED_PROMOTION');

UserVoucherPageDtoOutputItemsInnerSource_Enum
    _$userVoucherPageDtoOutputItemsInnerSourceEnumValueOf(String name) {
  switch (name) {
    case 'LOYALTY_REDEMPTION':
      return _$userVoucherPageDtoOutputItemsInnerSourceEnum_LOYALTY_REDEMPTION;
    case 'SAVED_PROMOTION':
      return _$userVoucherPageDtoOutputItemsInnerSourceEnum_SAVED_PROMOTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserVoucherPageDtoOutputItemsInnerSource_Enum>
    _$userVoucherPageDtoOutputItemsInnerSourceEnumValues = BuiltSet<
        UserVoucherPageDtoOutputItemsInnerSource_Enum>(const <UserVoucherPageDtoOutputItemsInnerSource_Enum>[
  _$userVoucherPageDtoOutputItemsInnerSourceEnum_LOYALTY_REDEMPTION,
  _$userVoucherPageDtoOutputItemsInnerSourceEnum_SAVED_PROMOTION,
]);

const UserVoucherPageDtoOutputItemsInnerStatusEnum
    _$userVoucherPageDtoOutputItemsInnerStatusEnum_AVAILABLE =
    const UserVoucherPageDtoOutputItemsInnerStatusEnum._('AVAILABLE');
const UserVoucherPageDtoOutputItemsInnerStatusEnum
    _$userVoucherPageDtoOutputItemsInnerStatusEnum_RESERVED =
    const UserVoucherPageDtoOutputItemsInnerStatusEnum._('RESERVED');
const UserVoucherPageDtoOutputItemsInnerStatusEnum
    _$userVoucherPageDtoOutputItemsInnerStatusEnum_USED =
    const UserVoucherPageDtoOutputItemsInnerStatusEnum._('USED');
const UserVoucherPageDtoOutputItemsInnerStatusEnum
    _$userVoucherPageDtoOutputItemsInnerStatusEnum_EXPIRED =
    const UserVoucherPageDtoOutputItemsInnerStatusEnum._('EXPIRED');

UserVoucherPageDtoOutputItemsInnerStatusEnum
    _$userVoucherPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$userVoucherPageDtoOutputItemsInnerStatusEnum_AVAILABLE;
    case 'RESERVED':
      return _$userVoucherPageDtoOutputItemsInnerStatusEnum_RESERVED;
    case 'USED':
      return _$userVoucherPageDtoOutputItemsInnerStatusEnum_USED;
    case 'EXPIRED':
      return _$userVoucherPageDtoOutputItemsInnerStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserVoucherPageDtoOutputItemsInnerStatusEnum>
    _$userVoucherPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        UserVoucherPageDtoOutputItemsInnerStatusEnum>(const <UserVoucherPageDtoOutputItemsInnerStatusEnum>[
  _$userVoucherPageDtoOutputItemsInnerStatusEnum_AVAILABLE,
  _$userVoucherPageDtoOutputItemsInnerStatusEnum_RESERVED,
  _$userVoucherPageDtoOutputItemsInnerStatusEnum_USED,
  _$userVoucherPageDtoOutputItemsInnerStatusEnum_EXPIRED,
]);

const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum
    _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_PERCENT =
    const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum._('PERCENT');
const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum
    _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_AMOUNT =
    const UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum._('AMOUNT');

UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum
    _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnumValueOf(String name) {
  switch (name) {
    case 'PERCENT':
      return _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_PERCENT;
    case 'AMOUNT':
      return _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_AMOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum>
    _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnumValues = BuiltSet<
        UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum>(const <UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum>[
  _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_PERCENT,
  _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnum_AMOUNT,
]);

Serializer<UserVoucherPageDtoOutputItemsInnerSource_Enum>
    _$userVoucherPageDtoOutputItemsInnerSourceEnumSerializer =
    _$UserVoucherPageDtoOutputItemsInnerSource_EnumSerializer();
Serializer<UserVoucherPageDtoOutputItemsInnerStatusEnum>
    _$userVoucherPageDtoOutputItemsInnerStatusEnumSerializer =
    _$UserVoucherPageDtoOutputItemsInnerStatusEnumSerializer();
Serializer<UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum>
    _$userVoucherPageDtoOutputItemsInnerDiscountTypeEnumSerializer =
    _$UserVoucherPageDtoOutputItemsInnerDiscountTypeEnumSerializer();

class _$UserVoucherPageDtoOutputItemsInnerSource_EnumSerializer
    implements
        PrimitiveSerializer<UserVoucherPageDtoOutputItemsInnerSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LOYALTY_REDEMPTION': 'LOYALTY_REDEMPTION',
    'SAVED_PROMOTION': 'SAVED_PROMOTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LOYALTY_REDEMPTION': 'LOYALTY_REDEMPTION',
    'SAVED_PROMOTION': 'SAVED_PROMOTION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UserVoucherPageDtoOutputItemsInnerSource_Enum
  ];
  @override
  final String wireName = 'UserVoucherPageDtoOutputItemsInnerSource_Enum';

  @override
  Object serialize(Serializers serializers,
          UserVoucherPageDtoOutputItemsInnerSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserVoucherPageDtoOutputItemsInnerSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserVoucherPageDtoOutputItemsInnerSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserVoucherPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<UserVoucherPageDtoOutputItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    UserVoucherPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'UserVoucherPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          UserVoucherPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserVoucherPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserVoucherPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserVoucherPageDtoOutputItemsInnerDiscountTypeEnumSerializer
    implements
        PrimitiveSerializer<
            UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum> {
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
    UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum
  ];
  @override
  final String wireName = 'UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum';

  @override
  Object serialize(Serializers serializers,
          UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserVoucherPageDtoOutputItemsInner
    extends UserVoucherPageDtoOutputItemsInner {
  @override
  final String userVoucherId;
  @override
  final UserVoucherPageDtoOutputItemsInnerSource_Enum source_;
  @override
  final UserVoucherPageDtoOutputItemsInnerStatusEnum status;
  @override
  final String? promotionCode;
  @override
  final String name;
  @override
  final String? discountAmount;
  @override
  final UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum discountType;
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

  factory _$UserVoucherPageDtoOutputItemsInner(
          [void Function(UserVoucherPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (UserVoucherPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$UserVoucherPageDtoOutputItemsInner._(
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
  UserVoucherPageDtoOutputItemsInner rebuild(
          void Function(UserVoucherPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserVoucherPageDtoOutputItemsInnerBuilder toBuilder() =>
      UserVoucherPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserVoucherPageDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(r'UserVoucherPageDtoOutputItemsInner')
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

class UserVoucherPageDtoOutputItemsInnerBuilder
    implements
        Builder<UserVoucherPageDtoOutputItemsInner,
            UserVoucherPageDtoOutputItemsInnerBuilder> {
  _$UserVoucherPageDtoOutputItemsInner? _$v;

  String? _userVoucherId;
  String? get userVoucherId => _$this._userVoucherId;
  set userVoucherId(String? userVoucherId) =>
      _$this._userVoucherId = userVoucherId;

  UserVoucherPageDtoOutputItemsInnerSource_Enum? _source_;
  UserVoucherPageDtoOutputItemsInnerSource_Enum? get source_ => _$this._source_;
  set source_(UserVoucherPageDtoOutputItemsInnerSource_Enum? source_) =>
      _$this._source_ = source_;

  UserVoucherPageDtoOutputItemsInnerStatusEnum? _status;
  UserVoucherPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(UserVoucherPageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

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

  UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum? _discountType;
  UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum? get discountType =>
      _$this._discountType;
  set discountType(
          UserVoucherPageDtoOutputItemsInnerDiscountTypeEnum? discountType) =>
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

  UserVoucherPageDtoOutputItemsInnerBuilder() {
    UserVoucherPageDtoOutputItemsInner._defaults(this);
  }

  UserVoucherPageDtoOutputItemsInnerBuilder get _$this {
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
  void replace(UserVoucherPageDtoOutputItemsInner other) {
    _$v = other as _$UserVoucherPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(UserVoucherPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserVoucherPageDtoOutputItemsInner build() => _build();

  _$UserVoucherPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$UserVoucherPageDtoOutputItemsInner._(
          userVoucherId: BuiltValueNullFieldError.checkNotNull(userVoucherId,
              r'UserVoucherPageDtoOutputItemsInner', 'userVoucherId'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'UserVoucherPageDtoOutputItemsInner', 'source_'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'UserVoucherPageDtoOutputItemsInner', 'status'),
          promotionCode: promotionCode,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserVoucherPageDtoOutputItemsInner', 'name'),
          discountAmount: discountAmount,
          discountType: BuiltValueNullFieldError.checkNotNull(discountType,
              r'UserVoucherPageDtoOutputItemsInner', 'discountType'),
          discountValue: BuiltValueNullFieldError.checkNotNull(discountValue,
              r'UserVoucherPageDtoOutputItemsInner', 'discountValue'),
          maxDiscount: maxDiscount,
          minOrder: BuiltValueNullFieldError.checkNotNull(
              minOrder, r'UserVoucherPageDtoOutputItemsInner', 'minOrder'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'UserVoucherPageDtoOutputItemsInner', 'expiresAt'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'UserVoucherPageDtoOutputItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
