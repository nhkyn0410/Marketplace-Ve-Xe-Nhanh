// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules_any_of2.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum_BANK_TRANSFER =
    const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum._(
        'BANK_TRANSFER');

PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumValueOf(
        String name) {
  switch (name) {
    case 'BANK_TRANSFER':
      return _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum_BANK_TRANSFER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumValues =
    BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum>(const <PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum>[
  _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum_BANK_TRANSFER,
]);

const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum_true_ =
    const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
        ._('true_');

PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumValueOf(
        String name) {
  switch (name) {
    case 'true_':
      return _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumValues =
    BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum>(const <PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum>[
  _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum_true_,
]);

Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumSerializer();
Serializer<
        PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumSerializer();

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumSerializer
    implements
        PrimitiveSerializer<
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum
  ];
  @override
  final String wireName =
      'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum';

  @override
  Object serialize(Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumSerializer
    implements
        PrimitiveSerializer<
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
  ];
  @override
  final String wireName =
      'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum';

  @override
  Object serialize(
          Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
      deserialize(
              Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2
    extends PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 {
  @override
  final int delayDays;
  @override
  final PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum channel;
  @override
  final PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum
      manualConfirmation;
  @override
  final int? minimumAmount;

  factory _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2(
          [void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder()
            ..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2._(
      {required this.delayDays,
      required this.channel,
      required this.manualConfirmation,
      this.minimumAmount})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 rebuild(
          void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 &&
        delayDays == other.delayDays &&
        channel == other.channel &&
        manualConfirmation == other.manualConfirmation &&
        minimumAmount == other.minimumAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, delayDays.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, manualConfirmation.hashCode);
    _$hash = $jc(_$hash, minimumAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2')
          ..add('delayDays', delayDays)
          ..add('channel', channel)
          ..add('manualConfirmation', manualConfirmation)
          ..add('minimumAmount', minimumAmount))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder> {
  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2? _$v;

  int? _delayDays;
  int? get delayDays => _$this._delayDays;
  set delayDays(int? delayDays) => _$this._delayDays = delayDays;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum? _channel;
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum? get channel =>
      _$this._channel;
  set channel(
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum?
              channel) =>
      _$this._channel = channel;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum?
      _manualConfirmation;
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum?
      get manualConfirmation => _$this._manualConfirmation;
  set manualConfirmation(
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum?
              manualConfirmation) =>
      _$this._manualConfirmation = manualConfirmation;

  int? _minimumAmount;
  int? get minimumAmount => _$this._minimumAmount;
  set minimumAmount(int? minimumAmount) =>
      _$this._minimumAmount = minimumAmount;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder() {
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _delayDays = $v.delayDays;
      _channel = $v.channel;
      _manualConfirmation = $v.manualConfirmation;
      _minimumAmount = $v.minimumAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 _build() {
    final _$result = _$v ??
        _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2._(
          delayDays: BuiltValueNullFieldError.checkNotNull(delayDays,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2', 'delayDays'),
          channel: BuiltValueNullFieldError.checkNotNull(channel,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2', 'channel'),
          manualConfirmation: BuiltValueNullFieldError.checkNotNull(
              manualConfirmation,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2',
              'manualConfirmation'),
          minimumAmount: minimumAmount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
