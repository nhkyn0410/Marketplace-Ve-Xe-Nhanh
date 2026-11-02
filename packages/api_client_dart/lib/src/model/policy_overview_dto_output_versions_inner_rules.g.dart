// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum
    _$policyOverviewDtoOutputVersionsInnerRulesChannelEnum_BANK_TRANSFER =
    const PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum._(
        'BANK_TRANSFER');

PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum
    _$policyOverviewDtoOutputVersionsInnerRulesChannelEnumValueOf(String name) {
  switch (name) {
    case 'BANK_TRANSFER':
      return _$policyOverviewDtoOutputVersionsInnerRulesChannelEnum_BANK_TRANSFER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesChannelEnumValues = BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum>(const <PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum>[
  _$policyOverviewDtoOutputVersionsInnerRulesChannelEnum_BANK_TRANSFER,
]);

const PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum
    _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum_true_ =
    const PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum._(
        'true_');

PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum
    _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumValueOf(
        String name) {
  switch (name) {
    case 'true_':
      return _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumValues =
    BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum>(const <PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum>[
  _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum_true_,
]);

Serializer<PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesChannelEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerRulesChannelEnumSerializer();
Serializer<PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumSerializer();

class _$PolicyOverviewDtoOutputVersionsInnerRulesChannelEnumSerializer
    implements
        PrimitiveSerializer<
            PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum
  ];
  @override
  final String wireName =
      'PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum';

  @override
  Object serialize(Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumSerializer
    implements
        PrimitiveSerializer<
            PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum
  ];
  @override
  final String wireName =
      'PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum';

  @override
  Object serialize(
          Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerRules
    extends PolicyOverviewDtoOutputVersionsInnerRules {
  @override
  final AnyOf anyOf;

  factory _$PolicyOverviewDtoOutputVersionsInnerRules(
          [void Function(PolicyOverviewDtoOutputVersionsInnerRulesBuilder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesBuilder()..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRules._({required this.anyOf})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRules rebuild(
          void Function(PolicyOverviewDtoOutputVersionsInnerRulesBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesBuilder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerRulesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRules &&
        anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRules')
          ..add('anyOf', anyOf))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesBuilder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRules,
            PolicyOverviewDtoOutputVersionsInnerRulesBuilder> {
  _$PolicyOverviewDtoOutputVersionsInnerRules? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  PolicyOverviewDtoOutputVersionsInnerRulesBuilder() {
    PolicyOverviewDtoOutputVersionsInnerRules._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputVersionsInnerRules other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRules;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputVersionsInnerRulesBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRules build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRules _build() {
    final _$result = _$v ??
        _$PolicyOverviewDtoOutputVersionsInnerRules._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'PolicyOverviewDtoOutputVersionsInnerRules', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
