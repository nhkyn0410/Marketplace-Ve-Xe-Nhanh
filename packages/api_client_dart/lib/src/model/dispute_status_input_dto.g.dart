// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_status_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeStatusInputDtoStatusEnum
    _$disputeStatusInputDtoStatusEnum_UNDER_REVIEW =
    const DisputeStatusInputDtoStatusEnum._('UNDER_REVIEW');
const DisputeStatusInputDtoStatusEnum
    _$disputeStatusInputDtoStatusEnum_ESCALATED =
    const DisputeStatusInputDtoStatusEnum._('ESCALATED');
const DisputeStatusInputDtoStatusEnum _$disputeStatusInputDtoStatusEnum_CLOSED =
    const DisputeStatusInputDtoStatusEnum._('CLOSED');

DisputeStatusInputDtoStatusEnum _$disputeStatusInputDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'UNDER_REVIEW':
      return _$disputeStatusInputDtoStatusEnum_UNDER_REVIEW;
    case 'ESCALATED':
      return _$disputeStatusInputDtoStatusEnum_ESCALATED;
    case 'CLOSED':
      return _$disputeStatusInputDtoStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeStatusInputDtoStatusEnum>
    _$disputeStatusInputDtoStatusEnumValues = BuiltSet<
        DisputeStatusInputDtoStatusEnum>(const <DisputeStatusInputDtoStatusEnum>[
  _$disputeStatusInputDtoStatusEnum_UNDER_REVIEW,
  _$disputeStatusInputDtoStatusEnum_ESCALATED,
  _$disputeStatusInputDtoStatusEnum_CLOSED,
]);

Serializer<DisputeStatusInputDtoStatusEnum>
    _$disputeStatusInputDtoStatusEnumSerializer =
    _$DisputeStatusInputDtoStatusEnumSerializer();

class _$DisputeStatusInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<DisputeStatusInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'ESCALATED': 'ESCALATED',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'ESCALATED': 'ESCALATED',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeStatusInputDtoStatusEnum];
  @override
  final String wireName = 'DisputeStatusInputDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeStatusInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeStatusInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeStatusInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeStatusInputDto extends DisputeStatusInputDto {
  @override
  final DisputeStatusInputDtoStatusEnum status;
  @override
  final String reason;

  factory _$DisputeStatusInputDto(
          [void Function(DisputeStatusInputDtoBuilder)? updates]) =>
      (DisputeStatusInputDtoBuilder()..update(updates))._build();

  _$DisputeStatusInputDto._({required this.status, required this.reason})
      : super._();
  @override
  DisputeStatusInputDto rebuild(
          void Function(DisputeStatusInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeStatusInputDtoBuilder toBuilder() =>
      DisputeStatusInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeStatusInputDto &&
        status == other.status &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeStatusInputDto')
          ..add('status', status)
          ..add('reason', reason))
        .toString();
  }
}

class DisputeStatusInputDtoBuilder
    implements Builder<DisputeStatusInputDto, DisputeStatusInputDtoBuilder> {
  _$DisputeStatusInputDto? _$v;

  DisputeStatusInputDtoStatusEnum? _status;
  DisputeStatusInputDtoStatusEnum? get status => _$this._status;
  set status(DisputeStatusInputDtoStatusEnum? status) =>
      _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DisputeStatusInputDtoBuilder() {
    DisputeStatusInputDto._defaults(this);
  }

  DisputeStatusInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeStatusInputDto other) {
    _$v = other as _$DisputeStatusInputDto;
  }

  @override
  void update(void Function(DisputeStatusInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeStatusInputDto build() => _build();

  _$DisputeStatusInputDto _build() {
    final _$result = _$v ??
        _$DisputeStatusInputDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DisputeStatusInputDto', 'status'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DisputeStatusInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
