// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_detail_dto_output_ledger_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYMENT_CAPTURED =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._(
        'PAYMENT_CAPTURED');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._('COMMISSION');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_REFUND =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._('REFUND');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION_REVERSAL =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._(
        'COMMISSION_REVERSAL');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._(
        'PLATFORM_FUNDED_DISCOUNT');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT_REVERSAL =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._(
        'PLATFORM_FUNDED_DISCOUNT_REVERSAL');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYOUT =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._('PAYOUT');
const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_ADJUSTMENT =
    const AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum._('ADJUSTMENT');

AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumValueOf(String name) {
  switch (name) {
    case 'PAYMENT_CAPTURED':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYMENT_CAPTURED;
    case 'COMMISSION':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION;
    case 'REFUND':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_REFUND;
    case 'COMMISSION_REVERSAL':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION_REVERSAL;
    case 'PLATFORM_FUNDED_DISCOUNT':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT;
    case 'PLATFORM_FUNDED_DISCOUNT_REVERSAL':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT_REVERSAL;
    case 'PAYOUT':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYOUT;
    case 'ADJUSTMENT':
      return _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_ADJUSTMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum>
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumValues = BuiltSet<
        AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum>(const <AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum>[
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYMENT_CAPTURED,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_REFUND,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_COMMISSION_REVERSAL,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PLATFORM_FUNDED_DISCOUNT_REVERSAL,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_PAYOUT,
  _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum_ADJUSTMENT,
]);

Serializer<AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum>
    _$adminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumSerializer =
    _$AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumSerializer();

class _$AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnumSerializer
    implements
        PrimitiveSerializer<
            AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PAYMENT_CAPTURED': 'PAYMENT_CAPTURED',
    'COMMISSION': 'COMMISSION',
    'REFUND': 'REFUND',
    'COMMISSION_REVERSAL': 'COMMISSION_REVERSAL',
    'PLATFORM_FUNDED_DISCOUNT': 'PLATFORM_FUNDED_DISCOUNT',
    'PLATFORM_FUNDED_DISCOUNT_REVERSAL': 'PLATFORM_FUNDED_DISCOUNT_REVERSAL',
    'PAYOUT': 'PAYOUT',
    'ADJUSTMENT': 'ADJUSTMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PAYMENT_CAPTURED': 'PAYMENT_CAPTURED',
    'COMMISSION': 'COMMISSION',
    'REFUND': 'REFUND',
    'COMMISSION_REVERSAL': 'COMMISSION_REVERSAL',
    'PLATFORM_FUNDED_DISCOUNT': 'PLATFORM_FUNDED_DISCOUNT',
    'PLATFORM_FUNDED_DISCOUNT_REVERSAL': 'PLATFORM_FUNDED_DISCOUNT_REVERSAL',
    'PAYOUT': 'PAYOUT',
    'ADJUSTMENT': 'ADJUSTMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum
  ];
  @override
  final String wireName = 'AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentDetailDtoOutputLedgerInner
    extends AdminPaymentDetailDtoOutputLedgerInner {
  @override
  final AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum entryType;
  @override
  final int amount;
  @override
  final DateTime eligibleAt;
  @override
  final DateTime createdAt;

  factory _$AdminPaymentDetailDtoOutputLedgerInner(
          [void Function(AdminPaymentDetailDtoOutputLedgerInnerBuilder)?
              updates]) =>
      (AdminPaymentDetailDtoOutputLedgerInnerBuilder()..update(updates))
          ._build();

  _$AdminPaymentDetailDtoOutputLedgerInner._(
      {required this.entryType,
      required this.amount,
      required this.eligibleAt,
      required this.createdAt})
      : super._();
  @override
  AdminPaymentDetailDtoOutputLedgerInner rebuild(
          void Function(AdminPaymentDetailDtoOutputLedgerInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentDetailDtoOutputLedgerInnerBuilder toBuilder() =>
      AdminPaymentDetailDtoOutputLedgerInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentDetailDtoOutputLedgerInner &&
        entryType == other.entryType &&
        amount == other.amount &&
        eligibleAt == other.eligibleAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entryType.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, eligibleAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPaymentDetailDtoOutputLedgerInner')
          ..add('entryType', entryType)
          ..add('amount', amount)
          ..add('eligibleAt', eligibleAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminPaymentDetailDtoOutputLedgerInnerBuilder
    implements
        Builder<AdminPaymentDetailDtoOutputLedgerInner,
            AdminPaymentDetailDtoOutputLedgerInnerBuilder> {
  _$AdminPaymentDetailDtoOutputLedgerInner? _$v;

  AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum? _entryType;
  AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum? get entryType =>
      _$this._entryType;
  set entryType(
          AdminPaymentDetailDtoOutputLedgerInnerEntryTypeEnum? entryType) =>
      _$this._entryType = entryType;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  DateTime? _eligibleAt;
  DateTime? get eligibleAt => _$this._eligibleAt;
  set eligibleAt(DateTime? eligibleAt) => _$this._eligibleAt = eligibleAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminPaymentDetailDtoOutputLedgerInnerBuilder() {
    AdminPaymentDetailDtoOutputLedgerInner._defaults(this);
  }

  AdminPaymentDetailDtoOutputLedgerInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entryType = $v.entryType;
      _amount = $v.amount;
      _eligibleAt = $v.eligibleAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentDetailDtoOutputLedgerInner other) {
    _$v = other as _$AdminPaymentDetailDtoOutputLedgerInner;
  }

  @override
  void update(
      void Function(AdminPaymentDetailDtoOutputLedgerInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentDetailDtoOutputLedgerInner build() => _build();

  _$AdminPaymentDetailDtoOutputLedgerInner _build() {
    final _$result = _$v ??
        _$AdminPaymentDetailDtoOutputLedgerInner._(
          entryType: BuiltValueNullFieldError.checkNotNull(entryType,
              r'AdminPaymentDetailDtoOutputLedgerInner', 'entryType'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'AdminPaymentDetailDtoOutputLedgerInner', 'amount'),
          eligibleAt: BuiltValueNullFieldError.checkNotNull(eligibleAt,
              r'AdminPaymentDetailDtoOutputLedgerInner', 'eligibleAt'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminPaymentDetailDtoOutputLedgerInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
