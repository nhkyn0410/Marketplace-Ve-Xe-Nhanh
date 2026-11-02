// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bank_change_approve_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBankChangeApproveDto extends AdminBankChangeApproveDto {
  @override
  final String changeId;

  factory _$AdminBankChangeApproveDto(
          [void Function(AdminBankChangeApproveDtoBuilder)? updates]) =>
      (AdminBankChangeApproveDtoBuilder()..update(updates))._build();

  _$AdminBankChangeApproveDto._({required this.changeId}) : super._();
  @override
  AdminBankChangeApproveDto rebuild(
          void Function(AdminBankChangeApproveDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminBankChangeApproveDtoBuilder toBuilder() =>
      AdminBankChangeApproveDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBankChangeApproveDto && changeId == other.changeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBankChangeApproveDto')
          ..add('changeId', changeId))
        .toString();
  }
}

class AdminBankChangeApproveDtoBuilder
    implements
        Builder<AdminBankChangeApproveDto, AdminBankChangeApproveDtoBuilder> {
  _$AdminBankChangeApproveDto? _$v;

  String? _changeId;
  String? get changeId => _$this._changeId;
  set changeId(String? changeId) => _$this._changeId = changeId;

  AdminBankChangeApproveDtoBuilder() {
    AdminBankChangeApproveDto._defaults(this);
  }

  AdminBankChangeApproveDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changeId = $v.changeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBankChangeApproveDto other) {
    _$v = other as _$AdminBankChangeApproveDto;
  }

  @override
  void update(void Function(AdminBankChangeApproveDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBankChangeApproveDto build() => _build();

  _$AdminBankChangeApproveDto _build() {
    final _$result = _$v ??
        _$AdminBankChangeApproveDto._(
          changeId: BuiltValueNullFieldError.checkNotNull(
              changeId, r'AdminBankChangeApproveDto', 'changeId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
