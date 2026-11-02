// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ward_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminWardInputDto extends AdminWardInputDto {
  @override
  final String provinceId;
  @override
  final String code;
  @override
  final String name;

  factory _$AdminWardInputDto(
          [void Function(AdminWardInputDtoBuilder)? updates]) =>
      (AdminWardInputDtoBuilder()..update(updates))._build();

  _$AdminWardInputDto._(
      {required this.provinceId, required this.code, required this.name})
      : super._();
  @override
  AdminWardInputDto rebuild(void Function(AdminWardInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminWardInputDtoBuilder toBuilder() =>
      AdminWardInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminWardInputDto &&
        provinceId == other.provinceId &&
        code == other.code &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provinceId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminWardInputDto')
          ..add('provinceId', provinceId)
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class AdminWardInputDtoBuilder
    implements Builder<AdminWardInputDto, AdminWardInputDtoBuilder> {
  _$AdminWardInputDto? _$v;

  String? _provinceId;
  String? get provinceId => _$this._provinceId;
  set provinceId(String? provinceId) => _$this._provinceId = provinceId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminWardInputDtoBuilder() {
    AdminWardInputDto._defaults(this);
  }

  AdminWardInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provinceId = $v.provinceId;
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminWardInputDto other) {
    _$v = other as _$AdminWardInputDto;
  }

  @override
  void update(void Function(AdminWardInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminWardInputDto build() => _build();

  _$AdminWardInputDto _build() {
    final _$result = _$v ??
        _$AdminWardInputDto._(
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminWardInputDto', 'provinceId'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminWardInputDto', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminWardInputDto', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
