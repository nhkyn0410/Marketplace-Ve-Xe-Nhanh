// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_dto_output_dispute.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_OPEN =
    const TicketDetailDtoOutputDisputeStatusEnum._('OPEN');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_USER_EVIDENCE =
    const TicketDetailDtoOutputDisputeStatusEnum._('WAITING_USER_EVIDENCE');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_OPERATOR_RESPONSE =
    const TicketDetailDtoOutputDisputeStatusEnum._('WAITING_OPERATOR_RESPONSE');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_UNDER_REVIEW =
    const TicketDetailDtoOutputDisputeStatusEnum._('UNDER_REVIEW');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_ESCALATED =
    const TicketDetailDtoOutputDisputeStatusEnum._('ESCALATED');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_REFUND =
    const TicketDetailDtoOutputDisputeStatusEnum._('RESOLVED_REFUND');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_NO_REFUND =
    const TicketDetailDtoOutputDisputeStatusEnum._('RESOLVED_NO_REFUND');
const TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnum_CLOSED =
    const TicketDetailDtoOutputDisputeStatusEnum._('CLOSED');

TicketDetailDtoOutputDisputeStatusEnum
    _$ticketDetailDtoOutputDisputeStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$ticketDetailDtoOutputDisputeStatusEnum_OPEN;
    case 'WAITING_USER_EVIDENCE':
      return _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_USER_EVIDENCE;
    case 'WAITING_OPERATOR_RESPONSE':
      return _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_OPERATOR_RESPONSE;
    case 'UNDER_REVIEW':
      return _$ticketDetailDtoOutputDisputeStatusEnum_UNDER_REVIEW;
    case 'ESCALATED':
      return _$ticketDetailDtoOutputDisputeStatusEnum_ESCALATED;
    case 'RESOLVED_REFUND':
      return _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_REFUND;
    case 'RESOLVED_NO_REFUND':
      return _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_NO_REFUND;
    case 'CLOSED':
      return _$ticketDetailDtoOutputDisputeStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketDetailDtoOutputDisputeStatusEnum>
    _$ticketDetailDtoOutputDisputeStatusEnumValues = BuiltSet<
        TicketDetailDtoOutputDisputeStatusEnum>(const <TicketDetailDtoOutputDisputeStatusEnum>[
  _$ticketDetailDtoOutputDisputeStatusEnum_OPEN,
  _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_USER_EVIDENCE,
  _$ticketDetailDtoOutputDisputeStatusEnum_WAITING_OPERATOR_RESPONSE,
  _$ticketDetailDtoOutputDisputeStatusEnum_UNDER_REVIEW,
  _$ticketDetailDtoOutputDisputeStatusEnum_ESCALATED,
  _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_REFUND,
  _$ticketDetailDtoOutputDisputeStatusEnum_RESOLVED_NO_REFUND,
  _$ticketDetailDtoOutputDisputeStatusEnum_CLOSED,
]);

Serializer<TicketDetailDtoOutputDisputeStatusEnum>
    _$ticketDetailDtoOutputDisputeStatusEnumSerializer =
    _$TicketDetailDtoOutputDisputeStatusEnumSerializer();

class _$TicketDetailDtoOutputDisputeStatusEnumSerializer
    implements PrimitiveSerializer<TicketDetailDtoOutputDisputeStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'WAITING_USER_EVIDENCE': 'WAITING_USER_EVIDENCE',
    'WAITING_OPERATOR_RESPONSE': 'WAITING_OPERATOR_RESPONSE',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'ESCALATED': 'ESCALATED',
    'RESOLVED_REFUND': 'RESOLVED_REFUND',
    'RESOLVED_NO_REFUND': 'RESOLVED_NO_REFUND',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'WAITING_USER_EVIDENCE': 'WAITING_USER_EVIDENCE',
    'WAITING_OPERATOR_RESPONSE': 'WAITING_OPERATOR_RESPONSE',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'ESCALATED': 'ESCALATED',
    'RESOLVED_REFUND': 'RESOLVED_REFUND',
    'RESOLVED_NO_REFUND': 'RESOLVED_NO_REFUND',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TicketDetailDtoOutputDisputeStatusEnum
  ];
  @override
  final String wireName = 'TicketDetailDtoOutputDisputeStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TicketDetailDtoOutputDisputeStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketDetailDtoOutputDisputeStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketDetailDtoOutputDisputeStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketDetailDtoOutputDispute extends TicketDetailDtoOutputDispute {
  @override
  final String disputeId;
  @override
  final String disputeCode;
  @override
  final TicketDetailDtoOutputDisputeStatusEnum status;

  factory _$TicketDetailDtoOutputDispute(
          [void Function(TicketDetailDtoOutputDisputeBuilder)? updates]) =>
      (TicketDetailDtoOutputDisputeBuilder()..update(updates))._build();

  _$TicketDetailDtoOutputDispute._(
      {required this.disputeId,
      required this.disputeCode,
      required this.status})
      : super._();
  @override
  TicketDetailDtoOutputDispute rebuild(
          void Function(TicketDetailDtoOutputDisputeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketDetailDtoOutputDisputeBuilder toBuilder() =>
      TicketDetailDtoOutputDisputeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketDetailDtoOutputDispute &&
        disputeId == other.disputeId &&
        disputeCode == other.disputeCode &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, disputeId.hashCode);
    _$hash = $jc(_$hash, disputeCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketDetailDtoOutputDispute')
          ..add('disputeId', disputeId)
          ..add('disputeCode', disputeCode)
          ..add('status', status))
        .toString();
  }
}

class TicketDetailDtoOutputDisputeBuilder
    implements
        Builder<TicketDetailDtoOutputDispute,
            TicketDetailDtoOutputDisputeBuilder> {
  _$TicketDetailDtoOutputDispute? _$v;

  String? _disputeId;
  String? get disputeId => _$this._disputeId;
  set disputeId(String? disputeId) => _$this._disputeId = disputeId;

  String? _disputeCode;
  String? get disputeCode => _$this._disputeCode;
  set disputeCode(String? disputeCode) => _$this._disputeCode = disputeCode;

  TicketDetailDtoOutputDisputeStatusEnum? _status;
  TicketDetailDtoOutputDisputeStatusEnum? get status => _$this._status;
  set status(TicketDetailDtoOutputDisputeStatusEnum? status) =>
      _$this._status = status;

  TicketDetailDtoOutputDisputeBuilder() {
    TicketDetailDtoOutputDispute._defaults(this);
  }

  TicketDetailDtoOutputDisputeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _disputeId = $v.disputeId;
      _disputeCode = $v.disputeCode;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketDetailDtoOutputDispute other) {
    _$v = other as _$TicketDetailDtoOutputDispute;
  }

  @override
  void update(void Function(TicketDetailDtoOutputDisputeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketDetailDtoOutputDispute build() => _build();

  _$TicketDetailDtoOutputDispute _build() {
    final _$result = _$v ??
        _$TicketDetailDtoOutputDispute._(
          disputeId: BuiltValueNullFieldError.checkNotNull(
              disputeId, r'TicketDetailDtoOutputDispute', 'disputeId'),
          disputeCode: BuiltValueNullFieldError.checkNotNull(
              disputeCode, r'TicketDetailDtoOutputDispute', 'disputeCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TicketDetailDtoOutputDispute', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
