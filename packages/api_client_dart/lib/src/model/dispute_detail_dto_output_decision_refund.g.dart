// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail_dto_output_decision_refund.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnum_REQUESTED =
    const DisputeDetailDtoOutputDecisionRefundStatusEnum._('REQUESTED');
const DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnum_APPROVED =
    const DisputeDetailDtoOutputDecisionRefundStatusEnum._('APPROVED');
const DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnum_PROCESSING =
    const DisputeDetailDtoOutputDecisionRefundStatusEnum._('PROCESSING');
const DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnum_SUCCESS =
    const DisputeDetailDtoOutputDecisionRefundStatusEnum._('SUCCESS');
const DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnum_FAILED =
    const DisputeDetailDtoOutputDecisionRefundStatusEnum._('FAILED');
const DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnum_REJECTED =
    const DisputeDetailDtoOutputDecisionRefundStatusEnum._('REJECTED');

DisputeDetailDtoOutputDecisionRefundStatusEnum
    _$disputeDetailDtoOutputDecisionRefundStatusEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$disputeDetailDtoOutputDecisionRefundStatusEnum_REQUESTED;
    case 'APPROVED':
      return _$disputeDetailDtoOutputDecisionRefundStatusEnum_APPROVED;
    case 'PROCESSING':
      return _$disputeDetailDtoOutputDecisionRefundStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$disputeDetailDtoOutputDecisionRefundStatusEnum_SUCCESS;
    case 'FAILED':
      return _$disputeDetailDtoOutputDecisionRefundStatusEnum_FAILED;
    case 'REJECTED':
      return _$disputeDetailDtoOutputDecisionRefundStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDetailDtoOutputDecisionRefundStatusEnum>
    _$disputeDetailDtoOutputDecisionRefundStatusEnumValues = BuiltSet<
        DisputeDetailDtoOutputDecisionRefundStatusEnum>(const <DisputeDetailDtoOutputDecisionRefundStatusEnum>[
  _$disputeDetailDtoOutputDecisionRefundStatusEnum_REQUESTED,
  _$disputeDetailDtoOutputDecisionRefundStatusEnum_APPROVED,
  _$disputeDetailDtoOutputDecisionRefundStatusEnum_PROCESSING,
  _$disputeDetailDtoOutputDecisionRefundStatusEnum_SUCCESS,
  _$disputeDetailDtoOutputDecisionRefundStatusEnum_FAILED,
  _$disputeDetailDtoOutputDecisionRefundStatusEnum_REJECTED,
]);

Serializer<DisputeDetailDtoOutputDecisionRefundStatusEnum>
    _$disputeDetailDtoOutputDecisionRefundStatusEnumSerializer =
    _$DisputeDetailDtoOutputDecisionRefundStatusEnumSerializer();

class _$DisputeDetailDtoOutputDecisionRefundStatusEnumSerializer
    implements
        PrimitiveSerializer<DisputeDetailDtoOutputDecisionRefundStatusEnum> {
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
    DisputeDetailDtoOutputDecisionRefundStatusEnum
  ];
  @override
  final String wireName = 'DisputeDetailDtoOutputDecisionRefundStatusEnum';

  @override
  Object serialize(Serializers serializers,
          DisputeDetailDtoOutputDecisionRefundStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDetailDtoOutputDecisionRefundStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDetailDtoOutputDecisionRefundStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDetailDtoOutputDecisionRefund
    extends DisputeDetailDtoOutputDecisionRefund {
  @override
  final String refundId;
  @override
  final String refundCode;
  @override
  final DisputeDetailDtoOutputDecisionRefundStatusEnum status;

  factory _$DisputeDetailDtoOutputDecisionRefund(
          [void Function(DisputeDetailDtoOutputDecisionRefundBuilder)?
              updates]) =>
      (DisputeDetailDtoOutputDecisionRefundBuilder()..update(updates))._build();

  _$DisputeDetailDtoOutputDecisionRefund._(
      {required this.refundId, required this.refundCode, required this.status})
      : super._();
  @override
  DisputeDetailDtoOutputDecisionRefund rebuild(
          void Function(DisputeDetailDtoOutputDecisionRefundBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailDtoOutputDecisionRefundBuilder toBuilder() =>
      DisputeDetailDtoOutputDecisionRefundBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetailDtoOutputDecisionRefund &&
        refundId == other.refundId &&
        refundCode == other.refundCode &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refundId.hashCode);
    _$hash = $jc(_$hash, refundCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDetailDtoOutputDecisionRefund')
          ..add('refundId', refundId)
          ..add('refundCode', refundCode)
          ..add('status', status))
        .toString();
  }
}

class DisputeDetailDtoOutputDecisionRefundBuilder
    implements
        Builder<DisputeDetailDtoOutputDecisionRefund,
            DisputeDetailDtoOutputDecisionRefundBuilder> {
  _$DisputeDetailDtoOutputDecisionRefund? _$v;

  String? _refundId;
  String? get refundId => _$this._refundId;
  set refundId(String? refundId) => _$this._refundId = refundId;

  String? _refundCode;
  String? get refundCode => _$this._refundCode;
  set refundCode(String? refundCode) => _$this._refundCode = refundCode;

  DisputeDetailDtoOutputDecisionRefundStatusEnum? _status;
  DisputeDetailDtoOutputDecisionRefundStatusEnum? get status => _$this._status;
  set status(DisputeDetailDtoOutputDecisionRefundStatusEnum? status) =>
      _$this._status = status;

  DisputeDetailDtoOutputDecisionRefundBuilder() {
    DisputeDetailDtoOutputDecisionRefund._defaults(this);
  }

  DisputeDetailDtoOutputDecisionRefundBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refundId = $v.refundId;
      _refundCode = $v.refundCode;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDetailDtoOutputDecisionRefund other) {
    _$v = other as _$DisputeDetailDtoOutputDecisionRefund;
  }

  @override
  void update(
      void Function(DisputeDetailDtoOutputDecisionRefundBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetailDtoOutputDecisionRefund build() => _build();

  _$DisputeDetailDtoOutputDecisionRefund _build() {
    final _$result = _$v ??
        _$DisputeDetailDtoOutputDecisionRefund._(
          refundId: BuiltValueNullFieldError.checkNotNull(
              refundId, r'DisputeDetailDtoOutputDecisionRefund', 'refundId'),
          refundCode: BuiltValueNullFieldError.checkNotNull(refundCode,
              r'DisputeDetailDtoOutputDecisionRefund', 'refundCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DisputeDetailDtoOutputDecisionRefund', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
