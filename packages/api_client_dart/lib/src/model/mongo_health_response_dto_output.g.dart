// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mongo_health_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MongoHealthResponseDtoOutputStatusEnum
    _$mongoHealthResponseDtoOutputStatusEnum_ok =
    const MongoHealthResponseDtoOutputStatusEnum._('ok');

MongoHealthResponseDtoOutputStatusEnum
    _$mongoHealthResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$mongoHealthResponseDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MongoHealthResponseDtoOutputStatusEnum>
    _$mongoHealthResponseDtoOutputStatusEnumValues = BuiltSet<
        MongoHealthResponseDtoOutputStatusEnum>(const <MongoHealthResponseDtoOutputStatusEnum>[
  _$mongoHealthResponseDtoOutputStatusEnum_ok,
]);

const MongoHealthResponseDtoOutputServiceEnum
    _$mongoHealthResponseDtoOutputServiceEnum_mongo =
    const MongoHealthResponseDtoOutputServiceEnum._('mongo');

MongoHealthResponseDtoOutputServiceEnum
    _$mongoHealthResponseDtoOutputServiceEnumValueOf(String name) {
  switch (name) {
    case 'mongo':
      return _$mongoHealthResponseDtoOutputServiceEnum_mongo;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MongoHealthResponseDtoOutputServiceEnum>
    _$mongoHealthResponseDtoOutputServiceEnumValues = BuiltSet<
        MongoHealthResponseDtoOutputServiceEnum>(const <MongoHealthResponseDtoOutputServiceEnum>[
  _$mongoHealthResponseDtoOutputServiceEnum_mongo,
]);

Serializer<MongoHealthResponseDtoOutputStatusEnum>
    _$mongoHealthResponseDtoOutputStatusEnumSerializer =
    _$MongoHealthResponseDtoOutputStatusEnumSerializer();
Serializer<MongoHealthResponseDtoOutputServiceEnum>
    _$mongoHealthResponseDtoOutputServiceEnumSerializer =
    _$MongoHealthResponseDtoOutputServiceEnumSerializer();

class _$MongoHealthResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MongoHealthResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MongoHealthResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'MongoHealthResponseDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          MongoHealthResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MongoHealthResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MongoHealthResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MongoHealthResponseDtoOutputServiceEnumSerializer
    implements PrimitiveSerializer<MongoHealthResponseDtoOutputServiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'mongo': 'mongo',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'mongo': 'mongo',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MongoHealthResponseDtoOutputServiceEnum
  ];
  @override
  final String wireName = 'MongoHealthResponseDtoOutputServiceEnum';

  @override
  Object serialize(Serializers serializers,
          MongoHealthResponseDtoOutputServiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MongoHealthResponseDtoOutputServiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MongoHealthResponseDtoOutputServiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MongoHealthResponseDtoOutput extends MongoHealthResponseDtoOutput {
  @override
  final MongoHealthResponseDtoOutputStatusEnum status;
  @override
  final MongoHealthResponseDtoOutputServiceEnum service;
  @override
  final DateTime timestamp;

  factory _$MongoHealthResponseDtoOutput(
          [void Function(MongoHealthResponseDtoOutputBuilder)? updates]) =>
      (MongoHealthResponseDtoOutputBuilder()..update(updates))._build();

  _$MongoHealthResponseDtoOutput._(
      {required this.status, required this.service, required this.timestamp})
      : super._();
  @override
  MongoHealthResponseDtoOutput rebuild(
          void Function(MongoHealthResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MongoHealthResponseDtoOutputBuilder toBuilder() =>
      MongoHealthResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MongoHealthResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MongoHealthResponseDtoOutput')
          ..add('status', status)
          ..add('service', service)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class MongoHealthResponseDtoOutputBuilder
    implements
        Builder<MongoHealthResponseDtoOutput,
            MongoHealthResponseDtoOutputBuilder> {
  _$MongoHealthResponseDtoOutput? _$v;

  MongoHealthResponseDtoOutputStatusEnum? _status;
  MongoHealthResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(MongoHealthResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  MongoHealthResponseDtoOutputServiceEnum? _service;
  MongoHealthResponseDtoOutputServiceEnum? get service => _$this._service;
  set service(MongoHealthResponseDtoOutputServiceEnum? service) =>
      _$this._service = service;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  MongoHealthResponseDtoOutputBuilder() {
    MongoHealthResponseDtoOutput._defaults(this);
  }

  MongoHealthResponseDtoOutputBuilder get _$this {
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
  void replace(MongoHealthResponseDtoOutput other) {
    _$v = other as _$MongoHealthResponseDtoOutput;
  }

  @override
  void update(void Function(MongoHealthResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MongoHealthResponseDtoOutput build() => _build();

  _$MongoHealthResponseDtoOutput _build() {
    final _$result = _$v ??
        _$MongoHealthResponseDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'MongoHealthResponseDtoOutput', 'status'),
          service: BuiltValueNullFieldError.checkNotNull(
              service, r'MongoHealthResponseDtoOutput', 'service'),
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'MongoHealthResponseDtoOutput', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
