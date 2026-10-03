// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postgres_health_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PostgresHealthResponseDtoOutputStatusEnum
    _$postgresHealthResponseDtoOutputStatusEnum_ok =
    const PostgresHealthResponseDtoOutputStatusEnum._('ok');

PostgresHealthResponseDtoOutputStatusEnum
    _$postgresHealthResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$postgresHealthResponseDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostgresHealthResponseDtoOutputStatusEnum>
    _$postgresHealthResponseDtoOutputStatusEnumValues = BuiltSet<
        PostgresHealthResponseDtoOutputStatusEnum>(const <PostgresHealthResponseDtoOutputStatusEnum>[
  _$postgresHealthResponseDtoOutputStatusEnum_ok,
]);

const PostgresHealthResponseDtoOutputServiceEnum
    _$postgresHealthResponseDtoOutputServiceEnum_postgres =
    const PostgresHealthResponseDtoOutputServiceEnum._('postgres');

PostgresHealthResponseDtoOutputServiceEnum
    _$postgresHealthResponseDtoOutputServiceEnumValueOf(String name) {
  switch (name) {
    case 'postgres':
      return _$postgresHealthResponseDtoOutputServiceEnum_postgres;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostgresHealthResponseDtoOutputServiceEnum>
    _$postgresHealthResponseDtoOutputServiceEnumValues = BuiltSet<
        PostgresHealthResponseDtoOutputServiceEnum>(const <PostgresHealthResponseDtoOutputServiceEnum>[
  _$postgresHealthResponseDtoOutputServiceEnum_postgres,
]);

Serializer<PostgresHealthResponseDtoOutputStatusEnum>
    _$postgresHealthResponseDtoOutputStatusEnumSerializer =
    _$PostgresHealthResponseDtoOutputStatusEnumSerializer();
Serializer<PostgresHealthResponseDtoOutputServiceEnum>
    _$postgresHealthResponseDtoOutputServiceEnumSerializer =
    _$PostgresHealthResponseDtoOutputServiceEnumSerializer();

class _$PostgresHealthResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PostgresHealthResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PostgresHealthResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'PostgresHealthResponseDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          PostgresHealthResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostgresHealthResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostgresHealthResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PostgresHealthResponseDtoOutputServiceEnumSerializer
    implements PrimitiveSerializer<PostgresHealthResponseDtoOutputServiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'postgres': 'postgres',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'postgres': 'postgres',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PostgresHealthResponseDtoOutputServiceEnum
  ];
  @override
  final String wireName = 'PostgresHealthResponseDtoOutputServiceEnum';

  @override
  Object serialize(Serializers serializers,
          PostgresHealthResponseDtoOutputServiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostgresHealthResponseDtoOutputServiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostgresHealthResponseDtoOutputServiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PostgresHealthResponseDtoOutput
    extends PostgresHealthResponseDtoOutput {
  @override
  final PostgresHealthResponseDtoOutputStatusEnum status;
  @override
  final PostgresHealthResponseDtoOutputServiceEnum service;
  @override
  final DateTime timestamp;

  factory _$PostgresHealthResponseDtoOutput(
          [void Function(PostgresHealthResponseDtoOutputBuilder)? updates]) =>
      (PostgresHealthResponseDtoOutputBuilder()..update(updates))._build();

  _$PostgresHealthResponseDtoOutput._(
      {required this.status, required this.service, required this.timestamp})
      : super._();
  @override
  PostgresHealthResponseDtoOutput rebuild(
          void Function(PostgresHealthResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostgresHealthResponseDtoOutputBuilder toBuilder() =>
      PostgresHealthResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostgresHealthResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'PostgresHealthResponseDtoOutput')
          ..add('status', status)
          ..add('service', service)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PostgresHealthResponseDtoOutputBuilder
    implements
        Builder<PostgresHealthResponseDtoOutput,
            PostgresHealthResponseDtoOutputBuilder> {
  _$PostgresHealthResponseDtoOutput? _$v;

  PostgresHealthResponseDtoOutputStatusEnum? _status;
  PostgresHealthResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(PostgresHealthResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  PostgresHealthResponseDtoOutputServiceEnum? _service;
  PostgresHealthResponseDtoOutputServiceEnum? get service => _$this._service;
  set service(PostgresHealthResponseDtoOutputServiceEnum? service) =>
      _$this._service = service;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PostgresHealthResponseDtoOutputBuilder() {
    PostgresHealthResponseDtoOutput._defaults(this);
  }

  PostgresHealthResponseDtoOutputBuilder get _$this {
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
  void replace(PostgresHealthResponseDtoOutput other) {
    _$v = other as _$PostgresHealthResponseDtoOutput;
  }

  @override
  void update(void Function(PostgresHealthResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostgresHealthResponseDtoOutput build() => _build();

  _$PostgresHealthResponseDtoOutput _build() {
    final _$result = _$v ??
        _$PostgresHealthResponseDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PostgresHealthResponseDtoOutput', 'status'),
          service: BuiltValueNullFieldError.checkNotNull(
              service, r'PostgresHealthResponseDtoOutput', 'service'),
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'PostgresHealthResponseDtoOutput', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
