// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redis_health_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RedisHealthResponseDtoOutputStatusEnum
    _$redisHealthResponseDtoOutputStatusEnum_ok =
    const RedisHealthResponseDtoOutputStatusEnum._('ok');

RedisHealthResponseDtoOutputStatusEnum
    _$redisHealthResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$redisHealthResponseDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RedisHealthResponseDtoOutputStatusEnum>
    _$redisHealthResponseDtoOutputStatusEnumValues = BuiltSet<
        RedisHealthResponseDtoOutputStatusEnum>(const <RedisHealthResponseDtoOutputStatusEnum>[
  _$redisHealthResponseDtoOutputStatusEnum_ok,
]);

const RedisHealthResponseDtoOutputServiceEnum
    _$redisHealthResponseDtoOutputServiceEnum_redis =
    const RedisHealthResponseDtoOutputServiceEnum._('redis');

RedisHealthResponseDtoOutputServiceEnum
    _$redisHealthResponseDtoOutputServiceEnumValueOf(String name) {
  switch (name) {
    case 'redis':
      return _$redisHealthResponseDtoOutputServiceEnum_redis;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RedisHealthResponseDtoOutputServiceEnum>
    _$redisHealthResponseDtoOutputServiceEnumValues = BuiltSet<
        RedisHealthResponseDtoOutputServiceEnum>(const <RedisHealthResponseDtoOutputServiceEnum>[
  _$redisHealthResponseDtoOutputServiceEnum_redis,
]);

Serializer<RedisHealthResponseDtoOutputStatusEnum>
    _$redisHealthResponseDtoOutputStatusEnumSerializer =
    _$RedisHealthResponseDtoOutputStatusEnumSerializer();
Serializer<RedisHealthResponseDtoOutputServiceEnum>
    _$redisHealthResponseDtoOutputServiceEnumSerializer =
    _$RedisHealthResponseDtoOutputServiceEnumSerializer();

class _$RedisHealthResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<RedisHealthResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RedisHealthResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'RedisHealthResponseDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          RedisHealthResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RedisHealthResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RedisHealthResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RedisHealthResponseDtoOutputServiceEnumSerializer
    implements PrimitiveSerializer<RedisHealthResponseDtoOutputServiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'redis': 'redis',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'redis': 'redis',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RedisHealthResponseDtoOutputServiceEnum
  ];
  @override
  final String wireName = 'RedisHealthResponseDtoOutputServiceEnum';

  @override
  Object serialize(Serializers serializers,
          RedisHealthResponseDtoOutputServiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RedisHealthResponseDtoOutputServiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RedisHealthResponseDtoOutputServiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RedisHealthResponseDtoOutput extends RedisHealthResponseDtoOutput {
  @override
  final RedisHealthResponseDtoOutputStatusEnum status;
  @override
  final RedisHealthResponseDtoOutputServiceEnum service;
  @override
  final DateTime timestamp;

  factory _$RedisHealthResponseDtoOutput(
          [void Function(RedisHealthResponseDtoOutputBuilder)? updates]) =>
      (RedisHealthResponseDtoOutputBuilder()..update(updates))._build();

  _$RedisHealthResponseDtoOutput._(
      {required this.status, required this.service, required this.timestamp})
      : super._();
  @override
  RedisHealthResponseDtoOutput rebuild(
          void Function(RedisHealthResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RedisHealthResponseDtoOutputBuilder toBuilder() =>
      RedisHealthResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RedisHealthResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'RedisHealthResponseDtoOutput')
          ..add('status', status)
          ..add('service', service)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class RedisHealthResponseDtoOutputBuilder
    implements
        Builder<RedisHealthResponseDtoOutput,
            RedisHealthResponseDtoOutputBuilder> {
  _$RedisHealthResponseDtoOutput? _$v;

  RedisHealthResponseDtoOutputStatusEnum? _status;
  RedisHealthResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(RedisHealthResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  RedisHealthResponseDtoOutputServiceEnum? _service;
  RedisHealthResponseDtoOutputServiceEnum? get service => _$this._service;
  set service(RedisHealthResponseDtoOutputServiceEnum? service) =>
      _$this._service = service;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  RedisHealthResponseDtoOutputBuilder() {
    RedisHealthResponseDtoOutput._defaults(this);
  }

  RedisHealthResponseDtoOutputBuilder get _$this {
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
  void replace(RedisHealthResponseDtoOutput other) {
    _$v = other as _$RedisHealthResponseDtoOutput;
  }

  @override
  void update(void Function(RedisHealthResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RedisHealthResponseDtoOutput build() => _build();

  _$RedisHealthResponseDtoOutput _build() {
    final _$result = _$v ??
        _$RedisHealthResponseDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'RedisHealthResponseDtoOutput', 'status'),
          service: BuiltValueNullFieldError.checkNotNull(
              service, r'RedisHealthResponseDtoOutput', 'service'),
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'RedisHealthResponseDtoOutput', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
