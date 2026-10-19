// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_catalog_deactivate_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCatalogDeactivateDto extends AdminCatalogDeactivateDto {
  @override
  final String reason;

  factory _$AdminCatalogDeactivateDto(
          [void Function(AdminCatalogDeactivateDtoBuilder)? updates]) =>
      (AdminCatalogDeactivateDtoBuilder()..update(updates))._build();

  _$AdminCatalogDeactivateDto._({required this.reason}) : super._();
  @override
  AdminCatalogDeactivateDto rebuild(
          void Function(AdminCatalogDeactivateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCatalogDeactivateDtoBuilder toBuilder() =>
      AdminCatalogDeactivateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCatalogDeactivateDto && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCatalogDeactivateDto')
          ..add('reason', reason))
        .toString();
  }
}

class AdminCatalogDeactivateDtoBuilder
    implements
        Builder<AdminCatalogDeactivateDto, AdminCatalogDeactivateDtoBuilder> {
  _$AdminCatalogDeactivateDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCatalogDeactivateDtoBuilder() {
    AdminCatalogDeactivateDto._defaults(this);
  }

  AdminCatalogDeactivateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCatalogDeactivateDto other) {
    _$v = other as _$AdminCatalogDeactivateDto;
  }

  @override
  void update(void Function(AdminCatalogDeactivateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCatalogDeactivateDto build() => _build();

  _$AdminCatalogDeactivateDto _build() {
    final _$result = _$v ??
        _$AdminCatalogDeactivateDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminCatalogDeactivateDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
