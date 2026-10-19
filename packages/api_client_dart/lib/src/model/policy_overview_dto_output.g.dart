// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyOverviewDtoOutputTypeEnum
    _$policyOverviewDtoOutputTypeEnum_CANCELLATION =
    const PolicyOverviewDtoOutputTypeEnum._('CANCELLATION');
const PolicyOverviewDtoOutputTypeEnum
    _$policyOverviewDtoOutputTypeEnum_SEAT_HOLD =
    const PolicyOverviewDtoOutputTypeEnum._('SEAT_HOLD');
const PolicyOverviewDtoOutputTypeEnum _$policyOverviewDtoOutputTypeEnum_PAYOUT =
    const PolicyOverviewDtoOutputTypeEnum._('PAYOUT');

PolicyOverviewDtoOutputTypeEnum _$policyOverviewDtoOutputTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'CANCELLATION':
      return _$policyOverviewDtoOutputTypeEnum_CANCELLATION;
    case 'SEAT_HOLD':
      return _$policyOverviewDtoOutputTypeEnum_SEAT_HOLD;
    case 'PAYOUT':
      return _$policyOverviewDtoOutputTypeEnum_PAYOUT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputTypeEnum>
    _$policyOverviewDtoOutputTypeEnumValues = BuiltSet<
        PolicyOverviewDtoOutputTypeEnum>(const <PolicyOverviewDtoOutputTypeEnum>[
  _$policyOverviewDtoOutputTypeEnum_CANCELLATION,
  _$policyOverviewDtoOutputTypeEnum_SEAT_HOLD,
  _$policyOverviewDtoOutputTypeEnum_PAYOUT,
]);

Serializer<PolicyOverviewDtoOutputTypeEnum>
    _$policyOverviewDtoOutputTypeEnumSerializer =
    _$PolicyOverviewDtoOutputTypeEnumSerializer();

class _$PolicyOverviewDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<PolicyOverviewDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CANCELLATION': 'CANCELLATION',
    'SEAT_HOLD': 'SEAT_HOLD',
    'PAYOUT': 'PAYOUT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CANCELLATION': 'CANCELLATION',
    'SEAT_HOLD': 'SEAT_HOLD',
    'PAYOUT': 'PAYOUT',
  };

  @override
  final Iterable<Type> types = const <Type>[PolicyOverviewDtoOutputTypeEnum];
  @override
  final String wireName = 'PolicyOverviewDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PolicyOverviewDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutput extends PolicyOverviewDtoOutput {
  @override
  final PolicyOverviewDtoOutputTypeEnum type;
  @override
  final String? operatorId;
  @override
  final String? operatorName;
  @override
  final BuiltList<PolicyOverviewDtoOutputVersionsInner> versions;
  @override
  final int activeOperatorCount;
  @override
  final BuiltList<PolicyOverviewDtoOutputOverridesInner> overrides;

  factory _$PolicyOverviewDtoOutput(
          [void Function(PolicyOverviewDtoOutputBuilder)? updates]) =>
      (PolicyOverviewDtoOutputBuilder()..update(updates))._build();

  _$PolicyOverviewDtoOutput._(
      {required this.type,
      this.operatorId,
      this.operatorName,
      required this.versions,
      required this.activeOperatorCount,
      required this.overrides})
      : super._();
  @override
  PolicyOverviewDtoOutput rebuild(
          void Function(PolicyOverviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputBuilder toBuilder() =>
      PolicyOverviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutput &&
        type == other.type &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        versions == other.versions &&
        activeOperatorCount == other.activeOperatorCount &&
        overrides == other.overrides;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jc(_$hash, activeOperatorCount.hashCode);
    _$hash = $jc(_$hash, overrides.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PolicyOverviewDtoOutput')
          ..add('type', type)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('versions', versions)
          ..add('activeOperatorCount', activeOperatorCount)
          ..add('overrides', overrides))
        .toString();
  }
}

class PolicyOverviewDtoOutputBuilder
    implements
        Builder<PolicyOverviewDtoOutput, PolicyOverviewDtoOutputBuilder> {
  _$PolicyOverviewDtoOutput? _$v;

  PolicyOverviewDtoOutputTypeEnum? _type;
  PolicyOverviewDtoOutputTypeEnum? get type => _$this._type;
  set type(PolicyOverviewDtoOutputTypeEnum? type) => _$this._type = type;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  ListBuilder<PolicyOverviewDtoOutputVersionsInner>? _versions;
  ListBuilder<PolicyOverviewDtoOutputVersionsInner> get versions =>
      _$this._versions ??= ListBuilder<PolicyOverviewDtoOutputVersionsInner>();
  set versions(ListBuilder<PolicyOverviewDtoOutputVersionsInner>? versions) =>
      _$this._versions = versions;

  int? _activeOperatorCount;
  int? get activeOperatorCount => _$this._activeOperatorCount;
  set activeOperatorCount(int? activeOperatorCount) =>
      _$this._activeOperatorCount = activeOperatorCount;

  ListBuilder<PolicyOverviewDtoOutputOverridesInner>? _overrides;
  ListBuilder<PolicyOverviewDtoOutputOverridesInner> get overrides =>
      _$this._overrides ??=
          ListBuilder<PolicyOverviewDtoOutputOverridesInner>();
  set overrides(
          ListBuilder<PolicyOverviewDtoOutputOverridesInner>? overrides) =>
      _$this._overrides = overrides;

  PolicyOverviewDtoOutputBuilder() {
    PolicyOverviewDtoOutput._defaults(this);
  }

  PolicyOverviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _versions = $v.versions.toBuilder();
      _activeOperatorCount = $v.activeOperatorCount;
      _overrides = $v.overrides.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutput other) {
    _$v = other as _$PolicyOverviewDtoOutput;
  }

  @override
  void update(void Function(PolicyOverviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutput build() => _build();

  _$PolicyOverviewDtoOutput _build() {
    _$PolicyOverviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PolicyOverviewDtoOutput._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'PolicyOverviewDtoOutput', 'type'),
            operatorId: operatorId,
            operatorName: operatorName,
            versions: versions.build(),
            activeOperatorCount: BuiltValueNullFieldError.checkNotNull(
                activeOperatorCount,
                r'PolicyOverviewDtoOutput',
                'activeOperatorCount'),
            overrides: overrides.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'versions';
        versions.build();

        _$failedField = 'overrides';
        overrides.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyOverviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
