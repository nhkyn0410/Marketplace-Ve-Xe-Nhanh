// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_result_dto_output_refund.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnum_REQUESTED =
    const CancellationResultDtoOutputRefundStatusEnum._('REQUESTED');
const CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnum_APPROVED =
    const CancellationResultDtoOutputRefundStatusEnum._('APPROVED');
const CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnum_PROCESSING =
    const CancellationResultDtoOutputRefundStatusEnum._('PROCESSING');
const CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnum_SUCCESS =
    const CancellationResultDtoOutputRefundStatusEnum._('SUCCESS');
const CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnum_FAILED =
    const CancellationResultDtoOutputRefundStatusEnum._('FAILED');
const CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnum_REJECTED =
    const CancellationResultDtoOutputRefundStatusEnum._('REJECTED');

CancellationResultDtoOutputRefundStatusEnum
    _$cancellationResultDtoOutputRefundStatusEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$cancellationResultDtoOutputRefundStatusEnum_REQUESTED;
    case 'APPROVED':
      return _$cancellationResultDtoOutputRefundStatusEnum_APPROVED;
    case 'PROCESSING':
      return _$cancellationResultDtoOutputRefundStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$cancellationResultDtoOutputRefundStatusEnum_SUCCESS;
    case 'FAILED':
      return _$cancellationResultDtoOutputRefundStatusEnum_FAILED;
    case 'REJECTED':
      return _$cancellationResultDtoOutputRefundStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationResultDtoOutputRefundStatusEnum>
    _$cancellationResultDtoOutputRefundStatusEnumValues = BuiltSet<
        CancellationResultDtoOutputRefundStatusEnum>(const <CancellationResultDtoOutputRefundStatusEnum>[
  _$cancellationResultDtoOutputRefundStatusEnum_REQUESTED,
  _$cancellationResultDtoOutputRefundStatusEnum_APPROVED,
  _$cancellationResultDtoOutputRefundStatusEnum_PROCESSING,
  _$cancellationResultDtoOutputRefundStatusEnum_SUCCESS,
  _$cancellationResultDtoOutputRefundStatusEnum_FAILED,
  _$cancellationResultDtoOutputRefundStatusEnum_REJECTED,
]);

Serializer<CancellationResultDtoOutputRefundStatusEnum>
    _$cancellationResultDtoOutputRefundStatusEnumSerializer =
    _$CancellationResultDtoOutputRefundStatusEnumSerializer();

class _$CancellationResultDtoOutputRefundStatusEnumSerializer
    implements
        PrimitiveSerializer<CancellationResultDtoOutputRefundStatusEnum> {
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
    CancellationResultDtoOutputRefundStatusEnum
  ];
  @override
  final String wireName = 'CancellationResultDtoOutputRefundStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CancellationResultDtoOutputRefundStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationResultDtoOutputRefundStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationResultDtoOutputRefundStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationResultDtoOutputRefund
    extends CancellationResultDtoOutputRefund {
  @override
  final String refundCode;
  @override
  final int amount;
  @override
  final CancellationResultDtoOutputRefundStatusEnum status;

  factory _$CancellationResultDtoOutputRefund(
          [void Function(CancellationResultDtoOutputRefundBuilder)? updates]) =>
      (CancellationResultDtoOutputRefundBuilder()..update(updates))._build();

  _$CancellationResultDtoOutputRefund._(
      {required this.refundCode, required this.amount, required this.status})
      : super._();
  @override
  CancellationResultDtoOutputRefund rebuild(
          void Function(CancellationResultDtoOutputRefundBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationResultDtoOutputRefundBuilder toBuilder() =>
      CancellationResultDtoOutputRefundBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationResultDtoOutputRefund &&
        refundCode == other.refundCode &&
        amount == other.amount &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refundCode.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationResultDtoOutputRefund')
          ..add('refundCode', refundCode)
          ..add('amount', amount)
          ..add('status', status))
        .toString();
  }
}

class CancellationResultDtoOutputRefundBuilder
    implements
        Builder<CancellationResultDtoOutputRefund,
            CancellationResultDtoOutputRefundBuilder> {
  _$CancellationResultDtoOutputRefund? _$v;

  String? _refundCode;
  String? get refundCode => _$this._refundCode;
  set refundCode(String? refundCode) => _$this._refundCode = refundCode;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  CancellationResultDtoOutputRefundStatusEnum? _status;
  CancellationResultDtoOutputRefundStatusEnum? get status => _$this._status;
  set status(CancellationResultDtoOutputRefundStatusEnum? status) =>
      _$this._status = status;

  CancellationResultDtoOutputRefundBuilder() {
    CancellationResultDtoOutputRefund._defaults(this);
  }

  CancellationResultDtoOutputRefundBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refundCode = $v.refundCode;
      _amount = $v.amount;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationResultDtoOutputRefund other) {
    _$v = other as _$CancellationResultDtoOutputRefund;
  }

  @override
  void update(
      void Function(CancellationResultDtoOutputRefundBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationResultDtoOutputRefund build() => _build();

  _$CancellationResultDtoOutputRefund _build() {
    final _$result = _$v ??
        _$CancellationResultDtoOutputRefund._(
          refundCode: BuiltValueNullFieldError.checkNotNull(
              refundCode, r'CancellationResultDtoOutputRefund', 'refundCode'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CancellationResultDtoOutputRefund', 'amount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CancellationResultDtoOutputRefund', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
