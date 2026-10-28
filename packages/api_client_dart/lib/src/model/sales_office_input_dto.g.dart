// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesOfficeInputDto extends SalesOfficeInputDto {
  @override
  final String code;
  @override
  final String name;
  @override
  final String address;
  @override
  final bool? active;

  factory _$SalesOfficeInputDto(
          [void Function(SalesOfficeInputDtoBuilder)? updates]) =>
      (SalesOfficeInputDtoBuilder()..update(updates))._build();

  _$SalesOfficeInputDto._(
      {required this.code,
      required this.name,
      required this.address,
      this.active})
      : super._();
  @override
  SalesOfficeInputDto rebuild(
          void Function(SalesOfficeInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeInputDtoBuilder toBuilder() =>
      SalesOfficeInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeInputDto &&
        code == other.code &&
        name == other.name &&
        address == other.address &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalesOfficeInputDto')
          ..add('code', code)
          ..add('name', name)
          ..add('address', address)
          ..add('active', active))
        .toString();
  }
}

class SalesOfficeInputDtoBuilder
    implements Builder<SalesOfficeInputDto, SalesOfficeInputDtoBuilder> {
  _$SalesOfficeInputDto? _$v;

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

  SalesOfficeInputDtoBuilder() {
    SalesOfficeInputDto._defaults(this);
  }

  SalesOfficeInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _address = $v.address;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesOfficeInputDto other) {
    _$v = other as _$SalesOfficeInputDto;
  }

  @override
  void update(void Function(SalesOfficeInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeInputDto build() => _build();

  _$SalesOfficeInputDto _build() {
    final _$result = _$v ??
        _$SalesOfficeInputDto._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'SalesOfficeInputDto', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SalesOfficeInputDto', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'SalesOfficeInputDto', 'address'),
          active: active,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
