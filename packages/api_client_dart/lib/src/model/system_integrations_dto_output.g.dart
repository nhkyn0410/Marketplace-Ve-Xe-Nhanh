// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_integrations_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SystemIntegrationsDtoOutput extends SystemIntegrationsDtoOutput {
  @override
  final DateTime checkedAt;
  @override
  final String environment;
  @override
  final BuiltList<SystemIntegrationsDtoOutputItemsInner> items;

  factory _$SystemIntegrationsDtoOutput(
          [void Function(SystemIntegrationsDtoOutputBuilder)? updates]) =>
      (SystemIntegrationsDtoOutputBuilder()..update(updates))._build();

  _$SystemIntegrationsDtoOutput._(
      {required this.checkedAt, required this.environment, required this.items})
      : super._();
  @override
  SystemIntegrationsDtoOutput rebuild(
          void Function(SystemIntegrationsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SystemIntegrationsDtoOutputBuilder toBuilder() =>
      SystemIntegrationsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SystemIntegrationsDtoOutput &&
        checkedAt == other.checkedAt &&
        environment == other.environment &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checkedAt.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SystemIntegrationsDtoOutput')
          ..add('checkedAt', checkedAt)
          ..add('environment', environment)
          ..add('items', items))
        .toString();
  }
}

class SystemIntegrationsDtoOutputBuilder
    implements
        Builder<SystemIntegrationsDtoOutput,
            SystemIntegrationsDtoOutputBuilder> {
  _$SystemIntegrationsDtoOutput? _$v;

  DateTime? _checkedAt;
  DateTime? get checkedAt => _$this._checkedAt;
  set checkedAt(DateTime? checkedAt) => _$this._checkedAt = checkedAt;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  ListBuilder<SystemIntegrationsDtoOutputItemsInner>? _items;
  ListBuilder<SystemIntegrationsDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<SystemIntegrationsDtoOutputItemsInner>();
  set items(ListBuilder<SystemIntegrationsDtoOutputItemsInner>? items) =>
      _$this._items = items;

  SystemIntegrationsDtoOutputBuilder() {
    SystemIntegrationsDtoOutput._defaults(this);
  }

  SystemIntegrationsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checkedAt = $v.checkedAt;
      _environment = $v.environment;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SystemIntegrationsDtoOutput other) {
    _$v = other as _$SystemIntegrationsDtoOutput;
  }

  @override
  void update(void Function(SystemIntegrationsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SystemIntegrationsDtoOutput build() => _build();

  _$SystemIntegrationsDtoOutput _build() {
    _$SystemIntegrationsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$SystemIntegrationsDtoOutput._(
            checkedAt: BuiltValueNullFieldError.checkNotNull(
                checkedAt, r'SystemIntegrationsDtoOutput', 'checkedAt'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'SystemIntegrationsDtoOutput', 'environment'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SystemIntegrationsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
