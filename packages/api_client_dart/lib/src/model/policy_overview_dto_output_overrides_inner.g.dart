// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_overrides_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyOverviewDtoOutputOverridesInnerStateEnum
    _$policyOverviewDtoOutputOverridesInnerStateEnum_DRAFT =
    const PolicyOverviewDtoOutputOverridesInnerStateEnum._('DRAFT');
const PolicyOverviewDtoOutputOverridesInnerStateEnum
    _$policyOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED =
    const PolicyOverviewDtoOutputOverridesInnerStateEnum._('SCHEDULED');
const PolicyOverviewDtoOutputOverridesInnerStateEnum
    _$policyOverviewDtoOutputOverridesInnerStateEnum_ACTIVE =
    const PolicyOverviewDtoOutputOverridesInnerStateEnum._('ACTIVE');
const PolicyOverviewDtoOutputOverridesInnerStateEnum
    _$policyOverviewDtoOutputOverridesInnerStateEnum_EXPIRED =
    const PolicyOverviewDtoOutputOverridesInnerStateEnum._('EXPIRED');
const PolicyOverviewDtoOutputOverridesInnerStateEnum
    _$policyOverviewDtoOutputOverridesInnerStateEnum_CANCELLED =
    const PolicyOverviewDtoOutputOverridesInnerStateEnum._('CANCELLED');

PolicyOverviewDtoOutputOverridesInnerStateEnum
    _$policyOverviewDtoOutputOverridesInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$policyOverviewDtoOutputOverridesInnerStateEnum_DRAFT;
    case 'SCHEDULED':
      return _$policyOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$policyOverviewDtoOutputOverridesInnerStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$policyOverviewDtoOutputOverridesInnerStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$policyOverviewDtoOutputOverridesInnerStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputOverridesInnerStateEnum>
    _$policyOverviewDtoOutputOverridesInnerStateEnumValues = BuiltSet<
        PolicyOverviewDtoOutputOverridesInnerStateEnum>(const <PolicyOverviewDtoOutputOverridesInnerStateEnum>[
  _$policyOverviewDtoOutputOverridesInnerStateEnum_DRAFT,
  _$policyOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED,
  _$policyOverviewDtoOutputOverridesInnerStateEnum_ACTIVE,
  _$policyOverviewDtoOutputOverridesInnerStateEnum_EXPIRED,
  _$policyOverviewDtoOutputOverridesInnerStateEnum_CANCELLED,
]);

Serializer<PolicyOverviewDtoOutputOverridesInnerStateEnum>
    _$policyOverviewDtoOutputOverridesInnerStateEnumSerializer =
    _$PolicyOverviewDtoOutputOverridesInnerStateEnumSerializer();

class _$PolicyOverviewDtoOutputOverridesInnerStateEnumSerializer
    implements
        PrimitiveSerializer<PolicyOverviewDtoOutputOverridesInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputOverridesInnerStateEnum
  ];
  @override
  final String wireName = 'PolicyOverviewDtoOutputOverridesInnerStateEnum';

  @override
  Object serialize(Serializers serializers,
          PolicyOverviewDtoOutputOverridesInnerStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputOverridesInnerStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputOverridesInnerStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputOverridesInner
    extends PolicyOverviewDtoOutputOverridesInner {
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String operatorSlug;
  @override
  final PolicyOverviewDtoOutputOverridesInnerStateEnum state;

  factory _$PolicyOverviewDtoOutputOverridesInner(
          [void Function(PolicyOverviewDtoOutputOverridesInnerBuilder)?
              updates]) =>
      (PolicyOverviewDtoOutputOverridesInnerBuilder()..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputOverridesInner._(
      {required this.operatorId,
      required this.operatorName,
      required this.operatorSlug,
      required this.state})
      : super._();
  @override
  PolicyOverviewDtoOutputOverridesInner rebuild(
          void Function(PolicyOverviewDtoOutputOverridesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputOverridesInnerBuilder toBuilder() =>
      PolicyOverviewDtoOutputOverridesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputOverridesInner &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        operatorSlug == other.operatorSlug &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputOverridesInner')
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('operatorSlug', operatorSlug)
          ..add('state', state))
        .toString();
  }
}

class PolicyOverviewDtoOutputOverridesInnerBuilder
    implements
        Builder<PolicyOverviewDtoOutputOverridesInner,
            PolicyOverviewDtoOutputOverridesInnerBuilder> {
  _$PolicyOverviewDtoOutputOverridesInner? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  PolicyOverviewDtoOutputOverridesInnerStateEnum? _state;
  PolicyOverviewDtoOutputOverridesInnerStateEnum? get state => _$this._state;
  set state(PolicyOverviewDtoOutputOverridesInnerStateEnum? state) =>
      _$this._state = state;

  PolicyOverviewDtoOutputOverridesInnerBuilder() {
    PolicyOverviewDtoOutputOverridesInner._defaults(this);
  }

  PolicyOverviewDtoOutputOverridesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _operatorSlug = $v.operatorSlug;
      _state = $v.state;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputOverridesInner other) {
    _$v = other as _$PolicyOverviewDtoOutputOverridesInner;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputOverridesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputOverridesInner build() => _build();

  _$PolicyOverviewDtoOutputOverridesInner _build() {
    final _$result = _$v ??
        _$PolicyOverviewDtoOutputOverridesInner._(
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'PolicyOverviewDtoOutputOverridesInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'PolicyOverviewDtoOutputOverridesInner', 'operatorName'),
          operatorSlug: BuiltValueNullFieldError.checkNotNull(operatorSlug,
              r'PolicyOverviewDtoOutputOverridesInner', 'operatorSlug'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'PolicyOverviewDtoOutputOverridesInner', 'state'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
