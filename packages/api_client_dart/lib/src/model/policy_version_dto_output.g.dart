// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_version_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyVersionDtoOutputTypeEnum
    _$policyVersionDtoOutputTypeEnum_CANCELLATION =
    const PolicyVersionDtoOutputTypeEnum._('CANCELLATION');
const PolicyVersionDtoOutputTypeEnum
    _$policyVersionDtoOutputTypeEnum_SEAT_HOLD =
    const PolicyVersionDtoOutputTypeEnum._('SEAT_HOLD');
const PolicyVersionDtoOutputTypeEnum _$policyVersionDtoOutputTypeEnum_PAYOUT =
    const PolicyVersionDtoOutputTypeEnum._('PAYOUT');
const PolicyVersionDtoOutputTypeEnum _$policyVersionDtoOutputTypeEnum_LOYALTY =
    const PolicyVersionDtoOutputTypeEnum._('LOYALTY');

PolicyVersionDtoOutputTypeEnum _$policyVersionDtoOutputTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'CANCELLATION':
      return _$policyVersionDtoOutputTypeEnum_CANCELLATION;
    case 'SEAT_HOLD':
      return _$policyVersionDtoOutputTypeEnum_SEAT_HOLD;
    case 'PAYOUT':
      return _$policyVersionDtoOutputTypeEnum_PAYOUT;
    case 'LOYALTY':
      return _$policyVersionDtoOutputTypeEnum_LOYALTY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyVersionDtoOutputTypeEnum>
    _$policyVersionDtoOutputTypeEnumValues = BuiltSet<
        PolicyVersionDtoOutputTypeEnum>(const <PolicyVersionDtoOutputTypeEnum>[
  _$policyVersionDtoOutputTypeEnum_CANCELLATION,
  _$policyVersionDtoOutputTypeEnum_SEAT_HOLD,
  _$policyVersionDtoOutputTypeEnum_PAYOUT,
  _$policyVersionDtoOutputTypeEnum_LOYALTY,
]);

const PolicyVersionDtoOutputStatusEnum
    _$policyVersionDtoOutputStatusEnum_DRAFT =
    const PolicyVersionDtoOutputStatusEnum._('DRAFT');
const PolicyVersionDtoOutputStatusEnum
    _$policyVersionDtoOutputStatusEnum_PUBLISHED =
    const PolicyVersionDtoOutputStatusEnum._('PUBLISHED');
const PolicyVersionDtoOutputStatusEnum
    _$policyVersionDtoOutputStatusEnum_CANCELLED =
    const PolicyVersionDtoOutputStatusEnum._('CANCELLED');

PolicyVersionDtoOutputStatusEnum _$policyVersionDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$policyVersionDtoOutputStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$policyVersionDtoOutputStatusEnum_PUBLISHED;
    case 'CANCELLED':
      return _$policyVersionDtoOutputStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyVersionDtoOutputStatusEnum>
    _$policyVersionDtoOutputStatusEnumValues = BuiltSet<
        PolicyVersionDtoOutputStatusEnum>(const <PolicyVersionDtoOutputStatusEnum>[
  _$policyVersionDtoOutputStatusEnum_DRAFT,
  _$policyVersionDtoOutputStatusEnum_PUBLISHED,
  _$policyVersionDtoOutputStatusEnum_CANCELLED,
]);

const PolicyVersionDtoOutputStateEnum _$policyVersionDtoOutputStateEnum_DRAFT =
    const PolicyVersionDtoOutputStateEnum._('DRAFT');
const PolicyVersionDtoOutputStateEnum
    _$policyVersionDtoOutputStateEnum_SCHEDULED =
    const PolicyVersionDtoOutputStateEnum._('SCHEDULED');
const PolicyVersionDtoOutputStateEnum _$policyVersionDtoOutputStateEnum_ACTIVE =
    const PolicyVersionDtoOutputStateEnum._('ACTIVE');
const PolicyVersionDtoOutputStateEnum
    _$policyVersionDtoOutputStateEnum_EXPIRED =
    const PolicyVersionDtoOutputStateEnum._('EXPIRED');
const PolicyVersionDtoOutputStateEnum
    _$policyVersionDtoOutputStateEnum_CANCELLED =
    const PolicyVersionDtoOutputStateEnum._('CANCELLED');

PolicyVersionDtoOutputStateEnum _$policyVersionDtoOutputStateEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$policyVersionDtoOutputStateEnum_DRAFT;
    case 'SCHEDULED':
      return _$policyVersionDtoOutputStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$policyVersionDtoOutputStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$policyVersionDtoOutputStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$policyVersionDtoOutputStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyVersionDtoOutputStateEnum>
    _$policyVersionDtoOutputStateEnumValues = BuiltSet<
        PolicyVersionDtoOutputStateEnum>(const <PolicyVersionDtoOutputStateEnum>[
  _$policyVersionDtoOutputStateEnum_DRAFT,
  _$policyVersionDtoOutputStateEnum_SCHEDULED,
  _$policyVersionDtoOutputStateEnum_ACTIVE,
  _$policyVersionDtoOutputStateEnum_EXPIRED,
  _$policyVersionDtoOutputStateEnum_CANCELLED,
]);

Serializer<PolicyVersionDtoOutputTypeEnum>
    _$policyVersionDtoOutputTypeEnumSerializer =
    _$PolicyVersionDtoOutputTypeEnumSerializer();
Serializer<PolicyVersionDtoOutputStatusEnum>
    _$policyVersionDtoOutputStatusEnumSerializer =
    _$PolicyVersionDtoOutputStatusEnumSerializer();
Serializer<PolicyVersionDtoOutputStateEnum>
    _$policyVersionDtoOutputStateEnumSerializer =
    _$PolicyVersionDtoOutputStateEnumSerializer();

class _$PolicyVersionDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<PolicyVersionDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CANCELLATION': 'CANCELLATION',
    'SEAT_HOLD': 'SEAT_HOLD',
    'PAYOUT': 'PAYOUT',
    'LOYALTY': 'LOYALTY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CANCELLATION': 'CANCELLATION',
    'SEAT_HOLD': 'SEAT_HOLD',
    'PAYOUT': 'PAYOUT',
    'LOYALTY': 'LOYALTY',
  };

  @override
  final Iterable<Type> types = const <Type>[PolicyVersionDtoOutputTypeEnum];
  @override
  final String wireName = 'PolicyVersionDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PolicyVersionDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyVersionDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyVersionDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyVersionDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PolicyVersionDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[PolicyVersionDtoOutputStatusEnum];
  @override
  final String wireName = 'PolicyVersionDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PolicyVersionDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyVersionDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyVersionDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyVersionDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<PolicyVersionDtoOutputStateEnum> {
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
  final Iterable<Type> types = const <Type>[PolicyVersionDtoOutputStateEnum];
  @override
  final String wireName = 'PolicyVersionDtoOutputStateEnum';

  @override
  Object serialize(
          Serializers serializers, PolicyVersionDtoOutputStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyVersionDtoOutputStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyVersionDtoOutputStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyVersionDtoOutput extends PolicyVersionDtoOutput {
  @override
  final String id;
  @override
  final PolicyVersionDtoOutputTypeEnum type;
  @override
  final String? operatorId;
  @override
  final String? operatorName;
  @override
  final int version;
  @override
  final PolicyVersionDtoOutputStatusEnum status;
  @override
  final PolicyVersionDtoOutputStateEnum state;
  @override
  final PolicyOverviewDtoOutputVersionsInnerRules rules;
  @override
  final String? description;
  @override
  final String? changeReason;
  @override
  final DateTime? effectiveFrom;
  @override
  final String? createdBy;
  @override
  final DateTime? publishedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$PolicyVersionDtoOutput(
          [void Function(PolicyVersionDtoOutputBuilder)? updates]) =>
      (PolicyVersionDtoOutputBuilder()..update(updates))._build();

  _$PolicyVersionDtoOutput._(
      {required this.id,
      required this.type,
      this.operatorId,
      this.operatorName,
      required this.version,
      required this.status,
      required this.state,
      required this.rules,
      this.description,
      this.changeReason,
      this.effectiveFrom,
      this.createdBy,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  PolicyVersionDtoOutput rebuild(
          void Function(PolicyVersionDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyVersionDtoOutputBuilder toBuilder() =>
      PolicyVersionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyVersionDtoOutput &&
        id == other.id &&
        type == other.type &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        version == other.version &&
        status == other.status &&
        state == other.state &&
        rules == other.rules &&
        description == other.description &&
        changeReason == other.changeReason &&
        effectiveFrom == other.effectiveFrom &&
        createdBy == other.createdBy &&
        publishedAt == other.publishedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, changeReason.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PolicyVersionDtoOutput')
          ..add('id', id)
          ..add('type', type)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('version', version)
          ..add('status', status)
          ..add('state', state)
          ..add('rules', rules)
          ..add('description', description)
          ..add('changeReason', changeReason)
          ..add('effectiveFrom', effectiveFrom)
          ..add('createdBy', createdBy)
          ..add('publishedAt', publishedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PolicyVersionDtoOutputBuilder
    implements Builder<PolicyVersionDtoOutput, PolicyVersionDtoOutputBuilder> {
  _$PolicyVersionDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PolicyVersionDtoOutputTypeEnum? _type;
  PolicyVersionDtoOutputTypeEnum? get type => _$this._type;
  set type(PolicyVersionDtoOutputTypeEnum? type) => _$this._type = type;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  PolicyVersionDtoOutputStatusEnum? _status;
  PolicyVersionDtoOutputStatusEnum? get status => _$this._status;
  set status(PolicyVersionDtoOutputStatusEnum? status) =>
      _$this._status = status;

  PolicyVersionDtoOutputStateEnum? _state;
  PolicyVersionDtoOutputStateEnum? get state => _$this._state;
  set state(PolicyVersionDtoOutputStateEnum? state) => _$this._state = state;

  PolicyOverviewDtoOutputVersionsInnerRulesBuilder? _rules;
  PolicyOverviewDtoOutputVersionsInnerRulesBuilder get rules =>
      _$this._rules ??= PolicyOverviewDtoOutputVersionsInnerRulesBuilder();
  set rules(PolicyOverviewDtoOutputVersionsInnerRulesBuilder? rules) =>
      _$this._rules = rules;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _changeReason;
  String? get changeReason => _$this._changeReason;
  set changeReason(String? changeReason) => _$this._changeReason = changeReason;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PolicyVersionDtoOutputBuilder() {
    PolicyVersionDtoOutput._defaults(this);
  }

  PolicyVersionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _version = $v.version;
      _status = $v.status;
      _state = $v.state;
      _rules = $v.rules.toBuilder();
      _description = $v.description;
      _changeReason = $v.changeReason;
      _effectiveFrom = $v.effectiveFrom;
      _createdBy = $v.createdBy;
      _publishedAt = $v.publishedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyVersionDtoOutput other) {
    _$v = other as _$PolicyVersionDtoOutput;
  }

  @override
  void update(void Function(PolicyVersionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyVersionDtoOutput build() => _build();

  _$PolicyVersionDtoOutput _build() {
    _$PolicyVersionDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PolicyVersionDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PolicyVersionDtoOutput', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'PolicyVersionDtoOutput', 'type'),
            operatorId: operatorId,
            operatorName: operatorName,
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'PolicyVersionDtoOutput', 'version'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PolicyVersionDtoOutput', 'status'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'PolicyVersionDtoOutput', 'state'),
            rules: rules.build(),
            description: description,
            changeReason: changeReason,
            effectiveFrom: effectiveFrom,
            createdBy: createdBy,
            publishedAt: publishedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PolicyVersionDtoOutput', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'PolicyVersionDtoOutput', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyVersionDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
