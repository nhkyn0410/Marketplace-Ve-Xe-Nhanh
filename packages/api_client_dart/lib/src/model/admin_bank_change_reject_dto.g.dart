// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bank_change_reject_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBankChangeRejectDto extends AdminBankChangeRejectDto {
  @override
  final String changeId;
  @override
  final String reason;

  factory _$AdminBankChangeRejectDto(
          [void Function(AdminBankChangeRejectDtoBuilder)? updates]) =>
      (AdminBankChangeRejectDtoBuilder()..update(updates))._build();

  _$AdminBankChangeRejectDto._({required this.changeId, required this.reason})
      : super._();
  @override
  AdminBankChangeRejectDto rebuild(
          void Function(AdminBankChangeRejectDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminBankChangeRejectDtoBuilder toBuilder() =>
      AdminBankChangeRejectDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBankChangeRejectDto &&
        changeId == other.changeId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changeId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBankChangeRejectDto')
          ..add('changeId', changeId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminBankChangeRejectDtoBuilder
    implements
        Builder<AdminBankChangeRejectDto, AdminBankChangeRejectDtoBuilder> {
  _$AdminBankChangeRejectDto? _$v;

  String? _changeId;
  String? get changeId => _$this._changeId;
  set changeId(String? changeId) => _$this._changeId = changeId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminBankChangeRejectDtoBuilder() {
    AdminBankChangeRejectDto._defaults(this);
  }

  AdminBankChangeRejectDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changeId = $v.changeId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBankChangeRejectDto other) {
    _$v = other as _$AdminBankChangeRejectDto;
  }

  @override
  void update(void Function(AdminBankChangeRejectDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBankChangeRejectDto build() => _build();

  _$AdminBankChangeRejectDto _build() {
    final _$result = _$v ??
        _$AdminBankChangeRejectDto._(
          changeId: BuiltValueNullFieldError.checkNotNull(
              changeId, r'AdminBankChangeRejectDto', 'changeId'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminBankChangeRejectDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
