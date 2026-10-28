// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesOfficeUpdateDto extends SalesOfficeUpdateDto {
  @override
  final String code;
  @override
  final String name;
  @override
  final String address;
  @override
  final bool active;
  @override
  final int version;

  factory _$SalesOfficeUpdateDto(
          [void Function(SalesOfficeUpdateDtoBuilder)? updates]) =>
      (SalesOfficeUpdateDtoBuilder()..update(updates))._build();

  _$SalesOfficeUpdateDto._(
      {required this.code,
      required this.name,
      required this.address,
      required this.active,
      required this.version})
      : super._();
  @override
  SalesOfficeUpdateDto rebuild(
          void Function(SalesOfficeUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeUpdateDtoBuilder toBuilder() =>
      SalesOfficeUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeUpdateDto &&
        code == other.code &&
        name == other.name &&
        address == other.address &&
        active == other.active &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalesOfficeUpdateDto')
          ..add('code', code)
          ..add('name', name)
          ..add('address', address)
          ..add('active', active)
          ..add('version', version))
        .toString();
  }
}

class SalesOfficeUpdateDtoBuilder
    implements Builder<SalesOfficeUpdateDto, SalesOfficeUpdateDtoBuilder> {
  _$SalesOfficeUpdateDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  SalesOfficeUpdateDtoBuilder() {
    SalesOfficeUpdateDto._defaults(this);
  }

  SalesOfficeUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _address = $v.address;
      _active = $v.active;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesOfficeUpdateDto other) {
    _$v = other as _$SalesOfficeUpdateDto;
  }

  @override
  void update(void Function(SalesOfficeUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeUpdateDto build() => _build();

  _$SalesOfficeUpdateDto _build() {
    final _$result = _$v ??
        _$SalesOfficeUpdateDto._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'SalesOfficeUpdateDto', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SalesOfficeUpdateDto', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'SalesOfficeUpdateDto', 'address'),
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'SalesOfficeUpdateDto', 'active'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'SalesOfficeUpdateDto', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
