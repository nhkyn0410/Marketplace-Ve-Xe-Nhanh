// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_amenity_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAmenityInputDto extends AdminAmenityInputDto {
  @override
  final String code;
  @override
  final String name;

  factory _$AdminAmenityInputDto(
          [void Function(AdminAmenityInputDtoBuilder)? updates]) =>
      (AdminAmenityInputDtoBuilder()..update(updates))._build();

  _$AdminAmenityInputDto._({required this.code, required this.name})
      : super._();
  @override
  AdminAmenityInputDto rebuild(
          void Function(AdminAmenityInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAmenityInputDtoBuilder toBuilder() =>
      AdminAmenityInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAmenityInputDto &&
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
    return (newBuiltValueToStringHelper(r'AdminAmenityInputDto')
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class AdminAmenityInputDtoBuilder
    implements Builder<AdminAmenityInputDto, AdminAmenityInputDtoBuilder> {
  _$AdminAmenityInputDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminAmenityInputDtoBuilder() {
    AdminAmenityInputDto._defaults(this);
  }

  AdminAmenityInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAmenityInputDto other) {
    _$v = other as _$AdminAmenityInputDto;
  }

  @override
  void update(void Function(AdminAmenityInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAmenityInputDto build() => _build();

  _$AdminAmenityInputDto _build() {
    final _$result = _$v ??
        _$AdminAmenityInputDto._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminAmenityInputDto', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminAmenityInputDto', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
