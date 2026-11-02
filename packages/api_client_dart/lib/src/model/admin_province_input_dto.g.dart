// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_province_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminProvinceInputDto extends AdminProvinceInputDto {
  @override
  final String code;
  @override
  final String name;

  factory _$AdminProvinceInputDto(
          [void Function(AdminProvinceInputDtoBuilder)? updates]) =>
      (AdminProvinceInputDtoBuilder()..update(updates))._build();

  _$AdminProvinceInputDto._({required this.code, required this.name})
      : super._();
  @override
  AdminProvinceInputDto rebuild(
          void Function(AdminProvinceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminProvinceInputDtoBuilder toBuilder() =>
      AdminProvinceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminProvinceInputDto &&
        code == other.code &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminProvinceInputDto')
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class AdminProvinceInputDtoBuilder
    implements Builder<AdminProvinceInputDto, AdminProvinceInputDtoBuilder> {
  _$AdminProvinceInputDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminProvinceInputDtoBuilder() {
    AdminProvinceInputDto._defaults(this);
  }

  AdminProvinceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminProvinceInputDto other) {
    _$v = other as _$AdminProvinceInputDto;
  }

  @override
  void update(void Function(AdminProvinceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminProvinceInputDto build() => _build();

  _$AdminProvinceInputDto _build() {
    final _$result = _$v ??
        _$AdminProvinceInputDto._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminProvinceInputDto', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminProvinceInputDto', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
