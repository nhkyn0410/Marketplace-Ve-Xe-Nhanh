// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_refunds_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnum_REQUESTED =
    const CreatedBookingDtoOutputRefundsInnerStatusEnum._('REQUESTED');
const CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnum_APPROVED =
    const CreatedBookingDtoOutputRefundsInnerStatusEnum._('APPROVED');
const CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnum_PROCESSING =
    const CreatedBookingDtoOutputRefundsInnerStatusEnum._('PROCESSING');
const CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnum_SUCCESS =
    const CreatedBookingDtoOutputRefundsInnerStatusEnum._('SUCCESS');
const CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnum_FAILED =
    const CreatedBookingDtoOutputRefundsInnerStatusEnum._('FAILED');
const CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnum_REJECTED =
    const CreatedBookingDtoOutputRefundsInnerStatusEnum._('REJECTED');

CreatedBookingDtoOutputRefundsInnerStatusEnum
    _$createdBookingDtoOutputRefundsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$createdBookingDtoOutputRefundsInnerStatusEnum_REQUESTED;
    case 'APPROVED':
      return _$createdBookingDtoOutputRefundsInnerStatusEnum_APPROVED;
    case 'PROCESSING':
      return _$createdBookingDtoOutputRefundsInnerStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$createdBookingDtoOutputRefundsInnerStatusEnum_SUCCESS;
    case 'FAILED':
      return _$createdBookingDtoOutputRefundsInnerStatusEnum_FAILED;
    case 'REJECTED':
      return _$createdBookingDtoOutputRefundsInnerStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputRefundsInnerStatusEnum>
    _$createdBookingDtoOutputRefundsInnerStatusEnumValues = BuiltSet<
        CreatedBookingDtoOutputRefundsInnerStatusEnum>(const <CreatedBookingDtoOutputRefundsInnerStatusEnum>[
  _$createdBookingDtoOutputRefundsInnerStatusEnum_REQUESTED,
  _$createdBookingDtoOutputRefundsInnerStatusEnum_APPROVED,
  _$createdBookingDtoOutputRefundsInnerStatusEnum_PROCESSING,
  _$createdBookingDtoOutputRefundsInnerStatusEnum_SUCCESS,
  _$createdBookingDtoOutputRefundsInnerStatusEnum_FAILED,
  _$createdBookingDtoOutputRefundsInnerStatusEnum_REJECTED,
]);

Serializer<CreatedBookingDtoOutputRefundsInnerStatusEnum>
    _$createdBookingDtoOutputRefundsInnerStatusEnumSerializer =
    _$CreatedBookingDtoOutputRefundsInnerStatusEnumSerializer();

class _$CreatedBookingDtoOutputRefundsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<CreatedBookingDtoOutputRefundsInnerStatusEnum> {
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
    CreatedBookingDtoOutputRefundsInnerStatusEnum
  ];
  @override
  final String wireName = 'CreatedBookingDtoOutputRefundsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CreatedBookingDtoOutputRefundsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputRefundsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputRefundsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutputRefundsInner
    extends CreatedBookingDtoOutputRefundsInner {
  @override
  final String refundCode;
  @override
  final int amount;
  @override
  final CreatedBookingDtoOutputRefundsInnerStatusEnum status;
  @override
  final DateTime createdAt;

  factory _$CreatedBookingDtoOutputRefundsInner(
          [void Function(CreatedBookingDtoOutputRefundsInnerBuilder)?
              updates]) =>
      (CreatedBookingDtoOutputRefundsInnerBuilder()..update(updates))._build();

  _$CreatedBookingDtoOutputRefundsInner._(
      {required this.refundCode,
      required this.amount,
      required this.status,
      required this.createdAt})
      : super._();
  @override
  CreatedBookingDtoOutputRefundsInner rebuild(
          void Function(CreatedBookingDtoOutputRefundsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputRefundsInnerBuilder toBuilder() =>
      CreatedBookingDtoOutputRefundsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputRefundsInner &&
        refundCode == other.refundCode &&
        amount == other.amount &&
        status == other.status &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refundCode.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatedBookingDtoOutputRefundsInner')
          ..add('refundCode', refundCode)
          ..add('amount', amount)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CreatedBookingDtoOutputRefundsInnerBuilder
    implements
        Builder<CreatedBookingDtoOutputRefundsInner,
            CreatedBookingDtoOutputRefundsInnerBuilder> {
  _$CreatedBookingDtoOutputRefundsInner? _$v;

  String? _refundCode;
  String? get refundCode => _$this._refundCode;
  set refundCode(String? refundCode) => _$this._refundCode = refundCode;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  CreatedBookingDtoOutputRefundsInnerStatusEnum? _status;
  CreatedBookingDtoOutputRefundsInnerStatusEnum? get status => _$this._status;
  set status(CreatedBookingDtoOutputRefundsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CreatedBookingDtoOutputRefundsInnerBuilder() {
    CreatedBookingDtoOutputRefundsInner._defaults(this);
  }

  CreatedBookingDtoOutputRefundsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refundCode = $v.refundCode;
      _amount = $v.amount;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutputRefundsInner other) {
    _$v = other as _$CreatedBookingDtoOutputRefundsInner;
  }

  @override
  void update(
      void Function(CreatedBookingDtoOutputRefundsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputRefundsInner build() => _build();

  _$CreatedBookingDtoOutputRefundsInner _build() {
    final _$result = _$v ??
        _$CreatedBookingDtoOutputRefundsInner._(
          refundCode: BuiltValueNullFieldError.checkNotNull(
              refundCode, r'CreatedBookingDtoOutputRefundsInner', 'refundCode'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CreatedBookingDtoOutputRefundsInner', 'amount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CreatedBookingDtoOutputRefundsInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CreatedBookingDtoOutputRefundsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
