// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DecisionResponseDtoOutputStatusEnum
    _$decisionResponseDtoOutputStatusEnum_NEEDS_INFO =
    const DecisionResponseDtoOutputStatusEnum._('NEEDS_INFO');
const DecisionResponseDtoOutputStatusEnum
    _$decisionResponseDtoOutputStatusEnum_REJECTED =
    const DecisionResponseDtoOutputStatusEnum._('REJECTED');

DecisionResponseDtoOutputStatusEnum
    _$decisionResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'NEEDS_INFO':
      return _$decisionResponseDtoOutputStatusEnum_NEEDS_INFO;
    case 'REJECTED':
      return _$decisionResponseDtoOutputStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DecisionResponseDtoOutputStatusEnum>
    _$decisionResponseDtoOutputStatusEnumValues = BuiltSet<
        DecisionResponseDtoOutputStatusEnum>(const <DecisionResponseDtoOutputStatusEnum>[
  _$decisionResponseDtoOutputStatusEnum_NEEDS_INFO,
  _$decisionResponseDtoOutputStatusEnum_REJECTED,
]);

Serializer<DecisionResponseDtoOutputStatusEnum>
    _$decisionResponseDtoOutputStatusEnumSerializer =
    _$DecisionResponseDtoOutputStatusEnumSerializer();

class _$DecisionResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<DecisionResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NEEDS_INFO': 'NEEDS_INFO',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NEEDS_INFO': 'NEEDS_INFO',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DecisionResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'DecisionResponseDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, DecisionResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DecisionResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DecisionResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DecisionResponseDtoOutput extends DecisionResponseDtoOutput {
  @override
  final String applicationCode;
  @override
  final DecisionResponseDtoOutputStatusEnum status;
  @override
  final bool emailDelivered;

  factory _$DecisionResponseDtoOutput(
          [void Function(DecisionResponseDtoOutputBuilder)? updates]) =>
      (DecisionResponseDtoOutputBuilder()..update(updates))._build();

  _$DecisionResponseDtoOutput._(
      {required this.applicationCode,
      required this.status,
      required this.emailDelivered})
      : super._();
  @override
  DecisionResponseDtoOutput rebuild(
          void Function(DecisionResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DecisionResponseDtoOutputBuilder toBuilder() =>
      DecisionResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecisionResponseDtoOutput &&
        applicationCode == other.applicationCode &&
        status == other.status &&
        emailDelivered == other.emailDelivered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applicationCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, emailDelivered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DecisionResponseDtoOutput')
          ..add('applicationCode', applicationCode)
          ..add('status', status)
          ..add('emailDelivered', emailDelivered))
        .toString();
  }
}

class DecisionResponseDtoOutputBuilder
    implements
        Builder<DecisionResponseDtoOutput, DecisionResponseDtoOutputBuilder> {
  _$DecisionResponseDtoOutput? _$v;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  DecisionResponseDtoOutputStatusEnum? _status;
  DecisionResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(DecisionResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  bool? _emailDelivered;
  bool? get emailDelivered => _$this._emailDelivered;
  set emailDelivered(bool? emailDelivered) =>
      _$this._emailDelivered = emailDelivered;

  DecisionResponseDtoOutputBuilder() {
    DecisionResponseDtoOutput._defaults(this);
  }

  DecisionResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applicationCode = $v.applicationCode;
      _status = $v.status;
      _emailDelivered = $v.emailDelivered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecisionResponseDtoOutput other) {
    _$v = other as _$DecisionResponseDtoOutput;
  }

  @override
  void update(void Function(DecisionResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DecisionResponseDtoOutput build() => _build();

  _$DecisionResponseDtoOutput _build() {
    final _$result = _$v ??
        _$DecisionResponseDtoOutput._(
          applicationCode: BuiltValueNullFieldError.checkNotNull(
              applicationCode, r'DecisionResponseDtoOutput', 'applicationCode'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DecisionResponseDtoOutput', 'status'),
          emailDelivered: BuiltValueNullFieldError.checkNotNull(
              emailDelivered, r'DecisionResponseDtoOutput', 'emailDelivered'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
