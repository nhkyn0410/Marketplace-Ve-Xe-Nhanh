// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_integrations_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_UP =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('UP');
const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DOWN =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('DOWN');
const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_CONFIGURED =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('CONFIGURED');
const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_LOCAL =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('LOCAL');
const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_CONFIGURED =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('NOT_CONFIGURED');
const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_INTEGRATED =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('NOT_INTEGRATED');
const SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DISABLED =
    const SystemIntegrationsDtoOutputItemsInnerStatusEnum._('DISABLED');

SystemIntegrationsDtoOutputItemsInnerStatusEnum
    _$systemIntegrationsDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'UP':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_UP;
    case 'DOWN':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DOWN;
    case 'CONFIGURED':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_CONFIGURED;
    case 'LOCAL':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_LOCAL;
    case 'NOT_CONFIGURED':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_CONFIGURED;
    case 'NOT_INTEGRATED':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_INTEGRATED;
    case 'DISABLED':
      return _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SystemIntegrationsDtoOutputItemsInnerStatusEnum>
    _$systemIntegrationsDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        SystemIntegrationsDtoOutputItemsInnerStatusEnum>(const <SystemIntegrationsDtoOutputItemsInnerStatusEnum>[
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_UP,
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DOWN,
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_CONFIGURED,
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_LOCAL,
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_CONFIGURED,
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_INTEGRATED,
  _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<SystemIntegrationsDtoOutputItemsInnerStatusEnum>
    _$systemIntegrationsDtoOutputItemsInnerStatusEnumSerializer =
    _$SystemIntegrationsDtoOutputItemsInnerStatusEnumSerializer();

class _$SystemIntegrationsDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<SystemIntegrationsDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UP': 'UP',
    'DOWN': 'DOWN',
    'CONFIGURED': 'CONFIGURED',
    'LOCAL': 'LOCAL',
    'NOT_CONFIGURED': 'NOT_CONFIGURED',
    'NOT_INTEGRATED': 'NOT_INTEGRATED',
    'DISABLED': 'DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UP': 'UP',
    'DOWN': 'DOWN',
    'CONFIGURED': 'CONFIGURED',
    'LOCAL': 'LOCAL',
    'NOT_CONFIGURED': 'NOT_CONFIGURED',
    'NOT_INTEGRATED': 'NOT_INTEGRATED',
    'DISABLED': 'DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SystemIntegrationsDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'SystemIntegrationsDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          SystemIntegrationsDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SystemIntegrationsDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SystemIntegrationsDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SystemIntegrationsDtoOutputItemsInner
    extends SystemIntegrationsDtoOutputItemsInner {
  @override
  final String key;
  @override
  final String name;
  @override
  final String category;
  @override
  final SystemIntegrationsDtoOutputItemsInnerStatusEnum status;
  @override
  final int? latencyMs;
  @override
  final String detail;

  factory _$SystemIntegrationsDtoOutputItemsInner(
          [void Function(SystemIntegrationsDtoOutputItemsInnerBuilder)?
              updates]) =>
      (SystemIntegrationsDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$SystemIntegrationsDtoOutputItemsInner._(
      {required this.key,
      required this.name,
      required this.category,
      required this.status,
      this.latencyMs,
      required this.detail})
      : super._();
  @override
  SystemIntegrationsDtoOutputItemsInner rebuild(
          void Function(SystemIntegrationsDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SystemIntegrationsDtoOutputItemsInnerBuilder toBuilder() =>
      SystemIntegrationsDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SystemIntegrationsDtoOutputItemsInner &&
        key == other.key &&
        name == other.name &&
        category == other.category &&
        status == other.status &&
        latencyMs == other.latencyMs &&
        detail == other.detail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, latencyMs.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SystemIntegrationsDtoOutputItemsInner')
          ..add('key', key)
          ..add('name', name)
          ..add('category', category)
          ..add('status', status)
          ..add('latencyMs', latencyMs)
          ..add('detail', detail))
        .toString();
  }
}

class SystemIntegrationsDtoOutputItemsInnerBuilder
    implements
        Builder<SystemIntegrationsDtoOutputItemsInner,
            SystemIntegrationsDtoOutputItemsInnerBuilder> {
  _$SystemIntegrationsDtoOutputItemsInner? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  SystemIntegrationsDtoOutputItemsInnerStatusEnum? _status;
  SystemIntegrationsDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(SystemIntegrationsDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _latencyMs;
  int? get latencyMs => _$this._latencyMs;
  set latencyMs(int? latencyMs) => _$this._latencyMs = latencyMs;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  SystemIntegrationsDtoOutputItemsInnerBuilder() {
    SystemIntegrationsDtoOutputItemsInner._defaults(this);
  }

  SystemIntegrationsDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _name = $v.name;
      _category = $v.category;
      _status = $v.status;
      _latencyMs = $v.latencyMs;
      _detail = $v.detail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SystemIntegrationsDtoOutputItemsInner other) {
    _$v = other as _$SystemIntegrationsDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(SystemIntegrationsDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SystemIntegrationsDtoOutputItemsInner build() => _build();

  _$SystemIntegrationsDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$SystemIntegrationsDtoOutputItemsInner._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'SystemIntegrationsDtoOutputItemsInner', 'key'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SystemIntegrationsDtoOutputItemsInner', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'SystemIntegrationsDtoOutputItemsInner', 'category'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SystemIntegrationsDtoOutputItemsInner', 'status'),
          latencyMs: latencyMs,
          detail: BuiltValueNullFieldError.checkNotNull(
              detail, r'SystemIntegrationsDtoOutputItemsInner', 'detail'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
