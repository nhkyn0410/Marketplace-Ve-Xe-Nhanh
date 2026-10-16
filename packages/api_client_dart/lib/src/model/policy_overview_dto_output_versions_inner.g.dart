// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyOverviewDtoOutputVersionsInnerTypeEnum
    _$policyOverviewDtoOutputVersionsInnerTypeEnum_CANCELLATION =
    const PolicyOverviewDtoOutputVersionsInnerTypeEnum._('CANCELLATION');
const PolicyOverviewDtoOutputVersionsInnerTypeEnum
    _$policyOverviewDtoOutputVersionsInnerTypeEnum_SEAT_HOLD =
    const PolicyOverviewDtoOutputVersionsInnerTypeEnum._('SEAT_HOLD');
const PolicyOverviewDtoOutputVersionsInnerTypeEnum
    _$policyOverviewDtoOutputVersionsInnerTypeEnum_PAYOUT =
    const PolicyOverviewDtoOutputVersionsInnerTypeEnum._('PAYOUT');

PolicyOverviewDtoOutputVersionsInnerTypeEnum
    _$policyOverviewDtoOutputVersionsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'CANCELLATION':
      return _$policyOverviewDtoOutputVersionsInnerTypeEnum_CANCELLATION;
    case 'SEAT_HOLD':
      return _$policyOverviewDtoOutputVersionsInnerTypeEnum_SEAT_HOLD;
    case 'PAYOUT':
      return _$policyOverviewDtoOutputVersionsInnerTypeEnum_PAYOUT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputVersionsInnerTypeEnum>
    _$policyOverviewDtoOutputVersionsInnerTypeEnumValues = BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerTypeEnum>(const <PolicyOverviewDtoOutputVersionsInnerTypeEnum>[
  _$policyOverviewDtoOutputVersionsInnerTypeEnum_CANCELLATION,
  _$policyOverviewDtoOutputVersionsInnerTypeEnum_SEAT_HOLD,
  _$policyOverviewDtoOutputVersionsInnerTypeEnum_PAYOUT,
]);

const PolicyOverviewDtoOutputVersionsInnerStatusEnum
    _$policyOverviewDtoOutputVersionsInnerStatusEnum_DRAFT =
    const PolicyOverviewDtoOutputVersionsInnerStatusEnum._('DRAFT');
const PolicyOverviewDtoOutputVersionsInnerStatusEnum
    _$policyOverviewDtoOutputVersionsInnerStatusEnum_PUBLISHED =
    const PolicyOverviewDtoOutputVersionsInnerStatusEnum._('PUBLISHED');
const PolicyOverviewDtoOutputVersionsInnerStatusEnum
    _$policyOverviewDtoOutputVersionsInnerStatusEnum_CANCELLED =
    const PolicyOverviewDtoOutputVersionsInnerStatusEnum._('CANCELLED');

PolicyOverviewDtoOutputVersionsInnerStatusEnum
    _$policyOverviewDtoOutputVersionsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$policyOverviewDtoOutputVersionsInnerStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$policyOverviewDtoOutputVersionsInnerStatusEnum_PUBLISHED;
    case 'CANCELLED':
      return _$policyOverviewDtoOutputVersionsInnerStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputVersionsInnerStatusEnum>
    _$policyOverviewDtoOutputVersionsInnerStatusEnumValues = BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerStatusEnum>(const <PolicyOverviewDtoOutputVersionsInnerStatusEnum>[
  _$policyOverviewDtoOutputVersionsInnerStatusEnum_DRAFT,
  _$policyOverviewDtoOutputVersionsInnerStatusEnum_PUBLISHED,
  _$policyOverviewDtoOutputVersionsInnerStatusEnum_CANCELLED,
]);

const PolicyOverviewDtoOutputVersionsInnerStateEnum
    _$policyOverviewDtoOutputVersionsInnerStateEnum_DRAFT =
    const PolicyOverviewDtoOutputVersionsInnerStateEnum._('DRAFT');
const PolicyOverviewDtoOutputVersionsInnerStateEnum
    _$policyOverviewDtoOutputVersionsInnerStateEnum_SCHEDULED =
    const PolicyOverviewDtoOutputVersionsInnerStateEnum._('SCHEDULED');
const PolicyOverviewDtoOutputVersionsInnerStateEnum
    _$policyOverviewDtoOutputVersionsInnerStateEnum_ACTIVE =
    const PolicyOverviewDtoOutputVersionsInnerStateEnum._('ACTIVE');
const PolicyOverviewDtoOutputVersionsInnerStateEnum
    _$policyOverviewDtoOutputVersionsInnerStateEnum_EXPIRED =
    const PolicyOverviewDtoOutputVersionsInnerStateEnum._('EXPIRED');
const PolicyOverviewDtoOutputVersionsInnerStateEnum
    _$policyOverviewDtoOutputVersionsInnerStateEnum_CANCELLED =
    const PolicyOverviewDtoOutputVersionsInnerStateEnum._('CANCELLED');

PolicyOverviewDtoOutputVersionsInnerStateEnum
    _$policyOverviewDtoOutputVersionsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$policyOverviewDtoOutputVersionsInnerStateEnum_DRAFT;
    case 'SCHEDULED':
      return _$policyOverviewDtoOutputVersionsInnerStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$policyOverviewDtoOutputVersionsInnerStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$policyOverviewDtoOutputVersionsInnerStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$policyOverviewDtoOutputVersionsInnerStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputVersionsInnerStateEnum>
    _$policyOverviewDtoOutputVersionsInnerStateEnumValues = BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerStateEnum>(const <PolicyOverviewDtoOutputVersionsInnerStateEnum>[
  _$policyOverviewDtoOutputVersionsInnerStateEnum_DRAFT,
  _$policyOverviewDtoOutputVersionsInnerStateEnum_SCHEDULED,
  _$policyOverviewDtoOutputVersionsInnerStateEnum_ACTIVE,
  _$policyOverviewDtoOutputVersionsInnerStateEnum_EXPIRED,
  _$policyOverviewDtoOutputVersionsInnerStateEnum_CANCELLED,
]);

Serializer<PolicyOverviewDtoOutputVersionsInnerTypeEnum>
    _$policyOverviewDtoOutputVersionsInnerTypeEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerTypeEnumSerializer();
Serializer<PolicyOverviewDtoOutputVersionsInnerStatusEnum>
    _$policyOverviewDtoOutputVersionsInnerStatusEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerStatusEnumSerializer();
Serializer<PolicyOverviewDtoOutputVersionsInnerStateEnum>
    _$policyOverviewDtoOutputVersionsInnerStateEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerStateEnumSerializer();

class _$PolicyOverviewDtoOutputVersionsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerTypeEnum
  ];
  @override
  final String wireName = 'PolicyOverviewDtoOutputVersionsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerStatusEnum
  ];
  @override
  final String wireName = 'PolicyOverviewDtoOutputVersionsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerStateEnumSerializer
    implements
        PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerStateEnum> {
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
    PolicyOverviewDtoOutputVersionsInnerStateEnum
  ];
  @override
  final String wireName = 'PolicyOverviewDtoOutputVersionsInnerStateEnum';

  @override
  Object serialize(Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInner
    extends PolicyOverviewDtoOutputVersionsInner {
  @override
  final String id;
  @override
  final PolicyOverviewDtoOutputVersionsInnerTypeEnum type;
  @override
  final String? operatorId;
  @override
  final String? operatorName;
  @override
  final int version;
  @override
  final PolicyOverviewDtoOutputVersionsInnerStatusEnum status;
  @override
  final PolicyOverviewDtoOutputVersionsInnerStateEnum state;
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

  factory _$PolicyOverviewDtoOutputVersionsInner(
          [void Function(PolicyOverviewDtoOutputVersionsInnerBuilder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerBuilder()..update(updates))._build();

  _$PolicyOverviewDtoOutputVersionsInner._(
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
  PolicyOverviewDtoOutputVersionsInner rebuild(
          void Function(PolicyOverviewDtoOutputVersionsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerBuilder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInner &&
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
    return (newBuiltValueToStringHelper(r'PolicyOverviewDtoOutputVersionsInner')
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

class PolicyOverviewDtoOutputVersionsInnerBuilder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInner,
            PolicyOverviewDtoOutputVersionsInnerBuilder> {
  _$PolicyOverviewDtoOutputVersionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PolicyOverviewDtoOutputVersionsInnerTypeEnum? _type;
  PolicyOverviewDtoOutputVersionsInnerTypeEnum? get type => _$this._type;
  set type(PolicyOverviewDtoOutputVersionsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  PolicyOverviewDtoOutputVersionsInnerStatusEnum? _status;
  PolicyOverviewDtoOutputVersionsInnerStatusEnum? get status => _$this._status;
  set status(PolicyOverviewDtoOutputVersionsInnerStatusEnum? status) =>
      _$this._status = status;

  PolicyOverviewDtoOutputVersionsInnerStateEnum? _state;
  PolicyOverviewDtoOutputVersionsInnerStateEnum? get state => _$this._state;
  set state(PolicyOverviewDtoOutputVersionsInnerStateEnum? state) =>
      _$this._state = state;

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

  PolicyOverviewDtoOutputVersionsInnerBuilder() {
    PolicyOverviewDtoOutputVersionsInner._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerBuilder get _$this {
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
  void replace(PolicyOverviewDtoOutputVersionsInner other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInner;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputVersionsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInner build() => _build();

  _$PolicyOverviewDtoOutputVersionsInner _build() {
    _$PolicyOverviewDtoOutputVersionsInner _$result;
    try {
      _$result = _$v ??
          _$PolicyOverviewDtoOutputVersionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PolicyOverviewDtoOutputVersionsInner', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'PolicyOverviewDtoOutputVersionsInner', 'type'),
            operatorId: operatorId,
            operatorName: operatorName,
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'PolicyOverviewDtoOutputVersionsInner', 'version'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PolicyOverviewDtoOutputVersionsInner', 'status'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'PolicyOverviewDtoOutputVersionsInner', 'state'),
            rules: rules.build(),
            description: description,
            changeReason: changeReason,
            effectiveFrom: effectiveFrom,
            createdBy: createdBy,
            publishedAt: publishedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'PolicyOverviewDtoOutputVersionsInner', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
                r'PolicyOverviewDtoOutputVersionsInner', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyOverviewDtoOutputVersionsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
