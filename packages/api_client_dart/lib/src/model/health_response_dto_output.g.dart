// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const HealthResponseDtoOutputStatusEnum _$healthResponseDtoOutputStatusEnum_ok =
    const HealthResponseDtoOutputStatusEnum._('ok');

HealthResponseDtoOutputStatusEnum _$healthResponseDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ok':
      return _$healthResponseDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<HealthResponseDtoOutputStatusEnum>
    _$healthResponseDtoOutputStatusEnumValues = BuiltSet<
        HealthResponseDtoOutputStatusEnum>(const <HealthResponseDtoOutputStatusEnum>[
  _$healthResponseDtoOutputStatusEnum_ok,
]);

Serializer<HealthResponseDtoOutputStatusEnum>
    _$healthResponseDtoOutputStatusEnumSerializer =
    _$HealthResponseDtoOutputStatusEnumSerializer();

class _$HealthResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<HealthResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthResponseDtoOutputStatusEnum];
  @override
  final String wireName = 'HealthResponseDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, HealthResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HealthResponseDtoOutput extends HealthResponseDtoOutput {
  @override
  final HealthResponseDtoOutputStatusEnum status;
  @override
  final String service;
  @override
  final DateTime timestamp;

  factory _$HealthResponseDtoOutput(
          [void Function(HealthResponseDtoOutputBuilder)? updates]) =>
      (HealthResponseDtoOutputBuilder()..update(updates))._build();

  _$HealthResponseDtoOutput._(
      {required this.status, required this.service, required this.timestamp})
      : super._();
  @override
  HealthResponseDtoOutput rebuild(
          void Function(HealthResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthResponseDtoOutputBuilder toBuilder() =>
      HealthResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthResponseDtoOutput &&
        status == other.status &&
        service == other.service &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, service.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthResponseDtoOutput')
          ..add('status', status)
          ..add('service', service)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class HealthResponseDtoOutputBuilder
    implements
        Builder<HealthResponseDtoOutput, HealthResponseDtoOutputBuilder> {
  _$HealthResponseDtoOutput? _$v;

  HealthResponseDtoOutputStatusEnum? _status;
  HealthResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(HealthResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _service;
  String? get service => _$this._service;
  set service(String? service) => _$this._service = service;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  HealthResponseDtoOutputBuilder() {
    HealthResponseDtoOutput._defaults(this);
  }

  HealthResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _service = $v.service;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthResponseDtoOutput other) {
    _$v = other as _$HealthResponseDtoOutput;
  }

  @override
  void update(void Function(HealthResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthResponseDtoOutput build() => _build();

  _$HealthResponseDtoOutput _build() {
    final _$result = _$v ??
        _$HealthResponseDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'HealthResponseDtoOutput', 'status'),
          service: BuiltValueNullFieldError.checkNotNull(
              service, r'HealthResponseDtoOutput', 'service'),
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'HealthResponseDtoOutput', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
