// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApprovalResponseDtoOutputStatusEnum
    _$approvalResponseDtoOutputStatusEnum_APPROVED =
    const ApprovalResponseDtoOutputStatusEnum._('APPROVED');

ApprovalResponseDtoOutputStatusEnum
    _$approvalResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'APPROVED':
      return _$approvalResponseDtoOutputStatusEnum_APPROVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApprovalResponseDtoOutputStatusEnum>
    _$approvalResponseDtoOutputStatusEnumValues = BuiltSet<
        ApprovalResponseDtoOutputStatusEnum>(const <ApprovalResponseDtoOutputStatusEnum>[
  _$approvalResponseDtoOutputStatusEnum_APPROVED,
]);

Serializer<ApprovalResponseDtoOutputStatusEnum>
    _$approvalResponseDtoOutputStatusEnumSerializer =
    _$ApprovalResponseDtoOutputStatusEnumSerializer();

class _$ApprovalResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<ApprovalResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVED': 'APPROVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVED': 'APPROVED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApprovalResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'ApprovalResponseDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ApprovalResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApprovalResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApprovalResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApprovalResponseDtoOutput extends ApprovalResponseDtoOutput {
  @override
  final String applicationCode;
  @override
  final ApprovalResponseDtoOutputStatusEnum status;
  @override
  final String operatorId;
  @override
  final String operatorSlug;
  @override
  final String ownerUsername;
  @override
  final bool credentialDeliveryPending;

  factory _$ApprovalResponseDtoOutput(
          [void Function(ApprovalResponseDtoOutputBuilder)? updates]) =>
      (ApprovalResponseDtoOutputBuilder()..update(updates))._build();

  _$ApprovalResponseDtoOutput._(
      {required this.applicationCode,
      required this.status,
      required this.operatorId,
      required this.operatorSlug,
      required this.ownerUsername,
      required this.credentialDeliveryPending})
      : super._();
  @override
  ApprovalResponseDtoOutput rebuild(
          void Function(ApprovalResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApprovalResponseDtoOutputBuilder toBuilder() =>
      ApprovalResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApprovalResponseDtoOutput &&
        applicationCode == other.applicationCode &&
        status == other.status &&
        operatorId == other.operatorId &&
        operatorSlug == other.operatorSlug &&
        ownerUsername == other.ownerUsername &&
        credentialDeliveryPending == other.credentialDeliveryPending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applicationCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, ownerUsername.hashCode);
    _$hash = $jc(_$hash, credentialDeliveryPending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApprovalResponseDtoOutput')
          ..add('applicationCode', applicationCode)
          ..add('status', status)
          ..add('operatorId', operatorId)
          ..add('operatorSlug', operatorSlug)
          ..add('ownerUsername', ownerUsername)
          ..add('credentialDeliveryPending', credentialDeliveryPending))
        .toString();
  }
}

class ApprovalResponseDtoOutputBuilder
    implements
        Builder<ApprovalResponseDtoOutput, ApprovalResponseDtoOutputBuilder> {
  _$ApprovalResponseDtoOutput? _$v;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  ApprovalResponseDtoOutputStatusEnum? _status;
  ApprovalResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(ApprovalResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  String? _ownerUsername;
  String? get ownerUsername => _$this._ownerUsername;
  set ownerUsername(String? ownerUsername) =>
      _$this._ownerUsername = ownerUsername;

  bool? _credentialDeliveryPending;
  bool? get credentialDeliveryPending => _$this._credentialDeliveryPending;
  set credentialDeliveryPending(bool? credentialDeliveryPending) =>
      _$this._credentialDeliveryPending = credentialDeliveryPending;

  ApprovalResponseDtoOutputBuilder() {
    ApprovalResponseDtoOutput._defaults(this);
  }

  ApprovalResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applicationCode = $v.applicationCode;
      _status = $v.status;
      _operatorId = $v.operatorId;
      _operatorSlug = $v.operatorSlug;
      _ownerUsername = $v.ownerUsername;
      _credentialDeliveryPending = $v.credentialDeliveryPending;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApprovalResponseDtoOutput other) {
    _$v = other as _$ApprovalResponseDtoOutput;
  }

  @override
  void update(void Function(ApprovalResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApprovalResponseDtoOutput build() => _build();

  _$ApprovalResponseDtoOutput _build() {
    final _$result = _$v ??
        _$ApprovalResponseDtoOutput._(
          applicationCode: BuiltValueNullFieldError.checkNotNull(
              applicationCode, r'ApprovalResponseDtoOutput', 'applicationCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ApprovalResponseDtoOutput', 'status'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'ApprovalResponseDtoOutput', 'operatorId'),
          operatorSlug: BuiltValueNullFieldError.checkNotNull(
              operatorSlug, r'ApprovalResponseDtoOutput', 'operatorSlug'),
          ownerUsername: BuiltValueNullFieldError.checkNotNull(
              ownerUsername, r'ApprovalResponseDtoOutput', 'ownerUsername'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'ApprovalResponseDtoOutput',
              'credentialDeliveryPending'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
