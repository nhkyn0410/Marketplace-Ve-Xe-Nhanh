// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceDtoOutput extends DeviceDtoOutput {
  @override
  final String id;
  @override
  final String provider;
  @override
  final bool active;

  factory _$DeviceDtoOutput([void Function(DeviceDtoOutputBuilder)? updates]) =>
      (DeviceDtoOutputBuilder()..update(updates))._build();

  _$DeviceDtoOutput._(
      {required this.id, required this.provider, required this.active})
      : super._();
  @override
  DeviceDtoOutput rebuild(void Function(DeviceDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceDtoOutputBuilder toBuilder() => DeviceDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceDtoOutput &&
        id == other.id &&
        provider == other.provider &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceDtoOutput')
          ..add('id', id)
          ..add('provider', provider)
          ..add('active', active))
        .toString();
  }
}

class DeviceDtoOutputBuilder
    implements Builder<DeviceDtoOutput, DeviceDtoOutputBuilder> {
  _$DeviceDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _provider;
  String? get provider => _$this._provider;
  set provider(String? provider) => _$this._provider = provider;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DeviceDtoOutputBuilder() {
    DeviceDtoOutput._defaults(this);
  }

  DeviceDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _provider = $v.provider;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceDtoOutput other) {
    _$v = other as _$DeviceDtoOutput;
  }

  @override
  void update(void Function(DeviceDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceDtoOutput build() => _build();

  _$DeviceDtoOutput _build() {
    final _$result = _$v ??
        _$DeviceDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DeviceDtoOutput', 'id'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'DeviceDtoOutput', 'provider'),
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'DeviceDtoOutput', 'active'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
