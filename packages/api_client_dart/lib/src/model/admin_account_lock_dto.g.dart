// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_account_lock_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAccountLockDto extends AdminAccountLockDto {
  @override
  final String reason;

  factory _$AdminAccountLockDto(
          [void Function(AdminAccountLockDtoBuilder)? updates]) =>
      (AdminAccountLockDtoBuilder()..update(updates))._build();

  _$AdminAccountLockDto._({required this.reason}) : super._();
  @override
  AdminAccountLockDto rebuild(
          void Function(AdminAccountLockDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAccountLockDtoBuilder toBuilder() =>
      AdminAccountLockDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAccountLockDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'AdminAccountLockDto')
          ..add('reason', reason))
        .toString();
  }
}

class AdminAccountLockDtoBuilder
    implements Builder<AdminAccountLockDto, AdminAccountLockDtoBuilder> {
  _$AdminAccountLockDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminAccountLockDtoBuilder() {
    AdminAccountLockDto._defaults(this);
  }

  AdminAccountLockDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAccountLockDto other) {
    _$v = other as _$AdminAccountLockDto;
  }

  @override
  void update(void Function(AdminAccountLockDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAccountLockDto build() => _build();

  _$AdminAccountLockDto _build() {
    final _$result = _$v ??
        _$AdminAccountLockDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminAccountLockDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
