// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_health_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const QueueHealthResponseDtoOutputStatusEnum
    _$queueHealthResponseDtoOutputStatusEnum_ok =
    const QueueHealthResponseDtoOutputStatusEnum._('ok');

QueueHealthResponseDtoOutputStatusEnum
    _$queueHealthResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$queueHealthResponseDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<QueueHealthResponseDtoOutputStatusEnum>
    _$queueHealthResponseDtoOutputStatusEnumValues = BuiltSet<
        QueueHealthResponseDtoOutputStatusEnum>(const <QueueHealthResponseDtoOutputStatusEnum>[
  _$queueHealthResponseDtoOutputStatusEnum_ok,
]);

Serializer<QueueHealthResponseDtoOutputStatusEnum>
    _$queueHealthResponseDtoOutputStatusEnumSerializer =
    _$QueueHealthResponseDtoOutputStatusEnumSerializer();

class _$QueueHealthResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<QueueHealthResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[
    QueueHealthResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'QueueHealthResponseDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          QueueHealthResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  QueueHealthResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      QueueHealthResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$QueueHealthResponseDtoOutput extends QueueHealthResponseDtoOutput {
  @override
  final QueueHealthResponseDtoOutputStatusEnum status;
  @override
  final BuiltList<QueueHealthResponseDtoOutputQueuesInner> queues;
  @override
  final DateTime timestamp;

  factory _$QueueHealthResponseDtoOutput(
          [void Function(QueueHealthResponseDtoOutputBuilder)? updates]) =>
      (QueueHealthResponseDtoOutputBuilder()..update(updates))._build();

  _$QueueHealthResponseDtoOutput._(
      {required this.status, required this.queues, required this.timestamp})
      : super._();
  @override
  QueueHealthResponseDtoOutput rebuild(
          void Function(QueueHealthResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueueHealthResponseDtoOutputBuilder toBuilder() =>
      QueueHealthResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueueHealthResponseDtoOutput &&
        status == other.status &&
        queues == other.queues &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, queues.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueueHealthResponseDtoOutput')
          ..add('status', status)
          ..add('queues', queues)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class QueueHealthResponseDtoOutputBuilder
    implements
        Builder<QueueHealthResponseDtoOutput,
            QueueHealthResponseDtoOutputBuilder> {
  _$QueueHealthResponseDtoOutput? _$v;

  QueueHealthResponseDtoOutputStatusEnum? _status;
  QueueHealthResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(QueueHealthResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  ListBuilder<QueueHealthResponseDtoOutputQueuesInner>? _queues;
  ListBuilder<QueueHealthResponseDtoOutputQueuesInner> get queues =>
      _$this._queues ??= ListBuilder<QueueHealthResponseDtoOutputQueuesInner>();
  set queues(ListBuilder<QueueHealthResponseDtoOutputQueuesInner>? queues) =>
      _$this._queues = queues;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  QueueHealthResponseDtoOutputBuilder() {
    QueueHealthResponseDtoOutput._defaults(this);
  }

  QueueHealthResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _queues = $v.queues.toBuilder();
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueueHealthResponseDtoOutput other) {
    _$v = other as _$QueueHealthResponseDtoOutput;
  }

  @override
  void update(void Function(QueueHealthResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueueHealthResponseDtoOutput build() => _build();

  _$QueueHealthResponseDtoOutput _build() {
    _$QueueHealthResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$QueueHealthResponseDtoOutput._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'QueueHealthResponseDtoOutput', 'status'),
            queues: queues.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'QueueHealthResponseDtoOutput', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'queues';
        queues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueueHealthResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
