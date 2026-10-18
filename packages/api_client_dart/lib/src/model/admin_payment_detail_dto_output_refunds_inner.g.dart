// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_detail_dto_output_refunds_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REQUESTED =
    const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._('REQUESTED');
const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_APPROVED =
    const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._('APPROVED');
const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_PROCESSING =
    const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._('PROCESSING');
const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_SUCCESS =
    const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._('SUCCESS');
const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_FAILED =
    const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._('FAILED');
const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REJECTED =
    const AdminPaymentDetailDtoOutputRefundsInnerStatusEnum._('REJECTED');

AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REQUESTED;
    case 'APPROVED':
      return _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_APPROVED;
    case 'PROCESSING':
      return _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_SUCCESS;
    case 'FAILED':
      return _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_FAILED;
    case 'REJECTED':
      return _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentDetailDtoOutputRefundsInnerStatusEnum>
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnumValues = BuiltSet<
        AdminPaymentDetailDtoOutputRefundsInnerStatusEnum>(const <AdminPaymentDetailDtoOutputRefundsInnerStatusEnum>[
  _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REQUESTED,
  _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_APPROVED,
  _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_PROCESSING,
  _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_SUCCESS,
  _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_FAILED,
  _$adminPaymentDetailDtoOutputRefundsInnerStatusEnum_REJECTED,
]);

Serializer<AdminPaymentDetailDtoOutputRefundsInnerStatusEnum>
    _$adminPaymentDetailDtoOutputRefundsInnerStatusEnumSerializer =
    _$AdminPaymentDetailDtoOutputRefundsInnerStatusEnumSerializer();

class _$AdminPaymentDetailDtoOutputRefundsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminPaymentDetailDtoOutputRefundsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUESTED': 'REQUESTED',
    'APPROVED': 'APPROVED',
    'PROCESSING': 'PROCESSING',
    'SUCCESS': 'SUCCESS',
    'FAILED': 'FAILED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUESTED': 'REQUESTED',
    'APPROVED': 'APPROVED',
    'PROCESSING': 'PROCESSING',
    'SUCCESS': 'SUCCESS',
    'FAILED': 'FAILED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPaymentDetailDtoOutputRefundsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminPaymentDetailDtoOutputRefundsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentDetailDtoOutputRefundsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentDetailDtoOutputRefundsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentDetailDtoOutputRefundsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentDetailDtoOutputRefundsInner
    extends AdminPaymentDetailDtoOutputRefundsInner {
  @override
  final String refundId;
  @override
  final String refundCode;
  @override
  final AdminPaymentDetailDtoOutputRefundsInnerStatusEnum status;
  @override
  final int amount;
  @override
  final DateTime createdAt;

  factory _$AdminPaymentDetailDtoOutputRefundsInner(
          [void Function(AdminPaymentDetailDtoOutputRefundsInnerBuilder)?
              updates]) =>
      (AdminPaymentDetailDtoOutputRefundsInnerBuilder()..update(updates))
          ._build();

  _$AdminPaymentDetailDtoOutputRefundsInner._(
      {required this.refundId,
      required this.refundCode,
      required this.status,
      required this.amount,
      required this.createdAt})
      : super._();
  @override
  AdminPaymentDetailDtoOutputRefundsInner rebuild(
          void Function(AdminPaymentDetailDtoOutputRefundsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentDetailDtoOutputRefundsInnerBuilder toBuilder() =>
      AdminPaymentDetailDtoOutputRefundsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentDetailDtoOutputRefundsInner &&
        refundId == other.refundId &&
        refundCode == other.refundCode &&
        status == other.status &&
        amount == other.amount &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refundId.hashCode);
    _$hash = $jc(_$hash, refundCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPaymentDetailDtoOutputRefundsInner')
          ..add('refundId', refundId)
          ..add('refundCode', refundCode)
          ..add('status', status)
          ..add('amount', amount)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminPaymentDetailDtoOutputRefundsInnerBuilder
    implements
        Builder<AdminPaymentDetailDtoOutputRefundsInner,
            AdminPaymentDetailDtoOutputRefundsInnerBuilder> {
  _$AdminPaymentDetailDtoOutputRefundsInner? _$v;

  String? _refundId;
  String? get refundId => _$this._refundId;
  set refundId(String? refundId) => _$this._refundId = refundId;

  String? _refundCode;
  String? get refundCode => _$this._refundCode;
  set refundCode(String? refundCode) => _$this._refundCode = refundCode;

  AdminPaymentDetailDtoOutputRefundsInnerStatusEnum? _status;
  AdminPaymentDetailDtoOutputRefundsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminPaymentDetailDtoOutputRefundsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminPaymentDetailDtoOutputRefundsInnerBuilder() {
    AdminPaymentDetailDtoOutputRefundsInner._defaults(this);
  }

  AdminPaymentDetailDtoOutputRefundsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refundId = $v.refundId;
      _refundCode = $v.refundCode;
      _status = $v.status;
      _amount = $v.amount;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentDetailDtoOutputRefundsInner other) {
    _$v = other as _$AdminPaymentDetailDtoOutputRefundsInner;
  }

  @override
  void update(
      void Function(AdminPaymentDetailDtoOutputRefundsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentDetailDtoOutputRefundsInner build() => _build();

  _$AdminPaymentDetailDtoOutputRefundsInner _build() {
    final _$result = _$v ??
        _$AdminPaymentDetailDtoOutputRefundsInner._(
          refundId: BuiltValueNullFieldError.checkNotNull(
              refundId, r'AdminPaymentDetailDtoOutputRefundsInner', 'refundId'),
          refundCode: BuiltValueNullFieldError.checkNotNull(refundCode,
              r'AdminPaymentDetailDtoOutputRefundsInner', 'refundCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminPaymentDetailDtoOutputRefundsInner', 'status'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'AdminPaymentDetailDtoOutputRefundsInner', 'amount'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminPaymentDetailDtoOutputRefundsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
